Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZJJEez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZJJEez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZJJEex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:34:53 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:34897 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZJJEev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:34:51 -0400
X-IronPort-AV: E=Sophos;i="4.44,534,1249254000"; 
   d="scan'208";a="139497979"
Subject: PROBLEM: Server hanging every 48 hours or so since upgrade to FC11
From: Nicholas Robinson <npr@bottlehall.co.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 10 Oct 2009 05:34:12 +0100
Message-Id: <1255149252.2326.20.camel@elm.bottlehall.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I upgraded to FC11 from FC8 using preupgrade-cli, my server has
been hanging every 48 hours or so. The server is used principally as a
local mail server (downloading using fetchmail and serving local users
with dovecot) and the hangs are usually during the day, so it may well
be connected with active use by mail clients (Linux Opera and MAC/OS-X
mail client).

I am not expecting replies directly to this bug report. I hope it is of
use to kernel developers and will await upgrades in the usual way.


Linux version 2.6.30.8-64.fc11.i586
(mockbuild@x86-6.fedora.phx.redhat.com) (gcc version 4.4.1 20090725 (Red
Hat 4.4.1-2) (GCC) ) #1 SMP Fri Sep 25 04:30:19 EDT 2009

Copy from /var/log/messages

Oct  9 11:34:05 oak kernel: ------------[ cut here ]------------
Oct  9 11:34:05 oak kernel: kernel BUG at fs/inode.c:302!
Oct  9 11:34:05 oak kernel: invalid opcode: 0000 [#1] SMP
Oct  9 11:34:05 oak kernel: last sysfs
file: /sys/devices/virtual/vc/vcsa2/dev
Oct  9 11:34:05 oak kernel: Modules linked in: nfsd lockd nfs_acl
auth_rpcgss exportfs autofs4 sunrpc ipv6 dm_multipath ppdev snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm snd_timer snd usb_storage ns558
parport_pc soundcore parport advansys pcspkr floppy gameport hfcpci
sis900 i2c_sis96x mISDN_core i2c_core snd_page_alloc mii ata_generic
pata_acpi pata_sis [last unloaded: scsi_wait_scan]
Oct  9 11:34:05 oak kernel:
Oct  9 11:34:05 oak kernel: Pid: 23, comm: kswapd0 Not tainted
(2.6.30.8-64.fc11.i586 #1) System Name
Oct  9 11:34:05 oak kernel: EIP: 0060:[<c04bbce9>] EFLAGS: 00010246 CPU:
0
Oct  9 11:34:05 oak kernel: EIP is at clear_inode+0x3d/0xd5
Oct  9 11:34:05 oak kernel: EAX: 00000000 EBX: c1f8c49c ECX: c08359f9
EDX: 0000012a
Oct  9 11:34:05 oak kernel: ESI: c1f8c4a4 EDI: 00000010 EBP: dd98deb8
ESP: dd98deb4
Oct  9 11:34:05 oak kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct  9 11:34:05 oak kernel: Process kswapd0 (pid: 23, ti=dd98c000
task=dd8f3340 task.ti=dd98c000)
Oct  9 11:34:05 oak kernel: Stack:
Oct  9 11:34:05 oak kernel: c1f8c49c dd98ded0 c04bbdbf dd98dee0 ddce0a9c
00000000 00000059 dd98def4
Oct  9 11:34:05 oak kernel: c04bbfc5 00000080 00000080 c1f8c6a4 ddce44a4
c08d2f60 c099ba18 00000082
Oct  9 11:34:05 oak kernel: dd98df28 c048e04d 0000000c 00000000 00004fb0
00000080 000000d0 00004fb0
Oct  9 11:34:05 oak kernel: Call Trace:
Oct  9 11:34:05 oak kernel: [<c04bbdbf>] ? dispose_list+0x3e/0xbd
Oct  9 11:34:05 oak kernel: [<c04bbfc5>] ? shrink_icache_memory
+0x187/0x1af
Oct  9 11:34:05 oak kernel: [<c048e04d>] ? shrink_slab+0xe5/0x13f
Oct  9 11:34:05 oak kernel: [<c048e42f>] ? kswapd+0x388/0x51b
Oct  9 11:34:05 oak kernel: [<c048cc44>] ? isolate_pages_global
+0x0/0x19b
Oct  9 11:34:05 oak kernel: [<c04411dd>] ? autoremove_wake_function
+0x0/0x34
Oct  9 11:34:05 oak kernel: [<c0422f7b>] ? complete+0x39/0x43
Oct  9 11:34:05 oak kernel: [<c048e0a7>] ? kswapd+0x0/0x51b
Oct  9 11:34:05 oak kernel: [<c048e0a7>] ? kswapd+0x0/0x51b
Oct  9 11:34:05 oak kernel: [<c0440ee5>] ? kthread+0x4b/0x6f
Oct  9 11:34:05 oak kernel: [<c0440e9a>] ? kthread+0x0/0x6f
Oct  9 11:34:05 oak kernel: [<c04040c7>] ? kernel_thread_helper+0x7/0x10
Oct  9 11:34:05 oak kernel: Code: 59 83 c0 e8 a8 d9 f6 ff e8 a1 1b 27 00
89 d8 e8 0b a8 00 00 83 bb e0 00 00 00 00 74 04 0f 0b eb fe 8b 83 44 01
00 00 a8 20 75 04 <0f> 0b eb fe a8 40 74 04 0f 0b eb fe ba 5d 00 00 00
b8 ce b6 82
Oct  9 11:34:05 oak kernel: EIP: [<c04bbce9>] clear_inode+0x3d/0xd5
SS:ESP 0068:dd98deb4
Oct  9 11:34:05 oak kernel: ---[ end trace de9a23552248f237 ]---

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 8
model name	: AMD Athlon(TM) XP 2000+
stepping	: 1
cpu MHz		: 1261.254
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat
pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow up
bogomips	: 2522.50
clflush size	: 32
power management: ts

nfsd 206660 9 - Live 0xdef87000
lockd 59392 1 nfsd, Live 0xdef3c000
nfs_acl 2468 1 nfsd, Live 0xdef24000
auth_rpcgss 31036 1 nfsd, Live 0xdef14000
exportfs 3612 1 nfsd, Live 0xdef06000
autofs4 21924 3 - Live 0xdeef7000
sunrpc 155648 11 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xdeec2000
ipv6 235696 43 - Live 0xdee42000
dm_multipath 14040 0 - Live 0xded0a000
ppdev 6480 0 - Live 0xdecd8000
snd_intel8x0 28148 0 - Live 0xdecbb000
snd_ac97_codec 91984 1 snd_intel8x0, Live 0xdec93000
ac97_bus 1408 1 snd_ac97_codec, Live 0xdec6c000
snd_pcm 62556 2 snd_intel8x0,snd_ac97_codec, Live 0xdec54000
floppy 47260 0 - Live 0xdec2d000
snd_timer 17876 1 snd_pcm, Live 0xdec11000
usb_storage 46620 0 - Live 0xdebf7000
ns558 4360 0 - Live 0xdebdc000
snd 50336 4 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer, Live
0xdebc6000
parport_pc 22492 0 - Live 0xdeba9000
parport 28968 2 ppdev,parport_pc, Live 0xdeb91000
gameport 9784 2 ns558, Live 0xdeb7d000
i2c_sis96x 5560 0 - Live 0xdeb70000
i2c_core 25024 1 i2c_sis96x, Live 0xdeb5f000
soundcore 5476 1 snd, Live 0xdeb4d000
advansys 51012 0 - Live 0xdeb36000
pcspkr 2168 0 - Live 0xdeb1b000
hfcpci 22628 0 - Live 0xdeb0d000
mISDN_core 67284 1 hfcpci, Live 0xdeaf0000
snd_page_alloc 7712 2 snd_intel8x0,snd_pcm, Live 0xdead1000
sis900 17916 0 - Live 0xdeac2000
mii 4024 1 sis900, Live 0xdeab7000
ata_generic 4288 0 - Live 0xde851000
pata_acpi 3648 0 - Live 0xde847000
pata_sis 9356 3 - Live 0xde83b000

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:02.5
  0170-0177 : pata_sis
01f0-01f7 : 0000:00:02.5
  01f0-01f7 : pata_sis
0200-0207 : ns558-pnp
0290-0297 : pnp 00:0e
0376-0376 : 0000:00:02.5
  0376-0376 : pata_sis
0378-037a : parport0
03c0-03df : vga+
03f0-03f1 : pnp 00:0e
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:02.5
  03f6-03f6 : pata_sis
03f7-03f7 : floppy
03f8-03ff : serial
0480-048f : pnp 00:02
04d0-04d1 : pnp 00:04
0500-0507 : pnp 00:0e
8000-8007 : 0000:00:0f.0
8400-84ff : 0000:00:0e.0
  8400-84ff : advansys
8800-88ff : 0000:00:04.0
  8800-88ff : sis900
9000-907f : 0000:00:02.7
  9000-907f : SiS SI7012
9400-94ff : 0000:00:02.7
  9400-94ff : SiS SI7012
a400-a40f : 0000:00:02.5
  a400-a40f : pata_sis
d000-dfff : PCI Bus 0000:01
  d800-d87f : 0000:01:00.0
e400-e47f : pnp 00:02
  e400-e403 : ACPI PM1a_EVT_BLK
  e404-e405 : ACPI PM1a_CNT_BLK
  e408-e40b : ACPI PM_TMR
  e420-e423 : ACPI GPE0_BLK
  e430-e433 : ACPI GPE1_BLK
e480-e4ff : pnp 00:02
e600-e61f : 0000:00:02.1
  e600-e61f : pnp 00:02
    e600-e61f : sis96x_smbus

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1dffbfff : System RAM
  00400000-00732ad3 : Kernel code
  00732ad4-00931b17 : Kernel data
  009a0000-00a69e4b : Kernel bss
1dffc000-1dffefff : ACPI Tables
1dfff000-1dffffff : ACPI Non-volatile Storage
20000000-2000ffff : 0000:00:0e.0
e4000000-e40000ff : 0000:00:0f.0
e4800000-e48000ff : 0000:00:0e.0
  e4800000-e48000ff : advansys
e5000000-e5000fff : 0000:00:04.0
  e5000000-e5000fff : sis900
e5800000-e5800fff : 0000:00:03.3
  e5800000-e5800fff : ehci_hcd
e6000000-e6000fff : 0000:00:03.2
  e6000000-e6000fff : ohci_hcd
e6800000-e6800fff : 0000:00:03.1
  e6800000-e6800fff : ohci_hcd
e7000000-e7000fff : 0000:00:03.0
  e7000000-e7000fff : ohci_hcd
e7800000-e7ffffff : PCI Bus 0000:01
  e7800000-e781ffff : 0000:01:00.0
e8000000-ebffffff : 0000:00:00.0
effe0000-efffffff : 0000:00:04.0
f0000000-febfffff : PCI Bus 0000:01
  f0000000-f7ffffff : 0000:01:00.0
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : reserved
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:00
ffee0000-ffefffff : pnp 00:02
ffff0000-ffffffff : reserved

00:00.0 Host bridge: Silicon Integrated Systems [SiS] 740 Host (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32
	Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=64M]
	Capabilities: [c0] AGP version 2.0
		Status: RQ=17 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x4
	Kernel driver in use: agpgart-sis

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI
bridge (AGP) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: e7800000-e7ffffff
	Prefetchable memory behind bridge: f0000000-febfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS962 [MuTIOL
Media IO] (rev 04)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus
Controller
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 0
	Region 4: I/O ports at e600 [size=32]
	Kernel driver in use: sis96x_smbus
	Kernel modules: i2c-sis96x

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE]
(prog-if 80 [Master])
	Subsystem: ASUSTeK Computer Inc. Device 8084
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128
	Interrupt: pin ? routed to IRQ 16
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
[size=1]
	Region 4: I/O ports at a400 [size=16]
	Kernel driver in use: pata_sis
	Kernel modules: pata_sis

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
AC'97 Sound Controller (rev a0)
	Subsystem: ASUSTeK Computer Inc. Device 806a
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (13000ns min, 2750ns max)
	Interrupt: pin C routed to IRQ 18
	Region 0: I/O ports at 9400 [size=256]
	Region 1: I/O ports at 9000 [size=128]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Intel ICH
	Kernel modules: snd-intel8x0

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8084
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e7000000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8084
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at e6800000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8084
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0
Controller (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 8084
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max)
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at e5800000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI
Fast Ethernet (rev 91)
	Subsystem: ASUSTeK Computer Inc. Device 807c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (13000ns min, 2750ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 8800 [size=256]
	Region 1: Memory at e5000000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at effe0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sis900
	Kernel modules: sis900

00:0e.0 SCSI storage controller: Advanced System Products, Inc
ABP940-U / ABP960-U (rev 03)
	Subsystem: Advanced System Products, Inc ASC1300 SCSI Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 8400 [size=256]
	Region 1: Memory at e4800000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 20000000 [disabled] [size=64K]
	Kernel driver in use: advansys
	Kernel modules: advansys

00:0f.0 Network controller: Cologne Chip Designs GmbH ISDN network
controller [HFC-PCI] (rev 02)
	Subsystem: Cologne Chip Designs GmbH ISDN Board
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 8000 [disabled] [size=8]
	Region 1: Memory at e4000000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: hfcpci
	Kernel modules: hisax, hfcpci

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
65x/M650/740 PCI/AGP VGA Display Adapter (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 80a0
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	BIST result: 00
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at e7800000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at d800 [size=128]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] AGP version 2.0
		Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: Hitachi HDT72503 Rev: V54O
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Nikimi           Rev: 18.2
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: HL-DT-ST Model: RW/DVD GCC-4120B Rev: 2.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 0.01
  Type:   Direct-Access                    ANSI  SCSI revision: 00


