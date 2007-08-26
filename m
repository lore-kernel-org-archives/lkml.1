Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXHZLBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXHZLBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 07:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXHZLB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 07:01:27 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:38468 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXHZLBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 07:01:24 -0400
Message-ID: <1188125967.46d15d0f87c01@imp.free.fr>
Date: Sun, 26 Aug 2007 12:59:27 +0200
From: fredoxygene@free.fr
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel BUG at kernel/workqueue.c:323!
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 81.56.79.192
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PROBLEM: kernel BUG at kernel/workqueue.c:323!

Summary :
Happened while i was transferring a huge amount of data on wifi (ipw3945).
Computer is a Fujitsu/Siemens Si 1520 / T5500, running Unbuntu Feisty 7.04.

Follows :
- dmesg output with "kernel bug"
- scripts/ver_linux output
- others thinks like lspci -vvv, etc...

Feel free to ask i you need some more details or if i can help (by doing some
testings or other stuffs)

dmesg output :
[  178.752000] ieee80211_crypt: registered algorithm 'TKIP'
[  196.120000] eth1: no IPv6 routers present
[ 1548.228000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
[ 1548.924000] ipw3945: Error sending cmd #07 to daemon: time out after 500ms.
[ 1550.524000] ipw3945: Error sending SCAN_ABORT_CMD: time out after 500ms.
[ 1551.024000] ipw3945: Error sending cmd #08 to daemon: time out after 500ms.
[ 1551.524000] ipw3945: Error sending ADD_STA: time out after 500ms.
[ 1552.024000] ipw3945: Error sending SCAN_ABORT_CMD: time out after 500ms.
[ 1561.536000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
[ 1561.712000] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 1582.928000] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 1611.024000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
[ 1611.524000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
[ 1611.796000] ------------[ cut here ]------------
[ 1611.796000] kernel BUG at kernel/workqueue.c:323!
[ 1611.796000] invalid opcode: 0000 [#1]
[ 1611.796000] SMP
[ 1611.796000] Modules linked in: michael_mic arc4 ecb blkcipher
ieee80211_crypt_tkip aes ieee80211_crypt_ccmp isofs nls_iso8859_1 nls_cp437 udf
ipv6 binfmt_misc rfcomm l2cap bluetooth i915 drm ppdev acpi_cpufreq
cpufreq_stats cpufreq_ondemand freq_table cpufreq_powersave cpufreq_conservative
cpufreq_userspace sony_acpi tc1100_wmi dev_acpi pcc_acpi container dock video
asus_acpi sbs i2c_ec i2c_core battery ac backlight button af_packet nls_utf8
nls_cp850 vfat fat tifm_sd tifm_core sbp2 parport_pc lp parport fuse joydev
mmc_block snd_hda_intel snd_hda_codec ipw3945 snd_pcm_oss snd_mixer_oss snd_pcm
ieee80211 snd_seq_dummy ieee80211_crypt snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device sdhci mmc_core snd soundcore
snd_page_alloc iTCO_wdt iTCO_vendor_support serio_raw psmouse shpchp pci_hotplug
intel_agp agpgart tsdev evdev ext3 jbd mbcache usbhid hid sg sr_mod cdrom sd_mod
ata_piix ata_generic libata scsi_mod ohci1394 ieee1394 e100 mii ehci_hcd generic
uhci_hcd usbcore thermal processor fan fbcon tileblit font bitblit softcursor
vesafb capability commoncap
[ 1611.796000] CPU:    1
[ 1611.796000] EIP:    0060:[<c013736e>]    Not tainted VLI
[ 1611.796000] EFLAGS: 00010292   (2.6.20-16-generic #2)
[ 1611.796000] EIP is at run_workqueue+0xee/0x140
[ 1611.796000] eax: 05b41318   ebx: dfd949cc   ecx: 00000246   edx: 00000000
[ 1611.796000] esi: dfd949c0   edi: dfd949c8   ebp: 00000246   esp: f78c1f58
[ 1611.796000] ds: 007b   es: 007b   ss: 0068
[ 1611.796000] Process ipw3945/1 (pid: 3715, ti=f78c0000 task=c2112560
task.ti=f78c0000)
[ 1611.796000] Stack: 00000000 dfd949d4 f78c1f9c 00000246 dfd949cb dfd949e0
00000001 dfd949c0
[ 1611.796000]        dfd949cc dfd949d4 f78c1f9c c0137d97 00000001 00000000
c1ffc5c0 00010000
[ 1611.796000]        00000000 00000000 c2112560 c0120b40 00100100 00200200
ffffffff ffffffff
[ 1611.796000] Call Trace:
[ 1611.796000]  [<c0137d97>] worker_thread+0x147/0x170
[ 1611.796000]  [<c0120b40>] default_wake_function+0x0/0x10
[ 1611.796000]  [<c0137c50>] worker_thread+0x0/0x170
[ 1611.796000]  [<c013ac4a>] kthread+0xba/0xf0
[ 1611.796000]  [<c013ab8e>] keventd_create_kthread+0x6e/0x70
[ 1611.796000]  [<c01044c7>] kernel_thread_helper+0x7/0x10
[ 1611.796000]  =======================
[ 1611.796000] Code: 24 00 00 00 00 e8 f3 72 fe ff 8b 44 24 10 3b 46 0c 0f 85 78
ff ff ff 83 6e 34 01 89 ea 83 c4 1c 89 f0 5b 5e 5f 5d e9 f2 75 1b 00 <0f> 0b eb
fe 65 a1 08 00 00 00 8b 90 a4 00 00 00 05 94 01 00 00
[ 1611.796000] EIP: [<c013736e>] run_workqueue+0xee/0x140 SS:ESP 0068:f78c1f58
[ 1611.796000]  <6>ADDRCONF(NETDEV_UP): eth1: link is not ready



scripts/ver_linux output :
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux minimum 2.6.20-16-generic #2 SMP Thu Jun 7 20:19:32 UTC 2007 i686
GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   108
wireless-tools         28
Modules Loaded         michael_mic arc4 ecb blkcipher ieee80211_crypt_tkip aes
ieee80211_crypt_ccmp hci_usb nls_iso8859_1 isofs nls_cp437 udf ipv6 binfmt_misc
rfcomm l2cap bluetooth ppdev i915 drm acpi_cpufreq cpufreq_stats
cpufreq_ondemand freq_table cpufreq_powersave cpufreq_conservative
cpufreq_userspace sony_acpi tc1100_wmi dev_acpi pcc_acpi container dock video
asus_acpi sbs i2c_ec i2c_core battery ac backlight button af_packet nls_utf8
nls_cp850 vfat fat tifm_sd tifm_core sbp2 parport_pc lp parport fuse mmc_block
joydev snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event ipw3945
snd_seq snd_timer snd_seq_device iTCO_wdt iTCO_vendor_support sdhci ieee80211
ieee80211_crypt serio_raw mmc_core snd soundcore snd_page_alloc psmouse shpchp
pci_hotplug intel_agp agpgart tsdev evdev ext3 jbd mbcache sg sr_mod cdrom
sd_mod usbhid hid ata_piix ata_generic libata scsi_mod generic ohci1394 ieee1394
e100 mii uhci_hcd ehci_hcd usbcore thermal processor fan fbcon tileblit font
bitblit softcursor vesafb capability commoncap




[7.] Environment

 BASH=/bin/bash
 BASH_ARGC=()
 BASH_ARGV=()
 BASH_LINENO=([0]="0")
 BASH_SOURCE=([0]="./test.sh")
 BASH_VERSINFO=([0]="3" [1]="2" [2]="13" [3]="1" [4]="release"
[5]="i486-pc-linux-gnu")
 BASH_VERSION='3.2.13(1)-release'
 COLORTERM=gnome-terminal
 DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-7YKigLUCGY,guid=e7d1437a9a1c2fc806e0de0046d151a2
 DESKTOP_SESSION=default
 DESKTOP_STARTUP_ID=
 DIRSTACK=()
 DISPLAY=:0.0
 EUID=1000
 GDMSESSION=default
 GDM_XSERVER_LOCATION=local
 GNOME_DESKTOP_SESSION_ID=Default
 GNOME_KEYRING_SOCKET=/tmp/keyring-Ryk07I/socket
 GROUPS=()
 GTK_RC_FILES=/etc/gtk/gtkrc:/home/fredo/.gtkrc-1.2-gnome2
 HISTCONTROL=ignoreboth
 HOME=/home/fredo
 HOSTNAME=minimum
 HOSTTYPE=i486
 IFS=$' \t\n'
 LANG=fr_FR.UTF-8
 LANGUAGE=fr_FR:fr:en_GB:en
 LESSCLOSE='/usr/bin/lesspipe %s %s'
 LESSOPEN='| /usr/bin/lesspipe %s'
 LOGNAME=fredo
 LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:'
 MACHTYPE=i486-pc-linux-gnu
 OPTERR=1
 OPTIND=1
 OSTYPE=linux-gnu
 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
 PIPESTATUS=([0]="0")
 PPID=6927
 PS4='+ '
 PWD=/home/fredo
 SESSION_MANAGER=local/minimum:/tmp/.ICE-unix/5246
 SHELL=/bin/bash
 SHELLOPTS=braceexpand:hashall:interactive-comments
 SHLVL=2
 SSH_AGENT_PID=5286
 SSH_AUTH_SOCK=/tmp/ssh-yAlVFB5246/agent.5246
 TERM=xterm
 UID=1000
 USER=fredo
 USERNAME=fredo
 WINDOWID=52448764
 XAUTHORITY=/home/fredo/.Xauthority
 _=
 dmesg='cat /var/log/kern.log'
 kversion=2.6.20-16-generic
 oops_module=f78c1f58
 oops_number=
 tabout ()
 {
     sed -e '/^/s// /'
 }

[7.1.] Software (add the output of the ver_linux script here)

 If some fields are empty or look unusual you may have an old version.
 Compare to the current minimal requirements in Documentation/Changes.

 Linux minimum 2.6.20-16-generic #2 SMP Thu Jun 7 20:19:32 UTC 2007 i686
GNU/Linux

 Gnu C                  4.1.2
 Gnu make               3.81
 binutils               2.17.50
 util-linux             2.12r
 mount                  2.12r
 module-init-tools      3.3-pre2
 e2fsprogs              1.40-WIP
 reiserfsprogs          3.6.19
 pcmciautils            014
 PPP                    2.4.4
 Linux C Library        > libc.2.5
 Dynamic linker (ldd)   2.5
 Procps                 3.2.7
 Net-tools              1.60
 Console-tools          0.2.3
 Sh-utils               5.97
 udev                   108
 wireless-tools         28
 Modules Loaded         michael_mic arc4 ecb blkcipher ieee80211_crypt_tkip aes
ieee80211_crypt_ccmp hci_usb nls_iso8859_1 isofs nls_cp437 udf ipv6 binfmt_misc
rfcomm l2cap bluetooth ppdev i915 drm acpi_cpufreq cpufreq_stats
cpufreq_ondemand freq_table cpufreq_powersave cpufreq_conservative
cpufreq_userspace sony_acpi tc1100_wmi dev_acpi pcc_acpi container dock video
asus_acpi sbs i2c_ec i2c_core battery ac backlight button af_packet nls_utf8
nls_cp850 vfat fat tifm_sd tifm_core sbp2 parport_pc lp parport fuse mmc_block
joydev snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event ipw3945
snd_seq snd_timer snd_seq_device iTCO_wdt iTCO_vendor_support sdhci ieee80211
ieee80211_crypt serio_raw mmc_core snd soundcore snd_page_alloc psmouse shpchp
pci_hotplug intel_agp agpgart tsdev evdev ext3 jbd mbcache sg sr_mod cdrom
sd_mod usbhid hid ata_piix ata_generic libata scsi_mod generic ohci1394 ieee1394
e100 mii uhci_hcd ehci_hcd usbcore thermal processor fan fbcon tileblit font
bitblit softcursor vesafb capability commoncap

[7.2.] Processor information (from /proc/cpuinfo):

 processor	: 0
 vendor_id	: GenuineIntel
 cpu family	: 6
 model		: 15
 model name	: Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
 stepping	: 2
 cpu MHz		: 1000.000
 cache size	: 2048 KB
 physical id	: 0
 siblings	: 2
 core id		: 0
 cpu cores	: 2
 fdiv_bug	: no
 hlt_bug		: no
 f00f_bug	: no
 coma_bug	: no
 fpu		: yes
 fpu_exception	: yes
 cpuid level	: 10
 wp		: yes
 flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
 bogomips	: 3330.05
 clflush size	: 64

 processor	: 1
 vendor_id	: GenuineIntel
 cpu family	: 6
 model		: 15
 model name	: Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
 stepping	: 2
 cpu MHz		: 1000.000
 cache size	: 2048 KB
 physical id	: 0
 siblings	: 2
 core id		: 1
 cpu cores	: 2
 fdiv_bug	: no
 hlt_bug		: no
 f00f_bug	: no
 coma_bug	: no
 fpu		: yes
 fpu_exception	: yes
 cpuid level	: 10
 wp		: yes
 flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
 bogomips	: 3326.32
 clflush size	: 64


[7.3.] Module information (from /proc/modules):

 michael_mic 3584 4 - Live 0xf8f18000
 arc4 2944 4 - Live 0xf8dfe000
 ecb 4480 4 - Live 0xf8f3e000
 blkcipher 6784 1 ecb, Live 0xf8f0f000
 ieee80211_crypt_tkip 12032 2 - Live 0xf8f30000
 aes 28608 1 - Live 0xf8f36000
 ieee80211_crypt_ccmp 8448 1 - Live 0xf8f0b000
 hci_usb 18204 2 - Live 0xf8f12000
 nls_iso8859_1 5120 1 - Live 0xf8e7c000
 isofs 36284 1 - Live 0xf8f01000
 nls_cp437 6784 2 - Live 0xf8e29000
 udf 85252 0 - Live 0xf8f1a000
 ipv6 268960 10 - Live 0xf8f50000
 binfmt_misc 12680 1 - Live 0xf8e24000
 rfcomm 40856 0 - Live 0xf8e35000
 l2cap 25856 5 rfcomm, Live 0xf8e2d000
 bluetooth 55908 7 hci_usb,rfcomm,l2cap, Live 0xf8e61000
 ppdev 10116 0 - Live 0xf8e20000
 i915 24448 2 - Live 0xf8def000
 drm 81044 3 i915, Live 0xf8e00000
 acpi_cpufreq 10056 0 - Live 0xf8dd4000
 cpufreq_stats 7360 0 - Live 0xf8dd8000
 cpufreq_ondemand 9228 2 - Live 0xf8da9000
 freq_table 5792 3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand, Live 0xf8dd1000
 cpufreq_powersave 2688 0 - Live 0xf8c56000
 cpufreq_conservative 8200 0 - Live 0xf8dcd000
 cpufreq_userspace 5408 0 - Live 0xf8dc0000
 sony_acpi 6284 0 - Live 0xf8dbd000
 tc1100_wmi 8068 0 - Live 0xf8bb0000
 dev_acpi 12292 0 - Live 0xf8dc8000
 pcc_acpi 13184 0 - Live 0xf8dc3000
 container 5248 0 - Live 0xf8da6000
 dock 10268 0 - Live 0xf8db9000
 video 16388 0 - Live 0xf8db3000
 asus_acpi 17308 0 - Live 0xf8dad000
 sbs 15652 0 - Live 0xf8d9a000
 i2c_ec 6016 1 sbs, Live 0xf8d97000
 i2c_core 22656 1 i2c_ec, Live 0xf8d9f000
 battery 10756 0 - Live 0xf8c4b000
 ac 6020 0 - Live 0xf8c37000
 backlight 7040 1 asus_acpi, Live 0xf8acb000
 button 8720 0 - Live 0xf8c47000
 af_packet 23816 4 - Live 0xf8c4f000
 nls_utf8 3072 1 - Live 0xf89e2000
 nls_cp850 5888 1 - Live 0xf8bad000
 vfat 14208 2 - Live 0xf8c42000
 fat 53916 1 vfat, Live 0xf8d88000
 tifm_sd 12552 0 - Live 0xf8c32000
 tifm_core 11140 1 tifm_sd, Live 0xf89f7000
 sbp2 23812 0 - Live 0xf8c3b000
 parport_pc 36388 0 - Live 0xf8c1b000
 lp 12452 0 - Live 0xf8c16000
 parport 36936 3 ppdev,parport_pc,lp, Live 0xf8bf5000
 fuse 46612 3 - Live 0xf8c25000
 mmc_block 13832 2 - Live 0xf8ae9000
 joydev 10816 0 - Live 0xf8aee000
 snd_hda_intel 21912 2 - Live 0xf8be8000
 snd_hda_codec 205056 1 snd_hda_intel, Live 0xf8c58000
 snd_pcm_oss 44544 0 - Live 0xf8bd2000
 snd_mixer_oss 17408 1 snd_pcm_oss, Live 0xf8afa000
 snd_pcm 79876 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8c01000
 snd_seq_dummy 4740 0 - Live 0xf8ace000
 snd_seq_oss 32896 0 - Live 0xf8bde000
 snd_seq_midi 9600 0 - Live 0xf8add000
 snd_rawmidi 25472 1 snd_seq_midi, Live 0xf8af2000
 snd_seq_midi_event 8448 2 snd_seq_oss,snd_seq_midi, Live 0xf8ad9000
 ipw3945 118816 1 - Live 0xf8bb3000
 snd_seq 52592 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live
0xf8b81000
 snd_timer 23684 2 snd_pcm,snd_seq, Live 0xf8ae2000
 snd_seq_device 9100 5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8ad5000
 iTCO_wdt 11812 0 - Live 0xf8ad1000
 iTCO_vendor_support 4868 1 iTCO_wdt, Live 0xf8a5c000
 sdhci 18700 0 - Live 0xf8a60000
 ieee80211 34760 1 ipw3945, Live 0xf8ac1000
 ieee80211_crypt 7040 3 ieee80211_crypt_tkip,ieee80211_crypt_ccmp,ieee80211,
Live 0xf89f4000
 serio_raw 7940 0 - Live 0xf8a56000
 mmc_core 26756 3 tifm_sd,mmc_block,sdhci, Live 0xf8a76000
 snd 54020 14
snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xf8a67000
 soundcore 8672 1 snd, Live 0xf8a52000
 snd_page_alloc 10888 2 snd_hda_intel,snd_pcm, Live 0xf8a4e000
 psmouse 38920 0 - Live 0xf8a2f000
 shpchp 34324 0 - Live 0xf8a44000
 pci_hotplug 32576 1 shpchp, Live 0xf8a3b000
 intel_agp 25244 1 - Live 0xf8a27000
 agpgart 35400 3 drm,intel_agp, Live 0xf89fb000
 tsdev 8768 0 - Live 0xf89eb000
 evdev 11008 5 - Live 0xf89e7000
 ext3 133128 1 - Live 0xf8a05000
 jbd 59816 1 ext3, Live 0xf89ce000
 mbcache 9604 1 ext3, Live 0xf8997000
 sg 36252 0 - Live 0xf89b0000
 sr_mod 17060 1 - Live 0xf899e000
 cdrom 37664 1 sr_mod, Live 0xf88e8000
 sd_mod 23428 4 - Live 0xf88dc000
 usbhid 26592 0 - Live 0xf88fb000
 hid 27392 1 usbhid, Live 0xf88f3000
 ata_piix 15492 4 - Live 0xf88e3000
 ata_generic 9092 0 - Live 0xf88d2000
 libata 125720 2 ata_piix,ata_generic, Live 0xf8977000
 scsi_mod 142348 5 sbp2,sg,sr_mod,sd_mod,libata, Live 0xf8953000
 generic 5124 0 [permanent], Live 0xf88b8000
 ohci1394 36528 0 - Live 0xf88c1000
 ieee1394 299448 2 sbp2,ohci1394, Live 0xf8908000
 e100 36232 0 - Live 0xf885e000
 mii 6528 1 e100, Live 0xf8856000
 uhci_hcd 25360 0 - Live 0xf8873000
 ehci_hcd 34188 0 - Live 0xf8869000
 usbcore 134280 5 hci_usb,usbhid,uhci_hcd,ehci_hcd, Live 0xf8887000
 thermal 14856 0 - Live 0xf8859000
 processor 31048 2 acpi_cpufreq,thermal, Live 0xf883e000
 fan 5636 0 - Live 0xf883b000
 fbcon 42656 0 - Live 0xf8847000
 tileblit 3584 1 fbcon, Live 0xf8839000
 font 9216 1 fbcon, Live 0xf8835000
 bitblit 6912 1 fbcon, Live 0xf882c000
 softcursor 3200 1 bitblit, Live 0xf882f000
 vesafb 9220 0 - Live 0xf8822000
 capability 5896 0 - Live 0xf8829000
 commoncap 8192 1 capability, Live 0xf8826000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

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
 0170-0177 : 0000:00:1f.2
   0170-0177 : libata
 01f0-01f7 : 0000:00:1f.2
   01f0-01f7 : libata
 0376-0376 : 0000:00:1f.2
   0376-0376 : libata
 03c0-03df : vga+
 03f6-03f6 : 0000:00:1f.2
   03f6-03f6 : libata
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
 1800-1807 : 0000:00:02.0
 1820-183f : 0000:00:1d.0
   1820-183f : uhci_hcd
 1840-185f : 0000:00:1d.1
   1840-185f : uhci_hcd
 1860-187f : 0000:00:1d.2
   1860-187f : uhci_hcd
 1880-189f : 0000:00:1d.3
   1880-189f : uhci_hcd
 18b0-18bf : 0000:00:1f.2
   18b0-18bf : libata
 18e0-18ff : 0000:00:1f.3
 2000-2fff : PCI Bus #01
 3000-3fff : PCI Bus #03
 4000-4fff : PCI Bus #05
 5000-5fff : PCI Bus #07
   5000-503f : 0000:07:08.0
     5000-503f : e100
 00000000-0009f7ff : System RAM
   00000000-00000000 : Crash kernel
 0009f800-0009ffff : reserved
 000a0000-000bffff : Video RAM area
 000c0000-000c7fff : Video ROM
 000f0000-000fffff : System ROM
 00100000-7f68ffff : System RAM
   00100000-002f2373 : Kernel code
   002f2374-003d36d3 : Kernel data
 7f690000-7f6fffff : ACPI Non-volatile Storage
 7f700000-7fffffff : reserved
 c0000000-cfffffff : 0000:00:02.0
 d0000000-d1ffffff : PCI Bus #03
 d2000000-d3ffffff : PCI Bus #05
 d4000000-d5ffffff : PCI Bus #01
 d6000000-d7ffffff : PCI Bus #03
 d8000000-d9ffffff : PCI Bus #05
 da000000-dbffffff : PCI Bus #01
   da000000-da000fff : 0000:01:00.0
     da000000-da000fff : ipw3945
 dc000000-dc0fffff : PCI Bus #07
   dc000000-dc000fff : 0000:07:08.0
     dc000000-dc000fff : e100
   dc001000-dc0017ff : 0000:07:09.0
     dc001000-dc0017ff : ohci1394
   dc001800-dc0018ff : 0000:07:09.1
     dc001800-dc0018ff : sdhci:slot0
   dc001c00-dc001cff : 0000:07:09.2
   dc002000-dc0020ff : 0000:07:09.3
   dc002400-dc0024ff : 0000:07:09.4
 dc100000-dc17ffff : 0000:00:02.0
 dc180000-dc1fffff : 0000:00:02.1
 dc200000-dc23ffff : 0000:00:02.0
 dc240000-dc243fff : 0000:00:1b.0
   dc240000-dc243fff : ICH HD audio
 dc444000-dc4443ff : 0000:00:1d.7
   dc444000-dc4443ff : ehci_hcd
 e0000000-efffffff : reserved
 fec00000-fec0ffff : reserved
 fed00000-fed003ff : HPET 0
 fed14000-fed19fff : reserved
 fed1c000-fed8ffff : reserved
 fee00000-fee00fff : reserved
 ff000000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)

 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT
Express Memory Controller Hub (rev 03)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR-
 	Latency: 0
 	Capabilities: [e0] Vendor Specific Information

 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML
Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 17
 	Region 0: Memory at dc100000 (32-bit, non-prefetchable) [size=512K]
 	Region 1: I/O ports at 1800 [size=8]
 	Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]
 	Region 3: Memory at dc200000 (32-bit, non-prefetchable) [size=256K]
 	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
 		Address: 00000000  Data: 0000
 	Capabilities: [d0] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express
Integrated Graphics Controller (rev 03)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Region 0: Memory at dc180000 (32-bit, non-prefetchable) [size=512K]
 	Capabilities: [d0] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition
Audio Controller (rev 02)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 23
 	Region 0: Memory at dc240000 (64-bit, non-prefetchable) [size=16K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
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

 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1
(rev 02) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 	I/O behind bridge: 00002000-00002fff
 	Memory behind bridge: da000000-dbffffff
 	Prefetchable memory behind bridge: 00000000d4000000-00000000d5ffffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 	Capabilities: [40] Express Root Port (Slot+) IRQ 0
 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
 		Device: Latency L0s unlimited, L1 unlimited
 		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
 		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
 		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
 		Link: Latency L0s <256ns, L1 <4us
 		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
 		Link: Speed 2.5Gb/s, Width x1
 		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
 		Slot: Number 2, PowerLimit 6.500000
 		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
 		Slot: AttnInd Unknown, PwrInd Unknown, Power-
 		Root: Correctable- Non-Fatal- Fatal- PME-
 	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
 		Address: 00000000  Data: 0000
 	Capabilities: [90] Subsystem: Fujitsu Siemens Computer GmbH Unknown device
10ad
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2
(rev 02) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
 	I/O behind bridge: 00003000-00003fff
 	Memory behind bridge: d6000000-d7ffffff
 	Prefetchable memory behind bridge: 00000000d0000000-00000000d1ffffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 	Capabilities: [40] Express Root Port (Slot+) IRQ 0
 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
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
 	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
 		Address: 00000000  Data: 0000
 	Capabilities: [90] Subsystem: Fujitsu Siemens Computer GmbH Unknown device
10ad
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3
(rev 02) (prog-if 00 [Normal decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0, Cache Line Size: 64 bytes
 	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
 	I/O behind bridge: 00004000-00004fff
 	Memory behind bridge: d8000000-d9ffffff
 	Prefetchable memory behind bridge: 00000000d2000000-00000000d3ffffff
 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 	Capabilities: [40] Express Root Port (Slot+) IRQ 0
 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
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
 	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
 		Address: 00000000  Data: 0000
 	Capabilities: [90] Subsystem: Fujitsu Siemens Computer GmbH Unknown device
10ad
 	Capabilities: [a0] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev
02) (prog-if 00 [UHCI])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 19
 	Region 4: I/O ports at 1820 [size=32]

 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev
02) (prog-if 00 [UHCI])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin B routed to IRQ 20
 	Region 4: I/O ports at 1840 [size=32]

 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev
02) (prog-if 00 [UHCI])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin C routed to IRQ 18
 	Region 4: I/O ports at 1860 [size=32]

 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev
02) (prog-if 00 [UHCI])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin D routed to IRQ 17
 	Region 4: I/O ports at 1880 [size=32]

 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 02) (prog-if 20 [EHCI])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 19
 	Region 0: Memory at dc444000 (32-bit, non-prefetchable) [size=1K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
 	Capabilities: [58] Debug port

 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if
01 [Subtractive decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Bus: primary=00, secondary=07, subordinate=07, sec-latency=32
 	I/O behind bridge: 00005000-00005fff
 	Memory behind bridge: dc000000-dc0fffff
 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 	Capabilities: [50] Subsystem: Fujitsu Siemens Computer GmbH Unknown device
10ad

 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge
(rev 02)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Capabilities: [e0] Vendor Specific Information

 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA
Storage Controller IDE (rev 02) (prog-if 80 [Master])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0
 	Interrupt: pin B routed to IRQ 20
 	Region 0: I/O ports at 01f0 [size=8]
 	Region 1: I/O ports at 03f4 [size=1]
 	Region 2: I/O ports at 0170 [size=8]
 	Region 3: I/O ports at 0374 [size=1]
 	Region 4: I/O ports at 18b0 [size=16]
 	Capabilities: [70] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Interrupt: pin B routed to IRQ 10
 	Region 4: I/O ports at 18e0 [size=32]

 01:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network
Connection (rev 02)
 	Subsystem: Intel Corporation Unknown device 1001
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 17
 	Region 0: Memory at da000000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [c8] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
 		Address: 0000000000000000  Data: 0000
 	Capabilities: [e0] Express Legacy Endpoint IRQ 0
 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
 		Device: Latency L0s <512ns, L1 unlimited
 		Device: AtnBtn- AtnInd- PwrInd-
 		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
 		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
 		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
 		Link: Latency L0s <128ns, L1 <64us
 		Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
 		Link: Speed 2.5Gb/s, Width x1

 07:08.0 Ethernet controller: Intel Corporation PRO/100 VE Network Connection
(rev 02)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 64 (2000ns min, 14000ns max)
 	Interrupt: pin A routed to IRQ 21
 	Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=4K]
 	Region 1: I/O ports at 5000 [size=64]
 	Capabilities: [dc] Power Management version 2
 		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

 07:09.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (prog-if 10
[OHCI])
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 64 (500ns min, 1000ns max)
 	Interrupt: pin A routed to IRQ 21
 	Region 0: Memory at dc001000 (32-bit, non-prefetchable) [size=2K]
 	Capabilities: [dc] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME+

 07:09.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Latency: 64
 	Interrupt: pin B routed to IRQ 22
 	Region 0: Memory at dc001800 (32-bit, non-prefetchable) [size=256]
 	Capabilities: [80] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

 07:09.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Interrupt: pin B routed to IRQ 11
 	Region 0: Memory at dc001c00 (32-bit, non-prefetchable) [disabled] [size=256]
 	Capabilities: [80] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

 07:09.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter
(rev 0a)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Interrupt: pin B routed to IRQ 11
 	Region 0: Memory at dc002000 (32-bit, non-prefetchable) [disabled] [size=256]
 	Capabilities: [80] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

 07:09.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
 	Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 	Interrupt: pin B routed to IRQ 11
 	Region 0: Memory at dc002400 (32-bit, non-prefetchable) [disabled] [size=256]
 	Capabilities: [80] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-


[7.6.] SCSI information (from /proc/scsi/scsi)

 Attached devices:
 Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD1600BEVS-0 Rev: 04.0
   Type:   Direct-Access                    ANSI SCSI revision: 05
 Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: HL-DT-ST Model: DVDRAM GSA-T20N  Rev: WW01
   Type:   CD-ROM                           ANSI SCSI revision: 05

