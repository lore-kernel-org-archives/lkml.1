Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXCUSXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXCUSXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCUSXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:23:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:9627 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbXCUSX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:user-agent:mime-version:date:content-type:message-id:from;
        b=nQaHwmqLnCoZ0rZTAmR4y/4EIoMx35ZXbJksDo8TSvTY716koJ+ttgi+WVfTtSjChOuXaM7EX6P+uhRniBBQhGQZajxLM3nMWBg+MEGxphkYTtgWQZPPCZWSb68L+kWfJga07zw+C9D6EYolkh1zBKh/U0h0TjV3b+uEL9b9YcQ=
To: linux-kernel@vger.kernel.org
Subject: BUG: at drivers/hid/hid-core.c:778 implement() with bluetooth keyboard/mouse
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Date: Wed, 21 Mar 2007 19:23:04 +0100
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IgXAGtrlxgL6p6M"
Message-Id: <200703211923.04651.Kevin.Baradon@gmail.com>
From: Kevin Baradon <kevin.baradon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_IgXAGtrlxgL6p6M
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[Please Cc: me as I'm not subscribed]

Hello everybody,


[1.] One line summary of the problem :
"BUG: at drivers/hid/hid-core.c:778 implement()" message in logs when booti=
ng=20
with bluetooth keyboard + mouse.

[2.] Full description of the problem/report :
During bootup, warnings (see below) are emitted in system log.=20
Hardware :=20
=2D P4 3.06MHz
=2D Logitech Cordless MX Desktop for Bluetooth (keyboard + mouse with an US=
B=20
bluetooth adapter).

Please let me know what I could do to help debugging this problem.


[3.] Keywords (i.e., modules, networking, kernel) :
HID, bluetooth, implement(), input

[4.] Kernel version :
Linux version 2.6.21-rc4 (root@kev1) (gcc version 4.1.2 20061115 (prereleas=
e)=20
(Debian 4.1.1-21)) #9 SMP PREEMPT Sun Mar 18 22:26:43 CET 2007

[5.] Most recent kernel version which did not have the bug :
Unknown, but I'm quite sure 2.6.20 has this problem.

[6.] Output of Oops.. message (if applicable) : extract of dmesg
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c0288c83>] usbhid_init_reports+0x70/0xe1
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c0288c83>] usbhid_init_reports+0x70/0xe1
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c0288c83>] usbhid_init_reports+0x70/0xe1
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
input: Logitech Bluetooth Mou=F0 as /class/input/input8
input: Logitech Bluetooth Keyboard as /class/input/input9


[7.] A small shell script or example program which
  triggers the problem (if possible) :
Simply boot system with bluetooth keyboard pluged in. Message probably appe=
ars=20
when USB bluetooth adapter is put in HCI mode (with hid2hci).

[8.1.] Software :
Linux kev1 2.6.21-rc4 #9 SMP PREEMPT Sun Mar 18 22:26:43 CET 2007 i686=20
GNU/Linux
=20
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
wireless-tools         29
Modules Loaded         rt2500 radeon drm xt_multiport snd_cs46xx tuner=20
snd_seq_midi 8139too cx88_alsa cx8800 cx88xx mii snd_rawmidi snd_ac97_codec=
=20
ir_common video_buf tveeprom btcx_risc ac97_bus

[8.2.] Processor information :
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 3.06GHz
stepping	: 7
cpu MHz		: 3066.590
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat=
=20
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
bogomips	: 6164.90
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 3.06GHz
stepping	: 7
cpu MHz		: 3066.590
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat=
=20
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
bogomips	: 6162.06
clflush size	: 64


