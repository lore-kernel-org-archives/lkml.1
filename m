Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYLEH6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYLEH6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYLEH6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:58:44 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57431 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYLEH6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:58:42 -0500
Date: Fri, 5 Dec 2008 09:58:36 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x29/0x9e()
Message-ID: <Pine.SOC.4.64.0812050957050.13897@math.ut.ee>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-1804928587-1228463916=:13897"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-1804928587-1228463916=:13897
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Got this warning on yesterdays 2.6.28-rc7-00105-gfeaf384 with ide-cd and=20
ali ide driver (full warning at the end of dmesg).

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc7-00105-gfeaf384 (mroos@vaarikas) (gcc version 4.3=
.2 (Debian 4.3.2-1) ) #237 PREEMPT Thu Dec 4 09:05:24 EET 2008
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
 BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
 BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn =3D 0x7ffb0 max_arch_pfn =3D 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 377fe000 @ 10000-16000
ACPI: RSDP 000F9BE0, 0014 (r0 ACPIAM)
ACPI: RSDT 7FFB0000, 0030 (r1 A M I  OEMRSDT   1000627 MSFT       97)
ACPI: FACP 7FFB0200, 0084 (r2 A M I  OEMFACP   1000627 MSFT       97)
ACPI: DSDT 7FFB0400, 45A7 (r1  939M2 939M2160      160 INTL  2002026)
ACPI: FACS 7FFC0000, 0040
ACPI: APIC 7FFB0390, 0068 (r1 A M I  OEMAPIC   1000627 MSFT       97)
ACPI: OEMB 7FFC0040, 0056 (r1 A M I  AMI_OEM   1000627 MSFT       97)
ACPI: Local APIC address 0xfee00000
1159MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(6 early reservations) =3D=3D> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 000=
0001000]
  #1 [0000100000 - 00004c6b00]    TEXT DATA BSS =3D=3D> [0000100000 - 000=
04c6b00]
  #2 [00004c7000 - 00004ca000]    INIT_PG_TABLE =3D=3D> [00004c7000 - 000=
04ca000]
  #3 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000009fc00 - 000=
0100000]
  #4 [0000010000 - 0000012000]          PGTABLE =3D=3D> [0000010000 - 000=
0012000]
  #5 [0000012000 - 0000019000]          BOOTMAP =3D=3D> [0000012000 - 000=
0019000]
found SMP MP-table at [c00ff780] 000ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0007ffb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007ffb0
On node 0 totalpages: 524095
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2320 pages used for memmap
  HighMem zone: 294562 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 17, address 0xfec10000, GSI 24-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7f7c0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 5199=
