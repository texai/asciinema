#!/bin/bash

set -e
set -x

export ASCIINEMA_CONFIG_HOME=`mktemp -d 2>/dev/null || mktemp -d -t asciinema-config-home`
TMP_DATA_DIR=`mktemp -d 2>/dev/null || mktemp -d -t asciinema-data-dir`
trap "rm -rf $ASCIINEMA_CONFIG_HOME $TMP_DATA_DIR" EXIT

function asciinema() {
    python3 -m asciinema "$@"
}

# test help message

asciinema -h

# test version command

asciinema --version

# test auth command

asciinema auth

# test play command

# asciicast v1
asciinema play -s 5 tests/demo.json
asciinema play -s 5 -i 0.2 tests/demo.json
cat tests/demo.json | asciinema play -s 5 -

# asciicast v2
asciinema play -s 5 tests/demo.cast
asciinema play -s 5 -i 0.2 tests/demo.cast
cat tests/demo.cast | asciinema play -s 5 -

# test cat command

# asciicast v1
asciinema cat tests/demo.json
cat tests/demo.json | asciinema cat -

# asciicast v2
asciinema cat tests/demo.cast
cat tests/demo.cast | asciinema cat -

# test rec command

asciinema rec -c who "$TMP_DATA_DIR/1.cast"

bash -c "sleep 1; pkill -28 -n -f 'm asciinema'" &
asciinema rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "$TMP_DATA_DIR/2.cast"

bash -c "sleep 1; pkill -n -f 'bash -c echo t3st'" &
asciinema rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "$TMP_DATA_DIR/3.cast"

bash -c "sleep 1; pkill -9 -n -f 'bash -c echo t3st'" &
asciinema rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "$TMP_DATA_DIR/4.cast"

asciinema rec --stdin -c 'bash -c "echo t3st; sleep 1; echo ok"' "$TMP_DATA_DIR/5.cast"

asciinema rec --raw -c 'bash -c "echo t3st; sleep 1; echo ok"' "$TMP_DATA_DIR/6.raw"