[8.3.] Module information :
rt2500 172516 0 - Live 0xe1ad2000
radeon 122400 2 - Live 0xe1a81000
drm 126488 3 radeon, Live 0xe1a61000
xt_multiport 3456 1 - Live 0xe08a5000
snd_cs46xx 80456 3 - Live 0xe08ea000
tuner 59304 0 - Live 0xe1915000
snd_seq_midi 8736 0 - Live 0xe08a1000
8139too 25216 0 - Live 0xe08ab000
cx88_alsa 13352 1 - Live 0xe0879000
cx8800 33520 0 - Live 0xe0836000
cx88xx 67108 2 cx88_alsa,cx8800, Live 0xe08d8000
mii 5888 1 8139too, Live 0xe0833000
snd_rawmidi 23840 2 snd_cs46xx,snd_seq_midi, Live 0xe0824000
snd_ac97_codec 93984 1 snd_cs46xx, Live 0xe08c0000
ir_common 34692 1 cx88xx, Live 0xe0869000
video_buf 24580 3 cx88_alsa,cx8800,cx88xx, Live 0xe0861000
tveeprom 15248 1 cx88xx, Live 0xe082b000
btcx_risc 5128 3 cx88_alsa,cx8800,cx88xx, Live 0xe0821000
ac97_bus 2688 1 snd_ac97_codec, Live 0xe081f000

[8.4.] Loaded driver and hardware information :
# cat /proc/ioports
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
0170-0177 : 0000:00:02.5
  0170-0177 : ide1
01f0-01f7 : 0000:00:02.5
0290-0297 : it87-isa
02f8-02ff : serial
0376-0376 : 0000:00:02.5
  0376-0376 : ide1
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:02.5
03f7-03f7 : floppy DIR
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-1003 : ACPI PM1a_EVT_BLK
1004-1005 : ACPI PM1a_CNT_BLK
1008-100b : ACPI PM_TMR
1016-1016 : ACPI PM2_CNT_BLK
1020-1023 : ACPI GPE0_BLK
1030-1033 : ACPI GPE1_BLK
1400-141f : 0000:00:02.1
  1400-141f : sis96x_smbus
a000-afff : PCI Bus #01
  a000-a0ff : 0000:01:00.0
    a000-a0ff : radeon
b800-b8ff : 0000:00:0b.0
  b800-b8ff : 8139too
bc10-bc17 : 0000:00:0e.0
  bc10-bc17 : ide2
c000-c003 : 0000:00:0e.0
  c002-c002 : ide2
c410-c417 : 0000:00:0e.0
  c410-c417 : ide3
c800-c803 : 0000:00:0e.0
  c802-c802 : ide3
cc00-cc0f : 0000:00:0e.0
  cc00-cc07 : ide2
  cc08-cc0f : ide3
d000-d03f : 0000:00:0f.0
  d000-d03f : e1000
d400-d407 : 0000:00:10.0
d800-d803 : 0000:00:10.0
dc00-dc07 : 0000:00:10.0
e000-e003 : 0000:00:10.0
e400-e40f : 0000:00:10.0
f000-f00f : 0000:00:02.5
  f000-f007 : ide0
  f008-f00f : ide1

# cat /proc/iomem
00000000-0009ffff : System RAM
  00000000-00000000 : Crash kernel
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000d0000-000d47ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
  00100000-00369b82 : Kernel code
  00369b83-0043d537 : Kernel data
1fff0000-1fff2fff : ACPI Non-volatile Storage
1fff3000-1fffffff : ACPI Tables
30000000-3007ffff : 0000:00:10.0
30080000-3009ffff : 0000:00:0e.0
300a0000-300affff : 0000:00:0b.0
e0000000-e7ffffff : 0000:00:00.0
e8000000-f7ffffff : PCI Bus #01
  e8000000-efffffff : 0000:01:00.0
    e8000000-efffffff : radeon
  f0000000-f7ffffff : 0000:01:00.1
f8000000-f9ffffff : PCI Bus #01
  f8000000-f801ffff : 0000:01:00.0
  f9000000-f900ffff : 0000:01:00.0
    f9000000-f900ffff : radeon
  f9010000-f901ffff : 0000:01:00.1
