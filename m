Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbZGXLXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbZGXLXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 07:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZGXLXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 07:23:47 -0400
Received: from main.gmane.org ([80.91.229.2]:51582 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZGXLXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 07:23:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: 2.6.31 - snd_intel8x0: fails to initialize NVidia CK804 sound chip
Date: Fri, 24 Jul 2009 11:23:31 +0000 (UTC)
Message-ID: <pan.2009.07.24.11.23.29@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-58-3.access.telenet.be
User-Agent: Pan/0.133 (House of Butterflies)
Cc: alsa-devel@alsa-project.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Linux 2.6.31-rc3-git4 with included Alsa and Linux 2.6.31-rc4 with an 
Alsa 1.0.20+ snapshot from 13 July, sound on my NVidia CK804 (NForce 4 
chipset) is not working). With 2.6.30 everything was working fine.

dmesg shows this error:
cannot find the slot for index 0 (range 0-1), error: -16
Intel ICH: probe of 0000:00:04.0 failed with error -16

lspci:
00:04.0 Multimedia audio controller [0401]: nVidia Corporation CK804 AC'97 Audio Controller [10de:0059] (rev a2)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:812a]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 12
	I/O ports at dc00 [size=256]
	I/O ports at e000 [size=256]
	Memory at d2003000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel modules: snd-intel8x0

Full dmesg:
Linux version 2.6.31-tmb-desktop-0.rc4.1mdv (mandrake@celeste.mandriva.com) (gcc version 4.4.0 (GCC) ) #1 SMP PREEMPT Thu Jul 23 08:39:00 EDT 2009
Command line: BOOT_IMAGE=2.6.31-tmb-desktoprc4-1 root=UUID=30bb01dd-1789-400b-955b-d9b15228ff9f resume=UUID=ace6dc48-3103-4a3a-8ee2-6f9eb76d716b splash=silent vga=788
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfff0000 (usable)
 BIOS-e820: 00000000bfff0000 - 00000000bfff3000 (ACPI NVS)
 BIOS-e820: 00000000bfff3000 - 00000000c0000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0xbfff0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFC0000000 write-back
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000bfff0000
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bfff0000 page 4k
kernel direct mapping tables up to bfff0000 @ 10000-15000
RAMDISK: 37b71000 - 37fefde6
ACPI: RSDP 00000000000f7c80 00014 (v00 Nvidia)
ACPI: RSDT 00000000bfff3040 00038 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 00000000bfff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 00000000bfff3180 06677 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 00000000bfff0000 00040
ACPI: SSDT 00000000bfff9900 000F7 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
ACPI: SRAT 00000000bfff9a40 00090 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: MCFG 00000000bfff9b40 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: APIC 00000000bfff9840 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 00bfff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 000158983c]    TEXT DATA BSS ==> [0001000000 - 000158983c]
  #3 [0037b71000 - 0037fefde6]          RAMDISK ==> [0037b71000 - 0037fefde6]
  #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #5 [000158a000 - 000158a145]              BRK ==> [000158a000 - 000158a145]
  #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