99
Kernel command line: root=3D/dev/sda1 ro
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=3Dc0474000 soft=3Dc0473000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1800.103 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074364k/2096832k available (2045k kernel code, 21164k reserved, =
1219k data, 248k init, 1187528k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0432000 - 0xc0470000   ( 248 kB)
      .data : 0xc02ff77b - 0xc0430638   (1219 kB)
      .text : 0xc0100000 - 0xc02ff77b   (2045 kB)
Checking if this processor honours the WP bit even in supervisor mode...O=
k.
Calibrating delay loop (skipped), value calculated using timer frequency.=
. 3600.20 BogoMIPS (lpj=3D7200412)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 02
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080926
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
net_namespace: 760 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D5
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:04.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:07.1: quirk: region 0800-083f claimed by ali7101 ACPI
pci 0000:00:08.0: reg 10 io port: [0xe800-0xe8ff]
pci 0000:00:08.0: reg 14 32bit mmio: [0xfebff000-0xfebfffff]
pci 0000:00:08.0: supports D1 D2
pci 0000:00:08.0: PME# supported from D2 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:11.0: reg 10 io port: [0xe400-0xe4ff]
pci 0000:00:11.0: reg 14 32bit mmio: [0xfebfec00-0xfebfecff]
pci 0000:00:11.0: PME# supported from D3hot D3cold
pci 0000:00:11.0: PME# disabled
pci 0000:00:12.0: reg 10 io port: [0x1f0-0x1ff]
pci 0000:00:12.0: reg 14 io port: [0x3f4-0x3f7]
pci 0000:00:12.0: reg 18 io port: [0x170-0x17f]
pci 0000:00:12.0: reg 1c io port: [0x374-0x377]
pci 0000:00:12.0: reg 20 io port: [0xff00-0xff0f]
pci 0000:00:13.0: reg 10 32bit mmio: [0xfebfd000-0xfebfdfff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xfebfc000-0xfebfcfff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xfebfb000-0xfebfbfff]
pci 0000:00:13.3: reg 10 32bit mmio: [0xfebfe800-0xfebfe8ff]
pci 0000:00:13.3: PME# supported from D0 D3hot D3cold
pci 0000:00:13.3: PME# disabled
pci 0000:00:01.0: bridge 32bit mmio: [0xfd600000-0xfd6fffff]
pci 0000:00:02.0: bridge 32bit mmio: [0xfd700000-0xfd7fffff]
pci 0000:03:00.0: reg 10 io port: [0xcc00-0xcc07]
pci 0000:03:00.0: reg 14 io port: [0xc880-0xc883]
pci 0000:03:00.0: reg 18 io port: [0xc800-0xc807]
pci 0000:03:00.0: reg 1c io port: [0xc480-0xc483]
pci 0000:03:00.0: reg 20 io port: [0xc400-0xc40f]
pci 0000:03:00.0: reg 24 32bit mmio: [0xfd8fe000-0xfd8fffff]
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable =
it with 'pcie_aspm=3Dforce'
pci 0000:00:03.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:03.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xbc000000-0xbdffffff]
pci 0000:04:00.0: reg 14 32bit mmio: [0xfe9fc000-0xfe9fffff]
pci 0000:04:00.0: reg 18 32bit mmio: [0xfe000000-0xfe7fffff]
pci 0000:04:00.0: reg 30 32bit mmio: [0xfe9e0000-0xfe9effff]
pci 0000:00:05.0: bridge 32bit mmio: [0xfd900000-0xfe9fffff]
pci 0000:00:05.0: bridge 32bit mmio pref: [0xbbe00000-0xbfdfffff]
pci 0000:05:05.0: reg 10 io port: [0xd800-0xd8ff]
pci 0000:05:05.0: reg 14 32bit mmio: [0xfeaffc00-0xfeaffcff]
pci 0000:05:05.0: supports D1 D2
pci 0000:05:05.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:05:05.0: PME# disabled
pci 0000:05:06.0: reg 10 io port: [0xd400-0xd4ff]
pci 0000:05:06.0: reg 14 32bit mmio: [0xfeaff800-0xfeaff8ff]
pci 0000:05:06.0: supports D1 D2
pci 0000:05:06.0: PME# supported from D1 D2 D3hot
pci 0000:05:06.0: PME# disabled
pci 0000:05:07.0: reg 10 32bit mmio: [0xbfeff000-0xbfefffff]
pci 0000:05:07.1: reg 10 32bit mmio: [0xbfefe000-0xbfefefff]
pci 0000:00:06.0: transparent bridge
pci 0000:00:06.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:06.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci 0000:00:06.0: bridge 32bit mmio pref: [0xbfe00000-0xbfefffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 87, sho=
uld be 57 [20080926]
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:0a: ioport range 0x480-0x48f has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x800-0x87f could not be reserved
system 00:0a: ioport range 0x400-0x40f has been reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0b: iomem range 0xfec10000-0xfec10fff has been reserved
system 00:0b: iomem range 0xffb80000-0xffffffff has been reserved
system 00:0d: ioport range 0x290-0x29f has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0xc0000-0xcffff could not be reserved
system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
system 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfd600000-0xfd6fffff
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: disabled
pci 0000:00:02.0:   MEM window: 0xfd700000-0xfd7fffff
pci 0000:00:02.0:   PREFETCH window: disabled
pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
pci 0000:00:03.0:   IO window: 0xc000-0xcfff
pci 0000:00:03.0:   MEM window: 0xfd800000-0xfd8fffff
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:00:05.0: PCI bridge, secondary bus 0000:04
pci 0000:00:05.0:   IO window: disabled
pci 0000:00:05.0:   MEM window: 0xfd900000-0xfe9fffff
pci 0000:00:05.0:   PREFETCH window: 0x000000bbe00000-0x000000bfdfffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:05
pci 0000:00:06.0:   IO window: 0xd000-0xdfff
pci 0000:00:06.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:06.0:   PREFETCH window: 0x000000bfe00000-0x000000bfefffff
pci 0000:00:01.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCI INT A -> GSI 34 (level, low) -> IRQ 34
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 39 (level, low) -> IRQ 39
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xfd600000-0xfd6fffff]
bus: 01 index 2 mmio: [0x0-0x0]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 mmio: [0x0-0x0]
bus: 02 index 1 mmio: [0xfd700000-0xfd7fffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xc000-0xcfff]
bus: 03 index 1 mmio: [0xfd800000-0xfd8fffff]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 04 index 0 mmio: [0x0-0x0]
bus: 04 index 1 mmio: [0xfd900000-0xfe9fffff]
bus: 04 index 2 mmio: [0xbbe00000-0xbfdfffff]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0xd000-0xdfff]
bus: 05 index 1 mmio: [0xfea00000-0xfeafffff]
bus: 05 index 2 mmio: [0xbfe00000-0xbfefffff]
bus: 05 index 3 io port: [0x00-0xffff]
bus: 05 index 4 mmio: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
msgmni has been set to 1733
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:01.0: Enabling HT MSI Mapping
pci 0000:00:02.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:04:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pcieport-driver 0000:00:01.0: irq 287 for MSI/MSI-X
pci_express 0000:00:01.0:pcie00: allocate port service
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pcieport-driver 0000:00:02.0: irq 286 for MSI/MSI-X
pci_express 0000:00:02.0:pcie00: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pcieport-driver 0000:00:03.0: irq 285 for MSI/MSI-X
pci_express 0000:00:03.0:pcie00: allocate port service
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/inp=
ut/input1
ACPI: Power Button (CM) [PWRB]
processor ACPI_CPU:00: registered as cooling_device0
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-amd64 0000:00:04.0: AGP bridge [10b9/1689]
agpgart-amd64 0000:00:04.0: setting up ULi AGP
agpgart-amd64 0000:00:04.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Fixed MDIO Bus: probed
PPP generic driver version 2.4.2
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:03:00.0: version 3.0
ahci 0000:03:00.0: PCI INT A -> GSI 35 (level, low) -> IRQ 35
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 impl SATA m=
ode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part=20
ahci 0000:03:00.0: setting latency timer to 64
scsi0 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfd8fe000 port 0xfd8fe100 irq 35
Switched to high resolution mode on CPU 0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI=
: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
registered taskstats version 1
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 248k freed
Write protecting the kernel text: 2048k
Write protecting the kernel read-only data: 1020k
kjournald starting.  Commit interval 5 seconds
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,=
EPP,ECP,DMA]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
ali1563_smbus 0000:00:07.0: Found ALi1563 SMBus at 0x0400
usbcore: registered new device driver usb
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
uli526x 0000:00:11.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
eth0: ULi M5263 at pci0000:00:11.0, 00:13:8f:98:2c:bd, irq 17.
8139too Fast Ethernet driver 0.9.28
8139too 0000:05:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
eth1: RealTek RTL8139 at 0xf8112c00, 00:40:95:30:0b:b0, IRQ 20
eth1:  Identified 8139 chip type 'RTL-8139C'
8139too 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
eth2: RealTek RTL8139 at 0xf801e800, 00:c0:df:04:7f:9b, IRQ 21
eth2:  Identified 8139 chip type 'RTL-8139B'
Uniform Multi-Platform E-IDE driver
isp1760 0000:00:07.1: enabling device (0000 -> 0001)
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 20, io mem 0xfebfd000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc7-00105-gfeaf384 ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.1: irq 21, io mem 0xfebfc000
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, n=
ot after
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-rc7-00105-gfeaf384 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.1
ali15x3_smbus 0000:00:07.1: ALI15X3_smb region uninitialized - upgrade BI=
OS or use force_addr=3D0xaddr
ali15x3_smbus 0000:00:07.1: ALI15X3 not detected, module not inserted.
alim15x3 0000:00:12.0: IDE controller (0x10b9:0x5229 rev 0xc7)
ALI15x3_IDE 0000:00:12.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
alim15x3 0000:00:12.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xff00-0xff07
    ide1: BM-DMA at 0xff08-0xff0f
