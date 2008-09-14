Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYINJ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYINJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYINJ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:29:15 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46359 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYINJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:29:12 -0400
Message-ID: <b6fa64320809140229h3818c207l76824f97f2d75d52@mail.gmail.com>
Date: Sun, 14 Sep 2008 11:29:09 +0200
From: "Matthias Mann" <matthias-m@jesus.de>
To: linux-kernel@vger.kernel.org
Subject: pktcdvd is unusable with Kernel 2.6.27.x
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

because linux_udf@hpesjro.fc.hp.com is unreachabe, i send
this bug report to you:


While booting i get an Ooops message. If i try to mount any
DVD written in packet writing mode, my system freezes so i
need to reboot.

Linux version 2.6.27-rc6 (root@calculusterix) (gcc version 4.3.1
(Debian 4.3.1-9) ) #1 SMP PREEMPT Sat Sep 13 17:30:30 CEST 2008

-----------------------------------------------------------
dmesg:

pktcdvd: writer pktcdvd0 mapped to hdb
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x3a()
sysfs: duplicate filename '254:0' can not be created
Modules linked in: snd_bt87x snd_seq_dummy snd_seq_oss snd_hda_intel
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_seq_device
snd_pcm snd_timer snd soundcore snd_page_alloc
Pid: 2440, comm: pktsetup Not tainted 2.6.27-rc6 #1

Call Trace:
 [<ffffffff80230768>] warn_slowpath+0xb4/0xdc
 [<ffffffff803175ef>] vsnprintf+0x52c/0x574
 [<ffffffff802bd789>] sysfs_addrm_finish+0x1d/0x21e
 [<ffffffff802bd451>] __sysfs_add_one+0x16/0x9e
 [<ffffffff803121d0>] idr_get_empty_slot+0x158/0x22b
 [<ffffffff80317688>] sprintf+0x51/0x59
 [<ffffffff802bd150>] sysfs_ilookup_test+0x0/0xf
 [<ffffffff802bd31c>] sysfs_find_dirent+0x1b/0x2f
 [<ffffffff802bd50c>] sysfs_add_one+0x33/0x3a
 [<ffffffff802be24e>] sysfs_do_create_link+0xb9/0x11b
 [<ffffffff8036d46e>] device_add+0x16c/0x530
 [<ffffffff80312c09>] kobject_init+0x42/0x82
 [<ffffffff8036d8de>] device_create_vargs+0x9a/0xc6
 [<ffffffff8036d944>] device_create+0x3a/0x42
 [<ffffffff802bd451>] __sysfs_add_one+0x16/0x9e
 [<ffffffff802be265>] sysfs_do_create_link+0xd0/0x11b
 [<ffffffff8030d1ad>] add_disk+0x88/0xa7
 [<ffffffff8037931b>] pkt_setup_dev+0x392/0x4aa
 [<ffffffff803dc032>] cdrom_release+0x1a8/0x1e5
 [<ffffffff803794bb>] pkt_ctl_ioctl+0x88/0x1a5
 [<ffffffff80286e92>] vfs_ioctl+0x56/0x6c
 [<ffffffff802870e7>] do_vfs_ioctl+0x23f/0x255
 [<ffffffff8028714e>] sys_ioctl+0x51/0x73
 [<ffffffff8020b48b>] system_call_fastpath+0x16/0x1b

---[ end trace a0d326bcb3645d20 ]---

-----------------------------------------------------------
cat /proc/cpuinfo:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) X2 Dual Core Processor BE-2400
stepping	: 2
cpu MHz		: 2310.613
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good nopl pni cx16 lahf_lm cmp_legacy svm
extapic cr8_legacy 3dnowprefetch
bogomips	: 4621.22
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) X2 Dual Core Processor BE-2400
stepping	: 2
cpu MHz		: 2310.613
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good nopl pni cx16 lahf_lm cmp_legacy svm
extapic cr8_legacy 3dnowprefetch
bogomips	: 4621.08
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

-----------------------------------------------------------
cat /proc/modules:

