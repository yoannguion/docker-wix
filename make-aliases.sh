#!/bin/sh

# This script creates shell scripts that simulate adding all of the WiX binaries
# to the PATH. `wine /home/wine/wix/light.exe will be able to be called with
# just `light`.

mkdir -p /home/wine/bin
binpath=/home/wine/bin

for exe in $(ls /home/wine/wix | grep .exe$); do
    name=$(echo $exe | cut -d '.' -f 1)

    cat > $binpath/$name << EOF
#!/bin/sh
if [[ -n ${WINE_UID} ]]; then
  echo "change wine uid to ${WINE_UID}"
  usermod -u ${WINE_UID} wine
fi

if [[ -n ${WINE_GID} ]]; then
  echo "change wine gid to ${WINE_GID}"
  groupmod  -g ${WINE_GID} wine
fi

if [[ -n ${WINE_UID} ]]; then
  runuser wine wine /home/wine/wix/$exe \$@
else
  wine /home/wine/wix/$exe \$@
fi
EOF
    chmod +x $binpath/$name
done
