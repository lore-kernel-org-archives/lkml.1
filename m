Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXA2Mme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXA2Mme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 07:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXA2Mme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 07:42:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:41630 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXA2Mmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 07:42:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DRGDxLSs++sTmPmCbO1q+I7LZGf+TUmj9vjZJYxnyCC+rbwGDoKLyLBh3kfBb9HiDwaRsUQcEdbOQK90dm+4rqIU2GJOfo4DZkxxnwGPqj5B2c/ljEBFXXo13Iouq5fCnIXmMRSrDsEgg7VuE7y9Oobz/R3KpnKgiFXyHjIrWrU=
Message-ID: <37260fba0701290442o58694a63n69b3ec4efc33771a@mail.gmail.com>
Date: Mon, 29 Jan 2007 09:42:29 -0300
From: "Roi Avidan" <roiavidan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#06) (try 'pci=assign-busses')
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the bug report according to the bullets in
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html.
I hope it can help:

[1]    PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06
(-#06) (try 'pci=assign-busses')
[2]    I do not see an immediate problem with my system. I'm just
following the request found in dmesg log to post this report.
[3]    Keywords: PCI
[4]    Linux version 2.6.19-gentoo-r4 (root@roipc) (gcc version 4.1.1
(Gentoo 4.1.1-r3)) #1 Sat Jan 13 11:51:08 BRST 2007
[5]    No oops
[6]    No shell script to reproduce problem
[7]    Environment:

ANT_HOME=/usr/share/ant-core
BASH=/bin/bash
BASH_ARGC=()
BASH_ARGV=()
BASH_LINENO=()
BASH_SOURCE=()
BASH_VERSINFO=([0]="3" [1]="2" [2]="9" [3]="1" [4]="release"
[5]="i686-pc-linux-gnu")
BASH_VERSION='3.2.9(1)-release'
CLASSPATH=.
COLORTERM=gnome-terminal
COLUMNS=157
CONFIG_PROTECT=/usr/share/X11/xkb
CONFIG_PROTECT_MASK='/etc/java-config/vms/ /etc/env.d/java/ /etc/gconf
/etc/terminfo /etc/revdep-rebuild /etc/splash'
CVS_RSH=ssh
DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-QPYzQrTXdN,guid=63f9945bd38a1b2eb2040b0045bde448
DESKTOP_SESSION=gnome
DESKTOP_STARTUP_ID=
DIRSTACK=()
DISPLAY=:0.0
EDITOR=/usr/bin/vim
EUID=1000
GCC_SPECS=
GDK_USE_XFT=1
GDMSESSION=gnome
GDM_LANG=en_US.UTF-8
GDM_XSERVER_LOCATION=local
GENERATION=2
GNOME_DESKTOP_SESSION_ID=Default
GNOME_KEYRING_SOCKET=/tmp/keyring-Fx1mau/socket
GROUPS=()
GTK_RC_FILES=/etc/gtk/gtkrc:/home/roi/.gtkrc-1.2-gnome2
G_BROKEN_FILENAMES=1
G_FILENAME_ENCODING=UTF-8
HISTCONTROL=ignoredups
HISTFILE=/home/roi/.bash_history
HISTFILESIZE=500
HOME=/home/roi
HOSTNAME=roipc
HOSTTYPE=i686
IFS=$' \t\n'
INFOPATH=/usr/share/info:/usr/athena/info:/usr/share/binutils-data/i686-pc-linux-gnu/2.17/info:/usr/share/gcc-data/i686-pc-linux-gnu/4.1.1/info
JAVAC=/etc/java-config-2/current-system-vm/bin/javac
JAVA_HOME=/etc/java-config-2/current-system-vm
JDK_HOME=/etc/java-config-2/current-system-vm
LANG=en_US.UTF-8
LESS='-R -M --shift 5'
LESSOPEN='|lesspipe.sh %s'
LINES=37
LOGNAME=roi
LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42
:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31
:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*
.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.yuv=01;35:*
.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*
.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.pat
ch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.flac=01;35:*.mp3=01;35:*.mpc=00;36:*.ogg=00;36:*.wav=00;36:*.mid=00;36:*.midi=00;36:*.au=00;36:*.
flac=00;36:*.aac=00;36:*.ra=01;36:*.mka=01;36:'
MACHTYPE=i686-pc-linux-gnu
MAILCHECK=60
MANPATH=/usr/local/share/man:/usr/share/man:/usr/athena/man:/usr/share/binutils-data/i686-pc-linux-gnu/2.17/man:/usr/share/gcc-data/i686-pc-linux-gnu/4.1.1/m
an:/opt/blackdown-jdk-1.4.2.03/man:/etc/java-config/system-vm/man/:/usr/qt/3/doc/man:/opt/vmware/workstation/man
OLDPWD=/home/roi
OPENGL_PROFILE=xorg-x11
OPTERR=1
OPTIND=1
OSTYPE=linux-gnu
PAGER=/usr/bin/less
PATH=/home/roi/bin:/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/athena/bin:/usr/i686-pc-linux-gnu/gcc-bin/4.1.1:/opt/blackdown-jdk-1.4.2.03/bin:/opt/blackdown-
jdk-1.4.2.03/jre/bin:/usr/qt/3/bin:/opt/vmware/workstation/bin
PIPESTATUS=([0]="0" [1]="0")
PKG_CONFIG_PATH=/usr/qt/3/lib/pkgconfig
PPID=9219
PRELINK_PATH_MASK=/usr/lib/gstreamer-0.10:/usr/lib/klibc
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
PS2='> '
PS4='+ '
PWD=/usr/src/linux
PYTHONPATH=/usr/lib/portage/pym
QMAKESPEC=linux-g++
QTDIR=/usr/qt/3
SESSION_MANAGER=local/roipc:/tmp/.ICE-unix/8987
SHELL=/bin/bash
SHELLOPTS=braceexpand:emacs:hashall:histexpand:history:interactive-comments:monitor
SHLVL=1
SSH_AGENT_PID=9007
SSH_AUTH_SOCK=/tmp/ssh-bywZmn8987/agent.8987
TERM=xterm
UID=1000
USER=roi
USERNAME=roi
VMHANDLE=blackdown-jdk-1.4.2
WINDOWID=46143043
XAUTHORITY=/home/roi/.Xauthority

[7.1]  Output of ver_linux:

Gnu C                  4.1.1
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
pcmcia-cs              3.2.9
Linux C Library        so.6 .> libc
Dynamic linker (ldd)   2.5
Procps                 3.2.6
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   103
Modules Loaded         i915 vmnet vmmon snd_pcm_oss snd_mixer_oss
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device usbhid ipw2200
yenta_socket rsrc_nonstatic pcmcia_core ieee80211 ieee80211_crypt
snd_hda_intel snd_hda_codec intelfb snd_pcm snd_timer iTCO_wdt snd
soundcore snd_page_alloc

[7.2]  Processor information:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.73GHz
stepping        : 8
cpu MHz         : 1733.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx est tm2
bogomips        : 3460.53

[7.3]  Module information:

i915 19648 3 - Live 0xf9019000
vmnet 25700 9 - Live 0xf89b7000 (PF)
vmmon 178540 0 - Live 0xf907c000 (PF)
snd_pcm_oss 40096 0 - Live 0xf900e000
snd_mixer_oss 16576 1 snd_pcm_oss, Live 0xf89e8000
snd_seq_oss 31296 0 - Live 0xf89f3000
snd_seq_midi_event 7168 1 snd_seq_oss, Live 0xf88e0000
snd_seq 47824 4 snd_seq_oss,snd_seq_midi_event, Live 0xf899f000
snd_seq_device 8204 2 snd_seq_oss,snd_seq, Live 0xf88dc000
usbhid 39136 0 - Live 0xf89ac000
ipw2200 142068 0 - Live 0xf902b000
yenta_socket 26892 0 - Live 0xf8997000
rsrc_nonstatic 13248 1 yenta_socket, Live 0xf886d000
pcmcia_core 39760 2 yenta_socket,rsrc_nonstatic, Live 0xf898c000
ieee80211 32968 1 ipw2200, Live 0xf88f6000
ieee80211_crypt 5696 1 ieee80211, Live 0xf886a000
snd_hda_intel 19544 1 - Live 0xf8879000
snd_hda_codec 160128 1 snd_hda_intel, Live 0xf89bf000
intelfb 37988 0 - Live 0xf8981000
snd_pcm 68936 3 snd_pcm_oss,snd_hda_intel,snd_hda_codec, Live 0xf88e4000
snd_timer 21572 2 snd_seq,snd_pcm, Live 0xf8872000
iTCO_wdt 10080 0 - Live 0xf8866000
snd 50852 11 snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer,
Live 0xf88c1000
soundcore 7648 1 snd, Live 0xf8863000
snd_page_alloc 9992 2 snd_hda_intel,snd_pcm, Live 0xf885f000

[7.4]  Loaded driver and hardware information:

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
03c0-03df : vga+
  03c0-03df : vesafb
03f6-03f6 : ide0
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : motherboard
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK
    1060-107f : iTCO_wdt
1180-11bf : 0000:00:1f.0
  1180-11bf : motherboard
1640-164f : motherboard
1800-1807 : 0000:00:02.0
180c-180f : 0000:00:1f.2
  180c-180f : libata
1810-181f : 0000:00:1f.1
  1810-1817 : ide0
1820-183f : 0000:00:1d.0
  1820-183f : uhci_hcd
1840-185f : 0000:00:1d.1
  1840-185f : uhci_hcd
1860-187f : 0000:00:1d.2
  1860-187f : uhci_hcd
1880-189f : 0000:00:1d.3
  1880-189f : uhci_hcd
18a8-18af : 0000:00:1f.2
  18a8-18af : libata
18b0-18bf : 0000:00:1f.2
  18b0-18bf : libata
18c0-18c3 : 0000:00:1f.2
  18c0-18c3 : libata
18c8-18cf : 0000:00:1f.2
  18c8-18cf : libata
18e0-18ff : 0000:00:1f.3
  18e0-18ff : i801_smbus
2000-2fff : PCI Bus #02
3000-3fff : PCI Bus #03
4000-4fff : PCI Bus #04
5000-5fff : PCI Bus #06
  5000-50ff : 0000:06:0b.0
    5000-50ff : r8169
  5400-547f : 0000:06:09.0
  5800-58ff : PCI CardBus #07
  5c00-5cff : PCI CardBus #07

00000000-0009f7ff : System RAM
  00000000-00000000 : Crash kernel
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000cffff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3f68ffff : System RAM
  00100000-0039159f : Kernel code
  003915a0-00473013 : Kernel data
3f690000-3f69dfff : ACPI Tables
3f69e000-3f6fffff : ACPI Non-volatile Storage
3f700000-3fffffff : reserved
50000000-52ffffff : PCI Bus #06
  50000000-51ffffff : PCI CardBus #07
  52000000-5201ffff : 0000:06:0b.0
53000000-5307ffff : 0000:00:02.1
54000000-55ffffff : PCI CardBus #07
a0000000-a0003fff : 0000:00:1b.0
  a0000000-a0003fff : ICH HD audio
a0004000-a00043ff : 0000:00:1d.7
  a0004000-a00043ff : ehci_hcd
a0004400-a00047ff : 0000:00:1f.2
  a0004400-a00047ff : libata
a0040000-a007ffff : 0000:00:02.0
a0080000-a00fffff : 0000:00:02.0
a4000000-a7ffffff : PCI Bus #02
a8000000-abffffff : PCI Bus #03
ac000000-afffffff : PCI Bus #04
b0000000-b00fffff : PCI Bus #06
  b0000000-b0000fff : 0000:06:03.0
    b0000000-b0000fff : ipw2200
  b0001000-b000107f : 0000:06:07.1
  b0001100-b00011ff : 0000:06:07.4
  b0001400-b00014ff : 0000:06:07.2
  b0001c00-b0001cff : 0000:06:0b.0
    b0001c00-b0001cff : r8169
  b0002000-b00027ff : 0000:06:09.0
    b0002000-b00027ff : ohci1394
  b0003000-b0003fff : 0000:06:07.0
    b0003000-b0003fff : yenta_socket
b4000000-b7ffffff : PCI Bus #03
c0000000-cfffffff : 0000:00:02.0
  c0000000-c07affff : vesafb
d0000000-d3ffffff : PCI Bus #02
d4000000-d7ffffff : PCI Bus #04
e0000000-f0005fff : reserved
f0008000-f000bfff : reserved
fed00000-fed003ff : HPET 0
fed20000-fed8ffff : reserved
ff000000-ffffffff : reserved

[7.5]  PCI Information:

00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation Mobile
915GM/GMS/910GML Express Graphics Controller (rev 04) (prog-if 00
[VGA])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at a0080000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at 1800 [size=8]
        Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at a0040000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
Express Graphics Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Region 0: Memory at 53000000 (32-bit, non-prefetchable)
[disabled] [size=512K]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at a0000000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 1 (rev 04) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: a4000000-a7ffffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000d3f00000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 2, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable+
                Address: fee0100c  Data: 41c9
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 2 (rev 04) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: a8000000-abffffff
        Prefetchable memory behind bridge: 00000000b4000000-00000000b7f00000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 3, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable+
                Address: fee0100c  Data: 41d1
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.2 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 3 (rev 04) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: ac000000-afffffff
        Prefetchable memory behind bridge: 00000000d4000000-00000000d7f00000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 4, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable+
                Address: fee0100c  Data: 41d9
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 04) (prog-if 00 [UHCI])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at 1820 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 04) (prog-if 00 [UHCI])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 16
        Region 4: I/O ports at 1840 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 04) (prog-if 00 [UHCI])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 19
        Region 4: I/O ports at 1860 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #4 (rev 04) (prog-if 00 [UHCI])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 18
        Region 4: I/O ports at 1880 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 04) (prog-if 20 [EHCI])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at a0004000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d4)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=06, subordinate=0a, sec-latency=32
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: b0000000-b00fffff
        Prefetchable memory behind bridge: 0000000050000000-0000000052f00000
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface
Bridge (rev 04)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 04) (prog-if 8a [Master SecP PriP])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at <unassigned>
        Region 1: I/O ports at <unassigned>
        Region 2: I/O ports at <unassigned>
        Region 3: I/O ports at <unassigned>
        Region 4: I/O ports at 1810 [size=16]

