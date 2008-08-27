Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYH0NQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYH0NQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYH0NPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:15:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:60601 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYH0NPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ix1MVHLK5trceIsgpBoufrn10l/+jPgP308gomvtssWGTb9fcLMSyLJa2IohrOSN9J
         s4fh4f4Juu5WorxsImMHLic8Yc8iX8ldRVnxdI61Ko3WF70/YFOG5NgrQB0Ft63Yf2wf
         4Fb74OBTbFKxG6KNKqKfgw5TGcJ2Wt0FadK1Y=
Message-ID: <854075c50808270615o582f9674k2a4282ebf6fa7a34@mail.gmail.com>
Date: Wed, 27 Aug 2008 10:15:51 -0300
From: "Ignacio Santolin" <lu5ehc@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Driver needed/broken? "U.S. Robotics Sportster 33600 FAX/Voice Int"
In-Reply-To: <854075c50808270610w599c2418wfd97a40261129240@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <854075c50808270610w599c2418wfd97a40261129240@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I Using an old modem (U.S. Robotics Sportster 33600 FAX/Voice Int)
***NOT WINMODEM***

Kernel succesfly detects the card (not as modem) and isnt creates the
/dev/modem (driver develop needed?), Just works sending commands to
/dev/ttyS1
NOTE: the modem is not present in any hardware manager or lspci

I TEST THE MODEM VIA THE WVDIALCONF AND THE MODEM ANSWER THE AT
COMMANDS BUT SENDING COMMANDS TO /dev/ttyS1 *not* to /dev/modem

DMESG OUTPUT (CARD DETECTED)
================================

ignacio@airwave:~$ dmesg
[    0.000000] Linux version 2.6.24-16-generic (buildd@palmer) (gcc
version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Thu Apr 10 13:23:42 UTC
2008 (Ubuntu 2.6.24-16.30-generic)
...
...
[   23.463231] isapnp: Scanning for PnP cards...
[   23.561750] isapnp: Card 'U.S. Robotics Sportster 33600 FAX/Voice Int'
[   23.561757] isapnp: 1 Plug & Play card detected total
[   23.674804] Real Time Clock Driver v1.12ac

-----------------------------------------------------------------------------------------

LSPCI OUTPUT (MODEM IS NOT PRESENT)
================================
ignacio@airwave:~$ lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 03)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP]
00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super
South] (rev 40)
00:07.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 1a)
00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 1a)
00:07.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
00:0a.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 08)
00:0a.1 Input device controller: Creative Labs SB Live! Game Port (rev 08)
00:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8029(AS)
01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4
MX 440 AGP 8x] (rev c1)

------------------------------------------------------------------------------------------