Probing IDE interface ide0...
input: PC Speaker as /devices/platform/pcspkr/input/input2
Linux video capture interface: v2.00
Bt87x 0000:05:07.1: PCI INT A -> GSI 22 (level, low) -> IRQ 22
bt87x0: Using board 1, analog, digital (rate 32000 Hz)
hda: SAMSUNG SP1614N, ATA DISK drive
usb 1-1: new full speed USB device using ohci_hcd and address 2
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:05:07.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
bttv0: Bt878 (rev 2) at 0000:05:07.0, irq: 22, latency: 32, mmio: 0xbfeff=
000
bttv0: detected: Hauppauge WinTV [card=3D10], PCI subsystem ID is 0070:13=
eb
bttv0: using: Hauppauge (bt878) [card=3D10,autodetected]
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 1-0050: Hauppauge model 37284, rev B121, serial# 3520921
tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, type 5)
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram
tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 1-0050: audio processor is MSP3410D (idx 5)
tveeprom 1-0050: has radio
bttv0: Hauppauge eeprom indicates model#37284
bttv0: tuner type=3D5
bttv0: i2c: checking for MSP34xx @ 0x80... found
msp3400' 1-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
msp3400' 1-0040: msp3400 supports nicam, mode is autodetect
usb 1-1: configuration #1 chosen from 1 choice
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
usb 1-1: New USB device found, idVendor=3D076b, idProduct=3D1021
usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 1-1: Product: Smart Card Reader USB
usb 1-1: Manufacturer: OMNIKEY
gameport: NS558 PnP Gameport is pnp00:08/gameport0, io 0x200, speed 727kH=
z
tuner' 1-0042: chip found @ 0x84 (bt878 #0 [sw])
tda9887 1-0042: creating new instance
tda9887 1-0042: tda988[5/6/7] found
tuner' 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatible=
s))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
usb 1-2: new full speed USB device using ohci_hcd and address 3
bttv0: PLL: 28636363 =3D> 35468950 .. ok
udev: renamed network interface eth1 to eth0
udev: renamed network interface eth2 to eth1
usb 1-2: configuration #1 chosen from 1 choice
udev: renamed network interface eth0_rename to eth2
usb 1-2: New USB device found, idVendor=3D03f0, idProduct=3D7204
usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 1-2: Product: deskjet 3600
usb 1-2: Manufacturer: hp
usb 1-2: SerialNumber: HU3AE1N3N96B
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
usb 2-2: new full speed USB device using ohci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 2-2: New USB device found, idVendor=3D0451, idProduct=3D2046
usb 2-2: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
usb 2-2.1: new low speed USB device using ohci_hcd and address 3
hdc: _NEC DVD_RW ND-4571A, ATAPI CD/DVD-ROM drive
usb 2-2.1: configuration #1 chosen from 1 choice
usb 2-2.1: New USB device found, idVendor=3D046d, idProduct=3Dc30e
usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2.1: Product: HID compliant keyboard
usb 2-2.1: Manufacturer: Logitech
usb 2-2.2: new low speed USB device using ohci_hcd and address 4
usb 2-2.2: configuration #1 chosen from 1 choice
usb 2-2.2: New USB device found, idVendor=3D046d, idProduct=3Dc00c
usb 2-2.2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2.2: Product: USB Mouse
usb 2-2.2: Manufacturer: Logitech
usb 2-2.3: new low speed USB device using ohci_hcd and address 5
usb 2-2.3: configuration #1 chosen from 1 choice
usb 2-2.3: New USB device found, idVendor=3D06f2, idProduct=3D0011
usb 2-2.3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2.3: Product: USB KVM Switch
usb 2-2.3: Manufacturer: Justcom Technology
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ehci_hcd 0000:00:13.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:13.3: EHCI Host Controller
ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:13.3: debug port 1
ehci_hcd 0000:00:13.3: irq 23, io mem 0xfebfe800
usb 1-1: USB disconnect, address 2
ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 8 ports detected
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-rc7-00105-gfeaf384 ehci_hcd
usb usb3: SerialNumber: 0000:00:13.3
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 22, io mem 0xfebfb000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28-rc7-00105-gfeaf384 ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
ali1535_smbus 0000:00:07.1: ALI1535_smb region uninitialized - upgrade BI=
OS?
ali1535_smbus 0000:00:07.1: ALI1535 not detected, module not inserted.
Intel ICH 0000:00:08.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
usb 1-2: USB disconnect, address 3
usb 2-2: USB disconnect, address 2
usb 2-2.1: USB disconnect, address 3
usb 2-2.2: USB disconnect, address 4
usb 2-2.3: USB disconnect, address 5
usbcore: registered new interface driver usblp
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 1-1: new full speed USB device using ohci_hcd and address 4
AC'97 1 does not respond - RESET
AC'97 1 access is not valid [0xffffffff], removing mixer.
Unable to initialize codec #1
intel8x0_measure_ac97_clock: measured 54710 usecs
intel8x0: clocking to 48000
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=3D19457/255/63
hda: cache flushes supported
 hda: hda1
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=3D076b, idProduct=3D1021
usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 1-1: Product: Smart Card Reader USB
usb 1-1: Manufacturer: OMNIKEY
ide-cd driver 5.00
ide-cd: hdc: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
usb 1-2: new full speed USB device using ohci_hcd and address 5
usb 1-2: configuration #1 chosen from 1 choice
usblp0: USB Bidirectional printer dev 5 if 0 alt 0 proto 2 vid 0x03F0 pid=
 0x7204
