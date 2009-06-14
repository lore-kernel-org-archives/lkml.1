Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbZFNQNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbZFNQNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZFNQN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:13:28 -0400
Received: from www17.your-server.de ([213.133.104.17]:36286 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZFNQNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:13:21 -0400
Subject: 2.6.30: suspend-to-ram, second s2r wakes up immediately
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Jun 2009 18:13:21 +0200
Message-Id: <1244996001.8440.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

After a cold start of the computer, the first suspend-to-ram works as it
should and everything is fine.

But after waking up again, the second suspend-to-ram (in a row) seems to
work, but the computer wakes up immediately (i.e. it doesn't stay in
S3)!

Now the strange part: after re-plugging my 4-port usb hub, the computer
(in a third suspend-to-ram try) enters S3 without waking up immediately
again.

Strange, hmm?

Help appreciated.

mfg
thomas

Dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.30 (thomas@localhost.localdomain) (gcc version 4.4.0 20090506 (Red Hat 4.4.0-4) (GCC) ) #37 SMP PREEMPT Wed Jun 10 17:43:24 CEST 2009
[    0.000000] Command line: ro root=/dev/mapper/luks-1bda98a6-c825-4097-b472-3d8050c1a022 rhgb quiet fastboot usbcore.autosuspend=1 resume=/dev/mapper/luks-swap
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffd0000 - 00000000bffde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffde000 - 00000000c0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x1c0000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 0100000000 mask FF80000000 write-back
[    0.000000]   3 base 0180000000 mask FFC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 00000001c0000000 aka 7168M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbffd0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffd0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffd0000 page 4k
[    0.000000] kernel direct mapping tables up to bffd0000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000]  0100000000 - 01c0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1c0000000 @ b000-13000
[    0.000000] RAMDISK: 37ca6000 - 37fef433
[    0.000000] ACPI: RSDP 00000000000f98b0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bffd0000 0003C (v01 MSIISM OEMRSDT  04000807 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bffd0200 00084 (v02 MSIISM OEMFACP  04000807 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bffd0440 05045 (v01  1ADGH 1ADGH013 00000013 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bffde000 00040
[    0.000000] ACPI: APIC 00000000bffd0390 00070 (v01 MSIISM OEMAPIC  04000807 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bffd0400 0003C (v01 MSIISM OEMMCFG  04000807 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bffde040 00061 (v01 MSIISM AMI_OEM  04000807 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bffd5490 00038 (v01 MSIISM OEMHPET0 04000807 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bffd54d0 0028A (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 01c0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000fabbb0]    TEXT DATA BSS ==> [0000200000 - 0000fabbb0]
[    0.000000]   #3 [0037ca6000 - 0037fef433]          RAMDISK ==> [0037ca6000 - 0037fef433]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000fac000 - 0000fac16c]              BRK ==> [0000fac000 - 0000fac16c]
[    0.000000]   #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #7 [000000b000 - 000000e000]          PGTABLE ==> [000000b000 - 000000e000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffe20000000000-ffffe200061fffff] PMD -> [ffff880028200000-ffff88002e3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffd0
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] On node 0 totalpages: 1572719
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 3604 pages reserved
[    0.000000]   DMA zone: 339 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 768008 pages, LIFO batch:31
[    0.000000]   Normal zone: 10752 pages used for memmap
[    0.000000]   Normal zone: 775680 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bffd0000 - 00000000bffde000
[    0.000000] PM: Registered nosave memory: 00000000bffde000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff780000
[    0.000000] PM: Registered nosave memory: 00000000ff780000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028034000, static data 73184 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1544027
[    0.000000] Kernel command line: ro root=/dev/mapper/luks-1bda98a6-c825-4097-b472-3d8050c1a022 rhgb quiet fastboot usbcore.autosuspend=1 resume=/dev/mapper/luks-swap
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:1280
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2600.291 MHz processor.
[    0.000999] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ 8050000000 size 32 MB
[    0.000999] Aperture beyond 4GB. Ignoring.
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000999] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000999] Memory: 6093840k/7340032k available (8258k kernel code, 1049156k absent, 196128k reserved, 3888k data, 592k init)
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5200.58 BogoMIPS (lpj=2600291)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Mount-cache hash table entries: 256
[    0.000999] Initializing cgroup subsys ns
[    0.000999] Initializing cgroup subsys cpuacct
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] tseg: 0000000000
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] using C1E aware idle routine
[    0.000999] ACPI: Core revision 20090320
[    0.007053] Setting APIC routing to flat
[    0.007573] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.017846] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.017997] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5199.66 BogoMIPS (lpj=2599830)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.088419] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.088460] Brought up 2 CPUs
[    0.088463] Total of 2 processors activated (10400.24 BogoMIPS).
[    0.088564] net_namespace: 1888 bytes
[    0.089007] xor: automatically using best checksumming function: generic_sse
[    0.093987]    generic_sse:  7460.000 MB/sec
[    0.093989] xor: using function: generic_sse (7460.000 MB/sec)
[    0.094035] NET: Registered protocol family 16
[    0.094057] node 0 link 0: io port [1000, ffffff]
[    0.094057] node 0 link 0: io port [2000, 2fff]
[    0.094057] TOM: 00000000c0000000 aka 3072M
[    0.094057] node 0 link 0: mmio [e0000000, efffffff]
[    0.094057] node 0 link 0: mmio [a0000, bffff]
[    0.094057] node 0 link 0: mmio [c0000000, fe0bffff]
[    0.094057] TOM2: 00000001c0000000 aka 7168M
[    0.094057] bus: [00,ff] on node 0 link 0
[    0.094057] bus: 00 index 0 io port: [0, ffff]
[    0.094057] bus: 00 index 1 mmio: [c0000000, ffffffff]
[    0.094057] bus: 00 index 2 mmio: [a0000, bffff]
[    0.094057] bus: 00 index 3 mmio: [1c0000000, fcffffffff]
[    0.094057] ACPI: bus type pci registered
[    0.094078] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.094078] PCI: Not using MMCONFIG.
[    0.094078] PCI: Using configuration type 1 for base access
[    0.105019] bio: create slab <bio-0> at 0
[    0.106638] ACPI: EC: Look up EC in DSDT
[    0.118878] ACPI: Interpreter enabled
[    0.118881] ACPI: (supports S0 S1 S3 S4 S5)
[    0.118905] ACPI: Using IOAPIC for interrupt routing
[    0.118962] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.125708] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.134881] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.147146] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 5D, should be 4E [20090320]
[    0.147428] ACPI: No dock devices found.
[    0.147493] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.148112] pci 0000:00:01.0: reg 10 io port: [0x2f00-0x2f7f]
[    0.148147] pci 0000:00:01.1: reg 10 io port: [0x2900-0x293f]
[    0.148158] pci 0000:00:01.1: reg 20 io port: [0x2d00-0x2d3f]
[    0.148163] pci 0000:00:01.1: reg 24 io port: [0x2e00-0x2e3f]
[    0.148182] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.148188] pci 0000:00:01.1: PME# disabled
[    0.148211] pci 0000:00:02.0: reg 10 32bit mmio: [0xfe9fb000-0xfe9fbfff]
[    0.148229] pci 0000:00:02.0: supports D1 D2
[    0.148232] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148235] pci 0000:00:02.0: PME# disabled
[    0.148253] pci 0000:00:02.1: reg 10 32bit mmio: [0xfe9fac00-0xfe9facff]
[    0.148271] pci 0000:00:02.1: supports D1 D2
[    0.148273] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148276] pci 0000:00:02.1: PME# disabled
[    0.148301] pci 0000:00:04.0: reg 20 io port: [0xffa0-0xffaf]
[    0.148327] pci 0000:00:05.0: reg 10 io port: [0xc480-0xc487]
[    0.148331] pci 0000:00:05.0: reg 14 io port: [0xc400-0xc403]
[    0.148334] pci 0000:00:05.0: reg 18 io port: [0xc080-0xc087]
[    0.148338] pci 0000:00:05.0: reg 1c io port: [0xc000-0xc003]
[    0.148342] pci 0000:00:05.0: reg 20 io port: [0xbc00-0xbc0f]
[    0.148346] pci 0000:00:05.0: reg 24 32bit mmio: [0xfe9f9000-0xfe9f9fff]
[    0.148374] pci 0000:00:05.1: reg 10 io port: [0xb880-0xb887]
[    0.148378] pci 0000:00:05.1: reg 14 io port: [0xb800-0xb803]
[    0.148382] pci 0000:00:05.1: reg 18 io port: [0xb480-0xb487]
[    0.148385] pci 0000:00:05.1: reg 1c io port: [0xb400-0xb403]
[    0.148389] pci 0000:00:05.1: reg 20 io port: [0xb080-0xb08f]
[    0.148393] pci 0000:00:05.1: reg 24 32bit mmio: [0xfe9f8000-0xfe9f8fff]
[    0.148421] pci 0000:00:05.2: reg 10 io port: [0xb000-0xb007]
[    0.148425] pci 0000:00:05.2: reg 14 io port: [0xac00-0xac03]
[    0.148429] pci 0000:00:05.2: reg 18 io port: [0xa880-0xa887]
[    0.148433] pci 0000:00:05.2: reg 1c io port: [0xa800-0xa803]
[    0.148437] pci 0000:00:05.2: reg 20 io port: [0xa480-0xa48f]
[    0.148441] pci 0000:00:05.2: reg 24 32bit mmio: [0xfe9f7000-0xfe9f7fff]
[    0.148496] pci 0000:00:06.1: reg 10 32bit mmio: [0xfe9f0000-0xfe9f3fff]
[    0.148518] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.148521] pci 0000:00:06.1: PME# disabled
[    0.148552] pci 0000:00:08.0: reg 10 32bit mmio: [0xfe9f6000-0xfe9f6fff]
[    0.148556] pci 0000:00:08.0: reg 14 io port: [0xa400-0xa407]
[    0.148560] pci 0000:00:08.0: reg 18 32bit mmio: [0xfe9fa800-0xfe9fa8ff]
[    0.148564] pci 0000:00:08.0: reg 1c 32bit mmio: [0xfe9fa400-0xfe9fa40f]
[    0.148583] pci 0000:00:08.0: supports D1 D2
[    0.148585] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148589] pci 0000:00:08.0: PME# disabled
[    0.148616] pci 0000:00:09.0: reg 10 32bit mmio: [0xfe9f5000-0xfe9f5fff]
[    0.148620] pci 0000:00:09.0: reg 14 io port: [0xa080-0xa087]
[    0.148624] pci 0000:00:09.0: reg 18 32bit mmio: [0xfe9fa000-0xfe9fa0ff]
[    0.148628] pci 0000:00:09.0: reg 1c 32bit mmio: [0xfe9f4c00-0xfe9f4c0f]
[    0.148647] pci 0000:00:09.0: supports D1 D2
[    0.148649] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148654] pci 0000:00:09.0: PME# disabled
[    0.148683] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148686] pci 0000:00:0a.0: PME# disabled
[    0.148713] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148716] pci 0000:00:0b.0: PME# disabled
[    0.148743] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148745] pci 0000:00:0c.0: PME# disabled
[    0.148772] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148775] pci 0000:00:0d.0: PME# disabled
[    0.148801] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148804] pci 0000:00:0e.0: PME# disabled
[    0.148832] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148834] pci 0000:00:0f.0: PME# disabled
[    0.148915] pci 0000:01:00.0: reg 10 io port: [0xd800-0xd8ff]
[    0.148919] pci 0000:01:00.0: reg 14 32bit mmio: [0xfeaffc00-0xfeaffcff]
[    0.148924] pci 0000:01:00.0: reg 18 32bit mmio: [0xfeaff000-0xfeaff7ff]
[    0.148936] pci 0000:01:00.0: reg 30 32bit mmio: [0xfeae0000-0xfeae3fff]
[    0.148961] pci 0000:01:04.0: reg 10 32bit mmio: [0xfeafe800-0xfeafefff]
[    0.148967] pci 0000:01:04.0: reg 14 io port: [0xdc00-0xdc7f]
[    0.149004] pci 0000:01:04.0: supports D2
[    0.149007] pci 0000:01:04.0: PME# supported from D2 D3hot D3cold
[    0.149010] pci 0000:01:04.0: PME# disabled
[    0.149034] pci 0000:00:06.0: transparent bridge
[    0.149037] pci 0000:00:06.0: bridge io port: [0xd000-0xdfff]
[    0.149040] pci 0000:00:06.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.149207] pci 0000:07:00.0: reg 10 64bit mmio: [0xc0000000-0xcfffffff]
[    0.149214] pci 0000:07:00.0: reg 18 64bit mmio: [0xfebf0000-0xfebfffff]
[    0.149219] pci 0000:07:00.0: reg 20 io port: [0xe000-0xe0ff]
[    0.149227] pci 0000:07:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.149241] pci 0000:07:00.0: supports D1 D2
[    0.149268] pci 0000:07:00.1: reg 10 64bit mmio: [0xfebec000-0xfebeffff]
[    0.149293] pci 0000:07:00.1: supports D1 D2
[    0.151043] pci 0000:00:0f.0: bridge io port: [0xe000-0xefff]
[    0.151046] pci 0000:00:0f.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.151050] pci 0000:00:0f.0: bridge 64bit mmio pref: [0xc0000000-0xcfffffff]
[    0.151061] pci_bus 0000:00: on NUMA node 0
[    0.151068] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.151338] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.151479] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.151544] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.151606] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.151669] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.151731] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.151793] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[    0.164204] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.164430] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.164653] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.165167] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[    0.165389] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.165613] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.165835] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *5
[    0.166063] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[    0.166287] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *10
[    0.166509] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *10
[    0.166731] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *11
[    0.166953] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *5
[    0.167181] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *11
[    0.167403] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.167625] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.167847] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *5
[    0.168078] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *10
[    0.168341] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled.
[    0.168563] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.168980] SCSI subsystem initialized
[    0.168996] libata version 3.00 loaded.
[    0.169023] usbcore: registered new interface driver usbfs
[    0.169023] usbcore: registered new interface driver hub
[    0.169023] usbcore: registered new device driver usb
[    0.185993] raid6: int64x1   2222 MB/s
[    0.202994] raid6: int64x2   2464 MB/s
[    0.219984] raid6: int64x4   2042 MB/s
[    0.236978] raid6: int64x8   1476 MB/s
[    0.253976] raid6: sse2x1    3328 MB/s
[    0.270972] raid6: sse2x2    4867 MB/s
[    0.287958] raid6: sse2x4    4910 MB/s
[    0.287960] raid6: using algorithm sse2x4 (4910 MB/s)
[    0.287982] PCI: Using ACPI for IRQ routing
[    0.291989] Bluetooth: Core ver 2.15
[    0.292004] NET: Registered protocol family 31
[    0.292004] Bluetooth: HCI device and connection manager initialized
[    0.292004] Bluetooth: HCI socket layer initialized
[    0.305980] cfg80211: Calling CRDA to update world regulatory domain
[    0.305989] NetLabel: Initializing
[    0.305989] NetLabel:  domain hash size = 128
[    0.305989] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.305993] NetLabel:  unlabeled traffic allowed by default
[    0.306065] PCI-DMA: Disabling AGP.
[    0.306139] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.306139] PCI-DMA: using GART IOMMU.
[    0.306139] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.306975] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.306982] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.310964] Switched to high resolution mode on CPU 0
[    0.311438] Switched to high resolution mode on CPU 1
[    0.314018] pnp: PnP ACPI init
[    0.314034] ACPI: bus type pnp registered
[    0.321518] pnp: PnP ACPI: found 18 devices
[    0.321521] ACPI: ACPI bus type pnp unregistered
[    0.321534] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    0.321538] system 00:09: ioport range 0x800-0x80f has been reserved
[    0.321540] system 00:09: ioport range 0x2000-0x207f has been reserved
[    0.321543] system 00:09: ioport range 0x2080-0x20ff has been reserved
[    0.321546] system 00:09: ioport range 0x2400-0x247f has been reserved
[    0.321549] system 00:09: ioport range 0x2480-0x24ff has been reserved
[    0.321552] system 00:09: ioport range 0x2800-0x287f has been reserved
[    0.321555] system 00:09: ioport range 0x2880-0x28ff has been reserved
[    0.321558] system 00:09: ioport range 0x2c00-0x2c7f has been reserved
[    0.321561] system 00:09: ioport range 0x2c80-0x2cff has been reserved
[    0.321565] system 00:09: iomem range 0xfe980000-0xfe9bffff has been reserved
[    0.321568] system 00:09: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.321573] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.321576] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.321582] system 00:0e: ioport range 0xa00-0xa0f has been reserved
[    0.321585] system 00:0e: ioport range 0xa10-0xa1f has been reserved
[    0.321590] system 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
[    0.321595] system 00:10: iomem range 0xd0000000-0xdfffffff has been reserved
[    0.321600] system 00:11: iomem range 0x0-0x9ffff could not be reserved
[    0.321603] system 00:11: iomem range 0xc0000-0xcffff has been reserved
[    0.321606] system 00:11: iomem range 0xe0000-0xfffff could not be reserved
[    0.321609] system 00:11: iomem range 0x100000-0xbfffffff could not be reserved
[    0.321612] system 00:11: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.326751] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    0.326754] pci 0000:00:06.0:   IO window: 0xd000-0xdfff
[    0.326758] pci 0000:00:06.0:   MEM window: 0xfea00000-0xfeafffff
[    0.326761] pci 0000:00:06.0:   PREFETCH window: 0x000000f0000000-0x000000f00fffff
[    0.326764] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    0.326766] pci 0000:00:0a.0:   IO window: disabled
[    0.326769] pci 0000:00:0a.0:   MEM window: disabled
[    0.326771] pci 0000:00:0a.0:   PREFETCH window: disabled
[    0.326774] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
[    0.326776] pci 0000:00:0b.0:   IO window: disabled
[    0.326779] pci 0000:00:0b.0:   MEM window: disabled
[    0.326781] pci 0000:00:0b.0:   PREFETCH window: disabled
[    0.326785] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
[    0.326787] pci 0000:00:0c.0:   IO window: disabled
[    0.326789] pci 0000:00:0c.0:   MEM window: disabled
[    0.326791] pci 0000:00:0c.0:   PREFETCH window: disabled
[    0.326795] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
[    0.326797] pci 0000:00:0d.0:   IO window: disabled
[    0.326799] pci 0000:00:0d.0:   MEM window: disabled
[    0.326802] pci 0000:00:0d.0:   PREFETCH window: disabled
[    0.326805] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:06
[    0.326807] pci 0000:00:0e.0:   IO window: disabled
[    0.326809] pci 0000:00:0e.0:   MEM window: disabled
[    0.326812] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.326815] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:07
[    0.326818] pci 0000:00:0f.0:   IO window: 0xe000-0xefff
[    0.326821] pci 0000:00:0f.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.326824] pci 0000:00:0f.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
[    0.326831] pci 0000:00:06.0: setting latency timer to 64
[    0.326836] pci 0000:00:0a.0: setting latency timer to 64
[    0.326840] pci 0000:00:0b.0: setting latency timer to 64
[    0.326844] pci 0000:00:0c.0: setting latency timer to 64
[    0.326848] pci 0000:00:0d.0: setting latency timer to 64
[    0.326852] pci 0000:00:0e.0: setting latency timer to 64
[    0.326856] pci 0000:00:0f.0: setting latency timer to 64
[    0.326860] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.326862] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.326865] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.326868] pci_bus 0000:01: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.326870] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf00fffff]
[    0.326873] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.326875] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.326879] pci_bus 0000:07: resource 0 io:  [0xe000-0xefff]
[    0.326881] pci_bus 0000:07: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.326884] pci_bus 0000:07: resource 2 pref mem [0xc0000000-0xcfffffff]
[    0.326902] NET: Registered protocol family 2
[    0.338045] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.339878] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.342382] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.342988] TCP: Hash tables configured (established 262144 bind 65536)
[    0.342991] TCP reno registered
[    0.346086] NET: Registered protocol family 1
[    0.346153] Trying to unpack rootfs image as initramfs...
[    0.413026] Freeing initrd memory: 3365k freed
[    0.416513] Intel AES-NI instructions are not detected.
[    0.416817] audit: initializing netlink socket (disabled)
[    0.416834] type=2000 audit(1244975226.416:1): initialized
[    0.421940] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.425200] VFS: Disk quotas dquot_6.5.2
[    0.425282] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.426784] NTFS driver 2.1.29 [Flags: R/O].
[    0.426929] fuse init (API version 7.11)
[    0.427308] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.430670] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    0.431427] SGI XFS Quota Management subsystem
[    0.431437] msgmni has been set to 11910
[    0.431571] SELinux:  Registering netfilter hooks
[    0.431738] alg: No test for cipher_null (cipher_null-generic)
[    0.431764] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.431788] alg: No test for digest_null (digest_null-generic)
[    0.431812] alg: No test for compress_null (compress_null-generic)
[    0.432667] alg: No test for fcrypt (fcrypt-generic)
[    0.435017] alg: No test for stdrng (krng)
[    0.435027] async_tx: api initialized (sync-only)
[    0.435232] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.435235] io scheduler noop registered
[    0.435237] io scheduler anticipatory registered
[    0.435239] io scheduler deadline registered (default)
[    0.435254] io scheduler cfq registered
[    0.457071] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457108] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457145] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457182] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457221] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457271] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457322] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457375] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457432] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457492] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457555] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457622] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457694] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457706] pci 0000:07:00.0: Boot video device
[    0.457878] pcieport-driver 0000:00:0a.0: irq 24 for MSI/MSI-X
[    0.457886] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.458078] pcieport-driver 0000:00:0b.0: irq 25 for MSI/MSI-X
[    0.458084] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.458229] pcieport-driver 0000:00:0c.0: irq 26 for MSI/MSI-X
[    0.458234] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    0.458391] pcieport-driver 0000:00:0d.0: irq 27 for MSI/MSI-X
[    0.458397] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    0.458549] pcieport-driver 0000:00:0e.0: irq 28 for MSI/MSI-X
[    0.458555] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    0.458710] pcieport-driver 0000:00:0f.0: irq 29 for MSI/MSI-X
[    0.458717] pcieport-driver 0000:00:0f.0: setting latency timer to 64
[    0.458949] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.459111] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.459113] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.468035] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    0.468775] input: Power Button as /class/input/input0
[    0.468778] ACPI: Power Button [PWRF]
[    0.468884] input: Power Button as /class/input/input1
[    0.468886] ACPI: Power Button [PWRB]
[    0.469334] processor ACPI_CPU:00: registered as cooling_device0
[    0.469405] processor ACPI_CPU:01: registered as cooling_device1
[    0.478810] lp: driver loaded but no devices found
[    0.479284] Non-volatile memory driver v1.3
[    0.480204] ppdev: user-space parallel port driver
[    0.480208] Linux agpgart interface v0.103
[    0.480366] ipmi message handler version 39.2
[    0.480380] ipmi device interface
[    0.480482] IPMI System Interface driver.
[    0.492110] ipmi_si: Unable to find any System Interface(s)
[    0.492114] IPMI Watchdog: driver initialized
[    0.492116] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    0.492123] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.492125] Hangcheck: Using get_cycles().
[    0.492185] [drm] Initialized drm 1.1.0 20060810
[    0.493222] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    0.493234] pci 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 19 (level, low) -> IRQ 19
[    0.493239] pci 0000:07:00.0: setting latency timer to 64
[    0.493403] [drm] Initialized radeon 1.30.0 20080528 for 0000:07:00.0 on minor 0
[    0.493443] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.737204] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.981196] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.981635] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.981987] parport_pc 00:08: reported by Plug and Play ACPI
[    0.982044] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    1.063151] lp0: using parport0 (interrupt-driven).
[    1.063154] lp0: console ready
[    1.063673] Floppy drive(s): fd0 is 1.44M
[    1.077596] FDC 0 is a post-1991 82077
[    1.080620] brd: module loaded
[    1.081594] loop: module loaded
[    1.081850] nbd: registered device at major 43
[    1.084473] Loading iSCSI transport class v2.0-870.
[    1.085217] rdac: device handler registered
[    1.085219] hp_sw: device handler registered
[    1.085221] emc: device handler registered
[    1.085224] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    1.085275] Driver 'st' needs updating - please use bus_type methods
[    1.085327] osst :I: Tape driver with OnStream support version 0.99.4
[    1.085329] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.085374] Driver 'osst' needs updating - please use bus_type methods
[    1.085463] Driver 'sd' needs updating - please use bus_type methods
[    1.085506] Driver 'sr' needs updating - please use bus_type methods
[    1.085613] SCSI Media Changer driver v0.25 
[    1.085658] Driver 'ch' needs updating - please use bus_type methods
[    1.085787] sata_nv 0000:00:05.0: version 3.5
[    1.086202] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    1.086213] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
[    1.086216] sata_nv 0000:00:05.0: Using SWNCQ mode
[    1.086445] sata_nv 0000:00:05.0: setting latency timer to 64
[    1.086606] scsi0 : sata_nv
[    1.086751] scsi1 : sata_nv
[    1.086933] ata1: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xbc00 irq 23
[    1.086936] ata2: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xbc08 irq 23
[    1.087270] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    1.087279] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
[    1.087282] sata_nv 0000:00:05.1: Using SWNCQ mode
[    1.087495] sata_nv 0000:00:05.1: setting latency timer to 64
[    1.087628] scsi2 : sata_nv
[    1.087728] scsi3 : sata_nv
[    1.087899] ata3: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb080 irq 22
[    1.087902] ata4: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xb088 irq 22
[    1.088277] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    1.088286] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
[    1.088288] sata_nv 0000:00:05.2: Using SWNCQ mode
[    1.088502] sata_nv 0000:00:05.2: setting latency timer to 64
[    1.088624] scsi4 : sata_nv
[    1.088729] scsi5 : sata_nv
[    1.088942] ata5: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 21
[    1.088945] ata6: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 21
[    1.089085] pata_amd 0000:00:04.0: version 0.4.1
[    1.089133] pata_amd 0000:00:04.0: setting latency timer to 64
[    1.089213] scsi6 : pata_amd
[    1.089318] scsi7 : pata_amd
[    1.090551] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.090554] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.090801] Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)
[    1.090805] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[    1.090978] PPP generic driver version 2.4.2
[    1.091099] PPP Deflate Compression module registered
[    1.092704] PPP MPPE Compression module registered
[    1.092708] NET: Registered protocol family 24
[    1.093041] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    1.093130] tun: Universal TUN/TAP device driver, 1.6
[    1.093132] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.093196] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    1.093293] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    1.093365] usbcore: registered new interface driver cdc_ether
[    1.093419] usbcore: registered new interface driver cdc_eem
[    1.093469] usbcore: registered new interface driver rndis_host
[    1.093504] console [netcon0] enabled
[    1.093506] netconsole: network logging started
[    1.093964] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 18
[    1.093976] firewire_ohci 0000:01:04.0: PCI INT A -> Link[LNKD] -> GSI 18 (level, low) -> IRQ 18
[    1.151014] firewire_ohci: Added fw-ohci device 0000:01:04.0, OHCI version 1.10
[    1.151548] SSFDC read-only Flash Translation layer
[    1.151635] slram: not enough parameters.
[    1.151639] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.151975] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    1.151979] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[    1.151996] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    1.151999] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    1.152082] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    1.152108] ehci_hcd 0000:00:02.1: debug port 1
[    1.152112] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    1.152119] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe9fac00
[    1.157263] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    1.157405] usb usb1: configuration #1 chosen from 1 choice
[    1.157476] hub 1-0:1.0: USB hub found
[    1.157484] hub 1-0:1.0: 10 ports detected
[    1.157758] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.158092] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    1.158096] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[    1.158112] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    1.158115] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    1.158181] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    1.158197] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe9fb000
[    1.210125] usb usb2: configuration #1 chosen from 1 choice
[    1.210193] hub 2-0:1.0: USB hub found
[    1.210201] hub 2-0:1.0: 10 ports detected
[    1.210408] uhci_hcd: USB Universal Host Controller Interface driver
[    1.210549] usbcore: registered new interface driver cdc_acm
[    1.210551] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    1.210604] usbcore: registered new interface driver usblp
[    1.210654] usbcore: registered new interface driver cdc_wdm
[    1.210657] Initializing USB Mass Storage driver...
[    1.210715] usbcore: registered new interface driver usb-storage
[    1.210718] USB Mass Storage support registered.
[    1.210765] usbcore: registered new interface driver ums-alauda
[    1.210815] usbcore: registered new interface driver ums-cypress
[    1.210864] usbcore: registered new interface driver ums-datafab
[    1.210913] usbcore: registered new interface driver ums-freecom
[    1.210965] usbcore: registered new interface driver ums-isd200
[    1.211022] usbcore: registered new interface driver ums-jumpshot
[    1.211069] usbcore: registered new interface driver ums-karma
[    1.211116] usbcore: registered new interface driver ums-onetouch
[    1.211163] usbcore: registered new interface driver ums-sddr09
[    1.211210] usbcore: registered new interface driver ums-sddr55
[    1.211260] usbcore: registered new interface driver ums-usbat
[    1.211394] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.214247] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.214259] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.214317] mice: PS/2 mouse device common for all mice
[    1.214560] input: PC Speaker as /class/input/input2
[    1.214683] rtc_cmos 00:02: RTC can wake from S4
[    1.214756] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.214789] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    1.214838] i2c /dev entries driver
[    1.215117] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[    1.215223] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[    1.215274] Linux video capture interface: v2.00
[    1.215431] usbcore: registered new interface driver uvcvideo
[    1.215434] USB Video Class driver (v0.1.0)
[    1.215449] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    1.215615] w83627ehf: Found W83627EHG chip at 0xa10
[    1.215990] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
[    1.216018] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
[    1.216094] w83627hf/thf/hg WDT: initialized. timeout=60 sec (nowayout=0)
[    1.216097] md: linear personality registered for level -1
[    1.216099] md: raid0 personality registered for level 0
[    1.216101] md: raid1 personality registered for level 1
[    1.216103] md: raid10 personality registered for level 10
[    1.216105] md: raid6 personality registered for level 6
[    1.216107] md: raid5 personality registered for level 5
[    1.216109] md: raid4 personality registered for level 4
[    1.216111] md: multipath personality registered for level -4
[    1.216113] md: faulty personality registered for level -5
[    1.216312] device-mapper: uevent: version 1.0.3
[    1.216418] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.216613] Bluetooth: Virtual HCI driver ver 1.2
[    1.216667] Bluetooth: HCI UART driver ver 2.2
[    1.216669] Bluetooth: HCI H4 protocol initialized
[    1.216671] Bluetooth: HCI BCSP protocol initialized
[    1.216673] Bluetooth: HCILL protocol initialized
[    1.216675] Bluetooth: Broadcom Blutonium firmware driver ver 1.2
[    1.216725] usbcore: registered new interface driver bcm203x
[    1.216728] Bluetooth: Digianswer Bluetooth USB driver ver 0.10
[    1.216774] usbcore: registered new interface driver bpa10x
[    1.216776] Bluetooth: BlueFRITZ! USB driver ver 1.2
[    1.216826] usbcore: registered new interface driver bfusb
[    1.216829] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    1.216883] usbcore: registered new interface driver btusb
[    1.216886] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    1.216987] cpuidle: using governor ladder
[    1.216989] cpuidle: using governor menu
[    1.217154] sdhci: Secure Digital Host Controller Interface driver
[    1.217156] sdhci: Copyright(c) Pierre Ossman
[    1.217220] ricoh-mmc: Ricoh MMC Controller disabling driver
[    1.217222] ricoh-mmc: Copyright(c) Philip Langdale
[    1.217283] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    1.217285] wbsd: Copyright(c) Pierre Ossman
[    1.218708] usbcore: registered new interface driver hiddev
[    1.218762] usbcore: registered new interface driver usbhid
[    1.218765] usbhid: v2.6:USB HID core driver
[    1.218835] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.220223] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    1.220228] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[    1.220319] HDA Intel 0000:00:06.1: setting latency timer to 64
[    1.459018] usb 1-4: new high speed USB device using ehci_hcd and address 2
[    1.475224] ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 17
[    1.475235] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 17 (level, low) -> IRQ 17
[    1.475290] HDA Intel 0000:07:00.1: setting latency timer to 64
[    1.501681] ALSA device list:
[    1.501683]   #0: Dummy 1
[    1.501684]   #1: Virtual MIDI Card 1
[    1.501686]   #2: HDA NVidia at 0xfe9f0000 irq 21
[    1.501688]   #3: HDA ATI HDMI at 0xfebec000 irq 17
[    1.501799] oprofile: using NMI interrupt.
[    1.501867] GACT probability on
[    1.501869] Mirror/redirect action on
[    1.501871] Simple TC action Loaded
[    1.502013] netem: version 1.2
[    1.502015] u32 classifier
[    1.502016]     Performance counters on
[    1.502017]     input device check on 
[    1.502019]     Actions configured 
[    1.502023] Netfilter messages via NETLINK v0.30.
[    1.502054] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.502320] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    1.502323] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[    1.502325] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    1.502383] xt_time: kernel timezone is -0000
[    1.502403] IPVS: Registered protocols (TCP, UDP, AH, ESP)
[    1.502494] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
[    1.502532] IPVS: ipvs loaded.
[    1.502535] IPVS: [rr] scheduler registered.
[    1.502537] IPVS: [wrr] scheduler registered.
[    1.502539] IPVS: [lc] scheduler registered.
[    1.502541] IPVS: [wlc] scheduler registered.
[    1.502545] IPVS: [lblc] scheduler registered.
[    1.502549] IPVS: [lblcr] scheduler registered.
[    1.502551] IPVS: [dh] scheduler registered.
[    1.502553] IPVS: [sh] scheduler registered.
[    1.502555] IPVS: [sed] scheduler registered.
[    1.502556] IPVS: [nq] scheduler registered.
[    1.502559] IPVS: ftp: loaded support on port[0] = 21
[    1.502569] IPv4 over IPv4 tunneling driver
[    1.502681] GRE over IPv4 tunneling driver
[    1.502891] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.502913] ClusterIP Version 0.8 loaded successfully
[    1.502934] arp_tables: (C) 2002 David S. Miller
[    1.502953] TCP bic registered
[    1.502954] TCP cubic registered
[    1.502956] TCP westwood registered
[    1.502958] TCP highspeed registered
[    1.502959] TCP hybla registered
[    1.502961] TCP htcp registered
[    1.502963] TCP vegas registered
[    1.502964] TCP veno registered
[    1.502966] TCP scalable registered
[    1.502968] TCP lp registered
[    1.502969] TCP yeah registered
[    1.502971] TCP illinois registered
[    1.502972] Initializing XFRM netlink socket
[    1.503279] NET: Registered protocol family 10
[    1.503451] lo: Disabled Privacy Extensions
[    1.503696] tunl0: Disabled Privacy Extensions
[    1.503800] Mobile IPv6
[    1.503812] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.503856] IPv6 over IPv4 tunneling driver
[    1.504056] sit0: Disabled Privacy Extensions
[    1.504217] ip6tnl0: Disabled Privacy Extensions
[    1.504240] NET: Registered protocol family 17
[    1.504249] NET: Registered protocol family 15
[    1.504335] Bridge firewalling registered
[    1.504340] Ebtables v2.0 registered
[    1.504384] ebt_ulog: out of memory trying to call netlink_kernel_create
[    1.504387] NET: Registered protocol family 5
[    1.512276] Bluetooth: L2CAP ver 2.13
[    1.512277] Bluetooth: L2CAP socket layer initialized
[    1.512280] Bluetooth: SCO (Voice Link) ver 0.6
[    1.512282] Bluetooth: SCO socket layer initialized
[    1.512323] Bluetooth: RFCOMM socket layer initialized
[    1.512334] Bluetooth: RFCOMM TTY layer initialized
[    1.512336] Bluetooth: RFCOMM ver 1.11
[    1.512338] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.512340] Bluetooth: BNEP filters: protocol multicast
[    1.512342] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.512422] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    1.512425] All bugs added by David S. Miller <davem@redhat.com>
[    1.515798] CCID: Activated CCID 2 (TCP-like)
[    1.515819] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[    1.520714] SCTP: Hash tables configured (established 65536 bind 65536)
[    1.529385] TIPC: Activated (version 1.6.4 compiled Jun 10 2009 17:43:09)
[    1.529534] NET: Registered protocol family 30
[    1.529536] TIPC: Started in single node mode
[    1.529565] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
[    1.529624] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    1.529627] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    1.529630] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    1.529632] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    1.529635] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    1.529637] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    1.529933] PM: Checking image partition /dev/mapper/luks-swap
[    1.574144] usb 1-4: configuration #1 chosen from 1 choice
[    1.651113] firewire_core: created device fw0: GUID 0010dc0000cf25c6, S400
[    1.676019] usb 1-6: new high speed USB device using ehci_hcd and address 3
[    1.790627] usb 1-6: configuration #1 chosen from 1 choice
[    1.790841] hub 1-6:1.0: USB hub found
[    1.790887] hub 1-6:1.0: 4 ports detected
[    1.822548] ata5: SATA link down (SStatus 0 SControl 300)
[    1.961035] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.962280] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.964264] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
[    1.964346] ata3.00: ATA-7: ST98823AS, 7.01, max UDMA/133
[    1.964349] ata3.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.970226] ata1.00: configured for UDMA/66
[    1.970447] ata3.00: configured for UDMA/133
[    1.994478] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.18 PQ: 0 ANSI: 5
[    2.036515] sr0: scsi3-mmc drive: 12x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.036519] Uniform CD-ROM driver Revision: 3.20
[    2.036713] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.036872] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.055287] usb 1-6.1: new high speed USB device using ehci_hcd and address 4
[    2.134148] usb 1-6.1: configuration #1 chosen from 1 choice
[    2.200275] usb 1-6.2: new low speed USB device using ehci_hcd and address 5
[    2.286607] usb 1-6.2: configuration #1 chosen from 1 choice
[    2.292048] input: DELL DELL USB Keyboard as /class/input/input3
[    2.292424] generic-usb 0003:413C:2003.0001: input,hidraw0: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2/input0
[    2.302781] input: DELL DELL USB Keyboard as /class/input/input4
[    2.303102] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2/input1
[    2.367304] usb 1-6.3: new low speed USB device using ehci_hcd and address 6
[    2.461375] usb 1-6.3: configuration #1 chosen from 1 choice
[    2.470230] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input5
[    2.470682] generic-usb 0003:045E:0029.0003: input,hidraw2: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-6.3/input0
[    2.500020] Clocksource tsc unstable (delta = -218657587 ns)
[    2.534304] usb 1-6.4: new high speed USB device using ehci_hcd and address 7
[    2.611738] usb 1-6.4: configuration #1 chosen from 1 choice
[    2.612185] hub 1-6.4:1.0: USB hub found
[    2.612522] hub 1-6.4:1.0: 4 ports detected
[    2.910053] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.913346] ata2.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max UDMA/133
[    2.913354] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.919363] ata2.00: configured for UDMA/133
[    2.919589] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT72503 V54O PQ: 0 ANSI: 5
[    2.920202] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    2.920243] sd 1:0:0:0: [sda] Write Protect is off
[    2.920251] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.920328] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.920571]  sda:<5>sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.921021] scsi 2:0:0:0: Direct-Access     ATA      ST98823AS        7.01 PQ: 0 ANSI: 5
[    2.921629] sd 2:0:0:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    2.921640] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.921678] sd 2:0:0:0: [sdb] Write Protect is off
[    2.921686] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.921743] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.921967]  sdb: sdb1
[    2.934679] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.951668]  sda1 sda2 sda3 sda4
[    2.953046] sd 1:0:0:0: [sda] Attached SCSI disk
[    3.654440] ata4: SATA link down (SStatus 0 SControl 300)
[    4.398440] ata6: SATA link down (SStatus 0 SControl 300)
[    4.409071] ata8: port disabled. ignoring.
[    4.409117] PM: Resume from disk failed.
[    4.409158] registered taskstats version 1
[    4.409603] rtc_cmos 00:02: setting system clock to 2009-06-14 10:27:10 UTC (1244975230)
[    4.409611] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    4.410071] Freeing unused kernel memory: 592k freed
[    4.410652] Write protecting the kernel read-only data: 11308k
[    4.956029] end_request: I/O error, dev fd0, sector 0
[    5.681030] end_request: I/O error, dev fd0, sector 0
[   21.484032] end_request: I/O error, dev fd0, sector 0
[   33.175029] end_request: I/O error, dev fd0, sector 0
[   33.680043] end_request: I/O error, dev fd0, sector 0
[   33.800028] end_request: I/O error, dev fd0, sector 0
[   33.973528] EXT4-fs: barriers enabled
[   33.984789] kjournald2 starting: pid 1273, dev dm-0:8, commit interval 5 seconds
[   33.984807] EXT4-fs: delayed allocation enabled
[   33.984813] EXT4-fs: file extents enabled
[   33.986489] EXT4-fs: mballoc enabled
[   33.986525] EXT4-fs: mounted filesystem dm-0 with writeback data mode
[   34.130566] type=1404 audit(1244975260.220:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   34.401592] SELinux: 8192 avtab hash slots, 125804 rules.
[   34.450859] SELinux: 8192 avtab hash slots, 125804 rules.
[   34.627661] SELinux:  8 users, 11 roles, 2816 types, 127 bools, 1 sens, 1024 cats
[   34.627673] SELinux:  74 classes, 125804 rules
[   34.636756] SELinux:  Completing initialization.
[   34.636763] SELinux:  Setting up existing superblocks.
[   34.645877] SELinux: initialized (dev dm-0, type ext4), uses xattr
[   34.646044] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   34.656982] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   34.657005] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   34.657017] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   34.657072] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   34.657137] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[   34.657150] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   34.657334] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[   34.657344] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   34.657409] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   34.657420] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   34.657436] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   34.657605] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   34.657624] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   34.657657] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   34.657668] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   34.657880] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   34.670949] type=1403 audit(1244975260.760:3): policy loaded auid=4294967295 ses=4294967295
[   37.617876] udev: starting version 141
[   37.617941] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[   38.220292] end_request: I/O error, dev fd0, sector 0
[   39.761342] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[   39.761788] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[   39.761802] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 20 (level, low) -> IRQ 20
[   39.761807] forcedeth 0000:00:08.0: setting latency timer to 64
[   39.761922] nv_probe: set workaround bit for reversed mac addr
[   39.895672] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
[   39.895686] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 (level, low) -> IRQ 16
[   39.895736] Olympic.c v1.0.5 6/04/02 - Peter De Schrijver & Mike Phillips 
[   39.895740] 0000:01:00.0. I/O at d800, MMIO at ffffc20010732c00, LAP at ffffc2001076a000, using irq 16
[   40.232873] wlan0: register 'rndis_wlan' at usb-0000:00:02.1-6.1, Wireless RNDIS device, BCM4320b based, 00:16:01:cf:56:29
[   40.232907] usbcore: registered new interface driver rndis_wlan
[   40.277444] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr 60:50:40:30:20:10
[   40.277449] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[   40.277859] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[   40.277864] forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 20 (level, low) -> IRQ 20
[   40.277869] forcedeth 0000:00:09.0: setting latency timer to 64
[   40.277940] nv_probe: set workaround bit for reversed mac addr
[   40.792454] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr 60:50:40:30:20:11
[   40.792459] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[   41.705516] rndis_wlan 1-6.1:1.0: rndis media disconnect
[   43.637963] Olympic: 0000:01:00.0 registered as: tr0
[   44.592228] EXT4 FS on dm-0, internal journal on dm-0:8
[   44.909080] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   44.928586] SELinux: initialized (dev sda1, type ext2), uses xattr
[   45.057527] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   46.212613] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   56.700898] forcedeth 0000:00:09.0: irq 30 for MSI/MSI-X
[   56.701129] eth1: no link during initialization.
[   56.707399] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   56.718315] forcedeth 0000:00:08.0: irq 31 for MSI/MSI-X
[   56.718544] eth0: no link during initialization.
[   56.724472] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   56.837378] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   57.676428] [drm] Setting GART location based on new memory map
[   57.692328] [drm] Loading RV620 CP Microcode
[   57.694881] [drm] Loading RV620 PFP Microcode
[   57.710396] [drm] Resetting GPU
[   57.710461] [drm] writeback test succeeded in 0 usecs
[  100.997718] Too big adjustment 32
[  101.102690] Too big adjustment 32
[  101.139757] Too big adjustment 32
[  101.146003] Too big adjustment 32
[  101.179065] Too big adjustment 32
[  101.189030] Too big adjustment 32
[  101.194987] Too big adjustment 32
[  101.204412] hda-intel: IRQ timing workaround is activated for card #3. Suggest a bigger bdl_pos_adj.
[  101.228961] Too big adjustment 32
[  101.230226] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[  101.258603] Too big adjustment 32
[  101.266059] Too big adjustment 32
[  101.298315] Too big adjustment 32
[  101.318763] Too big adjustment 32
[  101.323957] Too big adjustment 32
[  101.355503] Too big adjustment 32
[  101.375829] Too big adjustment 32
[  101.381227] Too big adjustment 32
[  101.412669] Too big adjustment 32
[  101.432804] Too big adjustment 32
[  101.438228] Too big adjustment 32
[  101.481649] Too big adjustment 32
[  101.487292] Too big adjustment 32
[  103.744272] end_request: I/O error, dev fd0, sector 0
[  105.724272] end_request: I/O error, dev fd0, sector 0
[  107.724271] end_request: I/O error, dev fd0, sector 0
[  109.725283] end_request: I/O error, dev fd0, sector 0
[  111.724045] end_request: I/O error, dev fd0, sector 0
[  113.725047] end_request: I/O error, dev fd0, sector 0
[  115.704781] rndis_wlan 1-6.1:1.0: rndis media connect
[  115.725036] end_request: I/O error, dev fd0, sector 0
[  115.732754] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  117.723284] end_request: I/O error, dev fd0, sector 0
[  119.724029] end_request: I/O error, dev fd0, sector 0
[  121.725031] end_request: I/O error, dev fd0, sector 0
[  123.725043] end_request: I/O error, dev fd0, sector 0
[  125.725032] end_request: I/O error, dev fd0, sector 0
[  125.768025] wlan0: no IPv6 routers present
[  127.724289] end_request: I/O error, dev fd0, sector 0
[  129.724289] end_request: I/O error, dev fd0, sector 0
[  131.724036] end_request: I/O error, dev fd0, sector 0
[  153.743036] end_request: I/O error, dev fd0, sector 0
[  155.725036] end_request: I/O error, dev fd0, sector 0
[  157.725034] end_request: I/O error, dev fd0, sector 0
[  159.725036] end_request: I/O error, dev fd0, sector 0
[  161.725038] end_request: I/O error, dev fd0, sector 0
[  163.726048] end_request: I/O error, dev fd0, sector 0
[  165.724035] end_request: I/O error, dev fd0, sector 0
[  167.724031] end_request: I/O error, dev fd0, sector 0
[  169.725027] end_request: I/O error, dev fd0, sector 0
[ 2341.715474] rndis_wlan 1-6.1:1.0: rndis media disconnect
[ 2342.016921] [drm] Resetting GPU
[ 2342.221241] PM: Syncing filesystems ... done.
[ 2342.242935] PM: Preparing system for mem sleep
[ 2342.242953] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 2342.254552] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[ 2342.254681] PM: Entering mem sleep
[ 2342.254693] Suspending console(s) (use no_console_suspend to debug)
[ 2342.254910] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 2342.255010] sd 2:0:0:0: [sdb] Stopping disk
[ 2344.317543] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 2344.337031] sd 1:0:0:0: [sda] Stopping disk
[ 2344.773182] ACPI handle has no context!
[ 2344.773586] parport_pc 00:08: disabled
[ 2344.773941] serial 00:05: disabled
[ 2344.773970] HDA Intel 0000:07:00.1: PCI INT B disabled
[ 2344.773996] ACPI handle has no context!
[ 2344.785021] pci 0000:07:00.0: PCI INT A disabled
[ 2344.785048] ACPI handle has no context!
[ 2344.796016] olympic 0000:01:00.0: PCI INT A disabled
[ 2344.796310] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 2344.796315] forcedeth 0000:00:09.0: PME# disabled
[ 2344.796318] forcedeth 0000:00:09.0: PCI INT A disabled
[ 2344.807296] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 2344.807300] forcedeth 0000:00:08.0: PME# disabled
[ 2344.807303] forcedeth 0000:00:08.0: PCI INT A disabled
[ 2344.818021] HDA Intel 0000:00:06.1: PCI INT B disabled
[ 2344.829092] sata_nv 0000:00:05.2: PCI INT C disabled
[ 2344.840075] sata_nv 0000:00:05.1: PCI INT B disabled
[ 2344.851069] sata_nv 0000:00:05.0: PCI INT A disabled
[ 2344.862045] ata8: port disabled. ignoring.
[ 2344.873019] ehci_hcd 0000:00:02.1: PCI INT B disabled
[ 2344.873032] ehci_hcd 0000:00:02.1: PME# disabled
[ 2344.884019] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 2344.884032] ohci_hcd 0000:00:02.0: PME# disabled
[ 2344.895053] PM: suspend devices took 2.641 seconds
[ 2344.895481] ACPI: Preparing to enter system sleep state S3
[ 2344.896659] Disabling non-boot CPUs ...
[ 2344.897703] Broke affinity for irq 21
[ 2344.897703] Broke affinity for irq 22
[ 2344.897703] kvm: disabling virtualization on CPU1
[ 2344.898957] CPU 1 is now offline
[ 2344.898959] SMP alternatives: switching to UP code
[ 2344.903889] CPU1 is down
[ 2344.903899] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 2344.903899] Back to C!
[ 2344.903899] PCI-DMA: Resuming GART IOMMU
[ 2344.903899] PCI-DMA: Restoring GART aperture settings
[ 2344.907788] Enabling non-boot CPUs ...
[ 2344.908012] SMP alternatives: switching to SMP code
[ 2344.912472] Booting processor 1 APIC 0x1 ip 0x6000
[ 2344.903502] Initializing CPU#1
[ 2344.903502] Calibrating delay using timer specific routine.. 5200.06 BogoMIPS (lpj=2600033)
[ 2344.903502] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 2344.903502] CPU: L2 Cache: 512K (64 bytes/line)
[ 2344.903502] CPU: Physical Processor ID: 0
[ 2344.903502] CPU: Processor Core ID: 1
[ 2344.903502] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 2344.983415] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[ 2344.983474] kvm: enabling virtualization on CPU1
[ 2344.984267] Switched to high resolution mode on CPU 1
[ 2344.987211] CPU1 is up
[ 2344.987213] ACPI: Waking up from system sleep state S3
[ 2344.987900] pci 0000:00:00.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 2344.987930] pci 0000:00:00.0: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00106)
[ 2344.987948] pci 0000:00:01.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 2344.987954] pci 0000:00:01.0: restoring config space at offset 0x4 (was 0x1, writing 0x2f01)
[ 2344.987986] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00003)
[ 2344.988001] ehci_hcd 0000:00:02.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 2344.988053] pci 0000:00:06.0: restoring config space at offset 0x9 (was 0xfff0, writing 0xf000f000)
[ 2344.988056] pci 0000:00:06.0: restoring config space at offset 0x7 (was 0x280d0d0, writing 0x8280d0d0)
[ 2344.988072] HDA Intel 0000:00:06.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 2344.988088] forcedeth 0000:00:08.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9fa400)
[ 2344.988092] forcedeth 0000:00:08.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa800)
[ 2344.988109] forcedeth 0000:00:09.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9f4c00)
[ 2344.988113] forcedeth 0000:00:09.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa000)
[ 2344.988131] pcieport-driver 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 2344.988152] pcieport-driver 0000:00:0b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 2344.988172] pcieport-driver 0000:00:0c.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 2344.988191] pcieport-driver 0000:00:0d.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 2344.988211] pcieport-driver 0000:00:0e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 2344.988229] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x7 (was 0x2000e1e1, writing 0xe1e1)
[ 2344.988233] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[ 2344.988286] firewire_ohci 0000:01:04.0: restoring config space at offset 0xf (was 0x20000100, writing 0x2000010b)
[ 2344.988296] firewire_ohci 0000:01:04.0: restoring config space at offset 0x5 (was 0x1, writing 0xdc01)
[ 2344.988300] firewire_ohci 0000:01:04.0: restoring config space at offset 0x4 (was 0xd0000000, writing 0xfeafe800)
[ 2344.988304] firewire_ohci 0000:01:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[ 2344.988309] firewire_ohci 0000:01:04.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2100117)
[ 2344.988338] pci 0000:07:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
[ 2344.988371] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100103)
[ 2344.988518] nForce2_smbus 0000:00:01.1: PME# disabled
[ 2344.988532] ohci_hcd 0000:00:02.0: PME# disabled
[ 2344.988539] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[ 2344.988543] ohci_hcd 0000:00:02.0: setting latency timer to 64
[ 2344.988546] ohci_hcd 0000:00:02.0: PME# disabled
[ 2345.009030] ehci_hcd 0000:00:02.1: PME# disabled
[ 2345.009034] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[ 2345.009037] ehci_hcd 0000:00:02.1: setting latency timer to 64
[ 2345.009040] ehci_hcd 0000:00:02.1: PME# disabled
[ 2345.009054] pata_amd 0000:00:04.0: setting latency timer to 64
[ 2345.009081] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
[ 2345.009083] sata_nv 0000:00:05.0: setting latency timer to 64
[ 2345.009108] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
[ 2345.009111] sata_nv 0000:00:05.1: setting latency timer to 64
[ 2345.009134] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
[ 2345.009137] sata_nv 0000:00:05.2: setting latency timer to 64
[ 2345.009148] pci 0000:00:06.0: setting latency timer to 64
[ 2345.009167] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[ 2345.009170] HDA Intel 0000:00:06.1: setting latency timer to 64
[ 2345.009203] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 2345.009207] forcedeth 0000:00:08.0: PME# disabled
[ 2345.011673] ata8: port disabled. ignoring.
[ 2345.522345] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 2345.522349] forcedeth 0000:00:09.0: PME# disabled
[ 2345.763903] ata6: SATA link down (SStatus 0 SControl 300)
[ 2345.764009] ata5: SATA link down (SStatus 0 SControl 300)
[ 2345.764016] ata4: SATA link down (SStatus 0 SControl 300)
[ 2346.035356] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 (level, low) -> IRQ 16
[ 2346.092017] pci 0000:07:00.0: PME# disabled
[ 2346.092023] pci 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 19 (level, low) -> IRQ 19
[ 2346.092028] pci 0000:07:00.0: setting latency timer to 64
[ 2346.092053] firewire_core: skipped bus generations, destroying all nodes
[ 2346.092072] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 17 (level, low) -> IRQ 17
[ 2346.092076] HDA Intel 0000:07:00.1: setting latency timer to 64
[ 2346.093724] serial 00:05: activated
[ 2346.095627] parport_pc 00:08: activated
[ 2346.170030] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2346.173116] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 2346.173120] ata1.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 2346.179125] ata1.00: configured for UDMA/66
[ 2346.234234] sd 1:0:0:0: [sda] Starting disk
[ 2346.592024] firewire_core: rediscovered device fw0
[ 2346.812033] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2346.831113] ata3.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 2346.831116] ata3.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 2346.837255] ata3.00: configured for UDMA/133
[ 2350.963011] ata2: link is slow to respond, please be patient (ready=-19)
[ 2352.493030] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2352.512112] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 2352.512115] ata2.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 2352.518275] ata2.00: configured for UDMA/133
[ 2352.538515] sd 2:0:0:0: [sdb] Starting disk
[ 2352.549896] PM: resume devices took 7.561 seconds
[ 2352.549898] ------------[ cut here ]------------
[ 2352.549905] WARNING: at kernel/power/main.c:176 suspend_devices_and_enter+0x1af/0x1f8()
[ 2352.549907] Hardware name: MS-7250
[ 2352.549909] Component: resume devices
[ 2352.549910] Modules linked in: olympic rndis_wlan forcedeth [last unloaded: scsi_wait_scan]
[ 2352.549916] Pid: 28257, comm: pm-suspend Not tainted 2.6.30 #37
[ 2352.549918] Call Trace:
[ 2352.549923]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 2352.549928]  [<ffffffff804639ea>] ? warn_slowpath_common+0x84/0xb2
[ 2352.549931]  [<ffffffff80463aa1>] ? warn_slowpath_fmt+0x50/0x6a
[ 2352.549935]  [<ffffffff80494764>] ? suspend_test_finish+0x58/0xaf
[ 2352.549938]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 2352.549942]  [<ffffffff80494b6a>] ? enter_state+0x166/0x1c1
[ 2352.549945]  [<ffffffff80494c86>] ? state_store+0xc1/0xf6
[ 2352.549950]  [<ffffffff80558114>] ? sysfs_write_file+0xe6/0x137
[ 2352.549953]  [<ffffffff804fa1f3>] ? vfs_write+0xb4/0x126
[ 2352.549956]  [<ffffffff804fa34d>] ? sys_write+0x55/0x90
[ 2352.549960]  [<ffffffff80429fab>] ? system_call_fastpath+0x16/0x1b
[ 2352.549962] ---[ end trace 47d39cdfa3f16eb9 ]---
[ 2352.562035] PM: Finishing wakeup.
[ 2352.562037] Restarting tasks ... done.
[ 2354.554027] [drm] Loading RV620 CP Microcode
[ 2354.556499] [drm] Loading RV620 PFP Microcode
[ 2354.571978] [drm] Resetting GPU
[ 2355.013461] forcedeth 0000:00:09.0: irq 30 for MSI/MSI-X
[ 2355.013650] eth1: no link during initialization.
[ 2355.015869] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 2355.020778] forcedeth 0000:00:08.0: irq 31 for MSI/MSI-X
[ 2355.020966] eth0: no link during initialization.
[ 2355.023207] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 2355.131650] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2371.704990] rndis_wlan 1-6.1:1.0: rndis media connect
[ 2371.733685] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 2381.931024] wlan0: no IPv6 routers present
[ 2520.492024] Hangcheck: hangcheck value past margin!
[ 3318.081994] rndis_wlan 1-6.1:1.0: rndis media disconnect
[ 3318.330229] [drm] Resetting GPU
[ 3319.268124] PM: Syncing filesystems ... done.
[ 3319.289581] PM: Preparing system for mem sleep
[ 3319.289599] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 3319.290879] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[ 3319.291026] PM: Entering mem sleep
[ 3319.291038] Suspending console(s) (use no_console_suspend to debug)
[ 3319.291257] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 3319.291410] sd 2:0:0:0: [sdb] Stopping disk
[ 3321.350947] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 3321.366854] sd 1:0:0:0: [sda] Stopping disk
[ 3321.790184] ACPI handle has no context!
[ 3321.790571] parport_pc 00:08: disabled
[ 3321.790932] serial 00:05: disabled
[ 3321.790960] HDA Intel 0000:07:00.1: PCI INT B disabled
[ 3321.790987] ACPI handle has no context!
[ 3321.801021] pci 0000:07:00.0: PCI INT A disabled
[ 3321.801049] ACPI handle has no context!
[ 3321.812018] olympic 0000:01:00.0: PCI INT A disabled
[ 3321.812312] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 3321.812316] forcedeth 0000:00:09.0: PME# disabled
[ 3321.823296] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 3321.823300] forcedeth 0000:00:08.0: PME# disabled
[ 3321.834021] HDA Intel 0000:00:06.1: PCI INT B disabled
[ 3321.845064] sata_nv 0000:00:05.2: PCI INT C disabled
[ 3321.856055] sata_nv 0000:00:05.1: PCI INT B disabled
[ 3321.867054] sata_nv 0000:00:05.0: PCI INT A disabled
[ 3321.878045] ata8: port disabled. ignoring.
[ 3321.889017] ehci_hcd 0000:00:02.1: PCI INT B disabled
[ 3321.889030] ehci_hcd 0000:00:02.1: PME# disabled
[ 3321.900018] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 3321.900031] ohci_hcd 0000:00:02.0: PME# disabled
[ 3321.911056] PM: suspend devices took 2.620 seconds
[ 3321.911485] ACPI: Preparing to enter system sleep state S3
[ 3321.912607] Disabling non-boot CPUs ...
[ 3321.913650] kvm: disabling virtualization on CPU1
[ 3321.914901] CPU 1 is now offline
[ 3321.914903] SMP alternatives: switching to UP code
[ 3321.919786] CPU1 is down
[ 3321.919794] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 3321.919794] Back to C!
[ 3321.919794] PCI-DMA: Resuming GART IOMMU
[ 3321.919794] PCI-DMA: Restoring GART aperture settings
[ 3321.923541] Enabling non-boot CPUs ...
[ 3321.923756] SMP alternatives: switching to SMP code
[ 3321.928110] Booting processor 1 APIC 0x1 ip 0x6000
[ 3321.919390] Initializing CPU#1
[ 3321.919390] Calibrating delay using timer specific routine.. 5200.04 BogoMIPS (lpj=2600020)
[ 3321.919390] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 3321.919390] CPU: L2 Cache: 512K (64 bytes/line)
[ 3321.919390] CPU: Physical Processor ID: 0
[ 3321.919390] CPU: Processor Core ID: 1
[ 3321.919390] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 3321.999446] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[ 3321.999473] kvm: enabling virtualization on CPU1
[ 3322.000267] Switched to high resolution mode on CPU 1
[ 3322.003206] CPU1 is up
[ 3322.003208] ACPI: Waking up from system sleep state S3
[ 3322.003907] pci 0000:00:00.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 3322.003938] pci 0000:00:00.0: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00106)
[ 3322.003955] pci 0000:00:01.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 3322.003962] pci 0000:00:01.0: restoring config space at offset 0x4 (was 0x1, writing 0x2f01)
[ 3322.003994] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00003)
[ 3322.004012] ehci_hcd 0000:00:02.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 3322.004062] pci 0000:00:06.0: restoring config space at offset 0x9 (was 0xfff0, writing 0xf000f000)
[ 3322.004066] pci 0000:00:06.0: restoring config space at offset 0x7 (was 0x280d0d0, writing 0x8280d0d0)
[ 3322.004082] HDA Intel 0000:00:06.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 3322.004098] forcedeth 0000:00:08.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9fa400)
[ 3322.004101] forcedeth 0000:00:08.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa800)
[ 3322.004119] forcedeth 0000:00:09.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9f4c00)
[ 3322.004122] forcedeth 0000:00:09.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa000)
[ 3322.004140] pcieport-driver 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3322.004161] pcieport-driver 0000:00:0b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3322.004181] pcieport-driver 0000:00:0c.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3322.004200] pcieport-driver 0000:00:0d.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3322.004219] pcieport-driver 0000:00:0e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3322.004237] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x7 (was 0x2000e1e1, writing 0x6000e1e1)
[ 3322.004242] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[ 3322.004294] firewire_ohci 0000:01:04.0: restoring config space at offset 0xf (was 0x20000100, writing 0x2000010b)
[ 3322.004304] firewire_ohci 0000:01:04.0: restoring config space at offset 0x5 (was 0x1, writing 0xdc01)
[ 3322.004308] firewire_ohci 0000:01:04.0: restoring config space at offset 0x4 (was 0xd0000000, writing 0xfeafe800)
[ 3322.004312] firewire_ohci 0000:01:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[ 3322.004317] firewire_ohci 0000:01:04.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2100117)
[ 3322.004346] pci 0000:07:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
[ 3322.004378] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100000, writing 0x40100103)
[ 3322.004526] nForce2_smbus 0000:00:01.1: PME# disabled
[ 3322.004540] ohci_hcd 0000:00:02.0: PME# disabled
[ 3322.004547] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[ 3322.004551] ohci_hcd 0000:00:02.0: setting latency timer to 64
[ 3322.004554] ohci_hcd 0000:00:02.0: PME# disabled
[ 3322.025030] ehci_hcd 0000:00:02.1: PME# disabled
[ 3322.025033] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[ 3322.025037] ehci_hcd 0000:00:02.1: setting latency timer to 64
[ 3322.025040] ehci_hcd 0000:00:02.1: PME# disabled
[ 3322.025054] pata_amd 0000:00:04.0: setting latency timer to 64
[ 3322.025081] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
[ 3322.025083] sata_nv 0000:00:05.0: setting latency timer to 64
[ 3322.025107] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
[ 3322.025110] sata_nv 0000:00:05.1: setting latency timer to 64
[ 3322.025133] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
[ 3322.025136] sata_nv 0000:00:05.2: setting latency timer to 64
[ 3322.025147] pci 0000:00:06.0: setting latency timer to 64
[ 3322.025165] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[ 3322.025169] HDA Intel 0000:00:06.1: setting latency timer to 64
[ 3322.025202] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 3322.025207] forcedeth 0000:00:08.0: PME# disabled
[ 3322.027563] ata8: port disabled. ignoring.
[ 3322.538356] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 3322.538360] forcedeth 0000:00:09.0: PME# disabled
[ 3322.779902] ata6: SATA link down (SStatus 0 SControl 300)
[ 3322.780009] ata5: SATA link down (SStatus 0 SControl 300)
[ 3322.780016] ata4: SATA link down (SStatus 0 SControl 300)
[ 3323.051320] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 (level, low) -> IRQ 16
[ 3323.108017] pci 0000:07:00.0: PME# disabled
[ 3323.108023] pci 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 19 (level, low) -> IRQ 19
[ 3323.108028] pci 0000:07:00.0: setting latency timer to 64
[ 3323.108053] firewire_core: skipped bus generations, destroying all nodes
[ 3323.108060] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100103, writing 0x40100103)
[ 3323.108075] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 17 (level, low) -> IRQ 17
[ 3323.108079] HDA Intel 0000:07:00.1: setting latency timer to 64
[ 3323.109641] serial 00:05: activated
[ 3323.111541] parport_pc 00:08: activated
[ 3323.186030] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3323.189116] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 3323.189120] ata1.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 3323.195125] ata1.00: configured for UDMA/66
[ 3323.349756] sd 1:0:0:0: [sda] Starting disk
[ 3323.608024] firewire_core: rediscovered device fw0
[ 3323.981033] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3323.984111] ata3.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 3323.984114] ata3.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 3323.990249] ata3.00: configured for UDMA/133
[ 3327.979011] ata2: link is slow to respond, please be patient (ready=-19)
[ 3328.285030] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3328.304112] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 3328.304115] ata2.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 3328.310275] ata2.00: configured for UDMA/133
[ 3328.329039] sd 2:0:0:0: [sdb] Starting disk
[ 3328.341264] PM: resume devices took 6.337 seconds
[ 3328.341266] ------------[ cut here ]------------
[ 3328.341273] WARNING: at kernel/power/main.c:176 suspend_devices_and_enter+0x1af/0x1f8()
[ 3328.341275] Hardware name: MS-7250
[ 3328.341277] Component: resume devices
[ 3328.341278] Modules linked in: olympic rndis_wlan forcedeth [last unloaded: scsi_wait_scan]
[ 3328.341285] Pid: 20972, comm: pm-suspend Tainted: G        W  2.6.30 #37
[ 3328.341287] Call Trace:
[ 3328.341292]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 3328.341297]  [<ffffffff804639ea>] ? warn_slowpath_common+0x84/0xb2
[ 3328.341300]  [<ffffffff80463aa1>] ? warn_slowpath_fmt+0x50/0x6a
[ 3328.341303]  [<ffffffff80494764>] ? suspend_test_finish+0x58/0xaf
[ 3328.341307]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 3328.341310]  [<ffffffff80494b6a>] ? enter_state+0x166/0x1c1
[ 3328.341313]  [<ffffffff80494c86>] ? state_store+0xc1/0xf6
[ 3328.341318]  [<ffffffff80558114>] ? sysfs_write_file+0xe6/0x137
[ 3328.341321]  [<ffffffff804fa1f3>] ? vfs_write+0xb4/0x126
[ 3328.341324]  [<ffffffff804fa34d>] ? sys_write+0x55/0x90
[ 3328.341328]  [<ffffffff80429fab>] ? system_call_fastpath+0x16/0x1b
[ 3328.341330] ---[ end trace 47d39cdfa3f16eba ]---
[ 3328.352912] PM: Finishing wakeup.
[ 3328.352914] Restarting tasks ... done.
[ 3330.305465] [drm] Loading RV620 CP Microcode
[ 3330.307919] [drm] Loading RV620 PFP Microcode
[ 3330.323413] [drm] Resetting GPU
[ 3330.778931] forcedeth 0000:00:09.0: irq 30 for MSI/MSI-X
[ 3330.779123] eth1: no link during initialization.
[ 3330.781348] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 3330.786324] forcedeth 0000:00:08.0: irq 31 for MSI/MSI-X
[ 3330.786512] eth0: no link during initialization.
[ 3330.788721] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 3330.896695] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3347.704889] rndis_wlan 1-6.1:1.0: rndis media connect
[ 3347.732635] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3358.704022] wlan0: no IPv6 routers present
[ 3397.809660] hub 1-0:1.0: over-current change on port 1
[ 3397.910031] hub 1-0:1.0: over-current change on port 2
[ 3398.011035] usb 1-6: USB disconnect, address 3
[ 3398.011042] usb 1-6.1: USB disconnect, address 4
[ 3398.011690] wlan0: unregister 'rndis_wlan' usb-0000:00:02.1-6.1, Wireless RNDIS device, BCM4320b based
[ 3398.050323] usb 1-6.2: USB disconnect, address 5
[ 3398.068048] usb 1-6.3: USB disconnect, address 6
[ 3398.081508] usb 1-6.4: USB disconnect, address 7
[ 3403.114035] usb 1-6: new high speed USB device using ehci_hcd and address 8
[ 3403.228843] usb 1-6: configuration #1 chosen from 1 choice
[ 3403.231701] hub 1-6:1.0: USB hub found
[ 3403.236842] hub 1-6:1.0: 4 ports detected
[ 3403.501409] usb 1-6.2: new low speed USB device using ehci_hcd and address 9
[ 3403.586955] usb 1-6.2: configuration #1 chosen from 1 choice
[ 3403.592552] input: DELL DELL USB Keyboard as /class/input/input6
[ 3403.592764] generic-usb 0003:413C:2003.0004: input,hidraw0: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2/input0
[ 3403.602861] input: DELL DELL USB Keyboard as /class/input/input7
[ 3403.603112] generic-usb 0003:413C:2003.0005: input,hidraw1: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2/input1
[ 3403.667433] usb 1-6.3: new low speed USB device using ehci_hcd and address 10
[ 3403.764844] usb 1-6.3: configuration #1 chosen from 1 choice
[ 3403.777068] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input8
[ 3403.777292] generic-usb 0003:045E:0029.0006: input,hidraw2: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-6.3/input0
[ 3403.842436] usb 1-6.4: new high speed USB device using ehci_hcd and address 11
[ 3403.923501] usb 1-6.4: configuration #1 chosen from 1 choice
[ 3403.923843] hub 1-6.4:1.0: USB hub found
[ 3403.924154] hub 1-6.4:1.0: 4 ports detected
[ 3408.301420] usb 1-6.1: new high speed USB device using ehci_hcd and address 12
[ 3408.383252] usb 1-6.1: configuration #1 chosen from 1 choice
[ 3408.719158] wlan0: register 'rndis_wlan' at usb-0000:00:02.1-6.1, Wireless RNDIS device, BCM4320b based, 00:16:01:cf:56:29
[ 3409.704642] rndis_wlan 1-6.1:1.0: rndis media disconnect
[ 3413.494884] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3420.492022] Hangcheck: hangcheck value past margin!
[ 3429.704888] rndis_wlan 1-6.1:1.0: rndis media connect
[ 3429.732585] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3439.936024] wlan0: no IPv6 routers present
[ 3690.136879] rndis_wlan 1-6.1:1.0: rndis media disconnect
[ 3690.369147] [drm] Resetting GPU
[ 3690.687978] PM: Syncing filesystems ... done.
[ 3690.717527] PM: Preparing system for mem sleep
[ 3690.717543] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 3690.719101] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[ 3690.719390] PM: Entering mem sleep
[ 3690.719403] Suspending console(s) (use no_console_suspend to debug)
[ 3690.767024] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 3690.767127] sd 2:0:0:0: [sdb] Stopping disk
[ 3692.827350] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 3692.842771] sd 1:0:0:0: [sda] Stopping disk
[ 3693.233183] ACPI handle has no context!
[ 3693.233571] parport_pc 00:08: disabled
[ 3693.233898] serial 00:05: disabled
[ 3693.233927] HDA Intel 0000:07:00.1: PCI INT B disabled
[ 3693.233954] ACPI handle has no context!
[ 3693.244022] pci 0000:07:00.0: PCI INT A disabled
[ 3693.244049] ACPI handle has no context!
[ 3693.255018] olympic 0000:01:00.0: PCI INT A disabled
[ 3693.255312] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 3693.255316] forcedeth 0000:00:09.0: PME# disabled
[ 3693.266295] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 3693.266299] forcedeth 0000:00:08.0: PME# disabled
[ 3693.277021] HDA Intel 0000:00:06.1: PCI INT B disabled
[ 3693.288064] sata_nv 0000:00:05.2: PCI INT C disabled
[ 3693.299052] sata_nv 0000:00:05.1: PCI INT B disabled
[ 3693.310055] sata_nv 0000:00:05.0: PCI INT A disabled
[ 3693.321045] ata8: port disabled. ignoring.
[ 3693.332018] ehci_hcd 0000:00:02.1: PCI INT B disabled
[ 3693.332032] ehci_hcd 0000:00:02.1: PME# disabled
[ 3693.343018] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 3693.343031] ohci_hcd 0000:00:02.0: PME# disabled
[ 3693.354056] PM: suspend devices took 2.635 seconds
[ 3693.354486] ACPI: Preparing to enter system sleep state S3
[ 3693.355578] Disabling non-boot CPUs ...
[ 3693.356622] kvm: disabling virtualization on CPU1
[ 3693.357873] CPU 1 is now offline
[ 3693.357876] SMP alternatives: switching to UP code
[ 3693.362872] CPU1 is down
[ 3693.362880] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 3693.362880] Back to C!
[ 3693.362880] PCI-DMA: Resuming GART IOMMU
[ 3693.362880] PCI-DMA: Restoring GART aperture settings
[ 3693.366699] Enabling non-boot CPUs ...
[ 3693.366921] SMP alternatives: switching to SMP code
[ 3693.371422] Booting processor 1 APIC 0x1 ip 0x6000
[ 3693.362481] Initializing CPU#1
[ 3693.362481] Calibrating delay using timer specific routine.. 5200.04 BogoMIPS (lpj=2600020)
[ 3693.362481] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 3693.362481] CPU: L2 Cache: 512K (64 bytes/line)
[ 3693.362481] CPU: Physical Processor ID: 0
[ 3693.362481] CPU: Processor Core ID: 1
[ 3693.362481] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 3693.442459] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[ 3693.442472] kvm: enabling virtualization on CPU1
[ 3693.443267] Switched to high resolution mode on CPU 1
[ 3693.446210] CPU1 is up
[ 3693.446212] ACPI: Waking up from system sleep state S3
[ 3693.446887] pci 0000:00:00.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 3693.446918] pci 0000:00:00.0: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00106)
[ 3693.446935] pci 0000:00:01.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 3693.446942] pci 0000:00:01.0: restoring config space at offset 0x4 (was 0x1, writing 0x2f01)
[ 3693.446974] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00003)
[ 3693.446988] ehci_hcd 0000:00:02.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 3693.447042] pci 0000:00:06.0: restoring config space at offset 0x9 (was 0xfff0, writing 0xf000f000)
[ 3693.447059] HDA Intel 0000:00:06.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 3693.447075] forcedeth 0000:00:08.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9fa400)
[ 3693.447078] forcedeth 0000:00:08.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa800)
[ 3693.447096] forcedeth 0000:00:09.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9f4c00)
[ 3693.447099] forcedeth 0000:00:09.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa000)
[ 3693.447118] pcieport-driver 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3693.447138] pcieport-driver 0000:00:0b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3693.447158] pcieport-driver 0000:00:0c.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3693.447178] pcieport-driver 0000:00:0d.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3693.447197] pcieport-driver 0000:00:0e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 3693.447216] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x7 (was 0x2000e1e1, writing 0x6000e1e1)
[ 3693.447220] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[ 3693.447273] firewire_ohci 0000:01:04.0: restoring config space at offset 0xf (was 0x20000100, writing 0x2000010b)
[ 3693.447283] firewire_ohci 0000:01:04.0: restoring config space at offset 0x5 (was 0x1, writing 0xdc01)
[ 3693.447287] firewire_ohci 0000:01:04.0: restoring config space at offset 0x4 (was 0xd0000000, writing 0xfeafe800)
[ 3693.447291] firewire_ohci 0000:01:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[ 3693.447296] firewire_ohci 0000:01:04.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2100117)
[ 3693.447325] pci 0000:07:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
[ 3693.447357] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100000, writing 0x40100103)
[ 3693.447505] nForce2_smbus 0000:00:01.1: PME# disabled
[ 3693.447518] ohci_hcd 0000:00:02.0: PME# disabled
[ 3693.447526] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[ 3693.447530] ohci_hcd 0000:00:02.0: setting latency timer to 64
[ 3693.447533] ohci_hcd 0000:00:02.0: PME# disabled
[ 3693.468030] ehci_hcd 0000:00:02.1: PME# disabled
[ 3693.468034] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[ 3693.468037] ehci_hcd 0000:00:02.1: setting latency timer to 64
[ 3693.468040] ehci_hcd 0000:00:02.1: PME# disabled
[ 3693.468057] pata_amd 0000:00:04.0: setting latency timer to 64
[ 3693.468083] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
[ 3693.468086] sata_nv 0000:00:05.0: setting latency timer to 64
[ 3693.468112] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
[ 3693.468115] sata_nv 0000:00:05.1: setting latency timer to 64
[ 3693.468138] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
[ 3693.468140] sata_nv 0000:00:05.2: setting latency timer to 64
[ 3693.468152] pci 0000:00:06.0: setting latency timer to 64
[ 3693.468170] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[ 3693.468174] HDA Intel 0000:00:06.1: setting latency timer to 64
[ 3693.468205] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 3693.468209] forcedeth 0000:00:08.0: PME# disabled
[ 3693.470556] ata8: port disabled. ignoring.
[ 3693.981356] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 3693.981361] forcedeth 0000:00:09.0: PME# disabled
[ 3694.222903] ata6: SATA link down (SStatus 0 SControl 300)
[ 3694.223009] ata4: SATA link down (SStatus 0 SControl 300)
[ 3694.223016] ata5: SATA link down (SStatus 0 SControl 300)
[ 3694.494355] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 (level, low) -> IRQ 16
[ 3694.551017] pci 0000:07:00.0: PME# disabled
[ 3694.551023] pci 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 19 (level, low) -> IRQ 19
[ 3694.551028] pci 0000:07:00.0: setting latency timer to 64
[ 3694.551052] firewire_core: skipped bus generations, destroying all nodes
[ 3694.551060] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100103, writing 0x40100103)
[ 3694.551074] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 17 (level, low) -> IRQ 17
[ 3694.551078] HDA Intel 0000:07:00.1: setting latency timer to 64
[ 3694.552562] serial 00:05: activated
[ 3694.554362] parport_pc 00:08: activated
[ 3694.574604] sd 1:0:0:0: [sda] Starting disk
[ 3694.608034] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3694.611117] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 3694.611121] ata1.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 3694.617125] ata1.00: configured for UDMA/66
[ 3695.051038] firewire_core: rediscovered device fw0
[ 3695.241030] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3695.260113] ata3.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 3695.260116] ata3.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 3695.266255] ata3.00: configured for UDMA/133
[ 3699.422024] ata2: link is slow to respond, please be patient (ready=-19)
[ 3700.901043] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3700.920114] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 3700.920117] ata2.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 3700.926277] ata2.00: configured for UDMA/133
[ 3700.946230] sd 2:0:0:0: [sdb] Starting disk
[ 3701.093656] PM: resume devices took 7.646 seconds
[ 3701.093658] ------------[ cut here ]------------
[ 3701.093664] WARNING: at kernel/power/main.c:176 suspend_devices_and_enter+0x1af/0x1f8()
[ 3701.093666] Hardware name: MS-7250
[ 3701.093668] Component: resume devices
[ 3701.093669] Modules linked in: olympic rndis_wlan forcedeth [last unloaded: scsi_wait_scan]
[ 3701.093676] Pid: 30598, comm: pm-suspend Tainted: G        W  2.6.30 #37
[ 3701.093678] Call Trace:
[ 3701.093683]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 3701.093688]  [<ffffffff804639ea>] ? warn_slowpath_common+0x84/0xb2
[ 3701.093691]  [<ffffffff80463aa1>] ? warn_slowpath_fmt+0x50/0x6a
[ 3701.093694]  [<ffffffff80494764>] ? suspend_test_finish+0x58/0xaf
[ 3701.093698]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 3701.093701]  [<ffffffff80494b6a>] ? enter_state+0x166/0x1c1
[ 3701.093705]  [<ffffffff80494c86>] ? state_store+0xc1/0xf6
[ 3701.093709]  [<ffffffff80558114>] ? sysfs_write_file+0xe6/0x137
[ 3701.093712]  [<ffffffff804fa1f3>] ? vfs_write+0xb4/0x126
[ 3701.093715]  [<ffffffff804fa34d>] ? sys_write+0x55/0x90
[ 3701.093719]  [<ffffffff80429fab>] ? system_call_fastpath+0x16/0x1b
[ 3701.093722] ---[ end trace 47d39cdfa3f16ebb ]---
[ 3701.107066] PM: Finishing wakeup.
[ 3701.107067] Restarting tasks ... done.
[ 3703.108242] [drm] Loading RV620 CP Microcode
[ 3703.110706] [drm] Loading RV620 PFP Microcode
[ 3703.126188] [drm] Resetting GPU
[ 3703.482286] forcedeth 0000:00:09.0: irq 30 for MSI/MSI-X
[ 3703.482476] eth1: no link during initialization.
[ 3703.484689] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 3703.487978] forcedeth 0000:00:08.0: irq 31 for MSI/MSI-X
[ 3703.488173] eth0: no link during initialization.
[ 3703.490390] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 3703.602662] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3719.704978] rndis_wlan 1-6.1:1.0: rndis media connect
[ 3719.732934] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3730.587035] wlan0: no IPv6 routers present
[ 3780.492024] Hangcheck: hangcheck value past margin!
[ 5360.477096] rndis_wlan 1-6.1:1.0: rndis media disconnect
[ 5360.752845] [drm] Resetting GPU
[ 5360.896690] PM: Syncing filesystems ... done.
[ 5360.928975] PM: Preparing system for mem sleep
[ 5360.928993] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 5360.940615] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[ 5360.940898] PM: Entering mem sleep
[ 5360.940911] Suspending console(s) (use no_console_suspend to debug)
[ 5360.986024] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 5360.986164] sd 2:0:0:0: [sdb] Stopping disk
[ 5363.034015] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 5363.047420] sd 1:0:0:0: [sda] Stopping disk
[ 5363.422182] ACPI handle has no context!
[ 5363.422583] parport_pc 00:08: disabled
[ 5363.422936] serial 00:05: disabled
[ 5363.422964] HDA Intel 0000:07:00.1: PCI INT B disabled
[ 5363.422991] ACPI handle has no context!
[ 5363.433019] pci 0000:07:00.0: PCI INT A disabled
[ 5363.433046] ACPI handle has no context!
[ 5363.444017] olympic 0000:01:00.0: PCI INT A disabled
[ 5363.444311] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 5363.444316] forcedeth 0000:00:09.0: PME# disabled
[ 5363.455295] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 5363.455299] forcedeth 0000:00:08.0: PME# disabled
[ 5363.466020] HDA Intel 0000:00:06.1: PCI INT B disabled
[ 5363.477064] sata_nv 0000:00:05.2: PCI INT C disabled
[ 5363.488053] sata_nv 0000:00:05.1: PCI INT B disabled
[ 5363.499053] sata_nv 0000:00:05.0: PCI INT A disabled
[ 5363.510043] ata8: port disabled. ignoring.
[ 5363.521017] ehci_hcd 0000:00:02.1: PCI INT B disabled
[ 5363.521030] ehci_hcd 0000:00:02.1: PME# disabled
[ 5363.532016] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 5363.532029] ohci_hcd 0000:00:02.0: PME# disabled
[ 5363.543054] PM: suspend devices took 2.602 seconds
[ 5363.543486] ACPI: Preparing to enter system sleep state S3
[ 5363.544616] Disabling non-boot CPUs ...
[ 5363.545660] kvm: disabling virtualization on CPU1
[ 5363.546913] CPU 1 is now offline
[ 5363.546915] SMP alternatives: switching to UP code
[ 5363.551788] CPU1 is down
[ 5363.551797] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 5363.551797] Back to C!
[ 5363.551797] PCI-DMA: Resuming GART IOMMU
[ 5363.551797] PCI-DMA: Restoring GART aperture settings
[ 5363.555683] Enabling non-boot CPUs ...
[ 5363.555902] SMP alternatives: switching to SMP code
[ 5363.560289] Booting processor 1 APIC 0x1 ip 0x6000
[ 5363.551400] Initializing CPU#1
[ 5363.551400] Calibrating delay using timer specific routine.. 5200.05 BogoMIPS (lpj=2600025)
[ 5363.551400] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 5363.551400] CPU: L2 Cache: 512K (64 bytes/line)
[ 5363.551400] CPU: Physical Processor ID: 0
[ 5363.551400] CPU: Processor Core ID: 1
[ 5363.551400] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 5363.631441] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[ 5363.631474] kvm: enabling virtualization on CPU1
[ 5363.632267] Switched to high resolution mode on CPU 1
[ 5363.634207] CPU1 is up
[ 5363.634209] ACPI: Waking up from system sleep state S3
[ 5363.634890] pci 0000:00:00.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 5363.634920] pci 0000:00:00.0: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00106)
[ 5363.634938] pci 0000:00:01.0: restoring config space at offset 0xf (was 0x0, writing 0xff)
[ 5363.634945] pci 0000:00:01.0: restoring config space at offset 0x4 (was 0x1, writing 0x2f01)
[ 5363.634977] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00003)
[ 5363.634990] ehci_hcd 0000:00:02.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 5363.635046] pci 0000:00:06.0: restoring config space at offset 0x9 (was 0xfff0, writing 0xf000f000)
[ 5363.635050] pci 0000:00:06.0: restoring config space at offset 0x7 (was 0x280d0d0, writing 0x8280d0d0)
[ 5363.635066] HDA Intel 0000:00:06.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[ 5363.635082] forcedeth 0000:00:08.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9fa400)
[ 5363.635085] forcedeth 0000:00:08.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa800)
[ 5363.635103] forcedeth 0000:00:09.0: restoring config space at offset 0x7 (was 0x0, writing 0xfe9f4c00)
[ 5363.635107] forcedeth 0000:00:09.0: restoring config space at offset 0x6 (was 0x0, writing 0xfe9fa000)
[ 5363.635125] pcieport-driver 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 5363.635146] pcieport-driver 0000:00:0b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 5363.635165] pcieport-driver 0000:00:0c.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 5363.635185] pcieport-driver 0000:00:0d.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 5363.635205] pcieport-driver 0000:00:0e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100404)
[ 5363.635223] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x7 (was 0x2000e1e1, writing 0x6000e1e1)
[ 5363.635227] pcieport-driver 0000:00:0f.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[ 5363.635280] firewire_ohci 0000:01:04.0: restoring config space at offset 0xf (was 0x20000100, writing 0x2000010b)
[ 5363.635290] firewire_ohci 0000:01:04.0: restoring config space at offset 0x5 (was 0x1, writing 0xdc01)
[ 5363.635294] firewire_ohci 0000:01:04.0: restoring config space at offset 0x4 (was 0xd0000000, writing 0xfeafe800)
[ 5363.635298] firewire_ohci 0000:01:04.0: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[ 5363.635302] firewire_ohci 0000:01:04.0: restoring config space at offset 0x1 (was 0x2100080, writing 0x2100117)
[ 5363.635332] pci 0000:07:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
[ 5363.635364] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100000, writing 0x40100103)
[ 5363.635512] nForce2_smbus 0000:00:01.1: PME# disabled
[ 5363.635526] ohci_hcd 0000:00:02.0: PME# disabled
[ 5363.635533] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
[ 5363.635537] ohci_hcd 0000:00:02.0: setting latency timer to 64
[ 5363.635540] ohci_hcd 0000:00:02.0: PME# disabled
[ 5363.656030] ehci_hcd 0000:00:02.1: PME# disabled
[ 5363.656033] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
[ 5363.656037] ehci_hcd 0000:00:02.1: setting latency timer to 64
[ 5363.656040] ehci_hcd 0000:00:02.1: PME# disabled
[ 5363.656054] pata_amd 0000:00:04.0: setting latency timer to 64
[ 5363.656080] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
[ 5363.656083] sata_nv 0000:00:05.0: setting latency timer to 64
[ 5363.656108] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
[ 5363.656111] sata_nv 0000:00:05.1: setting latency timer to 64
[ 5363.656134] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
[ 5363.656137] sata_nv 0000:00:05.2: setting latency timer to 64
[ 5363.656149] pci 0000:00:06.0: setting latency timer to 64
[ 5363.656167] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[ 5363.656170] HDA Intel 0000:00:06.1: setting latency timer to 64
[ 5363.656204] forcedeth 0000:00:08.0: wake-up capability disabled by ACPI
[ 5363.656208] forcedeth 0000:00:08.0: PME# disabled
[ 5363.658567] ata8: port disabled. ignoring.
[ 5364.169350] forcedeth 0000:00:09.0: wake-up capability disabled by ACPI
[ 5364.169354] forcedeth 0000:00:09.0: PME# disabled
[ 5364.410912] ata6: SATA link down (SStatus 0 SControl 300)
[ 5364.411014] ata5: SATA link down (SStatus 0 SControl 300)
[ 5364.411021] ata4: SATA link down (SStatus 0 SControl 300)
[ 5364.682356] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 (level, low) -> IRQ 16
[ 5364.739017] pci 0000:07:00.0: PME# disabled
[ 5364.739024] pci 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 19 (level, low) -> IRQ 19
[ 5364.739028] pci 0000:07:00.0: setting latency timer to 64
[ 5364.739052] firewire_core: skipped bus generations, destroying all nodes
[ 5364.739060] HDA Intel 0000:07:00.1: restoring config space at offset 0x1 (was 0x100103, writing 0x40100103)
[ 5364.739074] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 17 (level, low) -> IRQ 17
[ 5364.739079] HDA Intel 0000:07:00.1: setting latency timer to 64
[ 5364.740617] serial 00:05: activated
[ 5364.742535] parport_pc 00:08: activated
[ 5364.762641] sd 1:0:0:0: [sda] Starting disk
[ 5364.817030] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 5364.820116] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 5364.820120] ata1.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 5364.826125] ata1.00: configured for UDMA/66
[ 5365.239034] firewire_core: rediscovered device fw0
[ 5365.561036] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 5365.580112] ata3.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 5365.580115] ata3.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 5365.586254] ata3.00: configured for UDMA/133
[ 5369.610022] ata2: link is slow to respond, please be patient (ready=-19)
[ 5369.865041] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 5369.884113] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[ 5369.884116] ata2.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
[ 5369.890275] ata2.00: configured for UDMA/133
[ 5369.905991] sd 2:0:0:0: [sdb] Starting disk
[ 5370.047568] PM: resume devices took 6.412 seconds
[ 5370.047569] ------------[ cut here ]------------
[ 5370.047576] WARNING: at kernel/power/main.c:176 suspend_devices_and_enter+0x1af/0x1f8()
[ 5370.047578] Hardware name: MS-7250
[ 5370.047580] Component: resume devices
[ 5370.047581] Modules linked in: olympic rndis_wlan forcedeth [last unloaded: scsi_wait_scan]
[ 5370.047588] Pid: 7551, comm: pm-suspend Tainted: G        W  2.6.30 #37
[ 5370.047590] Call Trace:
[ 5370.047595]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 5370.047599]  [<ffffffff804639ea>] ? warn_slowpath_common+0x84/0xb2
[ 5370.047603]  [<ffffffff80463aa1>] ? warn_slowpath_fmt+0x50/0x6a
[ 5370.047606]  [<ffffffff80494764>] ? suspend_test_finish+0x58/0xaf
[ 5370.047609]  [<ffffffff8049496a>] ? suspend_devices_and_enter+0x1af/0x1f8
[ 5370.047613]  [<ffffffff80494b6a>] ? enter_state+0x166/0x1c1
[ 5370.047616]  [<ffffffff80494c86>] ? state_store+0xc1/0xf6
[ 5370.047620]  [<ffffffff80558114>] ? sysfs_write_file+0xe6/0x137
[ 5370.047624]  [<ffffffff804fa1f3>] ? vfs_write+0xb4/0x126
[ 5370.047627]  [<ffffffff804fa34d>] ? sys_write+0x55/0x90
[ 5370.047631]  [<ffffffff80429fab>] ? system_call_fastpath+0x16/0x1b
[ 5370.047633] ---[ end trace 47d39cdfa3f16ebc ]---
[ 5370.060980] PM: Finishing wakeup.
[ 5370.060982] Restarting tasks ... done.
[ 5372.050740] [drm] Loading RV620 CP Microcode
[ 5372.053243] [drm] Loading RV620 PFP Microcode
[ 5372.068742] [drm] Resetting GPU
[ 5372.462248] forcedeth 0000:00:09.0: irq 30 for MSI/MSI-X
[ 5372.462443] eth1: no link during initialization.
[ 5372.464678] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 5372.470385] forcedeth 0000:00:08.0: irq 31 for MSI/MSI-X
[ 5372.470575] eth0: no link during initialization.
[ 5372.472788] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 5372.579678] ADDRCONF(NETDEV_UP): wlan0: link is not ready

config is:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc8
# Sat Jun  6 09:27:50 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_PARAVIRT is not set
# CONFIG_PARAVIRT_CLOCK is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x400000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_VS=y
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_GRE=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NF_NAT_AMANDA=y
CONFIG_NF_NAT_PPTP=y
CONFIG_NF_NAT_H323=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_SECURITY=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_QUEUE=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_MH=y
CONFIG_IP6_NF_MATCH_RT=y
CONFIG_IP6_NF_TARGET_HL=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_IP6_NF_SECURITY=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_IP6=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=y
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=m
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_DILNETPC is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_IFB=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=m
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
CONFIG_IBMOL=m
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_AR9170_USB is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set
# CONFIG_HERMES is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set

#
# SPI GPIO expanders:
#
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS65010 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TDA9875 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_TCM825X is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_CX25840 is not set

#
# MPEG video encoders
#
# CONFIG_VIDEO_CX2341X is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_ZC0301 is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set
# CONFIG_USB_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=y
CONFIG_SND_VIRMIDI=y
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_SMX is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_EXPORTFS=y
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_EVENT_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
# CONFIG_KVM_TRACE is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y