ignacio@airwave:~$ sudo wvdialconf
[sudo] password for ignacio:
Editing `/etc/wvdial.conf'.

Scanning your serial ports for a modem.

Modem Port Scan<*1>: S0
ttyS1<*1>: ATQ0 V1 E1 -- OK
ttyS1<*1>: ATQ0 V1 E1 Z -- OK
ttyS1<*1>: ATQ0 V1 E1 S0=0 -- OK
ttyS1<*1>: ATQ0 V1 E1 S0=0 &C1 -- OK
ttyS1<*1>: ATQ0 V1 E1 S0=0 &C1 &D2 -- OK
ttyS1<*1>: ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0 -- OK
ttyS1<*1>: Modem Identifier: ATI -- 3361
ttyS1<*1>: Speed 4800: AT -- OK
ttyS1<*1>: Speed 9600: AT -- OK
ttyS1<*1>: Speed 19200: AT -- OK
ttyS1<*1>: Speed 38400: AT -- OK
ttyS1<*1>: Speed 57600: AT -- OK
ttyS1<*1>: Speed 115200: AT -- OK
ttyS1<*1>: Max speed is 115200; that should be safe.
ttyS1<*1>: ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0 -- OK
Modem Port Scan<*1>: S3

Found a modem on /dev/ttyS1.
Modem configuration written to /etc/wvdial.conf.
ttyS1<Info>: Speed 115200; init "ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0"
ignacio@airwave:~$

AND FINALLY THE MODEM DIALS AND WORKS (not as /dev/modem)
========================================================
ignacio@airwave:~$ wvdial
--> WvDial: Internet dialer version 1.60
--> Initializing modem.
--> Sending: ATZ
ATZ
OK
--> Sending: ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
OK
--> Modem initialized.
--> Sending: ATDT02293422118
--> Waiting for carrier.
ATDT02293422118
DIALING
--> Dial Successfly.
--> Disconnecting at Mon Aug 18 23:26:38 2008

================================================================

I ATTACH MY SYSTEM INFO

ignacio@airwave:~$ cat /proc/version
Linux version 2.6.24-16-generic (buildd@palmer) (gcc version 4.2.3
(Ubuntu 4.2.3-2ubuntu7)) #1 SMP Thu Apr 10 13:23:42 UTC 2008

ignacio@airwave:~$ cat /proc/cpuinfo
processor : 0
vendor_id : AuthenticAMD
cpu family : 6
model  : 7
model name : AMD Duron(tm) processor
stepping : 1
cpu MHz  : 1200.106
cache size : 64 KB
fdiv_bug : no
hlt_bug  : no
f00f_bug : no
coma_bug : no
fpu  : yes
fpu_exception : yes
cpuid level : 1
wp  : yes
flags  : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat
pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow up ts
bogomips : 2402.68
clflush size : 32

ignacio@airwave:~$ cat /proc/modules
nls_iso8859_1 4992 1 - Live 0xd4cf1000
nls_cp437 6656 1 - Live 0xd4cde000
vfat 14464 1 - Live 0xd4d17000
fat 54556 1 vfat, Live 0xd4e6b000
isofs 36388 1 - Live 0xd4d8b000
udf 88612 0 - Live 0xd4e54000
binfmt_misc 12808 1 - Live 0xd4ccd000
rfcomm 41744 2 - Live 0xd4cff000
l2cap 25728 13 rfcomm, Live 0xd4cd6000
bluetooth 61156 4 rfcomm,l2cap, Live 0xd4ce1000
ipv6 267780 12 - Live 0xd4d1c000
ppdev 10372 0 - Live 0xd4cc9000
cpufreq_userspace 5284 0 - Live 0xd4cc6000
cpufreq_conservative 8712 0 - Live 0xd4cc2000
cpufreq_stats 7104 0 - Live 0xd4cb5000
cpufreq_ondemand 9740 0 - Live 0xd4c8d000
freq_table 5536 2 cpufreq_stats,cpufreq_ondemand, Live 0xd4cb2000
cpufreq_powersave 2688 0 - Live 0xd4bc0000
container 5632 0 - Live 0xd4c94000
sbs 15112 0 - Live 0xd4cb8000
sbshc 7680 1 sbs, Live 0xd4c91000
dock 11280 0 - Live 0xd4aa2000
video 19856 0 - Live 0xd4cac000
output 4736 1 video, Live 0xd4c7f000
battery 14212 0 - Live 0xd4ca7000
af_packet 23812 0 - Live 0xd4ca0000
ppp_generic 29588 0 - Live 0xd4c97000
slhc 7040 1 ppp_generic, Live 0xd4c7c000
iptable_filter 3840 0 - Live 0xd4865000
ip_tables 14820 1 iptable_filter, Live 0xd4c88000
x_tables 16132 1 ip_tables, Live 0xd4c83000
ac 6916 0 - Live 0xd4c04000
lp 12324 0 - Live 0xd4c09000
snd_emu10k1_synth 8064 0 - Live 0xd4bbd000
snd_emux_synth 36224 1 snd_emu10k1_synth, Live 0xd4b49000
snd_seq_virmidi 8192 1 snd_emux_synth, Live 0xd4aa6000
snd_seq_midi_emul 7552 1 snd_emux_synth, Live 0xd4854000
snd_emu10k1 146880 4 snd_emu10k1_synth, Live 0xd4b54000
snd_ac97_codec 101028 1 snd_emu10k1, Live 0xd4b0e000
ac97_bus 3072 1 snd_ac97_codec, Live 0xd49eb000
snd_pcm_oss 42144 0 - Live 0xd4ae1000
snd_mixer_oss 17920 1 snd_pcm_oss, Live 0xd4ab4000
snd_pcm 78596 3 snd_emu10k1,snd_ac97_codec,snd_pcm_oss, Live 0xd4acc000
snd_page_alloc 11400 2 snd_emu10k1,snd_pcm, Live 0xd4a76000
snd_util_mem 5632 2 snd_emux_synth,snd_emu10k1, Live 0xd498c000
snd_hwdep 10500 2 snd_emux_synth,snd_emu10k1, Live 0xd49c8000
snd_seq_dummy 4868 0 - Live 0xd4a1d000
evdev 13056 4 - Live 0xd4a9d000
nvidia 4718832 32 - Live 0xd5086000 (P)
serio_raw 7940 0 - Live 0xd4902000
snd_seq_oss 35584 0 - Live 0xd4aaa000
snd_seq_midi 9376 0 - Live 0xd4a54000
snd_rawmidi 25760 3 snd_seq_virmidi,snd_emu10k1,snd_seq_midi, Live 0xd4a7a000
psmouse 40336 0 - Live 0xd4a92000
snd_seq_midi_event 8320 3 snd_seq_virmidi,snd_seq_oss,snd_seq_midi,
Live 0xd4a50000
snd_seq 54224 9
snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event,
Live 0xd4a83000
pcspkr 4224 0 - Live 0xd48e6000
snd_timer 24836 3 snd_emu10k1,snd_pcm,snd_seq, Live 0xd4a69000
snd_seq_device 9612 8
snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq,
Live 0xd4a4c000
button 9232 0 - Live 0xd4a48000
snd 56996 20 snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_hwdep,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xd4a5a000
via686a 15244 0 - Live 0xd4a43000
emu10k1_gp 4608 0 - Live 0xd4878000
soundcore 8800 1 snd, Live 0xd4a19000
i2c_viapro 9876 0 - Live 0xd49e7000
gameport 16008 2 emu10k1_gp, Live 0xd49cc000
i2c_core 24832 2 nvidia,i2c_viapro, Live 0xd4a3b000
shpchp 34452 0 - Live 0xd4a31000
pci_hotplug 30880 1 shpchp, Live 0xd4a10000
parport_pc 36260 0 - Live 0xd49dd000
parport 37832 3 ppdev,lp,parport_pc, Live 0xd49d2000
via_agp 11136 1 - Live 0xd4988000
agpgart 34760 2 nvidia,via_agp, Live 0xd498f000
ext3 136712 1 - Live 0xd49ed000
jbd 48404 1 ext3, Live 0xd49b8000
mbcache 9600 1 ext3, Live 0xd48a2000
sg 36880 0 - Live 0xd49ad000
usb_storage 73664 1 - Live 0xd499a000
libusual 19108 1 usb_storage, Live 0xd48d9000
sr_mod 17956 1 - Live 0xd48e0000
cdrom 37408 1 sr_mod, Live 0xd4978000
sd_mod 30720 5 - Live 0xd48f9000
ata_generic 8324 0 - Live 0xd48d5000
pata_acpi 8320 0 - Live 0xd48a6000
floppy 59588 0 - Live 0xd48e9000
uhci_hcd 27024 0 - Live 0xd48ab000
pata_via 13316 3 - Live 0xd4891000
ne2k_pci 11744 0 - Live 0xd4896000
8390 11776 1 ne2k_pci, Live 0xd4867000
usbcore 146028 4 usb_storage,libusual,uhci_hcd, Live 0xd4953000
libata 159344 3 ata_generic,pata_acpi,pata_via, Live 0xd492b000
scsi_mod 151436 5 sg,usb_storage,sr_mod,sd_mod,libata, Live 0xd4905000
raid10 25728 0 - Live 0xd489a000
raid456 129040 0 - Live 0xd48b4000
async_xor 4992 1 raid456, Live 0xd4862000
async_memcpy 3712 1 raid456, Live 0xd483c000
async_tx 9292 3 raid456,async_xor,async_memcpy, Live 0xd4819000
xor 16136 2 raid456,async_xor, Live 0xd4873000
raid1 25728 0 - Live 0xd486b000
raid0 9344 0 - Live 0xd4850000
multipath 9600 0 - Live 0xd4838000
linear 7296 0 - Live 0xd4835000
md_mod 82068 6 raid10,raid456,raid1,raid0,multipath,linear, Live 0xd487b000
thermal 16796 0 - Live 0xd484a000
processor 36872 2 thermal, Live 0xd4857000
fan 5636 0 - Live 0xd4832000
fbcon 42912 0 - Live 0xd483e000
tileblit 3456 1 fbcon, Live 0xd4821000
font 9472 1 fbcon, Live 0xd481d000
bitblit 6784 1 fbcon, Live 0xd4814000
softcursor 3072 1 bitblit, Live 0xd4817000
fuse 50580 3 - Live 0xd4824000

ignacio@airwave:~$ cat /proc/ioports
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
0170-0177 : 0000:00:07.1
  0170-0177 : libata
01f0-01f7 : 0000:00:07.1
  01f0-01f7 : libata
0213-0213 : ISAPnP
02f8-02ff : serial
0376-0376 : 0000:00:07.1
  0376-0376 : libata
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:07.1
  03f6-03f6 : libata
03f7-03f7 : floppy DIR
04d0-04d1 : pnp 00:02
0a79-0a79 : isapnp write
0cf8-0cff : PCI conf1
4000-4003 : ACPI PM1a_EVT_BLK
4008-400b : ACPI PM_TMR
4010-4015 : ACPI CPU throttle
4020-4023 : ACPI GPE0_BLK
40f0-40f1 : ACPI PM1a_CNT_BLK
5000-500f : 0000:00:07.4
  5000-5007 : vt596_smbus
6000-607f : via686a
  6000-607f : 0000:00:07.4
    6000-607f : via686a
d000-d00f : 0000:00:07.1
  d000-d00f : libata
d400-d41f : 0000:00:07.2
  d400-d41f : uhci_hcd
d800-d81f : 0000:00:07.3
  d800-d81f : uhci_hcd
dc00-dc1f : 0000:00:0a.0
  dc00-dc1f : EMU10K1
e000-e007 : 0000:00:0a.1
  e000-e007 : emu10k1-gp
e400-e41f : 0000:00:0c.0
  e400-e41f : ne2k-pci

ignacio@airwave:~$ cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cf7ff : Video ROM
000f0000-000fffff : System ROM
00100000-13feffff : System RAM
  00100000-0031b5a3 : Kernel code
  0031b5a4-00414dc3 : Kernel data
  00476000-004eba7f : Kernel bss
13ff0000-13ff2fff : ACPI Non-volatile Storage
13ff3000-13ffffff : ACPI Tables
e0000000-e7ffffff : PCI Bus #01
  e0000000-e7ffffff : 0000:01:00.0
e8000000-ebffffff : 0000:00:00.0
ec000000-edffffff : PCI Bus #01
  ec000000-ecffffff : 0000:01:00.0
    ec000000-ecffffff : nvidia
  ed000000-ed01ffff : 0000:01:00.0
fee00000-fee00fff : pnp 00:00
ffff0000-ffffffff : reserved

ignacio@airwave:~$ sudo lspci -vvv
[sudo] password for ignacio:
00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 03)
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
 Latency: 8
 Region 0: Memory at e8000000 (32-bit, prefetchable) [size=64M]
 Capabilities: [a0] AGP version 2.0
  Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3- Rate=x1,x2,x4
  Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- Rate=x4
 Capabilities: [c0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133
AGP] (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
 Latency: 0
 Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 I/O behind bridge: 0000f000-00000fff
 Memory behind bridge: ec000000-edffffff
 Prefetchable memory behind bridge: e0000000-e7ffffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
 Capabilities: [80] Power Management version 2
  Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super
South] (rev 40)
 Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 0
 Capabilities: [c0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
 Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 32
 Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
 Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
 Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
 Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
 Region 4: I/O ports at d000 [size=16]
 Capabilities: [c0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 1a) (prog-if 00 [UHCI])
 Subsystem: First International Computer, Inc. VA-502 Mainboard
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 32, Cache Line Size: 32 bytes
 Interrupt: pin D routed to IRQ 15
 Region 4: I/O ports at d400 [size=32]
 Capabilities: [80] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 1a) (prog-if 00 [UHCI])
 Subsystem: First International Computer, Inc. VA-502 Mainboard
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 32, Cache Line Size: 32 bytes
 Interrupt: pin D routed to IRQ 15
 Region 4: I/O ports at d800 [size=32]
 Capabilities: [80] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
 Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Interrupt: pin ? routed to IRQ 5
 Capabilities: [68] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 08)
 Subsystem: Creative Labs CT4832 SBLive! Value
 Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 32 (500ns min, 5000ns max)
 Interrupt: pin A routed to IRQ 10
 Region 0: I/O ports at dc00 [size=32]
 Capabilities: [dc] Power Management version 1
  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.1 Input device controller: Creative Labs SB Live! Game Port (rev 08)
 Subsystem: Creative Labs Gameport Joystick
 Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 32
 Region 0: I/O ports at e000 [size=8]
 Capabilities: [dc] Power Management version 1
  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8029(AS)
 Subsystem: Realtek Semiconductor Co., Ltd. RTL-8029(AS)
 Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Interrupt: pin A routed to IRQ 15
 Region 0: I/O ports at e400 [size=32]

01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4
MX 440 AGP 8x] (rev c1) (prog-if 00 [VGA controller])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
 Latency: 248 (1250ns min, 250ns max)
 Interrupt: pin A routed to IRQ 11
 Region 0: Memory at ec000000 (32-bit, non-prefetchable) [size=16M]
 Region 1: Memory at e0000000 (32-bit, prefetchable) [size=128M]
 [virtual] Expansion ROM at ed000000 [disabled] [size=128K]
 Capabilities: [60] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [44] AGP version 3.0
  Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3- Rate=x1,x2,x4
  Command: RQ=32 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- Rate=x4

ignacio@airwave:~$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6E020L0   Rev: NAR6
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: TSSTcorp Model: CD/DVDW SH-W162Z Rev: TS01
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: Kingston Model: DataTraveler 2.0 Rev: 6.50
  Type:   Direct-Access                    ANSI  SCSI revision: 00