fb000000-fbffffff : 0000:00:0c.0
  fb000000-fbffffff : cx88[0]
fc000000-fcffffff : 0000:00:0c.1
  fc000000-fcffffff : cx88[0]
fd000000-fd0fffff : 0000:00:0d.0
  fd000000-fd002fff : CS46xx_BA1_data0
  fd010000-fd0137ff : CS46xx_BA1_data1
  fd020000-fd026fff : CS46xx_BA1_pmem
  fd030000-fd0300ff : CS46xx_BA1_reg
fd100000-fd11ffff : 0000:00:0f.0
  fd100000-fd11ffff : e1000
fd120000-fd121fff : 0000:00:0a.0
  fd120000-fd121fff : 0000:00:0a.0
fd123000-fd1230ff : 0000:00:0b.0
  fd123000-fd1230ff : 8139too
fd124000-fd124fff : 0000:00:03.0
  fd124000-fd124fff : ohci_hcd
fd125000-fd125fff : 0000:00:03.1
  fd125000-fd125fff : ohci_hcd
fd126000-fd126fff : 0000:00:0d.0
  fd126000-fd126fff : CS46xx_BA0
fd127000-fd127fff : 0000:00:03.2
  fd127000-fd127fff : ohci_hcd
fd128000-fd128fff : 0000:00:03.3
  fd128000-fd128fff : ehci_hcd
fd129000-fd1291ff : 0000:00:10.0
  fd129000-fd1291ff : sata_sil
fec00000-ffffffff : reserved

[8.5.] PCI information :
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 655 Host (rev 10)
	Subsystem: Silicon Integrated Systems [SiS] 655 Host
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort+ >SERR- <PERR-
	Latency: 32
	Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=3D128M]
	Capabilities: [c0] AGP version 3.0
		Status: RQ=3D32 Iso- ArqSz=3D2 Cal=3D3 SBA+ ITACoh- GART64- HTrans- 64bit=
=2D FW+=20
AGP3+ Rate=3Dx4,x8
		Command: RQ=3D1 ArqSz=3D0 Cal=3D0 SBA+ AGP+ GART64- 64bit- FW- Rate=3Dx8

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SG86C202 (prog-if 00=20
[Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
=20
<MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: f8000000-f9ffffff
	Prefetchable memory behind bridge: e8000000-f7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
=20
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL Media I=
O]=20
(rev 04)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 0
	Region 4: I/O ports at 1400 [size=3D32]

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (prog-if=
 80=20
[Master])
	Subsystem: Silicon Integrated Systems [SiS] SiS5513 EIDE Controller (A,B=20
step)
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 128
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disable=
d]=20
[size=3D8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disable=
d]=20
[size=3D1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disable=
d]=20
[size=3D8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disable=
d]=20
[size=3D1]
	Region 4: I/O ports at f000 [size=3D16]

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller=
=20
(rev 0f) (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] USB 1.0 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR+
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fd124000 (32-bit, non-prefetchable) [size=3D4K]

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller=
=20
(rev 0f) (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] USB 1.0 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at fd125000 (32-bit, non-prefetchable) [size=3D4K]

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller=
=20
(rev 0f) (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] USB 1.0 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at fd127000 (32-bit, non-prefetchable) [size=3D4K]

