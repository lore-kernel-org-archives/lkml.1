Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642Ab0A3TBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0A3TBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628Ab0A3TBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:01:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0A3TBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:01:09 -0500
Date: Sat, 30 Jan 2010 20:01:02 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc6, swapper - not tainted
Message-ID: <20100130190102.GA6776@fancy-poultry.org>
References: <20100130183311.GA6464@fancy-poultry.org>
 <201001301940.11477.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001301940.11477.rjw@sisk.pl>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20091213 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1/XMKBif/ZNtUolmPWO5wJ49e1Obh5J1pW+TYH
 OWEX/HJ8Pq3M2Mpy/V82LXNJSAe14T9YGUcgOW7ll2rzWZ5nbe
 PKaY5Ac/6V5r3Ikcof/jQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.01.2010, Rafael J. Wysocki wrote: 

> It looks like you cut too much from the log.  Can you please attach
> the entire log?

Yes, of course:

Inspecting /boot/System.map-2.6.33-rc6
Cannot find map file.
No module symbols loaded - kernel modules not enabled.

Cannot build symbol table - disabling symbol lookups
klogd 1.4.1, log source = ksyslog started.
<5>Linux version 2.6.33-rc6 (root@liesel) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (pclinux) ) #1 SMP PREEMPT Sat Jan 30 11:24:10 CET 2010
<6>Command line: root=/dev/mapper/root luks_root=/dev/sda3 luks="root" resume=/dev/mapper/swap splash=silent vga=0x31a clocksource=hpet pci=use_crs
<6>BIOS-provided physical RAM map:
<6> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
<6> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
<6> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<6> BIOS-e820: 0000000000100000 - 00000000cfde0000 (usable)
<6> BIOS-e820: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
<6> BIOS-e820: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
<6> BIOS-e820: 00000000cfdf0000 - 00000000cfe00000 (reserved)
<6> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
<6> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
<6> BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
<6>NX (Execute Disable) protection: active
<6>DMI 2.4 present.
<6>No AGP bridge found
<6>last_pfn = 0x230000 max_arch_pfn = 0x400000000
<7>MTRR default type: uncachable
<7>MTRR fixed ranges enabled:
<7>  00000-9FFFF write-back
<7>  A0000-BFFFF uncachable
<7>  C0000-C7FFF write-protect
<7>  C8000-FFFFF uncachable
<7>MTRR variable ranges enabled:
<7>  0 base 000000000000 mask FFFF80000000 write-back
<7>  1 base 000080000000 mask FFFFC0000000 write-back
<7>  2 base 0000C0000000 mask FFFFF0000000 write-back
<7>  3 base 0000CFE00000 mask FFFFFFE00000 uncachable
<7>  4 base 000100000000 mask FFFF00000000 write-back
<7>  5 base 000200000000 mask FFFFE0000000 write-back
<7>  6 base 000220000000 mask FFFFF0000000 write-back
<7>  7 disabled
<7>TOM2: 0000000230000000 aka 8960M
<6>x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<7>e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
<6>last_pfn = 0xcfde0 max_arch_pfn = 0x400000000
<7>initial memory mapped : 0 - 20000000
<6>Using GB pages for direct mapping
<6>init_memory_mapping: 0000000000000000-00000000cfde0000
<7> 0000000000 - 00c0000000 page 1G
<7> 00c0000000 - 00cfc00000 page 2M
<7> 00cfc00000 - 00cfde0000 page 4k
<7>kernel direct mapping tables up to cfde0000 @ 8000-b000
<6>init_memory_mapping: 0000000100000000-0000000230000000
<7> 0100000000 - 0200000000 page 1G
<7> 0200000000 - 0230000000 page 2M
<7>kernel direct mapping tables up to 230000000 @ a000-c000
<6>RAMDISK: 37a10000 - 37fef537
<4>ACPI: RSDP 00000000000f6e30 00014 (v00 GBT   )
<4>ACPI: RSDT 00000000cfde3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
<4>ACPI: FACP 00000000cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
<4>ACPI: DSDT 00000000cfde30c0 05E2B (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
<4>ACPI: FACS 00000000cfde0000 00040
<4>ACPI: SSDT 00000000cfde8fc0 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
<4>ACPI: HPET 00000000cfde9880 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
<4>ACPI: MCFG 00000000cfde98c0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
<4>ACPI: TAMG 00000000cfde9900 00302 (v01 GBT    GBT   B0 5455312E BG?? 53450101)
<4>ACPI: APIC 00000000cfde8f00 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
<7>ACPI: Local APIC address 0xfee00000
<6>No NUMA configuration found
<6>Faking a node at 0000000000000000-0000000230000000
<6>Bootmem setup node 0 0000000000000000-0000000230000000
<6>  NODE_DATA [000000000000b000 - 000000000003efff]
<6>  bootmap [000000000003f000 -  0000000000084fff] pages 46
<6>(9 early reservations) ==> bootmem [0000000000 - 0230000000]
<6>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
<6>  #1 [0001000000 - 0005dca844]    TEXT DATA BSS ==> [0001000000 - 0005dca844]
<6>  #2 [0037a10000 - 0037fef537]          RAMDISK ==> [0037a10000 - 0037fef537]
<6>  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
<6>  #4 [0005dcb000 - 0005dcb0fe]              BRK ==> [0005dcb000 - 0005dcb0fe]
<6>  #5 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
<6>  #6 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
<6>  #7 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
<6>  #8 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
<7> [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
<4>Zone PFN ranges:
<4>  DMA      0x00000000 -> 0x00001000
<4>  DMA32    0x00001000 -> 0x00100000
<4>  Normal   0x00100000 -> 0x00230000
<4>Movable zone start PFN for each node
<4>early_node_map[3] active PFN ranges
<4>    0: 0x00000000 -> 0x0000009f
<4>    0: 0x00000100 -> 0x000cfde0
<4>    0: 0x00100000 -> 0x00230000
<7>On node 0 totalpages: 2096511
<7>  DMA zone: 56 pages used for memmap
<7>  DMA zone: 106 pages reserved
<7>  DMA zone: 3837 pages, LIFO batch:0
<7>  DMA32 zone: 14280 pages used for memmap
<7>  DMA32 zone: 833048 pages, LIFO batch:31
<7>  Normal zone: 17024 pages used for memmap
<7>  Normal zone: 1228160 pages, LIFO batch:31
<6>ACPI: PM-Timer IO Port: 0x4008
<7>ACPI: Local APIC address 0xfee00000
<6>ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
<6>ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
<6>ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
<6>ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
<7>ACPI: IRQ0 used by override.
<7>ACPI: IRQ2 used by override.
<7>ACPI: IRQ9 used by override.
<6>Using ACPI (MADT) for SMP configuration information
<6>ACPI: HPET id: 0x10b9a201 base: 0xfed00000
<6>SMP: Allowing 4 CPUs, 0 hotplug CPUs
<7>nr_irqs_gsi: 24
<6>PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
<6>PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
<6>PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
<6>PM: Registered nosave memory: 00000000cfde0000 - 00000000cfde3000
<6>PM: Registered nosave memory: 00000000cfde3000 - 00000000cfdf0000
<6>PM: Registered nosave memory: 00000000cfdf0000 - 00000000cfe00000
<6>PM: Registered nosave memory: 00000000cfe00000 - 00000000e0000000
<6>PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
<6>PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
<6>PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
<6>Allocating PCI resources starting at cfe00000 (gap: cfe00000:10200000)
<6>setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
<6>PERCPU: Embedded 27 pages/cpu @ffff880028200000 s79384 r8192 d23016 u524288
<6>pcpu-alloc: s79384 r8192 d23016 u524288 alloc=1*2097152
<6>pcpu-alloc: [0] 0 1 2 3 
<4>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065045
<4>Policy zone: Normal
<5>Kernel command line: root=/dev/mapper/root luks_root=/dev/sda3 luks="root" resume=/dev/mapper/swap splash=silent vga=0x31a clocksource=hpet pci=use_crs
<6>PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>Checking aperture...
<6>No AGP bridge found
<6>Node 0: aperture @ 20000000 size 32 MB
<6>Aperture pointing to e820 RAM. Ignoring.
<6>Your BIOS doesn't leave a aperture memory hole
<6>Please enable the IOMMU option in the BIOS setup
<6>This costs you 64 MB of RAM
<6>Mapping aperture over 65536 KB of RAM @ 20000000
<6>PM: Registered nosave memory: 0000000020000000 - 0000000024000000
<6>Memory: 8051188k/9175040k available (4244k kernel code, 788996k absent, 334856k reserved, 3055k data, 1344k init)
<6>Experimental preemptable hierarchical RCU implementation.
<6>NR_IRQS:4352
<4>Console: colour dummy device 80x25
<6>console [tty0] enabled
<7>hpet clockevent registered
<4>Fast TSC calibration using PIT
<4>Detected 2511.892 MHz processor.
<6>Calibrating delay loop (skipped), value calculated using timer frequency.. 5023.77 BogoMIPS (lpj=2511889)
<6>Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<6>Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
<4>Mount-cache hash table entries: 256
<7>tseg: 00cfe00000
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 0
<6>mce: CPU supports 6 MCE banks
<6>using C1E aware idle routine
<6>Performance Events: AMD PMU driver.
<6>... version:                0
<6>... bit width:              48
<6>... generic registers:      4
<6>... value mask:             0000ffffffffffff
<6>... max period:             00007fffffffffff
<6>... fixed-purpose events:   0
<6>... event mask:             000000000000000f
<6>ACPI: Core revision 20091214
<6>Setting APIC routing to flat
<6>..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>CPU0: AMD Phenom(tm) II X4 905e Processor stepping 02
<6>Booting Node   0, Processors  #1 #2 #3 Ok.
<6>Brought up 4 CPUs
<6>Total of 4 processors activated (20092.99 BogoMIPS).
<6>NET: Registered protocol family 16
<7>node 0 link 0: io port [c000, ffff]
<6>TOM: 00000000d0000000 aka 3328M
<7>Fam 10h mmconf [e0000000, e00fffff]
<7>node 0 link 0: mmio [a0000, bffff]
<7>node 0 link 0: mmio [d0000000, dfffffff]
<7>node 0 link 0: mmio [f0000000, fe02ffff]
<7>node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
<6>TOM2: 0000000230000000 aka 8960M
<7>bus: [00, 03] on node 0 link 0
<7>bus: 00 index 0 io port: [0, ffff]
<7>bus: 00 index 1 mmio: [a0000, bffff]
<7>bus: 00 index 2 mmio: [d0000000, dfffffff]
<7>bus: 00 index 3 mmio: [e0400000, ffffffff]
<7>bus: 00 index 4 mmio: [e0100000, e03fffff]
<7>bus: 00 index 5 mmio: [230000000, fcffffffff]
<6>ACPI: bus type pci registered
<6>PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>PCI: Using configuration type 1 for base access
<4>bio: create slab <bio-0> at 0
<7>ACPI: EC: Look up EC in DSDT
<6>ACPI: Interpreter enabled
<6>ACPI: (supports S0 S1 S4 S5)
<6>ACPI: Using IOAPIC for interrupt routing
<6>ACPI: No dock devices found.
<6>ACPI: PCI Root Bridge [PCI0] (0000:00)
<6>pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
<6>pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0xcff00000-0xfed0ffff]
<7>pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
<7>pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:02.0: PME# disabled
<7>pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:0a.0: PME# disabled
<7>pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
<7>pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
<7>pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
<7>pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
<7>pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
<7>pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
<7>pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
<7>pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
<7>pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
<7>pci 0000:00:12.2: supports D1 D2
<7>pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
<7>pci 0000:00:12.2: PME# disabled
<7>pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
<7>pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
<7>pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
<7>pci 0000:00:13.2: supports D1 D2
<7>pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
<7>pci 0000:00:13.2: PME# disabled
<7>pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
<7>pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
<7>pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
<7>pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
<7>pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
<7>pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
<7>pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:14.2: PME# disabled
<7>pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
<7>pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
<7>pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
<7>pci 0000:01:00.0: reg 1c: [mem 0xfb000000-0xfbffffff 64bit]
<7>pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
<7>pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
<6>pci 0000:00:02.0: PCI bridge to [bus 01-01]
<7>pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
<7>pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfcffffff]
<7>pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
<7>pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
<7>pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
<7>pci 0000:02:00.0: reg 20: [mem 0xfdfe0000-0xfdfeffff 64bit pref]
<7>pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
<7>pci 0000:02:00.0: supports D1 D2
<7>pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>pci 0000:02:00.0: PME# disabled
<6>pci 0000:00:0a.0: PCI bridge to [bus 02-02]
<7>pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
<7>pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
<7>pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
<7>pci 0000:03:0e.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
<7>pci 0000:03:0e.0: reg 14: [mem 0xfdef8000-0xfdefbfff]
<7>pci 0000:03:0e.0: supports D1 D2
<7>pci 0000:03:0e.0: PME# supported from D0 D1 D2 D3hot
<7>pci 0000:03:0e.0: PME# disabled
<6>pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
<7>pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
<7>pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
<7>pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff pref]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
<6>ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
<6>vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
<6>vgaarb: loaded
<6>PCI: Using ACPI for IRQ routing
<7>PCI: pci_cache_line_size set to 64 bytes
<3>pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
<6>pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]
<4>Expanded resource reserved due to conflict with PCI Bus 0000:00
<6>hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
<6>hpet0: 4 comparators, 32-bit 14.318180 MHz counter
<6>Switching to clocksource hpet
<6>pnp: PnP ACPI init
<6>ACPI: bus type pnp registered
<4>pnp 00:0d: disabling [mem 0x000d1c00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
<4>pnp 00:0d: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
<4>pnp 00:0d: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
<4>pnp 00:0d: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
<4>pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
<4>pnp 00:0d: disabling [mem 0x00100000-0xcfddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
<6>pnp: PnP ACPI: found 14 devices
<6>ACPI: ACPI bus type pnp unregistered
<6>system 00:01: [io  0x04d0-0x04d1] has been reserved
<6>system 00:01: [io  0x0220-0x0225] has been reserved
<6>system 00:01: [io  0x0290-0x0294] has been reserved
<6>system 00:02: [io  0x4100-0x411f] has been reserved
<6>system 00:02: [io  0x0228-0x022f] has been reserved
<6>system 00:02: [io  0x0238-0x023f] has been reserved
<6>system 00:02: [io  0x040b] has been reserved
<6>system 00:02: [io  0x04d6] has been reserved
<6>system 00:02: [io  0x0c00-0x0c01] has been reserved
<6>system 00:02: [io  0x0c14] has been reserved
<6>system 00:02: [io  0x0c50-0x0c52] has been reserved
<6>system 00:02: [io  0x0c6c-0x0c6d] has been reserved
<6>system 00:02: [io  0x0c6f] has been reserved
<6>system 00:02: [io  0x0cd0-0x0cd1] has been reserved
<6>system 00:02: [io  0x0cd2-0x0cd3] has been reserved
<6>system 00:02: [io  0x0cd4-0x0cdf] has been reserved
<6>system 00:02: [io  0x4000-0x40fe] has been reserved
<6>system 00:02: [io  0x4210-0x4217] has been reserved
<6>system 00:02: [io  0x0b00-0x0b0f] has been reserved
<6>system 00:02: [io  0x0b10-0x0b1f] has been reserved
<6>system 00:02: [io  0x0b20-0x0b3f] has been reserved
<6>system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
<6>system 00:0d: [mem 0xcfde0000-0xcfdfffff] could not be reserved
<6>system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
<6>system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
<6>system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
<6>system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
<6>pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
<6>pci 0000:00:02.0: PCI bridge to [bus 01-01]
<6>pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
<6>pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfcffffff]
<6>pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
<6>pci 0000:02:00.0: BAR 6: assigned [mem 0xfdf00000-0xfdf0ffff pref]
<6>pci 0000:00:0a.0: PCI bridge to [bus 02-02]
<6>pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
<6>pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
<6>pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
<6>pci 0000:00:14.4: PCI bridge to [bus 03-03]
<6>pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
<6>pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
<6>pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff pref]
<6>pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<7>pci 0000:00:02.0: setting latency timer to 64
<6>pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<7>pci 0000:00:0a.0: setting latency timer to 64
<7>pci_bus 0000:00: resource 0 [io  0x0000-0x0cf7]
<7>pci_bus 0000:00: resource 1 [io  0x0d00-0xffff]
<7>pci_bus 0000:00: resource 2 [mem 0x000a0000-0x000bffff]
<7>pci_bus 0000:00: resource 3 [mem 0x000c0000-0x000dffff]
<7>pci_bus 0000:00: resource 4 [mem 0xcff00000-0xfed0ffff]
<7>pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
<7>pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfcffffff]
<7>pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
<7>pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
<7>pci_bus 0000:02: resource 1 [mem 0xfdc00000-0xfdcfffff]
<7>pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
<7>pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
<7>pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
<7>pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff pref]
<7>pci_bus 0000:03: resource 3 [io  0x0000-0x0cf7]
<7>pci_bus 0000:03: resource 4 [io  0x0d00-0xffff]
<7>pci_bus 0000:03: resource 5 [mem 0x000a0000-0x000bffff]
<7>pci_bus 0000:03: resource 6 [mem 0x000c0000-0x000dffff]
<7>pci_bus 0000:03: resource 7 [mem 0xcff00000-0xfed0ffff]
<6>NET: Registered protocol family 2
<6>IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
<6>TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>TCP: Hash tables configured (established 524288 bind 65536)
<6>TCP reno registered
<6>UDP hash table entries: 4096 (order: 5, 131072 bytes)
<6>UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
<6>NET: Registered protocol family 1
<7>pci 0000:01:00.0: Boot video device
<7>PCI: CLS 4 bytes, default 64
<6>Trying to unpack rootfs image as initramfs...
<6>Freeing initrd memory: 6013k freed
<6>PCI-DMA: Disabling AGP.
<6>PCI-DMA: aperture base @ 20000000 size 65536 KB
<6>PCI-DMA: using GART IOMMU.
<6>PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
<6>audit: initializing netlink socket (disabled)
<5>type=2000 audit(1264878799.525:1): initialized
<6>HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
<6>Btrfs loaded
<6>msgmni has been set to 15865
<6>alg: No test for stdrng (krng)
<6>io scheduler noop registered
<6>io scheduler deadline registered
<6>io scheduler cfq registered (default)
<7>pcieport 0000:00:02.0: setting latency timer to 64
<7>pcieport 0000:00:02.0: irq 24 for MSI/MSI-X
<7>pcieport 0000:00:0a.0: setting latency timer to 64
<7>pcieport 0000:00:0a.0: irq 25 for MSI/MSI-X
<6>vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011800000, using 5120k, total 262144k
<6>vesafb: mode is 1280x1024x16, linelength=2560, pages=1
<6>vesafb: scrolling: redraw
<6>vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
<4>Console: switching to colour frame buffer device 160x64
<6>fb0: VESA VGA frame buffer device
<6>Non-volatile memory driver v1.3
<6>Linux agpgart interface v0.103
<6>Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>brd: module loaded
<4>Compaq SMART2 Driver (v 2.6.0)
<6>HP CISS Driver (v 3.6.20)
<6>MM: desc_per_page = 128
<6>PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>serio: i8042 AUX port at 0x60,0x64 irq 12
<6>mice: PS/2 mouse device common for all mice
<6>cpuidle: using governor ladder
<6>cpuidle: using governor menu
<4>Netfilter messages via NETLINK v0.30.
<3>kmem_cache_create: duplicate cache ccid2_h
<4>Pid: 1, comm: swapper Not tainted 2.6.33-rc6 #1
<4>Call Trace:
<4> [<ffffffff810cf8d0>] ? kmem_cache_create+0x4a0/0x550
<4> [<ffffffff814007fe>] ? ccid_kmem_cache_create+0x5e/0x70
<4> [<ffffffff8176cdf9>] ? ccid_initialize_builtins+0x59/0xb0
<4> [<ffffffff8176d1c6>] ? dccp_init+0x376/0x3d7
<4> [<ffffffff8176ce50>] ? dccp_init+0x0/0x3d7
<4> [<ffffffff810001d5>] ? do_one_initcall+0x35/0x190
<4> [<ffffffff8173764d>] ? kernel_init+0x174/0x1ce
<4> [<ffffffff81003b54>] ? kernel_thread_helper+0x4/0x10
<4> [<ffffffff817374d9>] ? kernel_init+0x0/0x1ce
<4> [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10
<6>input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
<6>input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input1
<4>registered taskstats version 1
<6>Freeing unused kernel memory: 1344k freed
<5>SCSI subsystem initialized
<7>libata version 3.00 loaded.
<6>Uniform Multi-Platform E-IDE driver
<6>BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
<6>fuse init (API version 7.13)
<6>loop: module loaded
<6>device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
<6>udevd version 128 started
<6>rtc_cmos 00:05: RTC can wake from S4
<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<7>ahci 0000:00:11.0: version 3.0
<6>ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
<6>ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
<6>ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
<6>scsi0 : ahci
<6>usbcore: registered new device driver usb
<6>ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
<6>rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
<6>scsi1 : ahci
<6>scsi2 : ahci
<6>scsi3 : ahci
<6>scsi4 : ahci
<6>scsi5 : ahci
<6>ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed irq 22
<6>ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
<6>ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
<6>ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
<6>ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
<6>ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
<6>pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<6>scsi6 : pata_atiixp
<6>scsi7 : pata_atiixp
<6>ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
<6>ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
<6>ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
<6>ehci_hcd 0000:00:12.2: EHCI Host Controller
<6>ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
<6>ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
<6>ehci_hcd 0000:00:12.2: debug port 1
<6>ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
<6>ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
<6>usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb1: Product: EHCI Host Controller
<6>usb usb1: Manufacturer: Linux 2.6.33-rc6 ehci_hcd
<6>usb usb1: SerialNumber: 0000:00:12.2
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 6 ports detected
<6>ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>ehci_hcd 0000:00:13.2: EHCI Host Controller
<6>ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
<6>ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
<6>ehci_hcd 0000:00:13.2: debug port 1
<6>ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
<6>ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
<6>usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb2: Product: EHCI Host Controller
<6>usb usb2: Manufacturer: Linux 2.6.33-rc6 ehci_hcd
<6>usb usb2: SerialNumber: 0000:00:13.2
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 6 ports detected
<6>ata5: SATA link down (SStatus 0 SControl 300)
<6>ata6: SATA link down (SStatus 0 SControl 300)
<6>ata4: SATA link down (SStatus 0 SControl 300)
<6>usb 1-1: new high speed USB device using ehci_hcd and address 2
<3>ata3: softreset failed (device not ready)
<3>ata2: softreset failed (device not ready)
<4>ata2: applying SB600 PMP SRST workaround and retrying
<4>ata3: applying SB600 PMP SRST workaround and retrying
<6>usb 1-1: New USB device found, idVendor=07d1, idProduct=3c03
<6>usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>usb 1-1: Product: 802.11 bg WLAN
<6>usb 1-1: Manufacturer: Ralink
<6>ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>ata2.00: ATAPI: TSSTcorp CDDVDW SH-S223F, SB00, max UDMA/100, ATAPI AN
<6>ata2.00: configured for UDMA/100
<6>ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>ata3.00: ATA-8: OCZ SOLID_SSD, 02.10104, max UDMA/100
<6>ata3.00: 62586880 sectors, multi 0: LBA 
<6>ata3.00: configured for UDMA/100
<3>ata1: softreset failed (device not ready)
<4>ata1: applying SB600 PMP SRST workaround and retrying
<6>ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>ata1.00: HPA detected: current 976771055, native 976773168
<6>ata1.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
<6>ata1.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
<6>ata1.00: configured for UDMA/133
<5>scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
<5>scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223F  SB00 PQ: 0 ANSI: 5
<5>scsi 2:0:0:0: Direct-Access     ATA      OCZ SOLID_SSD    02.1 PQ: 0 ANSI: 5
<6>ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<5>sd 2:0:0:0: [sdb] 62586880 512-byte logical blocks: (32.0 GB/29.8 GiB)
<5>sd 0:0:0:0: [sda] 976771055 512-byte logical blocks: (500 GB/465 GiB)
<5>sd 0:0:0:0: [sda] Write Protect is off
<7>sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6> sda: sda1 sda2 sda3 sda4
<6>ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<5>sd 2:0:0:0: [sdb] Write Protect is off
<7>sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
<5>sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
<6> sdb:
<5>sd 0:0:0:0: [sda] Attached SCSI disk
<4> sdb1
<6>ohci_hcd 0000:00:12.0: OHCI Host Controller
<5>sd 2:0:0:0: [sdb] Attached SCSI disk
<6>ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
<6>ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
<6>usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb3: Product: OHCI Host Controller
<6>usb usb3: Manufacturer: Linux 2.6.33-rc6 ohci_hcd
<6>usb usb3: SerialNumber: 0000:00:12.0
<6>hub 3-0:1.0: USB hub found
<6>hub 3-0:1.0: 3 ports detected
<6>ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<6>ohci_hcd 0000:00:12.1: OHCI Host Controller
<6>ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
<6>ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
<6>usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb4: Product: OHCI Host Controller
<6>usb usb4: Manufacturer: Linux 2.6.33-rc6 ohci_hcd
<6>usb usb4: SerialNumber: 0000:00:12.1
<6>hub 4-0:1.0: USB hub found
<6>hub 4-0:1.0: 3 ports detected
<6>ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<6>ohci_hcd 0000:00:13.0: OHCI Host Controller
<6>ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
<6>ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
<6>usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb5: Product: OHCI Host Controller
<6>usb usb5: Manufacturer: Linux 2.6.33-rc6 ohci_hcd
<6>usb usb5: SerialNumber: 0000:00:13.0
<6>hub 5-0:1.0: USB hub found
<6>hub 5-0:1.0: 3 ports detected
<6>ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<6>ohci_hcd 0000:00:13.1: OHCI Host Controller
<6>ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
<6>ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
<6>usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb6: Product: OHCI Host Controller
<6>usb usb6: Manufacturer: Linux 2.6.33-rc6 ohci_hcd
<6>usb usb6: SerialNumber: 0000:00:13.1
<6>hub 6-0:1.0: USB hub found
<6>hub 6-0:1.0: 3 ports detected
<6>ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<6>ohci_hcd 0000:00:14.5: OHCI Host Controller
<6>ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
<6>ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
<6>usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb7: Product: OHCI Host Controller
<6>usb usb7: Manufacturer: Linux 2.6.33-rc6 ohci_hcd
<6>usb usb7: SerialNumber: 0000:00:14.5
<6>hub 7-0:1.0: USB hub found
<6>hub 7-0:1.0: 2 ports detected
<6>usb 3-2: new full speed USB device using ohci_hcd and address 2
<6>usb 3-2: New USB device found, idVendor=04a9, idProduct=220d
<6>usb 3-2: New USB device strings: Mfr=64, Product=77, SerialNumber=0
<6>usb 3-2: Product: CanoScan
<6>usb 3-2: Manufacturer: Canon
<6>usb 4-2: new low speed USB device using ohci_hcd and address 2
<6>usb 4-2: New USB device found, idVendor=051d, idProduct=0002
<6>usb 4-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
<6>usb 4-2: Product: Back-UPS ES 700 FW:829.D2 .I USB FW:D2 
<6>usb 4-2: Manufacturer: APC
<6>usb 4-2: SerialNumber: 5B0825T20337  
<6>usbcore: registered new interface driver hiddev
<6>usb 4-3: new full speed USB device using ohci_hcd and address 3
<6>generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.10 Device [APC Back-UPS ES 700 FW:829.D2 .I USB FW:D2 ] on usb-0000:00:12.1-2/input0
<6>usbcore: registered new interface driver usbhid
<6>usbhid: USB HID core driver
<6>usb 4-3: New USB device found, idVendor=046d, idProduct=c52b
<6>usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>usb 4-3: Product: USB Receiver
<6>usb 4-3: Manufacturer: Logitech
<6>input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input2
<6>generic-usb 0003:046D:C52B.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
<6>input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input3
<6>generic-usb 0003:046D:C52B.0003: input,hiddev97,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input1
<6>generic-usb 0003:046D:C52B.0004: hiddev98,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-3/input2
<6>alg: No test for xts(twofish) (xts(twofish-asm))
<5>XFS mounting filesystem dm-0
<7>Ending clean XFS mount for filesystem: dm-0
<6>udevd version 128 started
<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>scsi 1:0:0:0: Attached scsi generic sg1 type 5
<5>sd 2:0:0:0: Attached scsi generic sg2 type 0
<6>input: PC Speaker as /devices/platform/pcspkr/input/input4
<4>sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
<6>Uniform CD-ROM driver Revision: 3.20
<7>sr 1:0:0:0: Attached scsi CD-ROM sr0
<6>input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input5
<6>ACPI: Power Button [PWRB]
<6>input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
<6>ACPI: Power Button [PWRF]
<6>parport_pc 00:09: reported by Plug and Play ACPI
<6>parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
<6>cfg80211: Using static regulatory domain info
<6>cfg80211: Regulatory domain: 00
<6>    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
<6>    (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
<6>    (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
<6>    (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
<6>    (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
<6>    (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
<6>cfg80211: Calling CRDA to update world regulatory domain
<6>cfg80211: Calling CRDA for country: EU
<6>firewire_ohci 0000:03:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
<3>ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
<6>ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<6>r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
<6>r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<7>r8169 0000:02:00.0: setting latency timer to 64
<7>r8169 0000:02:00.0: irq 26 for MSI/MSI-X
<6>eth0: RTL8168c/8111c at 0xffffc900117ae000, 00:1f:d0:be:4c:a5, XID 1c4000c0 IRQ 26
<3>k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
<6>udev: renamed network interface eth0 to eth1
<5>firewire_ohci: Added fw-ohci device 0000:03:0e.0, OHCI version 1.10
<6>ppdev: user-space parallel port driver
<3>Error: Driver 'pcspkr' is already registered, aborting...
<6>HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<6>hda_codec: ALC888: BIOS auto-probing.
<7>ALSA sound/pci/hda/hda_codec.c:4284: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
<7>ALSA sound/pci/hda/hda_codec.c:4288:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<7>ALSA sound/pci/hda/hda_codec.c:4292:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
<7>ALSA sound/pci/hda/hda_codec.c:4293:    mono: mono_out=0x0
<7>ALSA sound/pci/hda/hda_codec.c:4296:    dig-out=0x1e/0x0
<7>ALSA sound/pci/hda/hda_codec.c:4304:    inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x1c, aux=0x0
<7>ALSA sound/pci/hda/hda_codec.c:4306:    dig-in=0x1f
<7>ALSA sound/pci/hda/patch_realtek.c:1309: realtek: Enabling init ASM_ID=0xe601 CODEC_ID=10ec0888
<5>firewire_core: created device fw0: GUID 0069a46900001d7d, S400
<7>phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
<7>phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
<7>phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
<6>phy0 -> rt2x00_print_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
<7>phy0: Selected rate control algorithm 'minstrel'
<6>Registered led device: rt73usb-phy0::radio
<6>Registered led device: rt73usb-phy0::assoc
<6>Registered led device: rt73usb-phy0::quality
<6>usbcore: registered new interface driver rt73usb
<6>uhci_hcd: USB Universal Host Controller Interface driver
<5>XFS mounting filesystem dm-2
<7>Ending clean XFS mount for filesystem: dm-2
<5>XFS mounting filesystem dm-3
<7>Ending clean XFS mount for filesystem: dm-3
Kernel logging (ksyslog) stopped.
Kernel log daemon terminating.