usb 1-2: New USB device found, idVendor=3D03f0, idProduct=3D7204
usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 1-2: Product: deskjet 3600
usb 1-2: Manufacturer: hp
usb 1-2: SerialNumber: HU3AE1N3N96B
Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k
usb 2-2: new full speed USB device using ohci_hcd and address 6
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 2-2: New USB device found, idVendor=3D0451, idProduct=3D2046
usb 2-2: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
usb 2-2.1: new low speed USB device using ohci_hcd and address 7
usb 2-2.1: configuration #1 chosen from 1 choice
input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:13.=
1/usb2/2-2/2-2.1/2-2.1:1.0/input/input3
generic-usb 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [L=
ogitech HID compliant keyboard] on usb-0000:00:13.1-2.1/input0
input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:13.=
1/usb2/2-2/2-2.1/2-2.1:1.1/input/input4
generic-usb 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Log=
itech HID compliant keyboard] on usb-0000:00:13.1-2.1/input1
usb 2-2.1: New USB device found, idVendor=3D046d, idProduct=3Dc30e
usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2.1: Product: HID compliant keyboard
usb 2-2.1: Manufacturer: Logitech
usb 2-2.2: new low speed USB device using ohci_hcd and address 8
usb 2-2.2: configuration #1 chosen from 1 choice
input: Logitech USB Mouse as /devices/pci0000:00/0000:00:13.1/usb2/2-2/2-=
2.2/2-2.2:1.0/input/input5
generic-usb 0003:046D:C00C.0003: input,hidraw2: USB HID v1.10 Mouse [Logi=
tech USB Mouse] on usb-0000:00:13.1-2.2/input0
usb 2-2.2: New USB device found, idVendor=3D046d, idProduct=3Dc00c
usb 2-2.2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2.2: Product: USB Mouse
usb 2-2.2: Manufacturer: Logitech
usb 2-2.3: new low speed USB device using ohci_hcd and address 9
usb 2-2.3: configuration #1 chosen from 1 choice
input: Justcom Technology USB KVM Switch as /devices/pci0000:00/0000:00:1=
3.1/usb2/2-2/2-2.3/2-2.3:1.0/input/input6
generic-usb 0003:06F2:0011.0004: input,hidraw3: USB HID v1.10 Keyboard [J=
ustcom Technology USB KVM Switch] on usb-0000:00:13.1-2.3/input0
input: Justcom Technology USB KVM Switch as /devices/pci0000:00/0000:00:1=
3.1/usb2/2-2/2-2.3/2-2.3:1.1/input/input7
generic-usb 0003:06F2:0011.0005: input,hidraw4: USB HID v1.10 Mouse [Just=
com Technology USB KVM Switch] on usb-0000:00:13.1-2.3/input1
usb 2-2.3: New USB device found, idVendor=3D06f2, idProduct=3D0011
usb 2-2.3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2.3: Product: USB KVM Switch
usb 2-2.3: Manufacturer: Justcom Technology
EXT3 FS on sda1, internal journal
w83627hf: Found W83627HF chip at 0x290
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@red=
hat.com
fuse init (API version 7.10)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
tun6to4: Disabled Privacy Extensions
u32 classifier
    Actions configured=20