00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA
Controller (rev 04) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 16
        Region 0: I/O ports at 18c8 [size=8]
        Region 1: I/O ports at 18c0 [size=4]
        Region 2: I/O ports at 18a8 [size=8]
        Region 3: I/O ports at 180c [size=4]
        Region 4: I/O ports at 18b0 [size=16]
        Region 5: Memory at a0004400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 16
        Region 4: I/O ports at 18e0 [size=32]

06:03.0 Network controller: Intel Corporation PRO/Wireless 2200BG
Network Connection (rev 05)
        Subsystem: Intel Corporation Unknown device 2702
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (750ns min, 6000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at b0000000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-

06:07.0 CardBus bridge: ENE Technology Inc CB-712/4 Cardbus Controller (rev 10)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at b0003000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=06, secondary=07, subordinate=0a, sec-latency=176
        Memory window 0: 50000000-51fff000 (prefetchable)
        Memory window 1: 54000000-55fff000
        I/O window 0: 00005800-000058ff
        I/O window 1: 00005c00-00005cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

06:07.1 FLASH memory: ENE Technology Inc ENE PCI Memory Stick Card
Reader Controller (rev 01)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (250ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 7
        Region 0: Memory at b0001000 (32-bit, non-prefetchable) [size=128]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

06:07.2 Class 0805: ENE Technology Inc ENE PCI Secure Digital Card
Reader Controller (rev 01) (prog-if 01)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min, 18000ns max), Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 7
        Region 0: Memory at b0001400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

06:07.4 FLASH memory: ENE Technology Inc Unknown device 0551 (rev 01)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 255
        Region 0: Memory at b0001100 (32-bit, non-prefetchable)
[disabled] [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

06:09.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80) (prog-if 10 [OHCI])
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at b0002000 (32-bit, non-prefetchable) [size=2K]
        Region 1: I/O ports at 5400 [size=128]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA
PME(D0-,D1-,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

06:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
Gigabit Ethernet (rev 10)
        Subsystem: CLEVO/KAPOK Computer Unknown device 5401
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 5000 [size=256]
        Region 1: Memory at b0001c00 (32-bit, non-prefetchable) [size=256]
        [virtual] Expansion ROM at 52000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[7.6]  No SCSI devices
[7.7]  Other information: I am attaching the output of dmesg up until
a few lines after the reported bug:

[    0.000000] Linux version 2.6.19-gentoo-r4 (root@roipc) (gcc
version 4.1.1 (Gentoo 4.1.1-r3)) #1 Sat Jan 13 11:51:08 BRST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f690000 (usable)
[    0.000000]  BIOS-e820: 000000003f690000 - 000000003f69e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f69e000 - 000000003f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0006000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] 118MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 259728) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   259728
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   259728
[    0.000000] On node 0 totalpages: 259728
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 237 pages used for memmap
[    0.000000]   HighMem zone: 30115 pages, LIFO batch:7
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP (v000 PTLTD
) @ 0x000f7910
[    0.000000] ACPI: RSDT (v001 PTLTD  Ohlone00 0x06040000  LTP
0x00000000) @ 0x3f6992e7
[    0.000000] ACPI: FADT (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3f69de88
[    0.000000] ACPI: MADT (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3f69defc
[    0.000000] ACPI: HPET (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3f69df64
[    0.000000] ACPI: MCFG (v001 INTEL  ALVISO   0x06040000 LOHR
0x0000005f) @ 0x3f69df9c
[    0.000000] ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP
0x00000001) @ 0x3f69dfd8
[    0.000000] ACPI: SSDT (v001 SataRe  SataPri 0x00001000 INTL
0x20030224) @ 0x3f69a054
[    0.000000] ACPI: SSDT (v001 SataRe  SataSec 0x00001000 INTL
0x20030224) @ 0x3f6999b8
[    0.000000] ACPI: SSDT (v001  PmRef  Cpu0Ist 0x00003000 INTL
0x20030224) @ 0x3f699548
[    0.000000] ACPI: SSDT (v001  PmRef    CpuPm 0x00003000 INTL
0x20030224) @ 0x3f69932f
[    0.000000] ACPI: DSDT (v001 INTEL  ALVISO   0x06040000 INTL
0x20030224) @ 0x00000000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:a0000000)
[    0.000000] Detected 1729.082 MHz processor.
[    9.261180] Built 1 zonelists.  Total pages: 257699
[    9.261182] Kernel command line: root=/dev/hda1
splash=silent,fadein,theme:matrix-splash
video=vesafb:1024x768-32@75,ywrap,mtrr quiet CONSOLE=/dev/tty1
[    9.261385] mapped APIC to ffffd000 (fee00000)
[    9.261388] mapped IOAPIC to ffffc000 (fec00000)
[    9.261391] Enabling fast FPU save and restore... done.
[    9.261393] Enabling unmasked SIMD FPU exception support... done.
[    9.261395] Initializing CPU#0
[    9.261463] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    9.263143] Console: colour VGA+ 80x25
[    9.263459] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    9.263948] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    9.287705] Memory: 1023896k/1038912k available (2629k kernel code,
14340k reserved, 902k data, 300k init, 121408k highmem)
[    9.287714] virtual kernel memory layout:
[    9.287716]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[    9.287717]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    9.287718]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    9.287719]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    9.287721]       .init : 0xc0476000 - 0xc04c1000   ( 300 kB)
[    9.287722]       .data : 0xc03915a0 - 0xc0473014   ( 902 kB)
[    9.287723]       .text : 0xc0100000 - 0xc03915a0   (2629 kB)
[    9.287728] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[    9.287858] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    9.287862] hpet0: 3 64-bit timers, 14318180 Hz
[    9.288868] Using HPET for base-timer
[    9.348834] Calibrating delay using timer specific routine..
3460.53 BogoMIPS (lpj=1730267)
[    9.348861] Security Framework v1.0.0 initialized
[    9.348870] Capability LSM initialized
[    9.348880] Mount-cache hash table entries: 512
[    9.348966] CPU: After generic identify, caps: afe9fbff 00100000
00000000 00000000 00000180 00000000 00000000
[    9.348975] CPU: L1 I cache: 32K, L1 D cache: 32K
[    9.348977] CPU: L2 cache: 2048K
[    9.348979] CPU: After all inits, caps: afe9fbff 00100000 00000000
00000040 00000180 00000000 00000000
[    9.348985] Intel machine check architecture supported.
[    9.348989] Intel machine check reporting enabled on CPU#0.
[    9.348998] CPU: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
[    9.349003] Checking 'hlt' instruction... OK.
[    9.352901] ACPI: Core revision 20060707
[    9.384943] ENABLING IO-APIC IRQs
[    9.385134] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    9.496853] checking if image is initramfs... it is
[    9.547825] Freeing initrd memory: 1152k freed
[    9.548035] NET: Registered protocol family 16
[    9.548106] EISA bus registered
[    9.548110] ACPI: bus type pci registered
[    9.548119] PCI: Using MMCONFIG
[    9.548737] Setting up standard PCI resources
[    9.558019] ACPI: Interpreter enabled
[    9.558021] ACPI: Using IOAPIC for interrupt routing
[    9.558598] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    9.558604] PCI: Probing PCI hardware (bus 00)
[    9.559733] Boot video device is 0000:00:02.0
[    9.560145] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    9.560149] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[    9.560184] PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
[    9.560918] PCI: Transparent bridge - 0000:00:1e.0
[    9.560968] PCI: Bus #07 (-#0a) is hidden behind transparent bridge
#06 (-#06) (try 'pci=assign-busses')
[    9.560971] Please report the result to linux-kernel to fix this permanently
[    9.561012] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    9.567501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    9.568101] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    9.568693] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    9.568909] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    9.569111] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    9.569313] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[    9.569513] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    9.569715] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    9.569922] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    9.570129] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 *3 4 5 6 7 11 12 14 15)



Thank you,

    Roi Avidan