00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller=
=20
(prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Unknown device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (20000ns max)
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fd128000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 6834
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort-=
=20
<MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fd120000 (32-bit, non-prefetchable) [size=3D8K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd.=20
RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at b800 [size=3D256]
	Region 1: Memory at fd123000 (32-bit, non-prefetchable) [size=3D256]
	[virtual] Expansion ROM at 300a0000 [disabled] [size=3D64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0-,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0c.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and=20
Audio Decoder (rev 03)
	Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 34xxx models
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0c.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio=20
Decoder [Audio Port] (rev 03)
	Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 34xxx models
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0d.0 Multimedia audio controller: Cirrus Logic CS 4614/22/24/30=20
[CrystalClear SoundFusion Audio Accelerator] (rev 01)
	Subsystem: Hercules Unknown device a010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort-=
=20
<MAbort- >SERR- <PERR-
	Latency: 32 (1000ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fd126000 (32-bit, non-prefetchable) [size=3D4K]
	Region 1: Memory at fd000000 (32-bit, non-prefetchable) [size=3D1M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0e.0 RAID bus controller: <pci_lookup_name: buffer too small> (rev 10)
	Subsystem: Integrated Technology Express, Inc. IT/ITE8212 Dual channel ATA=
=20
RAID controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 0 (2000ns min, 2000ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at bc10 [size=3D8]
	Region 1: I/O ports at c000 [size=3D4]
	Region 2: I/O ports at c410 [size=3D8]
	Region 3: I/O ports at c800 [size=3D4]
	Region 4: I/O ports at cc00 [size=3D16]
	[virtual] Expansion ROM at 30080000 [disabled] [size=3D128K]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0f.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet=20
Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 3013
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (63750ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fd100000 (32-bit, non-prefetchable) [size=3D128K]
	Region 2: I/O ports at d000 [size=3D64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=3D512 OST=3D1
		Status: Dev=3D00:00.0 64bit- 133MHz- SCD- USC- DC=3Dsimple DMMRBC=3D2048 =
DMOST=3D1=20
DMCRS=3D16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0=
=20
Enable-
		Address: 0000000000000000  Data: 0000

00:10.0 Mass storage controller: Silicon Image, Inc. SiI 3112=20
[SATALink/SATARaid] Serial ATA Controller (rev 02)
	Subsystem: Silicon Image, Inc. SiI 3112 SATALink Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at d400 [size=3D8]
	Region 1: I/O ports at d800 [size=3D4]
	Region 2: I/O ports at dc00 [size=3D8]
	Region 3: I/O ports at e000 [size=3D4]
	Region 4: I/O ports at e400 [size=3D16]
	Region 5: Memory at fd129000 (32-bit, non-prefetchable) [size=3D512]
	[virtual] Expansion ROM at 30000000 [disabled] [size=3D512K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AS [Radeon 95=
50]=20
(prog-if 00 [VGA])
	Subsystem: Unknown device 0001:0370
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=3D128M]
	Region 1: I/O ports at a000 [size=3D256]
	Region 2: Memory at f9000000 (32-bit, non-prefetchable) [size=3D64K]
	[virtual] Expansion ROM at f8000000 [disabled] [size=3D128K]
	Capabilities: [58] AGP version 3.0
		Status: RQ=3D256 Iso- ArqSz=3D0 Cal=3D0 SBA+ ITACoh- GART64- HTrans- 64bi=
t- FW+=20
AGP3+ Rate=3Dx4,x8
		Command: RQ=3D32 ArqSz=3D2 Cal=3D0 SBA+ AGP+ GART64- 64bit- FW- Rate=3Dx8
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

01:00.1 Display controller: ATI Technologies Inc RV350 AS [Radeon 9550]=20
(Secondary)
	Subsystem: Unknown device 0001:0371
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng-=20
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
=2D=20
<MAbort- >SERR- <PERR-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=3D128M]
	Region 1: Memory at f9010000 (32-bit, non-prefetchable) [size=3D64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-


[8.6.] SCSI information :
Attached devices:=20
Host: scsi0 Channel: 00 Target: 00 Lun: 00
  Vendor: ATA      Model: WDC WD360GD-00FN Rev: 35.0
  Type:   Direct-Access                    ANSI SCSI revision: 05

[8.7.] lsusb (attached); dmesg (attached)

=2D-=20
Kevin Baradon
Networks & Telecom Student
=2D

--Boundary-00=_IgXAGtrlxgL6p6M
Content-Type: text/plain;
  charset="iso-8859-15";
  name="lsusb"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsusb"


Bus 004 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.21-rc4 ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:03.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 003 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.21-rc4 ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:03.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.21-rc4 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:03.3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 002 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.21-rc4 ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:03.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 002 Device 002: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0         8
  idVendor           0x0451 Texas Instruments, Inc.
  idProduct          0x2036 TUSB2036 Hub
  bcdDevice            1.01
  iManufacturer           0 
  iProduct                1 General Purpose USB Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1 General Purpose USB Hub
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              1 General Purpose USB Hub
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x0014
    Ganged power switching
    Compound device
    No overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x06
  PortPwrCtrlMask    0x06
 Hub Port Status:
   Port 1: 0000.0303 lowspeed power enable connect
   Port 2: 0000.0103 power enable connect
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 003: ID 046d:c703 Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc703 
  bcdDevice           24.04
  iManufacturer           1 Logitech
  iProduct                2 USB Receiver
  iSerial                 3 08E6A2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      59
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     168
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 004: ID 046d:c707 Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc707 
  bcdDevice            8.46
  iManufacturer           1 Logitech
  iProduct                2 Logitech Bluetooth wireless hub
  iSerial                 3 08E6A2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          193
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      1 Device Firmware Update
      bInterfaceProtocol      0 
      iInterface              0 
Device Status:     0x0000
  (Bus Powered)

--Boundary-00=_IgXAGtrlxgL6p6M
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg"

Linux version 2.6.21-rc4 (root@kev1) (gcc version 4.1.2 20061115 (prereleas=
e) (Debian 4.1.1-21)) #9 SMP PREEMPT Sun Mar 18 22:26:43 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 0000000=
0000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000=
000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 0000000=
01fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 0000000000003000 end: 0000000=
01fff3000 type: 4
copy_e820_map() start: 000000001fff3000 size: 000000000000d000 end: 0000000=
020000000 type: 3
copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end: 0000000=
100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
 BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
511MB LOWMEM available.
found SMP MP-table at 000f5650
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F71F0, 0014 (r0 GBT   )
ACPI: RSDT 1FFF3000, 002C (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 1FFF3040, 0074 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 1FFF30C0, 3AF1 (r1 GBT    AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 1FFF0000, 0040
ACPI: APIC 1FFF6BC0, 0068 (r1 GBT    AWRDACPI 42302E31 AWRD  1010101)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 20, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists.  Total pages: 130033
Kernel command line: root=3D/dev/sda4 panic=3D30 vga=3Dextended nmi_watchdo=
g=3D1 selinux=3D0 ro=20
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 3081.603 MHz processor.
Console: colour VGA+ 80x50
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515392k/524224k available (2470k kernel code, 8356k reserved, 846k =
data, 212k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb8000 - 0xfffff000   ( 284 kB)
    vmalloc : 0xe0800000 - 0xfffb6000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc0444000 - 0xc0479000   ( 212 kB)
      .data : 0xc0369b83 - 0xc043d538   ( 846 kB)
      .text : 0xc0100000 - 0xc0369b83   (2470 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 6164.90 BogoMIPS (lpj=3D30=
82452)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000=
0000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00000000 00=
000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
=46reeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 3.06GHz stepping 07
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6162.06 BogoMIPS (lpj=3D30=
81032)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000=
0000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00000000 00=
000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.06GHz stepping 07
Total of 2 processors activated (12326.96 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=3D71
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Enabling SiS 96x SMBus.
0000:00:02.5: cannot adjust BAR0 (not I/O)
0000:00:02.5: cannot adjust BAR1 (not I/O)
0000:00:02.5: cannot adjust BAR2 (not I/O)
0000:00:02.5: cannot adjust BAR3 (not I/O)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f8000000-f9ffffff
  PREFETCH window: e8000000-f7ffffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 5, 196608 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [FUTS]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected SiS 655 chipset
agpgart: AGP aperture is 128M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 19 (level, low) -> IRQ 16
e1000: 0000:00:0f.0: e1000_probe: (PCI:33MHz:32-bit) 00:20:ed:5b:02:f6
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
SIS5513: IDE controller at PCI slot 0000:00:02.5
SIS5513: chipset revision 0
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: ASUS CRW-5224A, ATAPI CD/DVD-ROM drive
hdd: TSSTcorpCD/DVDW SH-S182D, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
IT8212: IDE controller at PCI slot 0000:00:0e.0
ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 18 (level, low) -> IRQ 17
IT8212: chipset revision 16
it821x: controller in pass through mode.
IT8212: 100% native mode on irq 17
    ide2: BM-DMA at 0xcc00-0xcc07, BIOS settings: hde:pio, hdf:pio
it821x: Revision 0x10, workarounds activated.
    ide3: BM-DMA at 0xcc08-0xcc0f, BIOS settings: hdg:pio, hdh:pio
it821x: Revision 0x10, workarounds activated.
Probing IDE interface ide2...
hde: Maxtor 6Y080P0, ATA DISK drive
ide2 at 0xbc10-0xbc17,0xc002 on irq 17
Probing IDE interface ide3...
hdg: Maxtor 6Y080P0, ATA DISK drive
ide3 at 0xc410-0xc417,0xc802 on irq 17
hde: max request size: 128KiB
hde: 160086528 sectors (81964 MB) w/7936KiB Cache, CHS=3D65535/16/63, UDMA(=
133)
hde: cache flushes supported
 hde: hde1 hde2
hdg: max request size: 128KiB
hdg: 160086528 sectors (81964 MB) w/7936KiB Cache, CHS=3D65535/16/63, UDMA(=
133)
hdg: cache flushes supported
 hdg: hdg1 hdg2
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 94X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
sata_sil 0000:00:10.0: version 2.1
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 18
ata1: SATA max UDMA/100 cmd 0xe0812080 ctl 0xe081208a bmdma 0xe0812000 irq =
18
ata2: SATA max UDMA/100 cmd 0xe08120c0 ctl 0xe08120ca bmdma 0xe0812008 irq =
18
scsi0 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-6: WDC WD360GD-00FNA0, 35.06K35, max UDMA/133
ata1.00: 72303840 sectors, multi 16: LBA48=20
ata1.00: applying bridge limits
ata1.00: configured for UDMA/100
scsi1 : sata_sil
ata2: SATA link down (SStatus 0 SControl 310)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD360GD-00FN 35.0 PQ: 0 ANSI: 5
SCSI device sda: 72303840 512-byte hdwr sectors (37020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sda: 72303840 512-byte hdwr sectors (37020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
 sda: sda1 sda2 < sda5 sda6 > sda3 sda4
sd 0:0:0:0: Attached scsi disk sda
ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 19
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
PCI: cache line size of 128 is not supported by device 0000:00:03.3
ehci_hcd 0000:00:03.3: irq 19, io mem 0xfd128000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 20, io mem 0xfd124000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 21, io mem 0xfd125000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:03.2: irq 22, io mem 0xfd127000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: new full speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 2 ports detected
usb 2-1.1: new low speed USB device using ohci_hcd and address 3
usb 2-1.1: configuration #1 chosen from 1 choice
usb 2-1.2: new full speed USB device using ohci_hcd and address 4
usb 2-1.2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:03.0-1=
=2E1
input: Logitech USB Receiver as /class/input/input4
input,hiddev96: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:=
03.0-1.1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input5
i2c /dev entries driver
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x1400
it87: Found IT8705F chip at 0x290, revision 2
it87-isa 9191-0290: Detected broken BIOS defaults, disabling PWM interface
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Tue Mar 06 13:1=
0:00 2007 UTC).
ALSA device list:
  No soundcards found.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Testing NMI watchdog ... OK.
Starting balanced_irq
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input6
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
=46reeing unused kernel memory: 212k freed
cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level, low) -> IRQ 23
CORE cx88[0]: subsystem: 0070:3401, board: Hauppauge WinTV 34xxx models [ca=
rd=3D1,autodetected]
TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
cx2388x alsa driver version 0.0.6 loaded
8139too Fast Ethernet driver 0.9.28
tveeprom 1-0050: Hauppauge model 34519, rev G152, serial# 6748079
tveeprom 1-0050: tuner model is Microtune 4049 FM5 (idx 52, type 45)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) (eepr=
om 0x74)
tveeprom 1-0050: audio processor is CX881 (idx 31)
tveeprom 1-0050: has radio
cx88[0]: hauppauge eeprom: model=3D34519
input: cx88 IR (Hauppauge WinTV 34xxx  as /class/input/input7
cx88[0]/0: found at 0000:00:0c.0, rev: 3, irq: 23, latency: 32, mmio: 0xfb0=
00000
tuner 1-0043: chip found @ 0x86 (cx88[0])
tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
tuner 1-0061: chip found @ 0xc2 (cx88[0])
tuner 1-0061: type set to 45 (Microtune 4049 FM5)
tuner 1-0061: type set to 45 (Microtune 4049 FM5)
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 16
eth0: RealTek RTL8139 at 0xe0874000, 00:50:22:b4:c9:9b, IRQ 16
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level, low) -> IRQ 18
ACPI: PCI Interrupt 0000:00:0c.1[A] -> GSI 16 (level, low) -> IRQ 23
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
ACPI: PCI interrupt for device 0000:00:0d.0 disabled
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level, low) -> IRQ 18
cs46xx: failure waiting for FIFO command to complete
Adding 2008116k swap on /dev/sda3.  Priority:-1 extents:1 across:2008116k
EXT3 FS on sda4, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hde1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hde2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdg1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ADDRCONF(NETDEV_UP): eth-e1000: link is not ready
e1000: eth-e1000: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow=
 Control: RX
ADDRCONF(NETDEV_CHANGE): eth-e1000: link becomes ready
eth-e1000: no IPv6 routers present
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c0288c83>] usbhid_init_reports+0x70/0xe1
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c0288c83>] usbhid_init_reports+0x70/0xe1
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c0288c83>] usbhid_init_reports+0x70/0xe1
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: at drivers/hid/hid-core.c:778 implement()
 [<c029e39a>] hid_output_report+0x23f/0x2de
 [<c02886b4>] hid_submit_ctrl+0x59/0x1f2
 [<c03679c1>] schedule_timeout+0x4b/0xa1
 [<c012e6ed>] finish_wait+0x22/0x48
 [<c0288948>] usbhid_submit_report+0xfb/0x172
 [<c012e658>] autoremove_wake_function+0x0/0x37
 [<c028aa16>] hiddev_ioctl+0x435/0xaff
 [<c01402bf>] find_get_page+0x37/0x42
 [<c0142a2d>] filemap_nopage+0x2f0/0x3e8
 [<c016544f>] open_namei+0x79/0x5ad
 [<c014bea8>] __handle_mm_fault+0x221/0x915
 [<c0166564>] do_ioctl+0x64/0x6d
 [<c01665bd>] vfs_ioctl+0x50/0x273
 [<c0166814>] sys_ioctl+0x34/0x50
 [<c0103f16>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] l2cap_sock_sendmsg+0x372/0x397
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
input: Logitech Bluetooth Mou=F0 as /class/input/input8
input: Logitech Bluetooth Keyboard as /class/input/input9
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 23
[drm] Initialized radeon 1.26.0 20060524 on minor 0
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 17
rt2500 1.1.0 BETA4 2006/06/18 http://rt2x00.serialmonkey.com
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs
APIC error on CPU0: 00(40)

--Boundary-00=_IgXAGtrlxgL6p6M--
