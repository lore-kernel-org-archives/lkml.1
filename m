Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbXJSKoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbXJSKoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbXJSKoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:44:15 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:63747 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXJSKoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:44:12 -0400
Subject: Network failure with 2.6.23-git14
From: Chris Holvenstot <cholvenstot@comcast.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 05:49:06 -0500
Message-Id: <1192790946.6416.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I built 2.6.23-git14 this morning - when booted I can not access the
network via my Ethernet connection.  Fallback to 2.6.23-git11 works OK.
One interesting message during boot:

sysctl table check failed: /net/token-ring .3.14 procname does not match
binary path procname

Complete dmesg output follows

[    0.000000] Linux version 2.6.23-git14 (root@popeye) (gcc version
4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP Fri Oct 19 04:31:31 CDT 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI
data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000
(reserved)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f5380
[    0.000000] Entering add_active_range(0, 0, 524272) 0 entries of 256
used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   524272
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   524272
[    0.000000] On node 0 totalpages: 524272
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2303 pages used for memmap
[    0.000000]   HighMem zone: 292593 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F9260, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 7FFF3040, 0030 (r1 Nvidia AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: DSDT 7FFF3180, 63C4 (r1 NVIDIA AWRDACPI     1000
MSFT  100000E)
[    0.000000] ACPI: FACS 7FFF0000, 0040
[    0.000000] ACPI: MCFG 7FFF9680, 003C (r1 Nvidia AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: APIC 7FFF95C0, 0072 (r1 Nvidia AWRDACPI 42302E31
AWRD        0)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high
edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high
edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap:
80000000:60000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 520177
[    0.000000] Kernel command line:
root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet single
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2412.413 MHz processor.
[   32.950316] spurious 8259A interrupt: IRQ7.
[   32.951445] Console: colour VGA+ 80x25
[   32.951448] console [tty0] enabled
[   32.951927] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[   32.952336] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[   33.024846] Memory: 2035932k/2097088k available (2031k kernel code,
59964k reserved, 940k data, 336k init, 1179584k highmem)
[   33.024852] virtual kernel memory layout:
[   33.024853]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[   33.024854]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   33.024855]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   33.024856]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   33.024857]       .init : 0xc03ed000 - 0xc0441000   ( 336 kB)
[   33.024858]       .data : 0xc02fbe0f - 0xc03e7084   ( 940 kB)
[   33.024858]       .text : 0xc0100000 - 0xc02fbe0f   (2031 kB)
[   33.024861] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   33.104900] Calibrating delay using timer specific routine.. 4827.67
BogoMIPS (lpj=9655356)
[   33.104935] Security Framework initialized
[   33.104941] SELinux:  Disabled at boot.
[   33.104955] Mount-cache hash table entries: 512
[   33.105095] CPU: After generic identify, caps: 178bfbff e3d3fbff
00000000 00000000 00000001 00000000 00000003 00000000
[   33.105100] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[   33.105102] CPU: L2 Cache: 512K (64 bytes/line)
[   33.105104] CPU 0(2) -> Core 0
[   33.105105] CPU: After all inits, caps: 178bfbff e3d3fbff 00000000
00000410 00000001 00000000 00000003 00000000
[   33.105114] Compat vDSO mapped to ffffe000.
[   33.105125] Checking 'hlt' instruction... OK.
[   33.121092] SMP alternatives: switching to UP code
[   33.121535] ACPI: Core revision 20070126
[   33.125279] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+
stepping 01
[   33.125296] SMP alternatives: switching to SMP code
[   33.125553] Booting processor 1/1 eip 3000
[   33.135799] Initializing CPU#1
[   33.213068] Calibrating delay using timer specific routine.. 4825.06
BogoMIPS (lpj=9650126)
[   33.213073] CPU: After generic identify, caps: 178bfbff e3d3fbff
00000000 00000000 00000001 00000000 00000003 00000000
[   33.213078] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[   33.213080] CPU: L2 Cache: 512K (64 bytes/line)
[   33.213081] CPU 1(2) -> Core 1
[   33.213082] CPU: After all inits, caps: 178bfbff e3d3fbff 00000000
00000410 00000001 00000000 00000003 00000000
[   33.212931] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+
stepping 01
[   33.212938] Total of 2 processors activated (9652.74 BogoMIPS).
[   33.213075] ENABLING IO-APIC IRQs
[   33.213260] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[   33.360749] Brought up 2 CPUs
[   33.360780] CPU0 attaching sched-domain:
[   33.360782]  domain 0: span 3
[   33.360784]   groups: 1 2
[   33.360786] CPU1 attaching sched-domain:
[   33.360787]  domain 0: span 3
[   33.360789]   groups: 2 1
[   33.360962] net_namespace: 64 bytes
[   33.361222] 
[   33.361471] Time:  5:34:19  Date: 10/19/07
[   33.361502] NET: Registered protocol family 16
[   33.361637] EISA bus registered
[   33.361641] ACPI: bus type pci registered
[   33.361702] PCI: Using MMCONFIG
[   33.361723] PCI: No mmconfig possible on device 00:18
[   33.362016] Setting up standard PCI resources
[   33.366555] ACPI: EC: Look up EC in DSDT
[   33.372064] ACPI: Interpreter enabled
[   33.372066] ACPI: (supports S0 S1 S5)
[   33.372074] ACPI: Using IOAPIC for interrupt routing
[   33.378909] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   33.379226] PCI: Transparent bridge - 0000:00:09.0
[   33.379483] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   33.379700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   33.427995] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.428144] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.428293] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12
14 15)
[   33.428439] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.428591] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.428742] ACPI: PCI Interrupt Link [LUBA] (IRQs *3 4 5 7 9 10 11 12
14 15)
[   33.428889] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.429038] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12
14 15)
[   33.429186] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12
14 15)
[   33.429333] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 *10 11 12
14 15)
[   33.429482] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 *11 12
14 15)
[   33.429630] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 *5 7 9 10 11 12
14 15)
[   33.429777] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.429932] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 *10 11 12
14 15)
[   33.430086] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 *11 12
14 15)
[   33.430238] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12
14 15) *0, disabled.
[   33.430401] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[   33.430558] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[   33.430714] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[   33.430870] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[   33.430977] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[   33.431138] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[   33.431299] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0,
disabled.
[   33.431460] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[   33.431620] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[   33.431779] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0
[   33.431939] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[   33.432098] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[   33.432258] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0,
disabled.
[   33.432424] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[   33.432591] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[   33.432757] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0,
disabled.
[   33.432856] Linux Plug and Play Support v0.97 (c) Adam Belay
[   33.432875] pnp: PnP ACPI init
[   33.432880] ACPI: bus type pnp registered
[   33.436851] pnp: PnP ACPI: found 14 devices
[   33.436853] ACPI: ACPI bus type pnp unregistered
[   33.436856] PnPBIOS: Disabled by ACPI PNP
[   33.436969] PCI: Using ACPI for IRQ routing
[   33.436972] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[   33.448561] NET: Registered protocol family 8
[   33.448562] NET: Registered protocol family 20
[   33.460548] system 00:01: ioport range 0x4000-0x407f has been
reserved
[   33.460550] system 00:01: ioport range 0x4080-0x40ff has been
reserved
[   33.460552] system 00:01: ioport range 0x4400-0x447f has been
reserved
[   33.460554] system 00:01: ioport range 0x4480-0x44ff has been
reserved
[   33.460556] system 00:01: ioport range 0x4800-0x487f has been
reserved
[   33.460558] system 00:01: ioport range 0x4880-0x48ff has been
reserved
[   33.460567] system 00:0c: iomem range 0xe0000000-0xefffffff could not
be reserved
[   33.460571] system 00:0d: iomem range 0xf0000-0xf3fff could not be
reserved
[   33.460573] system 00:0d: iomem range 0xf4000-0xf7fff could not be
reserved
[   33.460575] system 00:0d: iomem range 0xf8000-0xfbfff could not be
reserved
[   33.460577] system 00:0d: iomem range 0xfc000-0xfffff could not be
reserved
[   33.490814] PCI: Bridge: 0000:00:09.0
[   33.490817]   IO window: a000-afff
[   33.490819]   MEM window: fde00000-fdefffff
[   33.490821]   PREFETCH window: fdf00000-fdffffff
[   33.490823] PCI: Bridge: 0000:00:0b.0
[   33.490824]   IO window: 9000-9fff
[   33.490826]   MEM window: fdd00000-fddfffff
[   33.490828]   PREFETCH window: fdc00000-fdcfffff
[   33.490829] PCI: Bridge: 0000:00:0c.0
[   33.490831]   IO window: 8000-8fff
[   33.490833]   MEM window: fdb00000-fdbfffff
[   33.490834]   PREFETCH window: fda00000-fdafffff
[   33.490836] PCI: Bridge: 0000:00:0d.0
[   33.490838]   IO window: 7000-7fff
[   33.490840]   MEM window: fd900000-fd9fffff
[   33.490841]   PREFETCH window: fd800000-fd8fffff
[   33.490845] PCI: Bridge: 0000:00:0e.0
[   33.490847]   IO window: 6000-6fff
[   33.490848]   MEM window: fa000000-fcffffff
[   33.490850]   PREFETCH window: d0000000-dfffffff
[   33.490856] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   33.490862] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   33.490867] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   33.490872] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   33.490876] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   33.490900] NET: Registered protocol family 2
[   33.492494] Time: acpi_pm clocksource has been installed.
[   33.492507] Switched to high resolution mode on CPU 0
[   33.492899] Switched to high resolution mode on CPU 1
[   33.528502] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[   33.528809] TCP established hash table entries: 131072 (order: 8,
1572864 bytes)
[   33.530374] TCP bind hash table entries: 65536 (order: 7, 524288
bytes)
[   33.530904] TCP: Hash tables configured (established 131072 bind
65536)
[   33.530907] TCP reno registered
[   33.540559] checking if image is initramfs... it is
[   36.104262] Freeing initrd memory: 38951k freed
[   36.105226] audit: initializing netlink socket (disabled)
[   36.105239] audit(1192772061.980:1): initialized
[   36.105392] highmem bounce pool size: 64 pages
[   36.105461] VFS: Disk quotas dquot_6.5.1
[   36.105480] Dquot-cache hash table entries: 1024 (order 0, 4096
bytes)
[   36.105543] io scheduler noop registered
[   36.105544] io scheduler anticipatory registered
[   36.105545] io scheduler deadline registered
[   36.105556] io scheduler cfq registered (default)
[   36.118313] PCI: Linking AER extended capability on 0000:00:0b.0
[   36.118316] PCI: Linking AER extended capability on 0000:00:0c.0
[   36.118319] PCI: Linking AER extended capability on 0000:00:0d.0
[   36.118321] PCI: Linking AER extended capability on 0000:00:0e.0
[   36.118327] Boot video device is 0000:05:00.0
[   36.118407] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   36.118421] assign_interrupt_mode Found MSI capability
[   36.118422] Allocate Port Service[0000:00:0b.0:pcie00]
[   36.118448] Allocate Port Service[0000:00:0b.0:pcie03]
[   36.118489] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   36.118501] assign_interrupt_mode Found MSI capability
[   36.118502] Allocate Port Service[0000:00:0c.0:pcie00]
[   36.118527] Allocate Port Service[0000:00:0c.0:pcie03]
[   36.118567] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   36.118578] assign_interrupt_mode Found MSI capability
[   36.118580] Allocate Port Service[0000:00:0d.0:pcie00]
[   36.118608] Allocate Port Service[0000:00:0d.0:pcie03]
[   36.118654] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   36.118665] assign_interrupt_mode Found MSI capability
[   36.118666] Allocate Port Service[0000:00:0e.0:pcie00]
[   36.118693] Allocate Port Service[0000:00:0e.0:pcie03]
[   36.118801] isapnp: Scanning for PnP cards...
[   36.470808] isapnp: No Plug & Play device found
[   36.489025] Real Time Clock Driver v1.12ac
[   36.489130] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[   36.489236] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   36.489647] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   36.490256] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   36.490262] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   36.490265] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[   36.490427] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[   36.493048] serio: i8042 KBD port at 0x60,0x64 irq 1
[   36.493052] serio: i8042 AUX port at 0x60,0x64 irq 12
[   36.493162] mice: PS/2 mouse device common for all mice
[   36.493564] EISA: Probing bus 0 at eisa.0
[   36.493574] Cannot allocate resource for EISA slot 4
[   36.493578] Cannot allocate resource for EISA slot 6
[   36.493580] Cannot allocate resource for EISA slot 7
[   36.493581] Cannot allocate resource for EISA slot 8
[   36.493582] EISA: Detected 0 cards.
[   36.493656] TCP cubic registered
[   36.493665] NET: Registered protocol family 1
[   36.493693] Starting balanced_irq
[   36.493711] Using IPI No-Shortcut mode
[   36.493844]   Magic number: 11:10:568
[   36.493923]   hash matches device ptyb0
[   36.494015]   hash matches device PNP0C0F:15
[   36.494320] Freeing unused kernel memory: 336k freed
[   36.514866] input: AT Translated Set 2 keyboard
as /class/input/input0
[   36.680986] ACPI: Fan [FAN] (on)
[   36.686385] ACPI: Thermal Zone [THRM] (22 C)
[   37.228761] usbcore: registered new interface driver usbfs
[   37.228783] usbcore: registered new interface driver hub
[   37.229472] usbcore: registered new device driver usb
[   37.248193] SCSI subsystem initialized
[   37.325760] forcedeth: Reverse Engineered nForce ethernet driver.
Version 0.61.
[   37.326092] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[   37.326100] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI
23 (level, low) -> IRQ 16
[   37.326107] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   37.328332] Floppy drive(s): fd0 is 1.44M
[   37.329862] libata version 3.00 loaded.
[   37.347439] FDC 0 is a post-1991 82077
[   37.349120] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller
(OHCI) Driver
[   37.843618] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1,
addr 00:19:db:6d:3f:1b
[   37.843623] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim
desc-v3
[   37.843731] NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
[   37.843752] NFORCE-CK804: chipset revision 243
[   37.843754] NFORCE-CK804: not 100% native mode: will probe irqs later
[   37.843757] NFORCE-CK804: BIOS didn't set cable bits correctly.
Enabling workaround.
[   37.843760] NFORCE-CK804: 0000:00:06.0 (rev f3) UDMA133 controller
[   37.843765]     ide0: BM-DMA at 0xe000-0xe007, BIOS settings:
hda:DMA, hdb:DMA
[   37.843772]     ide1: BM-DMA at 0xe008-0xe00f, BIOS settings:
hdc:DMA, hdd:DMA
[   37.843778] Probing IDE interface ide0...
[   38.130993] hdb: WDC WD2500JB-55REA0, ATA DISK drive
[   38.578454] hda: IDE-DVD ROM 16x, ATAPI CD/DVD-ROM drive
[   38.578460] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   38.578556] hda: selected mode 0x42
[   38.578840] hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   38.578884] hdb: selected mode 0x45
[   38.578986] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   38.602277] Probing IDE interface ide1...
[   38.890079] hdd: Maxtor 6Y120P0, ATA DISK drive
[   39.225676] hdc: WDC WD2000BB-22GUC0, ATA DISK drive
[   39.225682] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   39.226898] hdc: selected mode 0x45
[   39.228135] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   39.228224] hdd: selected mode 0x46
[   39.228361] ide1 at 0x170-0x177,0x376 on irq 15
[   39.241535] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[   39.241542] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI
22 (level, low) -> IRQ 17
[   39.241553] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   39.241555] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   39.241754] ehci_hcd 0000:00:02.1: new USB bus registered, assigned
bus number 1
[   39.241781] ehci_hcd 0000:00:02.1: debug port 1
[   39.241783] PCI: cache line size of 64 is not supported by device
0000:00:02.1
[   39.241789] ehci_hcd 0000:00:02.1: irq 17, io mem 0xfe02e000
[   39.241794] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   39.241876] usb usb1: configuration #1 chosen from 1 choice
[   39.241896] hub 1-0:1.0: USB hub found
[   39.241902] hub 1-0:1.0: 10 ports detected
[   39.346310] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[   39.346319] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI
21 (level, low) -> IRQ 18
[   39.346331] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   39.346334] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   39.346365] ohci_hcd 0000:00:02.0: new USB bus registered, assigned
bus number 2
[   39.346380] ohci_hcd 0000:00:02.0: irq 18, io mem 0xfe02f000
[   39.404789] usb usb2: configuration #1 chosen from 1 choice
[   39.404811] hub 2-0:1.0: USB hub found
[   39.404820] hub 2-0:1.0: 10 ports detected
[   39.509801] sata_nv 0000:00:07.0: version 3.5
[   39.510182] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 20
[   39.510191] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI
20 (level, low) -> IRQ 19
[   39.510194] sata_nv 0000:00:07.0: Using ADMA mode
[   39.510246] PCI: Setting latency timer of device 0000:00:07.0 to 64
[   39.511294] scsi0 : sata_nv
[   39.511354] scsi1 : sata_nv
[   39.511412] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xcc00
irq 19
[   39.511414] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xcc08
irq 19
[   39.526569] hdb: max request size: 512KiB
[   39.537686] hdb: 488397168 sectors (250059 MB) w/8192KiB Cache,
CHS=30401/255/63, UDMA(100)
[   39.537764] hdb: cache flushes supported
[   39.537795]  hdb: hdb1
[   39.546333] hdc: max request size: 512KiB
[   39.547593] hdc: 390721968 sectors (200049 MB) w/2048KiB Cache,
CHS=24321/255/63, UDMA(100)
[   39.547775] hda: ATAPI 40X DVD-ROM drive, 256kB Cache, UDMA(33)
[   39.547779] Uniform CD-ROM driver Revision: 3.20
[   39.549304] hdc: cache flushes supported
[   39.549330]  hdc: hdc1 hdc2
[   39.581676] hdd: max request size: 128KiB
[   39.581890] hdd: 240121728 sectors (122942 MB) w/7936KiB Cache,
CHS=65535/16/63, UDMA(133)
[   39.582005] hdd: cache flushes supported
[   39.582023]  hdd:<6>usb 1-1: new high speed USB device using ehci_hcd
and address 2
[   39.586750]  hdd1
[   39.719845] usb 1-1: configuration #1 chosen from 1 choice
[   39.779516] kjournald starting.  Commit interval 5 seconds
[   39.779525] EXT3-fs: mounted filesystem with ordered data mode.
[   39.976714] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   39.986136] ata1.00: ATA-7: Maxtor 7H500F0, HA431DN0, max UDMA/133
[   39.986139] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
31/32)
[   40.002773] ata1.00: configured for UDMA/133
[   40.312304] ata2: SATA link down (SStatus 0 SControl 300)
[   40.312396] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 7H500F0
HA43 PQ: 0 ANSI: 5
[   40.312403] ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary
0xFFFFFFFF, hw segs 61
[   40.312812] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 23
[   40.312815] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI
23 (level, low) -> IRQ 16
[   40.312819] sata_nv 0000:00:08.0: Using ADMA mode
[   40.312860] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   40.312947] scsi2 : sata_nv
[   40.312981] scsi3 : sata_nv
[   40.313035] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xb800
irq 16
[   40.313037] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xb808
irq 16
[   40.436160] usb 1-7: new high speed USB device using ehci_hcd and
address 5
[   40.629073] usb 1-7: configuration #1 chosen from 1 choice
[   40.779750] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   40.789094] ata3.00: ATA-7: Maxtor 7L250S0, BACE1G20, max UDMA/133
[   40.789098] ata3.00: 490234752 sectors, multi 16: LBA48 NCQ (depth
31/32)
[   40.805747] ata3.00: configured for UDMA/133
[   40.931592] usb 2-3: new full speed USB device using ohci_hcd and
address 2
[   41.115339] ata4: SATA link down (SStatus 0 SControl 300)
[   41.115428] scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7L250S0
BACE PQ: 0 ANSI: 5
[   41.115435] ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary
0xFFFFFFFF, hw segs 61
[   41.146506] usb 2-3: configuration #1 chosen from 1 choice
[   41.450936] usb 2-6: new full speed USB device using ohci_hcd and
address 3
[   41.668920] usb 2-6: configuration #1 chosen from 1 choice
[   46.414433] sysfs: duplicate filename 'eth1' can not be created
[   46.414438] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[   46.414445]  [<c01ba80f>] sysfs_add_one+0x9f/0xe0
[   46.414456]  [<c01bb5c6>] sysfs_create_link+0x86/0x110
[   46.414462]  [<c025608a>] device_rename+0x17a/0x1e0
[   46.414467]  [<c0130190>] run_timer_softirq+0x30/0x180
[   46.414472]  [<c0287a60>] dev_change_name+0xb0/0x200
[   46.414476]  [<c0159a62>] filemap_fault+0x1f2/0x400
[   46.414478]  [<c012c895>] __do_softirq+0x75/0xf0
[   46.414484]  [<c027a260>] sock_ioctl+0x0/0x230
[   46.414487]  [<c028809c>] dev_ioctl+0x25c/0x520
[   46.414489]  [<c01646eb>] __do_fault+0x1ab/0x380
[   46.414494]  [<c0165d28>] handle_mm_fault+0xf8/0x610
[   46.414499]  [<c027a260>] sock_ioctl+0x0/0x230
[   46.414502]  [<c018343b>] do_ioctl+0x2b/0x90
[   46.414506]  [<c01834fc>] vfs_ioctl+0x5c/0x290
[   46.414510]  [<c0183798>] sys_ioctl+0x68/0x80
[   46.414513]  [<c01041de>] sysenter_past_esp+0x5f/0x85
[   46.414520]  =======================
[   46.414523] net eth1: device_rename: sysfs_create_symlink failed
(-17)
[   47.083004] NET: Registered protocol family 10
[   47.083212] lo: Disabled Privacy Extensions
[   47.631643] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   47.765417] input: PC Speaker as /class/input/input1
[   47.815304] shpchp: Standard Hot Plug PCI Controller Driver version:
0.4
[   47.827778] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   47.827792] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   47.849916] input: Power Button (FF) as /class/input/input2
[   47.899283] ACPI: Power Button (FF) [PWRF]
[   47.899345] input: Power Button (CM) as /class/input/input3
[   47.959228] ACPI: Power Button (CM) [PWRB]
[   48.256934] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors
(500108 MB)
[   48.256947] sd 0:0:0:0: [sda] Write Protect is off
[   48.256950] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   48.256963] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   48.257005] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors
(500108 MB)
[   48.257011] sd 0:0:0:0: [sda] Write Protect is off
[   48.257013] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   48.257024] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   48.257027]  sda: sda1
[   48.280235] sd 0:0:0:0: [sda] Attached SCSI disk
[   48.280326] sd 2:0:0:0: [sdb] 490234752 512-byte hardware sectors
(251000 MB)
[   48.280335] sd 2:0:0:0: [sdb] Write Protect is off
[   48.280337] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   48.280349] sd 2:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   48.280383] sd 2:0:0:0: [sdb] 490234752 512-byte hardware sectors
(251000 MB)
[   48.280389] sd 2:0:0:0: [sdb] Write Protect is off
[   48.280390] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   48.280400] sd 2:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   48.280402]  sdb: sdb1
[   48.300648] sd 2:0:0:0: [sdb] Attached SCSI disk
[   48.325240] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   48.325265] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   48.398212] input: ImPS/2 Generic Wheel Mouse as /class/input/input4
[   48.457082] parport_pc 00:09: reported by Plug and Play ACPI
[   48.457126] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   48.576313] Linux agpgart interface v0.102
[   48.639692] usbcore: registered new interface driver libusual
[   48.656014] usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto
2 vid 0x04B8 pid 0x0005
[   48.656034] usbcore: registered new interface driver usblp
[   48.767341] Initializing USB Mass Storage driver...
[   48.768347] scsi4 : SCSI emulation for USB Mass Storage devices
[   48.768737] usb-storage: device found at 5
[   48.768742] usb-storage: waiting for device to settle before scanning
[   48.768573] scsi5 : SCSI emulation for USB Mass Storage devices
[   48.770509] usb-storage: device found at 2
[   48.770511] usb-storage: waiting for device to settle before scanning
[   48.770195] usbcore: registered new interface driver usb-storage
[   48.770199] USB Mass Storage support registered.
[   48.786595] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
[   48.786600] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI
22 (level, low) -> IRQ 17
[   48.786619] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   49.107097] intel8x0_measure_ac97_clock: measured 54714 usecs
[   49.107100] intel8x0: clocking to 46897
[   49.274889] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   49.274902] ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [APC3] -> GSI
18 (level, low) -> IRQ 20
[   49.274909] PCI: Setting latency timer of device 0000:05:00.0 to 64
[   49.399917] lp0: using parport0 (interrupt-driven).
[   49.451871] fuse init (API version 7.9)
[   49.516676] Adding 10241428k swap on /dev/hdc2.  Priority:-1
extents:1 across:10241428k
[   49.592091] EXT3 FS on hdb1, internal journal
[   50.738122] kjournald starting.  Commit interval 5 seconds
[   50.744102] EXT3 FS on hdc1, internal journal
[   50.744109] EXT3-fs: mounted filesystem with ordered data mode.
[   50.756820] kjournald starting.  Commit interval 5 seconds
[   50.763926] EXT3 FS on hdd1, internal journal
[   50.763929] EXT3-fs: mounted filesystem with ordered data mode.
[   50.790933] kjournald starting.  Commit interval 5 seconds
[   50.800195] EXT3 FS on sdb1, internal journal
[   50.800199] EXT3-fs: mounted filesystem with ordered data mode.
[   52.093818] NET: Registered protocol family 17
[   53.761445] usb-storage: device scan complete
[   53.763647] scsi 4:0:0:0: CD-ROM            MAD DOG  MD-16XDVD9
2.FD PQ: 0 ANSI: 0
[   53.763918] scsi 4:0:0:0: Attached scsi generic sg2 type 5
[   53.767538] usb-storage: device scan complete
[   53.774534] scsi 5:0:0:0: Direct-Access     Generic  USB SD Reader
1.00 PQ: 0 ANSI: 0
[   53.781515] scsi 5:0:0:1: Direct-Access     Generic  USB CF Reader
1.01 PQ: 0 ANSI: 0
[   53.788503] scsi 5:0:0:2: Direct-Access     Generic  USB SM Reader
1.02 PQ: 0 ANSI: 0
[   53.795713] scsi 5:0:0:3: Direct-Access     Generic  USB MS Reader
1.03 PQ: 0 ANSI: 0
[   53.807495] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda
tray
[   53.807547] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   53.808907] sd 5:0:0:0: [sdc] Attached SCSI removable disk
[   53.808947] sd 5:0:0:0: Attached scsi generic sg3 type 0
[   53.825502] sd 5:0:0:1: [sdd] Attached SCSI removable disk
[   53.825540] sd 5:0:0:1: Attached scsi generic sg4 type 0
[   53.835515] sd 5:0:0:2: [sde] Attached SCSI removable disk
[   53.835551] sd 5:0:0:2: Attached scsi generic sg5 type 0
[   53.846500] sd 5:0:0:3: [sdf] Attached SCSI removable disk
[   53.846538] sd 5:0:0:3: Attached scsi generic sg6 type 0
[   57.555625] eth1: no IPv6 routers present