ADDRCONF(NETDEV_UP): eth2: link is not ready
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ processors (1 cpu =
cores) (version 2.20.00)
powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x6
powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0xa
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrack module opti=
on or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
uli526x: eth2 NIC Link is Down
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
Marking TSC unstable due to cpufreq changes
Clocksource tsc unstable (delta =3D -222227837 ns)
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized mga 3.2.1 20051102 on minor 0
agpgart-amd64 0000:00:04.0: AGP 3.0 bridge
agpgart-amd64 0000:00:04.0: bridge is in legacy mode, falling back to 2.x
agpgart-amd64 0000:00:04.0: putting AGP V2 device into 4x mode
pci 0000:04:00.0: putting AGP V2 device into 4x mode
[drm] Initialized card for AGP DMA.
eth0: link down
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
------------[ cut here ]------------
WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x29/0x9e()
Modules linked in: mga binfmt_misc rfcomm l2cap bluetooth ppdev lp xt_len=
gth xt_MARK iptable_mangle ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT x=
t_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_f=
ilter ip_tables x_tables powernow_k8 cpufreq_ondemand cpufreq_userspace c=
pufreq_powersave cls_fw cls_u32 sch_sfq sch_cbq sit tunnel4 fuse dm_crypt=
 dm_mod ipv6 w83627hf hwmon_vid ide_cd_mod cdrom ide_gd_mod usbhid usblp =
