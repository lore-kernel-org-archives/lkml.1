Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbZL1XTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbZL1XTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZL1XTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:19:01 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:37169 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbZL1XS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:18:59 -0500
Message-ID: <4B393CDF.5040404@blueyonder.co.uk>
Date: Mon, 28 Dec 2009 23:18:55 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** NOT Fixed
 in 2.6.33-rc2 either **
References: <4B324B76.9020901@blueyonder.co.uk> <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk> <4B363EEE.8020108@blueyonder.co.uk> <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain> <4B37F16D.1040000@blueyonder.co.uk> <4B37F3F8.5000108@blueyonder.co.uk> <4B38C3AF.1060509@blueyonder.co.uk>
In-Reply-To: <4B38C3AF.1060509@blueyonder.co.uk>
Content-Type: multipart/mixed;
 boundary="------------010009030407040607060803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010009030407040607060803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This dmesg is from a freshly built 2.6.32. The following do not appear
in later 2.6.32-git or 2.6.33-rc kernels.
# grep LAPIC /DMESG_2.6.32_tindog
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1]
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--------------010009030407040607060803
Content-Type: text/plain;
 name="DMESG_2.6.32_tindog"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DMESG_2.6.32_tindog"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.32-smp (root@tindog) (gcc version 4.4.2 [gcc-4_4-branch revision 154496] (SUSE Linux) ) #1 SMP Mon Dec 28 15:48:48 GMT 2009
Command line: root=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part1 resume=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part3 splash=silent vga=0x31a 3
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
 BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
DMI 2.4 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x120000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFC0000000 write-back
  2 base 00C0000000 mask FFE0000000 write-back
  3 base 00DFF00000 mask FFFFF00000 uncachable
  4 base 0100000000 mask FFE0000000 write-back
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000120000000 aka 4608M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xdfee0 max_arch_pfn = 0x400000000
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009f000 (usable)
 modified: 000000000009f000 - 00000000000a0000 (reserved)
 modified: 00000000000f0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000dfee0000 (usable)
 modified: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 modified: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 modified: 00000000dfef0000 - 00000000dff00000 (reserved)
 modified: 00000000f0000000 - 00000000f4000000 (reserved)
 modified: 00000000fec00000 - 0000000100000000 (reserved)
 modified: 0000000100000000 - 0000000120000000 (usable)
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000dfee0000
 0000000000 - 00dfe00000 page 2M
 00dfe00000 - 00dfee0000 page 4k
kernel direct mapping tables up to dfee0000 @ 10000-16000
init_memory_mapping: 0000000100000000-0000000120000000
 0100000000 - 0120000000 page 2M
kernel direct mapping tables up to 120000000 @ 14000-1a000
RAMDISK: 36c13000 - 37fef3ff
ACPI: RSDP 00000000000f7da0 00024 (v02 Nvidia)
ACPI: XSDT 00000000dfee3100 00044 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: FACP 00000000dfeeb080 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: DSDT 00000000dfee3280 07DAC (v01 NVIDIA AWRDACPI 00001000 MSFT 03000000)
ACPI: FACS 00000000dfee0000 00040
ACPI: HPET 00000000dfeeb2c0 00038 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000098)
ACPI: MCFG 00000000dfeeb340 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: APIC 00000000dfeeb1c0 00098 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000120000000
Bootmem setup node 0 0000000000000000-0000000120000000
  NODE_DATA [0000000000015000 - 0000000000029fff]
  bootmap [000000000002a000 -  000000000004dfff] pages 24
