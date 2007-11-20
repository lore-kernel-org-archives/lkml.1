Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbXKTOGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbXKTOGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXKTOGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:06:47 -0500
Received: from kwall.cncz.cz ([194.213.192.9]:7651 "EHLO kwall.cncz.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXKTOGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:06:44 -0500
From: Pavel Krauz <krauz@cncz.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: wrong NUMA detection on HP385 G2
Date: Tue, 20 Nov 2007 15:06:38 +0100
User-Agent: KMail/1.9.5
References: <200711191543.30665.krauz@cncz.cz>
In-Reply-To: <200711191543.30665.krauz@cncz.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vnuQH6fqoNMdHcs"
Message-Id: <200711201506.39184.krauz@cncz.cz>
X-OriginalArrivalTime: 20 Nov 2007 14:06:42.0476 (UTC) FILETIME=[93BFE6C0:01C82B7E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_vnuQH6fqoNMdHcs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>> my HP 385 G2 - 2x dual core Opteron 2216 running 2.6.23.1 with NUMA support says the following: 
>
> Can you post a full boot log? 

Here it is.

Further I have a problem with booting the kernel on 4x dual core Opteron (HP585). It prints lot of panics on boot to console but not to the log. (without NUMA support it boots OK).
If you tell me how to get the first panic message I will sent it to you.

On HP385 booted with mem=3072M when I try to bind a program to node1 the kernel panics - again there are lots of messages. With 4GB it runs OK.

b.r.
Pavel


--Boundary-00=_vnuQH6fqoNMdHcs
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.log"

Linux version 2.6.23.1 (root@tcom.domain.local) (gcc version 4.1.1 20070105=
 (Red Hat 4.1.1-52)) #2 SMP Thu Nov 15 10:31:53 CET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfe50000 (usable)
 BIOS-e820: 00000000cfe50000 - 00000000cfe58000 (ACPI data)
 BIOS-e820: 00000000cfe58000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000012ffff000 (usable)
Node: 0, start_pfn: 0, end_pfn: 159
  Setting physnode_map array to node 0 for pfns:
  0=20
Node: 0, start_pfn: 256, end_pfn: 851536
  Setting physnode_map array to node 0 for pfns:
  256 65792 131328 196864 262400 327936 393472 459008 524544 590080 655616 =
721152 786688=20
Node: 0, start_pfn: 1048576, end_pfn: 1245183
  Setting physnode_map array to node 0 for pfns:
  1048576 1114112 1179648=20
get_memcfg_from_srat: assigning address to rsdp
RSD PTR  v2 [HP    ]
Begin SRAT table scan....
CPU 0x00 in proximity domain 0x00
CPU 0x01 in proximity domain 0x00
Memory range 0x0 to 0xA0 (type 0x1) in proximity domain 0x00 enabled
Memory range 0x100 to 0x80000 (type 0x1) in proximity domain 0x00 enabled
CPU 0x02 in proximity domain 0x01
CPU 0x03 in proximity domain 0x01
Memory range 0x80000 to 0xD0000 (type 0x1) in proximity domain 0x01 enabled
Memory range 0x100000 to 0x130000 (type 0x1) in proximity domain 0x01 enabl=
ed
acpi20_parse_srat: Entry length value is zero; can't parse any further!
pxm bitmap: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00=20
Number of logical nodes in system =3D 2
Number of memory chunks in system =3D 4
chunk 0 nid 0 start_pfn 00000000 end_pfn 000000a0
Entering add_active_range(0, 0, 160) 0 entries of 256 used
chunk 1 nid 0 start_pfn 00000100 end_pfn 00080000
Entering add_active_range(0, 256, 524288) 1 entries of 256 used
chunk 2 nid 1 start_pfn 00080000 end_pfn 000d0000
Entering add_active_range(1, 524288, 851968) 2 entries of 256 used
chunk 3 nid 1 start_pfn 00100000 end_pfn 00130000
Entering add_active_range(1, 1048576, 1245184) 3 entries of 256 used
Node: 0, start_pfn: 0, end_pfn: 524288
  Setting physnode_map array to node 0 for pfns:
  0 65536 131072 196608 262144 327680 393216 458752=20
Node: 1, start_pfn: 524288, end_pfn: 1245184
  Setting physnode_map array to node 1 for pfns:
  524288 589824 655360 720896 786432 851968 917504 983040 1048576 1114112 1=
179648=20
Reserving 4608 pages of KVA for lmem_map of node 0
Shrinking node 0 from 524288 pages to 519680 pages
Reserving 6144 pages of KVA for lmem_map of node 1
Shrinking node 1 from 1245183 pages to 1239039 pages
Shrinking node 1 further by 511 pages for proper alignment
Reserving total of 10752 pages for numa KVA remap
kva_start_pfn ~ 218112 find_max_low_pfn() ~ 229376
max_pfn =3D 1245183
3967MB HIGHMEM available.
896MB LOWMEM available.
min_low_pfn =3D 2158, max_low_pfn =3D 229376, highstart_pfn =3D 229376
Low memory ends at vaddr f8000000
node 0 will remap to vaddr f5400000 - f9200000
node 1 will remap to vaddr f6600000 - faa00000
High memory starts at vaddr f8000000
found SMP MP-table at 000f4f80
NX (Execute Disable) protection: active
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1245183
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      160
    0:      256 ->   519680
    1:   524288 ->   851968
    1:  1048576 ->  1238528
On node 0 totalpages: 519584
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3968 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2268 pages used for memmap
  HighMem zone: 288036 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 517632
  DMA zone: 0 pages used for memmap
  Normal zone: 0 pages used for memmap
  HighMem zone: 5580 pages used for memmap
  HighMem zone: 512052 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT CFE50780, 005C (r1 HP     A09             2   =D2=04     162E)
ACPI: FACP CFE50800, 00F4 (r3 HP     A09             2   =D2=04     162E)
ACPI: DSDT CFE50900, 4D3B (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS CFE50100, 0040
ACPI: SPCR CFE50140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: MCFG CFE501C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET CFE50200, 0038 (r1 HP     A09             2   =D2=04     162E)
ACPI: SPMI CFE50240, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC CFE50280, 00EA (r1 HP     00000083        2             0)
ACPI: SRAT CFE50380, 0110 (r1 AMD    HAMMER          1 AMD         1)
ACPI: PM-Timer IO Port: 0x920
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3 15:1 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 9, version 17, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x0a] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 10, version 17, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
ACPI: HPET id: 0x1166a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
Built 2 zonelists in Zone order.  Total pages: 1027576
Policy zone: HighMem
Kernel command line: ro root=3DLABEL=3D/
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec01000)
mapped IOAPIC to ffff8000 (fec02000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=3Dc07e3000 soft=3Dc07c3000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2400.147 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing HighMem for node 0 (00038000:0007ee00)
Initializing HighMem for node 1 (00080000:0012e600)
Memory: 4097176k/4980732k available (2420k kernel code, 49956k reserved, 11=
32k data, 264k init, 3230016k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc54000 - 0xfffff000   (3756 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc077e000 - 0xc07c0000   ( 264 kB)
      .data : 0xc065d2d8 - 0xc07786a4   (1132 kB)
      .text : 0xc0400000 - 0xc065d2d8   (2420 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 4802.71 BogoMIPS (lpj=3D24=
01359)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 0000=
2001 00000000 0000001f 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00=
000000 0000001f 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: AMD Dual-Core AMD Opteron(tm) Processor 2216 HE stepping 03
Mapping cpu 0 to node 0
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=3Dc07e4000 soft=3Dc07c4000
Initializing CPU#1
Mapping cpu 1 to node 0
Calibrating delay using timer specific routine.. 4800.20 BogoMIPS (lpj=3D24=
00101)
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 0000=
2001 00000000 0000001f 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00=
000000 0000001f 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Dual-Core AMD Opteron(tm) Processor 2216 HE stepping 03
SMP alternatives: switching to SMP code
Booting processor 2/2 eip 3000
CPU 2 irqstacks, hard=3Dc07e5000 soft=3Dc07c5000
Initializing CPU#2
Mapping cpu 2 to node 0
Calibrating delay using timer specific routine.. 4800.35 BogoMIPS (lpj=3D24=
00178)
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 0000=
2001 00000000 0000001f 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2(2) -> Core 0
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00=
000000 0000001f 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: AMD Dual-Core AMD Opteron(tm) Processor 2216 HE stepping 03
SMP alternatives: switching to SMP code
Booting processor 3/3 eip 3000
CPU 3 irqstacks, hard=3Dc07e6000 soft=3Dc07c6000
Initializing CPU#3
Mapping cpu 3 to node 0
Calibrating delay using timer specific routine.. 4800.12 BogoMIPS (lpj=3D24=
00061)
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 0000=
2001 00000000 0000001f 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3(2) -> Core 1
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00=
000000 0000001f 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: AMD Dual-Core AMD Opteron(tm) Processor 2216 HE stepping 03
Total of 4 processors activated (19203.39 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
Brought up 4 CPUs
khelper used greatest stack depth: 3264 bytes left
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at d0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0072, last bus=3D74
PCI: Using configuration type 1
Setting up standard PCI resources
khelper used greatest stack depth: 3152 bytes left
ACPI: EC: Look up EC in DSDT
ACPI: SSDT CFE58000, 046C (r2 HP     PNOWSSDT        2 HP          1)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: PXH quirk detected, disabling MSI for SHPC device
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB0.PXH0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB4._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXBA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXBB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.EXBD._PRT]
ACPI: PCI Interrupt Link [IUSB] (IRQs *5)
ACPI: PCI Interrupt Link [IN00] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN01] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN02] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN03] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN04] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN05] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN06] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN07] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN08] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN09] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN10] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN11] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN12] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN13] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN14] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN15] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN16] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN17] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN18] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN19] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN20] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN21] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN22] (IRQs 7 *10 11)
ACPI: PCI Interrupt Link [IN23] (IRQs *7 10 11)
ACPI: PCI Interrupt Link [IN24] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN25] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN26] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN27] (IRQs 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [IN28] (IRQs *7 10 11)
ACPI: PCI Interrupt Link [IN29] (IRQs 7 10 *11)
ACPI: PCI Interrupt Link [IN30] (IRQs 7 *10 11)
ACPI: PCI Interrupt Link [IN31] (IRQs 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Time: hpet clocksource has been installed.
pnp: 00:01: ioport range 0x408-0x40f has been reserved
pnp: 00:01: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:01: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:01: iomem range 0xd0000000-0xdfffffff has been reserved
PCI: Bridge: 0000:01:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
  IO window: disabled.
  MEM window: f9e00000-f9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0f.0
  IO window: disabled.
  MEM window: f9d00000-f9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:10.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:11.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:12.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:03:00.0
  IO window: disabled.
  MEM window: f6000000-f7ffffff
  PREFETCH window: e0000000-e00fffff
PCI: Bridge: 0000:00:13.0
  IO window: disabled.
  MEM window: f6000000-f7ffffff
  PREFETCH window: e0000000-e00fffff
ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 42 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:0f.0 to 64
PCI: Setting latency timer of device 0000:05:00.0 to 64
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 38 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:10.0 to 64
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 39 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:11.0 to 64
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 40 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:12.0 to 64
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 41 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:03:00.0 to 64
PCI: Bridge: 0000:40:0f.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:40:10.0
  IO window: 4000-4fff
  MEM window: fde00000-fdffffff
  PREFETCH window: e0200000-e02fffff
PCI: Bridge: 0000:40:11.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:41:00.0
  IO window: disabled.
  MEM window: fa000000-fbffffff
  PREFETCH window: e0300000-e03fffff
PCI: Bridge: 0000:40:12.0
  IO window: disabled.
  MEM window: fa000000-fbffffff
  PREFETCH window: e0300000-e03fffff
PCI: Bridge: 0000:40:13.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:40:0f.0[A] -> GSI 36 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:40:0f.0 to 64
ACPI: PCI Interrupt 0000:40:10.0[A] -> GSI 32 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:40:10.0 to 64
ACPI: PCI Interrupt 0000:40:11.0[A] -> GSI 33 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:40:11.0 to 64
ACPI: PCI Interrupt 0000:40:12.0[A] -> GSI 34 (level, low) -> IRQ 24
PCI: Setting latency timer of device 0000:40:12.0 to 64
PCI: Setting latency timer of device 0000:41:00.0 to 64
ACPI: PCI Interrupt 0000:40:13.0[A] -> GSI 35 (level, low) -> IRQ 25
PCI: Setting latency timer of device 0000:40:13.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
=46reeing initrd memory: 1280k freed
khelper used greatest stack depth: 3084 bytes left
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1195568280.526:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:03.0
pci 0000:00:04.4: HCRESET not completed yet!
PCI: MSI quirk detected. MSI deactivated.
PCI: Setting latency timer of device 0000:00:0f.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0f.0:pcie00]
PCI: Setting latency timer of device 0000:00:10.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:10.0:pcie00]
PCI: Setting latency timer of device 0000:00:11.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:11.0:pcie00]
PCI: Setting latency timer of device 0000:00:12.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:12.0:pcie00]
PCI: Setting latency timer of device 0000:00:13.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:13.0:pcie00]
PCI: Setting latency timer of device 0000:40:0f.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0f.0:pcie00]
PCI: Setting latency timer of device 0000:40:10.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:10.0:pcie00]
PCI: Setting latency timer of device 0000:40:11.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:11.0:pcie00]
PCI: Setting latency timer of device 0000:40:12.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:12.0:pcie00]
PCI: Setting latency timer of device 0000:40:13.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:13.0:pcie00]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
ACPI: PCI Interrupt 0000:46:00.0[A] -> GSI 32 (level, low) -> IRQ 22
cciss: MSI-X init failed -22
cciss0: <0x3230> at PCI 0000:46:00.0 IRQ 22 using DAC
      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

 cciss/c0d0: p1 p2
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.6.5 (September 20, 20=
07)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 41 (level, low) -> IRQ 20
eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz fou=
nd at mem f6000000, IRQ 20, node addr 001cc456bda2
ACPI: PCI Interrupt 0000:42:00.0[A] -> GSI 34 (level, low) -> IRQ 24
eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz fou=
nd at mem fa000000, IRQ 24, node addr 001cc456bda0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
SvrWks HT1000: IDE controller at PCI slot 0000:00:06.1
SvrWks HT1000: chipset revision 0
SvrWks HT1000: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1840-0x1847, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: TEAC DV-W28ECW, ATAPI CD/DVD-ROM drive
hda: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 2216 HE processors=
 (4 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
Using IPI No-Shortcut mode
=46reeing unused kernel memory: 264k freed
Write protecting the kernel read-only data: 783k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:04.4[B] -> GSI 45 (level, low) -> IRQ 26
uhci_hcd 0000:00:04.4: UHCI Host Controller
uhci_hcd 0000:00:04.4: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:00:04.4: HCRESET not completed yet!
uhci_hcd 0000:00:04.4: irq 26, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
insmod used greatest stack depth: 2440 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [IUSB] enabled at IRQ 5
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [IUSB] -> GSI 5 (level, low) ->=
 IRQ 5
ohci_hcd 0000:00:07.0: OHCI Host Controller
ohci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:07.0: irq 5, io mem 0xf5ee0000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:07.1[A] -> Link [IUSB] -> GSI 5 (level, low) ->=
 IRQ 5
ohci_hcd 0000:00:07.1: OHCI Host Controller
ohci_hcd 0000:00:07.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:07.1: irq 5, io mem 0xf5ed0000
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: PS/2 Generic Mouse as /class/input/input1
insmod used greatest stack depth: 2368 bytes left
ACPI: PCI Interrupt 0000:00:07.2[A] -> Link [IUSB] -> GSI 5 (level, low) ->=
 IRQ 5
ehci_hcd 0000:00:07.2: EHCI Host Controller
ehci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:07.2: irq 5, io mem 0xf5ec0000
ehci_hcd 0000:00:07.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 4 ports detected
usb 1-1: configuration #1 chosen from 1 choice
input: HP Virtual Keyboard as /class/input/input2
input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:00:04.4-1
input: HP Virtual Keyboard as /class/input/input3
input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:00:04.4-1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 1-2: new full speed USB device using uhci_hcd and address 3
audit(1195568284.624:2): enforcing=3D1 old_enforcing=3D0 auid=3D4294967295
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 7 ports detected
security:  3 users, 6 roles, 1587 types, 172 bools, 1 sens, 1024 cats
security:  59 classes, 49762 rules
security:  class dccp_socket not defined in policy
security:  class memprotect not defined in policy
security:  permission dccp_recv in class node not defined in policy
security:  permission dccp_send in class node not defined in policy
security:  permission dccp_recv in class netif not defined in policy
security:  permission dccp_send in class netif not defined in policy
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev cciss/c0d0p1, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), not configured =
for labeling
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), not configured for labeling
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1195568284.819:3): policy loaded auid=3D4294967295
hostname used greatest stack depth: 2180 bytes left
uname used greatest stack depth: 2080 bytes left
mount used greatest stack depth: 1376 bytes left
usb 3-1: new full speed USB device using ohci_hcd and address 2
usb 3-1: not running at top speed; connect to a high speed hub
usb 3-1: configuration #1 chosen from 1 choice
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 4 ports detected
hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ipmi message handler version 39.1
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
piix4_smbus 0000:00:06.0: Found 0000:00:06.0 device
=46loppy drive(s): fd0 is 1.44M
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
ACPI: PCI Interrupt 0000:00:04.6[A] -> GSI 46 (level, low) -> IRQ 27
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf5ef0000, =
slave address 0x0, irq 27
  Using irq 27
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
IPMI kcs interface initialized
floppy0: no floppy controllers found
=46loppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
lp: driver loaded but no devices found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
EXT3 FS on cciss/c0d0p1, internal journal
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 4096564k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1 across:40=
96564k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contex=
ts
rc.sysinit used greatest stack depth: 1192 bytes left
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.defaul=
t.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
Clocksource tsc unstable (delta =3D -254144931 ns)
ADDRCONF(NETDEV_UP): eth0: link is not ready
bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex, receive & transmit=
 flow control ON
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
bnx2: eth1 NIC Copper Link is Up, 1000 Mbps full duplex
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
audit(1195568307.893:4): audit_pid=3D2804 old=3D0 by auid=3D4294967295 subj=
=3Dsystem_u:system_r:auditd_t:s0
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
eth0: no IPv6 routers present
eth1: no IPv6 routers present
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts

--Boundary-00=_vnuQH6fqoNMdHcs
Content-Type: application/x-gzip;
  name=".config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename=".config.gz"

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
AAA=

--Boundary-00=_vnuQH6fqoNMdHcs--