nvidia 7761176 26 - Live 0xffffffffa0082000 (P)
snd_bt87x 13428 0 - Live 0xffffffffa007d000
snd_seq_dummy 3204 0 - Live 0xffffffffa007b000
snd_seq_oss 28928 0 - Live 0xffffffffa0070000
snd_hda_intel 119544 0 - Live 0xffffffffa0051000
snd_seq_midi_event 6656 1 snd_seq_oss, Live 0xffffffffa004e000
snd_seq 48368 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live
0xffffffffa0041000
snd_pcm_oss 36576 0 - Live 0xffffffffa0035000
snd_mixer_oss 14656 1 snd_pcm_oss, Live 0xffffffffa0030000
snd_seq_device 6804 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xffffffffa002d000
snd_pcm 69256 3 snd_bt87x,snd_hda_intel,snd_pcm_oss, Live 0xffffffffa001b000
snd_timer 20176 2 snd_seq,snd_pcm, Live 0xffffffffa0015000
snd 53368 9 snd_bt87x,snd_seq_oss,snd_hda_intel,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_seq_device,snd_pcm,snd_timer,
Live 0xffffffffa0006000
soundcore 6992 1 snd, Live 0xffffffffa0003000
snd_page_alloc 8080 3 snd_bt87x,snd_hda_intel,snd_pcm, Live 0xffffffffa0000000

-----------------------------------------------------------
cat /proc/ioports:

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:04.0
  0170-0177 : amd74xx
01f0-01f7 : 0000:00:04.0
  01f0-01f7 : amd74xx
0290-0297 : pnp 00:02
  0295-0296 : it87
    0295-0296 : it87
0376-0376 : 0000:00:04.0
  0376-0376 : amd74xx
03c0-03df : vga+
03f6-03f6 : 0000:00:04.0
  03f6-03f6 : amd74xx
04d0-04d1 : pnp 00:02
0800-0801 : pnp 00:02
0960-0967 : 0000:00:05.1
  0960-0967 : sata_nv
0970-0977 : 0000:00:05.0
  0970-0977 : sata_nv
09e0-09e7 : 0000:00:05.1
  09e0-09e7 : sata_nv
09f0-09f7 : 0000:00:05.0
  09f0-09f7 : sata_nv
0b60-0b63 : 0000:00:05.1
  0b60-0b63 : sata_nv
0b70-0b73 : 0000:00:05.0
  0b70-0b73 : sata_nv
0be0-0be3 : 0000:00:05.1
  0be0-0be3 : sata_nv
0bf0-0bf3 : 0000:00:05.0
  0bf0-0bf3 : sata_nv
0cf8-0cff : PCI conf1
1000-107f : pnp 00:01
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  101c-101c : ACPI PM2_CNT_BLK
  1020-1027 : ACPI GPE0_BLK
1080-10ff : pnp 00:01
1400-147f : pnp 00:01
1480-14ff : pnp 00:01
  14a0-14af : ACPI GPE1_BLK
1800-187f : pnp 00:01
1880-18ff : pnp 00:01
1c00-1c3f : 0000:00:01.1
  1c00-1c3f : nForce2_smbus
1c40-1c7f : 0000:00:01.1
  1c40-1c7f : nForce2_smbus
7000-7fff : PCI Bus 0000:03
  7c00-7c7f : 0000:03:00.0
8000-9fff : PCI Bus 0000:02
a000-afff : PCI Bus 0000:01
  ac00-ac1f : 0000:01:07.0
b000-b007 : 0000:00:08.0
  b000-b007 : forcedeth
b400-b40f : 0000:00:05.2
  b400-b40f : sata_nv
b800-b803 : 0000:00:05.2
  b800-b803 : sata_nv
bc00-bc07 : 0000:00:05.2
  bc00-bc07 : sata_nv
c000-c003 : 0000:00:05.2
  c000-c003 : sata_nv
c400-c407 : 0000:00:05.2
  c400-c407 : sata_nv
c800-c80f : 0000:00:05.1
  c800-c80f : sata_nv
dc00-dc0f : 0000:00:05.0
  dc00-dc0f : sata_nv
f000-f00f : 0000:00:04.0
  f000-f00f : amd74xx
fc00-fc3f : 0000:00:01.1

-----------------------------------------------------------
cat /proc/iomem:

00000000-0009efff : System RAM
0009f000-0009ffff : reserved
000cce00-000cffff : pnp 00:0d
000f0000-000fffff : reserved
00100000-dfedffff : System RAM
  00200000-004bca03 : Kernel code
  004bca04-005f7377 : Kernel data
  00655000-006a6e4f : Kernel bss
dfee0000-dfee2fff : ACPI Non-volatile Storage
dfee3000-dfeeffff : ACPI Tables
dfef0000-dfefffff : reserved
e0000000-e7ffffff : PCI Bus 0000:03
  e0000000-e7ffffff : 0000:03:00.0
e8000000-efffffff : PCI Bus 0000:01
  e8000000-ebffffff : 0000:01:07.0
  efe00000-efffffff : 0000:01:07.0