(8 early reservations) ==> bootmem [0000000000 - 0120000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0001b861a4]    TEXT DATA BSS ==> [0001000000 - 0001b861a4]
  #3 [0036c13000 - 0037fef3ff]          RAMDISK ==> [0036c13000 - 0037fef3ff]
  #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #5 [0001b87000 - 0001b8715d]              BRK ==> [0001b87000 - 0001b8715d]
  #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
  #7 [0000014000 - 0000015000]          PGTABLE ==> [0000014000 - 0000015000]
 [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00120000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000dfee0
    0: 0x00100000 -> 0x00120000
On node 0 totalpages: 1048175
  DMA zone: 56 pages used for memmap
  DMA zone: 105 pages reserved
  DMA zone: 3822 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 898840 pages, LIFO batch:31
  Normal zone: 1792 pages used for memmap
  Normal zone: 129280 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10de8201 base: 0xfefff000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000dfee0000 - 00000000dfee3000
PM: Registered nosave memory: 00000000dfee3000 - 00000000dfef0000
PM: Registered nosave memory: 00000000dfef0000 - 00000000dff00000
PM: Registered nosave memory: 00000000dff00000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at dff00000 (gap: dff00000:10100000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 29 pages/cpu @ffff880028200000 s89560 r8192 d21032 u524288
pcpu-alloc: s89560 r8192 d21032 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031942
Policy zone: Normal
Kernel command line: root=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part1 resume=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part3 splash=silent vga=0x31a 3
PID hash table entries: 4096 (order: 3, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 0 size 32 MB
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 4034856k/4718592k available (3200k kernel code, 525892k absent, 157844k reserved, 3583k data, 1572k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 3013.546 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6027.09 BogoMIPS (lpj=3013546)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 00dff00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20090903
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 16288 entries in 64 pages
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6026.98 BogoMIPS (lpj=3013490)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
Brought up 2 CPUs
Total of 2 processors activated (12054.07 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
devtmpfs: initialized
NET: Registered protocol family 16
node 0 link 0: io port [b000, ffff]
TOM: 00000000e0000000 aka 3584M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f4000000, fe02ffff]
node 0 link 0: mmio [f0000000, f03fffff]
TOM2: 0000000120000000 aka 4608M
bus: [00,03] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [e0000000, f3ffffff]
bus: 00 index 3 mmio: [f4000000, ffffffff]
bus: 00 index 4 mmio: [120000000, fcffffffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:09.1: reg 20 io port: [0x1c00-0x1c3f]
pci 0000:00:09.1: reg 24 io port: [0x1c40-0x1c7f]
pci 0000:00:09.1: PME# supported from D3hot D3cold
pci 0000:00:09.1: PME# disabled
pci 0000:00:0a.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0a.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
pci 0000:00:0a.1: supports D1 D2
pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0c.0: reg 20 io port: [0xfd00-0xfd0f]
pci 0000:00:0d.0: reg 10 io port: [0x9f0-0x9f7]
pci 0000:00:0d.0: reg 14 io port: [0xbf0-0xbf3]
pci 0000:00:0d.0: reg 18 io port: [0x970-0x977]
pci 0000:00:0d.0: reg 1c io port: [0xb70-0xb73]
pci 0000:00:0d.0: reg 20 io port: [0xf800-0xf80f]
pci 0000:00:0d.0: reg 24 32bit mmio: [0xfe02d000-0xfe02dfff]
pci 0000:00:0d.1: reg 10 io port: [0x9e0-0x9e7]
pci 0000:00:0d.1: reg 14 io port: [0xbe0-0xbe3]
pci 0000:00:0d.1: reg 18 io port: [0x960-0x967]
pci 0000:00:0d.1: reg 1c io port: [0xb60-0xb63]
pci 0000:00:0d.1: reg 20 io port: [0xf300-0xf30f]
pci 0000:00:0d.1: reg 24 32bit mmio: [0xfe02c000-0xfe02cfff]
pci 0000:00:0d.2: reg 10 io port: [0xf200-0xf207]
pci 0000:00:0d.2: reg 14 io port: [0xf100-0xf103]
pci 0000:00:0d.2: reg 18 io port: [0xf000-0xf007]
pci 0000:00:0d.2: reg 1c io port: [0xef00-0xef03]
pci 0000:00:0d.2: reg 20 io port: [0xee00-0xee0f]
pci 0000:00:0d.2: reg 24 32bit mmio: [0xfe02b000-0xfe02bfff]
pci 0000:00:0e.1: reg 10 32bit mmio: [0xfe024000-0xfe027fff]
pci 0000:00:0e.1: PME# supported from D3hot D3cold
pci 0000:00:0e.1: PME# disabled
pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
pci 0000:01:00.0: reg 14 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:01:00.0: reg 24 io port: [0xdc00-0xdc7f]
pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfbfe0000-0xfbffffff]
pci 0000:00:04.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:04.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:04.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:02:07.0: reg 10 io port: [0xcc00-0xccff]
pci 0000:02:07.0: reg 14 32bit mmio: [0xfdfff000-0xfdfff0ff]
pci 0000:02:07.0: reg 30 32bit mmio pref: [0xfdfc0000-0xfdfdffff]
pci 0000:02:07.0: supports D1 D2
pci 0000:02:07.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:02:07.0: PME# disabled
pci 0000:02:0b.0: reg 10 32bit mmio: [0xfdffe000-0xfdffe7ff]
pci 0000:02:0b.0: reg 14 32bit mmio: [0xfdff8000-0xfdffbfff]
pci 0000:02:0b.0: supports D1 D2
pci 0000:02:0b.0: PME# supported from D0 D1 D2 D3hot
pci 0000:02:0b.0: PME# disabled
pci 0000:00:0e.0: transparent bridge
pci 0000:00:0e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xfdeff000-0xfdeff07f]
pci 0000:03:00.0: reg 18 64bit mmio: [0xfdef8000-0xfdefbfff]
pci 0000:03:00.0: reg 20 io port: [0xbc00-0xbc7f]
pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfde00000-0xfde7ffff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:16.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:16.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LSA2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1080-0x10ff has been reserved
system 00:01: ioport range 0x1400-0x147f has been reserved
system 00:01: ioport range 0x1480-0x14ff has been reserved
system 00:01: ioport range 0x1800-0x187f has been reserved
system 00:01: ioport range 0x1880-0x18ff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x87f has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:0d: iomem range 0xcd200-0xcffff has been reserved
system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
system 00:0d: iomem range 0xfefff000-0xfefff0ff has been reserved
system 00:0d: iomem range 0xdfee0000-0xdfefffff could not be reserved
system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0x100000-0xdfedffff could not be reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:0d: iomem range 0xfefff000-0xfeffffff could not be reserved
system 00:0d: iomem range 0xfff80000-0xfff80fff has been reserved
system 00:0d: iomem range 0xfff90000-0xfffbffff has been reserved
system 00:0d: iomem range 0xfffed000-0xfffeffff has been reserved
pci 0000:02:07.0: BAR 6: address space collision on of device [0xfdfc0000-0xfdfdffff]
pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
pci 0000:00:04.0:   IO window: 0xd000-0xdfff
pci 0000:00:04.0:   MEM window: 0xf8000000-0xfbffffff
pci 0000:00:04.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: 0xc000-0xcfff
pci 0000:00:0e.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:00:0e.0:   PREFETCH window: 0xf4000000-0xf40fffff
pci 0000:00:16.0: PCI bridge, secondary bus 0000:03
pci 0000:00:16.0:   IO window: 0xb000-0xbfff
pci 0000:00:16.0:   MEM window: 0xfde00000-0xfdefffff
pci 0000:00:16.0:   PREFETCH window: disabled
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:00:16.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
pci_bus 0000:01: resource 2 pref mem [0xe0000000-0xefffffff]
pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
pci_bus 0000:02: resource 2 pref mem [0xf4000000-0xf40fffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:03: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:03: resource 1 mem: [0xfde00000-0xfdefffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.1: Enabling HT MSI Mapping
pci 0000:00:0d.2: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.1: Enabling HT MSI Mapping
pci 0000:00:16.0: Enabling HT MSI Mapping
pci 0000:01:00.0: Boot video device
Unpacking initramfs...
Freeing initrd memory: 20336k freed
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1262039045.577:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7920
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: irq 24 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
pcieport 0000:00:16.0: irq 25 for MSI/MSI-X
pcieport 0000:00:16.0: setting latency timer to 64
vesafb: framebuffer at 0xf9000000, mapped to 0xffffc90005180000, using 5120k, total 14336k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
XENFS: not registering filesystem on non-xen platform
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
kgdb: Registered I/O driver kgdbts.
kgdbts:RUN plant and detach test
kgdbts:RUN sw breakpoint test
kgdbts:RUN bad memory access test
kgdbts:RUN singlestep test 1000 iterations
kgdbts:RUN singlestep [0/1000]
kgdbts:RUN singlestep [100/1000]
kgdbts:RUN singlestep [200/1000]
kgdbts:RUN singlestep [300/1000]
kgdbts:RUN singlestep [400/1000]
kgdbts:RUN singlestep [500/1000]
kgdbts:RUN singlestep [600/1000]
kgdbts:RUN singlestep [700/1000]
kgdbts:RUN singlestep [800/1000]
kgdbts:RUN singlestep [900/1000]
kgdbts:RUN hw breakpoint test
kgdbts:RUN hw write breakpoint test
kgdbts:RUN access write breakpoint test
kgdbts:RUN do_fork for 100 breakpoints
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
kmemleak: Kernel memory leak detector initialized
kmemleak: Automatic memory scanning thread started
Freeing unused kernel memory: 1572k freed
Write protecting the kernel read-only data: 4932k
Testing CPA: undo ffffffff81009000-ffffffff814da000
Testing CPA: again
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
ACPI Warning for \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference (20090903/nspredef-1012)
ACPI: Expecting a [Reference] package element, found type 0
ACPI: Invalid passive threshold
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:0c.0: UDMA133 controller
amd74xx 0000:00:0c.0: IDE controller (0x10de:0x036e rev 0xa1)
amd74xx 0000:00:0c.0: IDE port disabled
amd74xx 0000:00:0c.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfd00-0xfd07
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
SCSI subsystem initialized
libata version 3.00 loaded.
sata_nv 0000:00:0d.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
sata_nv 0000:00:0d.0: PCI INT A -> Link[APSI] -> GSI 23 (level, low) -> IRQ 23
sata_nv 0000:00:0d.0: Using SWNCQ mode
sata_nv 0000:00:0d.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xf800 irq 23
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xf808 irq 23
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
sata_nv 0000:00:0d.1: PCI INT B -> Link[APSJ] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:0d.1: Using SWNCQ mode
sata_nv 0000:00:0d.1: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xf300 irq 22
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xf308 irq 22
ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 21
sata_nv 0000:00:0d.2: PCI INT C -> Link[ASA2] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0d.2: Using SWNCQ mode
sata_nv 0000:00:0d.2: setting latency timer to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xf200 ctl 0xf100 bmdma 0xee00 irq 21
ata6: SATA max UDMA/133 cmd 0xf000 ctl 0xef00 bmdma 0xee08 irq 21
ata3: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD10EAVS-32D7B1, 01.01A01, max UDMA/133
ata1.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EAVS-32D 01.0 PQ: 0 ANSI: 5
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: MAXTOR STM3500630AS, 3.AAE, max UDMA/133
ata2.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      MAXTOR STM350063 3.AA PQ: 0 ANSI: 5
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
fan PNP0C0B:00: registered as cooling_device2
ACPI: Fan [FAN] (on)
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
JFS: nTxBlock = 8192, nTxLock = 65536
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
udev: starting version 149
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
 sdb: sda1 sda2 sda3
 sdb1 sdb2 sdb3
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 0:0:0:0: [sda] Attached SCSI disk
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
kgdb: Unregistered I/O driver kgdbts, debugger disabled.
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ehci_hcd 0000:00:0a.1: PCI INT B -> Link[APCL] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:0a.1: setting latency timer to 64
ehci_hcd 0000:00:0a.1: EHCI Host Controller
ehci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0a.1: debug port 1
ehci_hcd 0000:00:0a.1: cache line size of 64 is not supported
ehci_hcd 0000:00:0a.1: irq 20, io mem 0xfe02e000
ehci_hcd 0000:00:0a.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-smp ehci_hcd
usb usb1: SerialNumber: 0000:00:0a.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ohci_hcd 0000:00:0a.0: PCI INT A -> Link[APCF] -> GSI 23 (level, low) -> IRQ 23
ohci_hcd 0000:00:0a.0: setting latency timer to 64
ohci_hcd 0000:00:0a.0: OHCI Host Controller
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0a.0: irq 23, io mem 0xfe02f000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-smp ohci_hcd
usb usb2: SerialNumber: 0000:00:0a.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
PM: Starting manual resume from disk
usb 1-4: new high speed USB device using ehci_hcd and address 3
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
usb 1-4: New USB device found, idVendor=046d, idProduct=0990
usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=2
usb 1-4: SerialNumber: 7BBC20E7
usb 1-4: configuration #1 chosen from 1 choice
usb 1-9: new high speed USB device using ehci_hcd and address 4
usb 1-9: New USB device found, idVendor=0bda, idProduct=8187
usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9: Product: RTL8187_Wireless
usb 1-9: Manufacturer: Manufacturer_Realtek_RTL8187_
usb 1-9: SerialNumber: 0015AF230437
usb 1-9: configuration #1 chosen from 1 choice
usb 2-2: new low speed USB device using ohci_hcd and address 2
usb 2-2: New USB device found, idVendor=046d, idProduct=c404
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: Trackball
usb 2-2: Manufacturer: Logitech
usb 2-2: configuration #1 chosen from 1 choice
udev: starting version 149
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
EDAC MC: Ver: 2.1.0 Dec 28 2009
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
input: PC Speaker as /devices/platform/pcspkr/input/input3
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
EDAC amd64_edac:  Ver: 3.2.0 Dec 28 2009
EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:18.2 failed with error -22
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
r8169 0000:02:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
r8169 0000:02:07.0: no PCI Express capability
eth0: RTL8169sb/8110sb at 0xffffc90000672000, 00:1c:f0:bb:14:e1, XID 10000000 IRQ 17
ACPI: I/O resource nForce2_smbus [0x1c00-0x1c3f] conflicts with ACPI region SM00 [0x1c00-0x1c05]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
nForce2_smbus 0000:00:09.1: Error probing SMB1.
i2c i2c-0: nForce2 SMBus adapter at 0x1c40
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ohci1394 0000:02:0b.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
kvm: Nested Virtualization enabled
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[fdffe000-fdffe7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
usbcore: registered new interface driver hiddev
input: Logitech Trackball as /devices/pci0000:00/0000:00:0a.0/usb2/2-2/2-2:1.0/input/input4
generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:0a.0-2/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
udev: renamed network interface eth0 to eth_s1_0
Linux video capture interface: v2.00
IT8716 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
cfg80211: Calling CRDA to update world regulatory domain
ppdev: user-space parallel port driver
uvcvideo: Found UVC 1.00 device <unnamed> (046d:0990)
input: UVC Camera (046d:0990) as /devices/pci0000:00/0000:00:0a.1/usb1/1-4/1-4:1.0/input/input5
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:0e.1: setting latency timer to 64
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800015a4fb7]
usbcore: registered new interface driver snd-usb-audio
phy0: Selected rate control algorithm 'minstrel'
phy0: hwaddr 00:15:af:23:04:37, RTL8187vB (default) V1 + rtl8225z2
rtl8187: Customer ID is 0x00
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
rtl8187: wireless switch is on
usbcore: registered new interface driver rtl8187
i2c /dev entries driver
Adding 11004516k swap on /dev/sda3.  Priority:-1 extents:1 across:11004516k 
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
loop: module loaded
Btrfs loaded
device fsid 8b455ed49c789838-d4076299d5762cad devid 1 transid 960 /dev/sdb1
fuse init (API version 7.13)
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[Firmware Bug]: powernow-k8: Try again with latest BIOS.
r8169: eth_s1_0: link up
CPA self-test:
 4k 3072 large 2042 gb 0 x 2844[ffff880000000000-ffff8800dffff000] miss 131072
 4k 171520 large 1713 gb 0 x 48323[ffff880000000000-ffff8800dffff000] miss 131072
 4k 171520 large 1713 gb 0 x 48323[ffff880000000000-ffff8800dffff000] miss 131072
ok.
it87: Found IT8716F chip at 0x290, revision 0
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region HWRE [0x295-0x296]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
NET: Registered protocol family 17
wlan0: deauthenticating from 00:1b:9e:82:66:27 by local choice (reason=3)
wlan0: direct probe to AP 00:1b:9e:82:66:27 (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:1b:9e:82:66:27 (try 1)
wlan0: authenticated
wlan0: associate with AP 00:1b:9e:82:66:27 (try 1)
wlan0: RX AssocResp from 00:1b:9e:82:66:27 (capab=0x411 status=0 aid=4)
wlan0: associated
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
wlan0: no IPv6 routers present
eth_s1_0: no IPv6 routers present
kmemleak: 655 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
nvidia: module license 'NVIDIA' taints kernel.
Disabling lock debugging due to kernel taint
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
nvidia 0000:01:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  195.30  Fri Dec 18 16:14:43 PST 2009

--------------010009030407040607060803--