pata_ali tuner_simple tuner_types tda9887 tda8290 tuner ns558 tvaudio gam=
eport msp3400 rtc_cmos rtc_core rtc_lib snd_intel8x0 snd_ac97_codec ac97_=
bus bttv snd_bt87x videodev v4l1_compat pcspkr serio_raw ir_common k8temp=
 hwmon snd_pcm snd_seq snd_timer snd_seq_device i2c_ali1535 compat_ioctl3=
2 i2c_algo_bit ehci_hcd alim15x3 i2c_ali15x3 snd v4l2_common videobuf_dma=
_sg videobuf_core btcx_risc ohci_hcd ssb ide_pci_generic isp1760 soundcor=
e tveeprom ide_core snd_page_alloc 8139too mii uli526x i2c_ali1563 usbcor=
e i2c_core shpchp pci_hotplug parport_pc=20
 parport ali_agp
Pid: 5298, comm: kcminit_startup Not tainted 2.6.28-rc7-00105-gfeaf384 #2=
37
Call Trace:
 [<c02fc995>] ? printk+0xf/0x12
 [<c011cc8a>] warn_on_slowpath+0x41/0x62
 [<c0118e3e>] ? default_wake_function+0xb/0xd
 [<c0117f1d>] ? enqueue_entity+0x10b/0x113
 [<c011841a>] ? enqueue_task_fair+0x1c/0x5e
 [<c0107171>] nommu_map_sg+0x29/0x9e
 [<f811dfbd>] ide_build_sglist+0x48/0x50 [ide_core]
 [<f811e241>] ide_build_dmatable+0x30/0x154 [ide_core]
 [<f811e39b>] ide_dma_setup+0x36/0xc7 [ide_core]
 [<f804202f>] ali15x3_dma_setup+0x2f/0x35 [alim15x3]
 [<f8263f7a>] ide_cd_do_request+0x5fa/0x671 [ide_cd_mod]
 [<c01d784e>] ? delay_tsc+0x1d/0x5f
 [<f82644ac>] ? cdrom_do_newpc_cont+0x0/0x18 [ide_cd_mod]
 [<c01d77f8>] ? __const_udelay+0x18/0x1a
 [<f8117f15>] ? __ide_wait_stat+0x81/0xad [ide_core]
 [<f8118aa9>] ? ide_wait_stat+0x3f/0x6e [ide_core]
 [<f811703e>] ide_do_request+0x726/0x836 [ide_core]
 [<f8263978>] ? cdrom_end_request+0x171/0x179 [ide_cd_mod]
 [<f8264b5a>] ? cdrom_newpc_intr+0x5ef/0x5fd [ide_cd_mod]
 [<f8117ba0>] ? ide_input_data+0x0/0xda [ide_core]
 [<f8117307>] ide_intr+0x1b9/0x1f4 [ide_core]
 [<f826456b>] ? cdrom_newpc_intr+0x0/0x5fd [ide_cd_mod]
 [<c013c4f2>] handle_IRQ_event+0x21/0x48
 [<c013d450>] handle_edge_irq+0xc1/0x114
 [<c013d38f>] ? handle_edge_irq+0x0/0x114
 <IRQ>  [<c010388f>] ? common_interrupt+0x23/0x28
---[ end trace 18d5008b2820bb67 ]---
eth0: link down
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1

--=20
Meelis Roos (mroos@linux.ee)
---559023410-1804928587-1228463916=:13897--