f0000000-f3ffffff : reserved
f8000000-fbffffff : PCI Bus 0000:03
  f8000000-f9ffffff : 0000:03:00.0
  fa000000-faffffff : 0000:03:00.0
    fa000000-faffffff : nvidia
  fbfe0000-fbffffff : 0000:03:00.0
fdd00000-fddfffff : PCI Bus 0000:02
fde00000-fdefffff : PCI Bus 0000:01
  fdefe000-fdefefff : 0000:01:08.1
    fdefe000-fdefefff : Bt87x audio
  fdeff000-fdefffff : 0000:01:08.0
    fdeff000-fdefffff : bttv0
fe024000-fe027fff : 0000:00:06.1
  fe024000-fe027fff : ICH HD audio
fe028000-fe02800f : 0000:00:08.0
  fe028000-fe02800f : forcedeth
fe029000-fe0290ff : 0000:00:08.0
  fe029000-fe0290ff : forcedeth
fe02a000-fe02afff : 0000:00:08.0
  fe02a000-fe02afff : forcedeth
fe02b000-fe02bfff : 0000:00:05.2
  fe02b000-fe02bfff : sata_nv
fe02c000-fe02cfff : 0000:00:05.1
  fe02c000-fe02cfff : sata_nv
fe02d000-fe02dfff : 0000:00:05.0
  fe02d000-fe02dfff : sata_nv
fe02e000-fe02e0ff : 0000:00:02.1
  fe02e000-fe02e0ff : ehci_hcd
fe02f000-fe02ffff : 0000:00:02.0
  fe02f000-fe02ffff : ohci_hcd
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
  fee00000-fee00fff : Local APIC
  fefff000-fefff3ff : HPET 0
100000000-11fffffff : System RAM

-----------------------------------------------------------
lspci -vvv:

00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a3)
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a3)
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at fc00 [size=64]
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at 1c40 [size=64]
	Capabilities: <access denied>
	Kernel driver in use: nForce2_smbus

00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev
a1) (prog-if 10)
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd

00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev
a2) (prog-if 20)
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 23
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (prog-if
8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
[disabled] [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: AMD_IDE

00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev
a3) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at dc00 [size=16]
	Region 5: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv

00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev
a3) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: I/O ports at 09e0 [size=8]
	Region 1: I/O ports at 0be0 [size=4]
	Region 2: I/O ports at 0960 [size=8]
	Region 3: I/O ports at 0b60 [size=4]
	Region 4: I/O ports at c800 [size=16]
	Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv

00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev
a3) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin C routed to IRQ 20
	Region 0: I/O ports at c400 [size=8]
	Region 1: I/O ports at c000 [size=4]
	Region 2: I/O ports at bc00 [size=8]
	Region 3: I/O ports at b800 [size=4]
	Region 4: I/O ports at b400 [size=16]
	Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv

00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: e8000000-efffffff
	Prefetchable memory behind bridge: fde00000-fdefffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn+
	Capabilities: <access denied>

00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 81f6
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at fe024000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
	Subsystem: ASUSTeK Computer Inc. Device 8239
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at b000 [size=8]
	Region 2: Memory at fe029000 (32-bit, non-prefetchable) [size=256]
	Region 3: Memory at fe028000 (32-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>
	Kernel driver in use: forcedeth

00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00008000-00009fff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: f8000000-fbffffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000e7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel driver in use: k8temp

01:07.0 Multimedia audio controller: Creative Labs SB X-Fi
	Subsystem: Creative Labs Device 0021
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 1250ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at ac00 [size=32]
	Region 1: Memory at efe00000 (64-bit, non-prefetchable) [size=2M]
	Region 3: Memory at e8000000 (64-bit, non-prefetchable) [size=64M]
	Capabilities: <access denied>

01:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 02)
	Subsystem: Hauppauge computer works Inc. Device 13eb
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fdeff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: bttv

01:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 02)
	Subsystem: Hauppauge computer works Inc. Device 13eb
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fdefe000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Bt87x
	Kernel modules: snd-bt87x

03:00.0 VGA compatible controller: nVidia Corporation GeForce 8400 GS (rev a1)
	Subsystem: XFX Pine Group Inc. Device 2318
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=128M]
	Region 3: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at 7c00 [size=128]
	[virtual] Expansion ROM at fbfe0000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: nvidia
	Kernel modules: nvidia

-----------------------------------------------------------
cat /proc/ide/hdb/model:

PHILIPS DVDRW416


-- 
http://zentrum7.de
Matthias Mann
Hagebuttenweg 5
99097 Erfurt