found SMP MP-table at [ffff8800000f58d0] f58d0
 [ffffea0000000000-ffffea00029fffff] PMD -> [ffff880001a00000-ffff8800043fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bfff0
On node 0 totalpages: 786303
  DMA zone: 56 pages used for memmap
  DMA zone: 102 pages reserved
  DMA zone: 3825 pages, LIFO batch:0
  DMA32 zone: 10696 pages used for memmap
  DMA32 zone: 771624 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 1 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages at ffff8800015a7000, static data 71136 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 775449
Kernel command line: BOOT_IMAGE=2.6.31-tmb-desktoprc4-1 root=UUID=30bb01dd-1789-400b-955b-d9b15228ff9f resume=UUID=ace6dc48-3103-4a3a-8ee2-6f9eb76d716b splash=silent vga=788
PID hash table entries: 4096 (order: 12, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 1c2000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 3084700k/3145664k available (3039k kernel code, 452k absent, 59820k reserved, 1609k data, 416k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
NR_IRQS:768
Fast TSC calibration using PIT
Detected 2211.234 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Calibrating delay loop (skipped), value calculated using timer frequency.. 4422.46 BogoMIPS (lpj=2211234)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
tseg: 0000000000
mce: CPU supports 5 MCE banks
SMP alternatives: switching to UP code
ACPI: Core revision 20090521
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) 64 Processor 3500+ stepping 0a
Brought up 1 CPUs
Total of 1 processors activated (4422.46 BogoMIPS).
regulator: core version 0.5
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [feb00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, fed3ffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [c0000000, fcffffffff]
bus: 00 index 2 mmio: [feb00000, fec0ffff]
bus: 00 index 3 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.1: reg 10 io port: [0xe400-0xe41f]
pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10 32bit mmio: [0xd2004000-0xd2004fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: reg 10 io port: [0xdc00-0xdcff]
pci 0000:00:04.0: reg 14 io port: [0xe000-0xe0ff]
pci 0000:00:04.0: reg 18 32bit mmio: [0xd2003000-0xd2003fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
pci 0000:00:07.0: reg 10 io port: [0x9f0-0x9f7]
pci 0000:00:07.0: reg 14 io port: [0xbf0-0xbf3]
pci 0000:00:07.0: reg 18 io port: [0x970-0x977]
pci 0000:00:07.0: reg 1c io port: [0xb70-0xb73]
pci 0000:00:07.0: reg 20 io port: [0xd800-0xd80f]
pci 0000:00:07.0: reg 24 32bit mmio: [0xd2002000-0xd2002fff]
pci 0000:00:08.0: reg 10 io port: [0x9e0-0x9e7]
pci 0000:00:08.0: reg 14 io port: [0xbe0-0xbe3]
pci 0000:00:08.0: reg 18 io port: [0x960-0x967]
pci 0000:00:08.0: reg 1c io port: [0xb60-0xb63]
pci 0000:00:08.0: reg 20 io port: [0xc400-0xc40f]
pci 0000:00:08.0: reg 24 32bit mmio: [0xd2001000-0xd2001fff]
pci 0000:00:0a.0: reg 10 32bit mmio: [0xd2000000-0xd2000fff]
pci 0000:00:0a.0: reg 14 io port: [0xb000-0xb007]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:05:0a.0: reg 10 io port: [0x9000-0x9007]
pci 0000:05:0a.0: reg 14 io port: [0x9400-0x9403]
pci 0000:05:0a.0: reg 18 io port: [0x9800-0x9807]
pci 0000:05:0a.0: reg 1c io port: [0x9c00-0x9c03]
pci 0000:05:0a.0: reg 20 io port: [0xa000-0xa00f]
pci 0000:05:0a.0: reg 24 32bit mmio: [0xd1008000-0xd10083ff]
pci 0000:05:0a.0: reg 30 32bit mmio: [0xd0000000-0xd007ffff]
pci 0000:05:0a.0: supports D1 D2
pci 0000:05:0b.0: reg 10 32bit mmio: [0xd1009000-0xd10097ff]
pci 0000:05:0b.0: reg 14 32bit mmio: [0xd1000000-0xd1003fff]
pci 0000:05:0b.0: supports D1 D2
pci 0000:05:0b.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:0b.0: PME# disabled
pci 0000:05:0c.0: reg 10 32bit mmio: [0xd1004000-0xd1007fff]
pci 0000:05:0c.0: reg 14 io port: [0xa400-0xa4ff]
pci 0000:05:0c.0: reg 30 32bit mmio: [0xd0000000-0xd001ffff]
pci 0000:05:0c.0: supports D1 D2
pci 0000:05:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:0c.0: PME# disabled
pci 0000:00:09.0: transparent bridge
pci 0000:00:09.0: bridge io port: [0x9000-0xafff]
pci 0000:00:09.0: bridge 32bit mmio: [0xd0000000-0xd1ffffff]
pci 0000:01:00.0: reg 10 32bit mmio: [0xc8000000-0xcbffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xc7ffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xcc000000-0xccffffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xcd000000-0xcd01ffff]
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0e.0: bridge 32bit mmio: [0xc8000000-0xcfffffff]
pci 0000:00:0e.0: bridge 64bit mmio pref: [0xc0000000-0xc7ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4000-0x407f has been reserved
system 00:01: ioport range 0x4080-0x40ff has been reserved
system 00:01: ioport range 0x4400-0x447f has been reserved
system 00:01: ioport range 0x4480-0x44ff has been reserved
system 00:01: ioport range 0x4800-0x487f has been reserved
system 00:01: ioport range 0x4880-0x48ff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x87f has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0e: iomem range 0xf0000-0xf3fff could not be reserved
system 00:0e: iomem range 0xf4000-0xf7fff could not be reserved
system 00:0e: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0e: iomem range 0xfc000-0xfffff could not be reserved
system 00:0e: iomem range 0xbfff0000-0xbfffffff could not be reserved
system 00:0e: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0x100000-0xbffeffff could not be reserved
system 00:0e: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0e: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:0e: iomem range 0xfefff000-0xfeffffff has been reserved
system 00:0e: iomem range 0xfff80000-0xfff80fff has been reserved
system 00:0e: iomem range 0xfff90000-0xfffbffff has been reserved
system 00:0e: iomem range 0xfffed000-0xfffeffff has been reserved
pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
pci 0000:00:09.0:   IO window: 0x9000-0xafff
pci 0000:00:09.0:   MEM window: 0xd0000000-0xd1ffffff
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: disabled
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: disabled
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0e.0:   IO window: disabled
pci 0000:00:0e.0:   MEM window: 0xc8000000-0xcfffffff
pci 0000:00:0e.0:   PREFETCH window: 0x000000c0000000-0x000000c7ffffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:05: resource 0 io:  [0x9000-0xafff]
pci_bus 0000:05: resource 1 mem: [0xd0000000-0xd1ffffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 1 mem: [0xc8000000-0xcfffffff]
pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xc7ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Switched to high resolution mode on CPU 0
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4603k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1248431174.234:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 6035
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Linking AER extended capability
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Linking AER extended capability
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Linking AER extended capability
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Linking AER extended capability
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:0b.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:0d.0: setting latency timer to 64
pcieport-driver 0000:00:0e.0: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:0e.0: setting latency timer to 64
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc90010100000, using 1875k, total 131072k
vesafb: mode is 800x600x16, linelength=1600, pages=2
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Platform driver 'serial8250' needs updating - please use dev_pm_ops
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Platform driver 'i8042' needs updating - please use dev_pm_ops
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
PM: Checking image partition UUID=ace6dc48-3103-4a3a-8ee2-6f9eb76d716b
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
PM: Resume from disk failed.
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 416k freed
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
SCSI subsystem initialized
libata version 3.00 loaded.
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
sata_nv 0000:00:07.0: PCI INT A -> Link[APSI] -> GSI 23 (level, low) -> IRQ 23
sata_nv 0000:00:07.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 23
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 23
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:08.0: setting latency timer to 64
ata1: SATA link down (SStatus 0 SControl 300)
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 22
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 22
ata3: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata2.00: 390721968 sectors, multi 1: LBA48 
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
ata4: SATA link down (SStatus 0 SControl 300)
 sda1 sda2 < sda5 sda6 sda7 sda8 sda9 > sda3
sd 1:0:0:0: [sda] Attached SCSI disk
pata_acpi 0000:00:06.0: setting latency timer to 64
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
sata_sil 0000:05:0a.0: version 2.4
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
sata_sil 0000:05:0a.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
sata_sil 0000:05:0a.0: Applying R_ERR on DMA activate FIS errata fix
scsi4 : sata_sil
scsi5 : sata_sil
scsi6 : sata_sil
scsi7 : sata_sil
ata5: SATA max UDMA/100 mmio m1024@0xd1008000 tf 0xd1008080 irq 19
ata6: SATA max UDMA/100 mmio m1024@0xd1008000 tf 0xd10080c0 irq 19
ata7: SATA max UDMA/100 mmio m1024@0xd1008000 tf 0xd1008280 irq 19
ata8: SATA max UDMA/100 mmio m1024@0xd1008000 tf 0xd10082c0 irq 19
ata5: SATA link down (SStatus 0 SControl 310)
ata6: SATA link down (SStatus 0 SControl 310)
ata7: SATA link down (SStatus 0 SControl 310)
ata8: SATA link down (SStatus 0 SControl 310)
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi8 : pata_amd
scsi9 : pata_amd
ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata9.00: ATAPI: LITE-ON DVD SOHD-167T, 9IS1, max UDMA/33
ata9: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc000c000) ACPI=0x701f (60:600:0x13)
ata9.00: configured for UDMA/33
scsi 8:0:0:0: CD-ROM            LITE-ON  DVD SOHD-167T    9IS1 PQ: 0 ANSI: 5
ata10.00: ATAPI: _NEC DVD_RW ND-3520AW, 3.06, max UDMA/33
ata10: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc000c000) ACPI=0x701f (60:600:0x13)
ata10.00: configured for UDMA/33
scsi 9:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520AW 3.06 PQ: 0 ANSI: 5
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
EXT4-fs (dm-2): barriers enabled
kjournald2 starting: pid 449, dev dm-2:8, commit interval 5 seconds
EXT4-fs (dm-2): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (dm-2): mounted filesystem with ordered data mode
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
udev: starting version 145
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: Power Button [PWRB]
processor LNXCPU:00: registered as cooling_device0
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 21 (level, low) -> IRQ 21
forcedeth 0000:00:0a.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
gameport: NS558 PnP Gameport is pnp00:0c/gameport0, io 0x201, speed 922kHz
fan PNP0C0B:00: registered as cooling_device1
ACPI: Fan [FAN] (on)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
sd 1:0:0:0: Attached scsi generic sg0 type 0
scsi 8:0:0:0: Attached scsi generic sg1 type 5
scsi 9:0:0:0: Attached scsi generic sg2 type 5
Platform driver 'floppy' needs updating - please use dev_pm_ops
Floppy drive(s): fd0 is 1.44M
EDAC MC: Ver: 2.1.0 Jul 23 2009
FDC 0 is a post-1991 82077
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
EDAC amd64_edac:  Ver: 3.2.0 Jul 23 2009
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
skge 0000:05:0c.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
skge 1.13 addr 0xd1004000 irq 17 chip Yukon-Lite rev 9
skge eth0: addr 00:11:d8:98:22:aa
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
sr 9:0:0:0: Attached scsi CD-ROM sr1
udev: renamed network interface eth0 to eth1
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ohci1394 0000:05:0b.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[d1009000-d10097ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ppdev: user-space parallel port driver
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:11:d8:95:74:ec
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 20, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31-tmb-desktop-0.rc4.1mdv ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 23 (level, low) -> IRQ 23
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 23, io mem 0xd2004000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.31-tmb-desktop-0.rc4.1mdv ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
EDAC amd64: This node reports that Memory ECC is currently disabled.
EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTROL device (0000:00:18.3) should be enabled
EDAC amd64: WARNING: ECC is NOT currently enabled by the BIOS. Module will NOT be loaded.
    Either Enable ECC in the BIOS, or use the 'ecc_enable_override' parameter.
    Might be a BIOS bug, if BIOS says ECC is enabled
    Use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:18.2 failed with error -22
Platform driver 'pcspkr' needs updating - please use dev_pm_ops
input: PC Speaker as /devices/platform/pcspkr/input/input4
Error: Driver 'pcspkr' is already registered, aborting...
cannot find the slot for index 0 (range 0-1), error: -16
Intel ICH: probe of 0000:00:04.0 failed with error -16
usb 2-2: new low speed USB device using ohci_hcd and address 2
usb 2-2: New USB device found, idVendor=046d, idProduct=c01d
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: USB-PS/2 Optical Mouse
usb 2-2: Manufacturer: Logitech
usb 2-2: configuration #1 chosen from 1 choice
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3500+ processors (1 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
Error: Driver 'pcspkr' is already registered, aborting...
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.0/input/input5
generic-usb 0003:046D:C01D.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-2/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 2-3: new full speed USB device using ohci_hcd and address 3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000132b85]
usb 2-3: New USB device found, idVendor=03f0, idProduct=3404
usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-3: Product: deskjet 6122
usb 2-3: Manufacturer: hp
usb 2-3: SerialNumber: MY2881B2HY64
usb 2-3: configuration #1 chosen from 1 choice
usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x03F0 pid 0x3404
usbcore: registered new interface driver usblp
EXT4-fs (dm-2): internal journal on dm-2:8
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
fuse init (API version 7.12)
EXT4-fs (dm-3): barriers enabled
kjournald2 starting: pid 953, dev dm-3:8, commit interval 5 seconds
EXT4-fs (dm-3): internal journal on dm-3:8
EXT4-fs (dm-3): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (dm-3): mounted filesystem with ordered data mode
loop: module loaded
Adding 4883720k swap on /dev/sda8.  Priority:-1 extents:1 across:4883720k

$ cat /proc/interrupts 
           CPU0       
  0:        127   IO-APIC-edge      timer
  1:       7417   IO-APIC-edge      i8042
  4:          1   IO-APIC-edge    
  6:         11   IO-APIC-edge      floppy
  7:          1   IO-APIC-edge      parport0
  8:          1   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 10:          0   IO-APIC-edge      MPU401 UART
 14:      56298   IO-APIC-edge      pata_amd
 15:      75410   IO-APIC-edge      pata_amd
 16:          3   IO-APIC-fasteoi   ohci1394
 17:          0   IO-APIC-fasteoi   eth1
 18:     640221   IO-APIC-fasteoi   nvidia
 19:          0   IO-APIC-fasteoi   sata_sil
 20:      35875   IO-APIC-fasteoi   ehci_hcd:usb1
 21:     215300   IO-APIC-fasteoi   eth0
 22:          0   IO-APIC-fasteoi   sata_nv
 23:     327934   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
NMI:          0   Non-maskable interrupts
LOC:   25790888   Local timer interrupts
SPU:          0   Spurious interrupts
CNT:          0   Performance counter interrupts
PND:          0   Performance pending work
RES:          0   Rescheduling interrupts
CAL:          0   Function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:         35   Machine check polls
ERR:          1
MIS:          0

$ lsmod | grep snd
snd_intel8x0           35368  0 
snd_ac97_codec        122808  1 snd_intel8x0
ac97_bus                1952  1 snd_ac97_codec
snd_mpu401              8072  0 
snd_mpu401_uart         7936  1 snd_mpu401
snd_seq_dummy           3172  0 
snd_pcsp               11404  0 
snd_rawmidi            23712  1 snd_mpu401_uart
snd_seq_oss            31456  0 
snd_seq_midi_event      7296  1 snd_seq_oss
snd_seq                56864  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          7188  4 snd_seq_dummy,snd_rawmidi,snd_seq_oss,snd_seq
snd_pcm_oss            42752  0 
snd_pcm                80968  4 snd_intel8x0,snd_ac97_codec,snd_pcsp,snd_pcm_oss
snd_timer              22736  2 snd_seq,snd_pcm
snd_mixer_oss          16736  1 snd_pcm_oss
snd                    65288  13 snd_intel8x0,snd_ac97_codec,snd_mpu401,snd_mpu401_uart,snd_pcsp,snd_rawmidi,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss
soundcore               7904  1 snd
snd_page_alloc          9552  2 snd_intel8x0,snd_pcm


