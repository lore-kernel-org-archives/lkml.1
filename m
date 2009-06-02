Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZFBKGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZFBKGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 06:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZFBKGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 06:06:12 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:65040 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZFBKGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 06:06:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vYQdZudg2gP15z8oTdL4xCkKGIea32X+TVzav5eKYxVR+cCu5zuksNvy4X9WTGDtw3
         TtJS/6SutY2uNS7MwZnGFIJPPREg939c97QImeSmQNLZYC4gXxTXGJcdEzPgoBkCrGTa
         Z8b9uziz71+ou5pX5yFDMITtD5ZH6N1iekP4c=
MIME-Version: 1.0
Date: Tue, 2 Jun 2009 18:00:18 +0800
Message-ID: <a8e1da0906020300j6b001ff5qe888b184c963094e@mail.gmail.com>
Subject: suspend/hibernate lockdep warning
From: Dave Young <hidave.darkstar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git kernel with several bluetooth patch applied, suspend/hibernate
will trigger lockdep warning, please see the full dmesg dump, if
there's anything need to provide or test please just tell.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc7-00227-gd9244b5-dirty
(dave@darkstar) (gcc version 4.2.4) #51 SMP Tue Jun 2 13:07:55 CST
2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003d38d400 (usable)
[    0.000000]  BIOS-e820: 000000003d38d400 - 000000003d38f400 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003d38f400 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3d38d max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 03DC00000 mask FFFC00000 uncachable
[    0.000000]   3 base 03E000000 mask FFE000000 uncachable
[    0.000000]   4 base 03DB00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000003db00000 - 0000000040000000
(usable) ==> (reserved)
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000fbd10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 3d391e00 0006C (v01 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: FACP 3d391c9c 000F4 (v04 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: DSDT 3d392400 06357 (v02 INT430 SYSFexxx 00001001
INTL 20050624)
[    0.000000] ACPI: FACS 3d3a0c00 00040
[    0.000000] ACPI: HPET 3d391f00 00038 (v01 DELL    M09     00000001
ASL  00000061)
[    0.000000] ACPI: DMAR 3d3a0400 000F8 (v01 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: APIC 3d392000 00068 (v01 DELL    M09     27D90219
ASL  00000047)
[    0.000000] ACPI: ASF! 3d391c00 00076 (v32 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: MCFG 3d391fc0 0003E (v16 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: TCPA 3d392300 00032 (v01                 00000000
ASL  00000000)
[    0.000000] ACPI: BOOT 3d391bc0 00028 (v01 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: SSDT 3d3902eb 0066C (v01  PmRef    CpuPm 00003000
INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 91MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001b03e54]    TEXT DATA BSS ==>
[0001000000 - 0001b03e54]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #5 [0001b04000 - 0001b0c17c]              BRK ==>
[0001b04000 - 0001b0c17c]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003d38d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003d38d
[    0.000000] On node 0 totalpages: 250668
[    0.000000] free_area_init_node: node 0, pgdat c1545c80,
node_mem_map c1b0d000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 184 pages used for memmap
[    0.000000]   HighMem zone: 23255 pages, LIFO batch:3
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:b8000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c22c0000, static data 25052 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 248708
[    0.000000] Kernel command line: BOOT_IMAGE=dirty ro root=802
vt.default_utf8=0 resume=/dev/sda1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1994.880 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.003333] ... MAX_LOCKDEP_CHAINS:      32768
[    0.003333] ... CHAINHASH_SIZE:          16384
[    0.003333]  memory used by lock dependency info: 3487 kB
[    0.003333]  per task-struct memory footprint: 1152 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Initializing HighMem for node 0 (000377fe:0003d38d)
[    0.003333] Memory: 982232k/1003060k available (3363k kernel code,
20124k reserved, 2146k data, 352k init, 93756k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.003333]       .init : 0xc1567000 - 0xc15bf000   ( 352 kB)
[    0.003333]       .data : 0xc1348f7d - 0xc1561974   (2146 kB)
[    0.003333]       .text : 0xc1000000 - 0xc1348f7d   (3363 kB)
[    0.003333] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3991.00 BogoMIPS (lpj=6649600)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] using mwait in idle threads.
[    0.003333] Checking 'hlt' instruction... OK.
[    0.014575] ACPI: Core revision 20090320
[    0.030584] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064114] CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.066666] lockdep: fixing up alternatives.
[    0.066666] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine..
3991.26 BogoMIPS (lpj=6650020)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.158259] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.158303] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160064] Brought up 2 CPUs
[    0.160070] Total of 2 processors activated (7982.26 BogoMIPS).
[    0.160412] khelper used greatest stack depth: 6832 bytes left
[    0.160485] net_namespace: 636 bytes
[    0.160485] Booting paravirtualized kernel on bare hardware
[    0.163464] regulator: core version 0.5
[    0.163464] Time: 15:43:36  Date: 06/02/09
[    0.163546] NET: Registered protocol family 16
[    0.163628] ACPI: bus type pci registered
[    0.163628] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.163628] PCI: MCFG area at f8000000 reserved in E820
[    0.163628] PCI: Using MMCONFIG for extended config space
[    0.163628] PCI: Using configuration type 1 for base access
[    0.176798] bio: create slab <bio-0> at 0
[    0.184105] ACPI: EC: Look up EC in DSDT
[    0.184454] ACPI: BIOS _OSI(Linux) query ignored
[    0.224020] ACPI: SSDT 3d3a0c80 00043 (v01  LMPWR  DELLLOM 00001001
INTL 20050624)
[    0.253409] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.270332] ACPI: Interpreter enabled
[    0.270341] ACPI: (supports S0 S3 S4 S5)
[    0.270406] ACPI: Using IOAPIC for interrupt routing
[    0.383666] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.383675] ACPI: EC: driver started in interrupt mode
[    0.385274] ACPI: No dock devices found.
[    0.385305] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.385409] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    0.385409] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.385409] pci 0000:00:02.0: reg 20 io port: [0xefe8-0xefef]
[    0.385409] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    0.386837] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    0.386982] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    0.387126] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    0.387272] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.387378] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.387390] pci 0000:00:1a.7: PME# disabled
[    0.387481] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6afc000-0xf6afffff]
[    0.387575] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.387586] pci 0000:00:1b.0: PME# disabled
[    0.387717] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.387728] pci 0000:00:1c.0: PME# disabled
[    0.387864] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.387875] pci 0000:00:1c.1: PME# disabled
[    0.388016] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.388026] pci 0000:00:1c.4: PME# disabled
[    0.388145] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    0.388289] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    0.388433] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.388578] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.388683] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.388694] pci 0000:00:1d.7: PME# disabled
[    0.389072] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    0.389084] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    0.389095] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    0.389107] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    0.389119] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6ebf]
[    0.389130] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfed1c800-0xfed1cfff]
[    0.389204] pci 0000:00:1f.2: PME# supported from D3hot
[    0.389214] pci 0000:00:1f.2: PME# disabled
[    0.389279] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6afbf00-0xf6afbfff]
[    0.389308] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.389849] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fc000-0xf69fffff]
[    0.390108] pci 0000:0c:00.0: supports D1 D2
[    0.390111] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.390129] pci 0000:0c:00.0: PME# disabled
[    0.390298] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    0.390468] pci 0000:09:00.0: reg 10 64bit mmio: [0xf68f0000-0xf68fffff]
[    0.390612] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.390624] pci 0000:09:00.0: PME# disabled
[    0.390743] pci 0000:00:1c.4: bridge 32bit mmio: [0xf6800000-0xf68fffff]
[    0.390819] pci 0000:02:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.390855] pci 0000:02:01.0: supports D1 D2
[    0.390858] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.390869] pci 0000:02:01.0: PME# disabled
[    0.390934] pci 0000:02:01.1: reg 10 32bit mmio: [0xf67ff800-0xf67fffff]
[    0.391025] pci 0000:02:01.1: supports D1 D2
[    0.391027] pci 0000:02:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.391039] pci 0000:02:01.1: PME# disabled
[    0.391106] pci 0000:02:01.2: reg 10 32bit mmio: [0xf67ff600-0xf67ff6ff]
[    0.391196] pci 0000:02:01.2: supports D1 D2
[    0.391199] pci 0000:02:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.391211] pci 0000:02:01.2: PME# disabled
[    0.391276] pci 0000:02:01.3: reg 10 32bit mmio: [0xf67ff700-0xf67ff7ff]
[    0.391365] pci 0000:02:01.3: supports D1 D2
[    0.391367] pci 0000:02:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.391378] pci 0000:02:01.3: PME# disabled
[    0.391488] pci 0000:00:1e.0: transparent bridge
[    0.391503] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6700000-0xf67fffff]
[    0.391582] pci_bus 0000:00: on NUMA node 0
[    0.391591] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.392296] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.392550] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.392688] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.392833] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.421131] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.423425] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
[    0.423656] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *3
[    0.423886] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.424114] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.424349] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.424584] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.424789] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11
12 14 15) *0, disabled.
[    0.424910] SCSI subsystem initialized
[    0.424910] libata version 3.00 loaded.
[    0.424910] usbcore: registered new interface driver usbfs
[    0.424910] usbcore: registered new interface driver hub
[    0.426672] usbcore: registered new device driver usb
[    0.426763] PCI: Using ACPI for IRQ routing
[    0.486720] cfg80211: Using static regulatory domain info
[    0.486720] cfg80211: Regulatory domain: US
[    0.486721] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    0.486729] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.486737] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486744] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486751] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486758] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486766] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.486865] cfg80211: Calling CRDA for country: US
[    0.486976] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.486976] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.501730] Switched to high resolution mode on CPU 1
[    0.503338] Switched to high resolution mode on CPU 0
[    0.503355] pnp: PnP ACPI init
[    0.503390] ACPI: bus type pnp registered
[    0.583396] pnp: PnP ACPI: found 13 devices
[    0.583404] ACPI: ACPI bus type pnp unregistered
[    0.583430] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.583439] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.583459] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.583477] system 00:09: ioport range 0xcb0-0xcbb has been reserved
[    0.583486] system 00:09: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.583504] system 00:0a: ioport range 0x900-0x92f has been reserved
[    0.583512] system 00:0a: ioport range 0x931-0x933 has been reserved
[    0.583520] system 00:0a: ioport range 0x935-0x97f has been reserved
[    0.583528] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.583536] system 00:0a: ioport range 0x1000-0x1005 has been reserved
[    0.583544] system 00:0a: ioport range 0x1008-0x100f has been reserved
[    0.583562] system 00:0b: ioport range 0xf400-0xf4fe has been reserved
[    0.583571] system 00:0b: ioport range 0x1006-0x1007 has been reserved
[    0.583579] system 00:0b: ioport range 0x100a-0x1059 could not be reserved
[    0.583588] system 00:0b: ioport range 0x1060-0x107f has been reserved
[    0.583596] system 00:0b: ioport range 0x1080-0x10bf has been reserved
[    0.583604] system 00:0b: ioport range 0x1100-0x111f has been reserved
[    0.583612] system 00:0b: ioport range 0x1010-0x102f has been reserved
[    0.583620] system 00:0b: ioport range 0x809-0x809 has been reserved
[    0.583639] system 00:0c: iomem range 0x0-0x9efff could not be reserved
[    0.583647] system 00:0c: iomem range 0x9f000-0x9ffff could not be reserved
[    0.583656] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.583665] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.583674] system 00:0c: iomem range 0x100000-0x3d38d3ff could not
be reserved
[    0.583684] system 00:0c: iomem range 0x3d38d400-0x3dafffff could
not be reserved
[    0.583694] system 00:0c: iomem range 0x3db00000-0x3dbfffff has been reserved
[    0.583702] system 00:0c: iomem range 0xffe80000-0xffffffff has been reserved
[    0.583711] system 00:0c: iomem range 0xffa00000-0xffb7ffff has been reserved
[    0.583719] system 00:0c: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.583728] system 00:0c: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.583736] system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.583745] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.583754] system 00:0c: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.583762] system 00:0c: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.583771] system 00:0c: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.583780] system 00:0c: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.583788] system 00:0c: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    0.583797] system 00:0c: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.583805] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.620066] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.620074] pci 0000:00:1c.0:   IO window: disabled
[    0.620086] pci 0000:00:1c.0:   MEM window: disabled
[    0.620096] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.620111] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.620117] pci 0000:00:1c.1:   IO window: disabled
[    0.620130] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    0.620141] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.620156] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
[    0.620162] pci 0000:00:1c.4:   IO window: disabled
[    0.620174] pci 0000:00:1c.4:   MEM window: 0xf6800000-0xf68fffff
[    0.620185] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.620211] pci 0000:02:01.0: CardBus bridge, secondary bus 0000:03
[    0.620218] pci 0000:02:01.0:   IO window: 0x002000-0x0020ff
[    0.620228] pci 0000:02:01.0:   IO window: 0x002400-0x0024ff
[    0.620239] pci 0000:02:01.0:   PREFETCH window: 0x50000000-0x53ffffff
[    0.620251] pci 0000:02:01.0:   MEM window: 0x54000000-0x57ffffff
[    0.620262] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.620271] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.620284] pci 0000:00:1e.0:   MEM window: 0xf6700000-0xf67fffff
[    0.620295] pci 0000:00:1e.0:   PREFETCH window:
0x00000050000000-0x00000053ffffff
[    0.620327] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.620339] pci 0000:00:1c.0: setting latency timer to 64
[    0.620356] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.620367] pci 0000:00:1c.1: setting latency timer to 64
[    0.620381] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.620392] pci 0000:00:1c.4: setting latency timer to 64
[    0.620405] pci 0000:00:1e.0: setting latency timer to 64
[    0.620422] pci 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.620435] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.620438] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.620442] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    0.620445] pci_bus 0000:09: resource 1 mem: [0xf6800000-0xf68fffff]
[    0.620448] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.620452] pci_bus 0000:02: resource 1 mem: [0xf6700000-0xf67fffff]
[    0.620455] pci_bus 0000:02: resource 2 pref mem [0x50000000-0x53ffffff]
[    0.620458] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.620461] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    0.620464] pci_bus 0000:03: resource 0 io:  [0x2000-0x20ff]
[    0.620467] pci_bus 0000:03: resource 1 io:  [0x2400-0x24ff]
[    0.620470] pci_bus 0000:03: resource 2 pref mem [0x50000000-0x53ffffff]
[    0.620473] pci_bus 0000:03: resource 3 mem: [0x54000000-0x57ffffff]
[    0.620567] NET: Registered protocol family 2
[    0.663526] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.664383] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.664832] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.673164] TCP: Hash tables configured (established 131072 bind 65536)
[    0.673196] TCP reno registered
[    0.680235] NET: Registered protocol family 1
[    0.680753] Simple Boot Flag at 0x79 set to 0x1
[    0.683310] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.683887] audit: initializing netlink socket (disabled)
[    0.683926] type=2000 audit(1243957415.683:1): initialized
[    0.692070] highmem bounce pool size: 64 pages
[    0.692083] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.699509] VFS: Disk quotas dquot_6.5.2
[    0.699742] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.701725] msgmni has been set to 1735
[    0.702737] alg: No test for stdrng (krng)
[    0.703009] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.703034] io scheduler noop registered
[    0.703040] io scheduler anticipatory registered
[    0.703046] io scheduler deadline registered
[    0.703205] io scheduler cfq registered (default)
[    0.703229] pci 0000:00:02.0: Boot video device
[    0.703968] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.703996] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.704556] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.704583] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.705083] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
[    0.705111] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.705664] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.706445] ALI M7101 PMU not found.
[    0.706752] vesafb: framebuffer at 0xe0000000, mapped to
0xf8080000, using 3072k, total 32704k
[    0.706762] vesafb: mode is 1024x768x16, linelength=2048, pages=20
[    0.706768] vesafb: scrolling: redraw
[    0.706774] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.720528] Console: switching to colour frame buffer device 128x48
[    0.733477] fb0: VESA VGA frame buffer device
[    0.734168] ACPI: AC Adapter [AC] (on-line)
[    0.734728] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.737222] ACPI: Lid Switch [LID]
[    0.737494] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.737781] ACPI: Power Button [PBTN]
[    0.738116] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.738367] ACPI: Sleep Button [SBTN]
[    0.740405] ACPI: SSDT 3d390957 002C3 (v01  PmRef   BspIst 00003000
INTL 20050624)
[    0.741775] ACPI: SSDT 3d390df1 005C6 (v01  PmRef   BspCst 00003001
INTL 20050624)
[    0.744092] Monitor-Mwait will be used to enter C-1 state
[    0.744151] Monitor-Mwait will be used to enter C-2 state
[    0.744208] Monitor-Mwait will be used to enter C-3 state
[    0.744229] Marking TSC unstable due to TSC halts in idle
[    0.744621] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.745019] processor ACPI_CPU:00: registered as cooling_device0
[    0.745170] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.746054] ACPI: SSDT 3d390c1a 001D7 (v01  PmRef    ApIst 00003000
INTL 20050624)
[    0.747384] ACPI: SSDT 3d3913b7 0008D (v01  PmRef    ApCst 00003000
INTL 20050624)
[    0.749022] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.749296] processor ACPI_CPU:01: registered as cooling_device1
[    0.749447] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.780253] thermal LNXTHERM:01: registered as thermal_zone0
[    0.780412] ACPI: Thermal Zone [THM] (47 C)
[    0.789841] Non-volatile memory driver v1.3
[    0.790513] i8k: unable to get SMM BIOS version
[    0.796130] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal
Zotto (dz@debian.org)
[    0.802371] Linux agpgart interface v0.103
[    0.808181] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45
Express Chipset
[    0.814706] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.824316] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.830090] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    0.835884] Hangcheck: Using get_cycles().
[    0.841698] [drm] Initialized drm 1.1.0 20060810
[    0.847652] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.853365] pci 0000:00:02.0: setting latency timer to 64
[    0.855247] mtrr: type mismatch for e0000000,10000000 old:
write-back new: write-combining
[    0.861103] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.867002] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.902173] acpi device:36: registered as cooling_device2
[    0.912783] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
[    0.918787] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.926148] ACPI Warning (nspredef-0437): \_SB_.PCI0.VID2._DOD:
Return Package has no elements (empty) [20090320]
[    0.932708] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
[    0.939115] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[    0.945671] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.952268] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.966797] brd: module loaded
[    0.973812] ACPI: Battery Slot [BAT0] (battery present)
[    0.975447] loop: module loaded
[    0.975787] Loading iSCSI transport class v2.0-870.
[    0.976404] Driver 'sd' needs updating - please use bus_type methods
[    0.976504] Driver 'sr' needs updating - please use bus_type methods
[    0.976805] ahci 0000:00:1f.2: version 3.0
[    0.976826] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.976910] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    0.977024] ahci: SSS flag set, parallel bus scan disabled
[    0.977076] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3
Gbps 0x33 impl SATA mode
[    0.977080] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ems
[    0.977089] ahci 0000:00:1f.2: setting latency timer to 64
[    0.980468] scsi0 : ahci
[    0.981015] scsi1 : ahci
[    0.981309] scsi2 : ahci
[    0.981602] scsi3 : ahci
[    0.981898] scsi4 : ahci
[    0.982194] scsi5 : ahci
[    0.983232] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1c900 irq 28
[    0.983236] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1c980 irq 28
[    0.983239] ata3: DUMMY
[    0.983240] ata4: DUMMY
[    0.983243] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1cb00 irq 28
[    0.983247] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1cb80 irq 28
[    0.984282] tg3.c:v3.98 (February 25, 2009)
[    0.984339] tg3 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.984351] tg3 0000:09:00.0: setting latency timer to 64
[    1.111081] tg3 0000:09:00.0: PME# disabled
[    1.129835] eth0: Tigon3 [partno(BCM95756m) rev a200] (PCI Express)
MAC address 00:21:9b:f5:60:0f
[    1.135400] eth0: attached PHY is 5722/5756 (10/100/1000Base-T
Ethernet) (WireSpeed[1])
[    1.140999] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.146598] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.152353] sky2 driver version 1.22
[    1.158563] PPP generic driver version 2.4.2
[    1.164285] PPP Deflate Compression module registered
[    1.169723] PPP BSD Compression module registered
[    1.175542] PPP MPPE Compression module registered
[    1.180869] NET: Registered protocol family 24
[    1.186155] PPPoL2TP kernel driver, V1.0
[    1.191384] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels,
max=256) (6 bit encapsulation enabled).
[    1.196829] CSLIP: code copyright 1989 Regents of the University of
California.
[    1.202221] SLIP linefill/keepalive option.
[    1.207878] console [netcon0] enabled
[    1.213123] netconsole: network logging started
[    1.218428] yenta_cardbus 0000:02:01.0: CardBus bridge found [1028:0262]
[    1.423373] ata5: SATA link down (SStatus 0 SControl 300)
[    1.428456] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.430039] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.438483] ata1.00: ATA-8: ST9160310AS, DE04, max UDMA/133
[    1.443217] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    1.449479] ata1.00: configured for UDMA/133
[    1.454183] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633A, D500, max UDMA/100
[    1.458969] ata2.00: applying bridge limits
[    1.468078] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS
  DE04 PQ: 0 ANSI: 5
[    1.474356] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[    1.474372] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.484181] sd 0:0:0:0: [sda] Write Protect is off
[    1.484198] ata2.00: configured for UDMA/100
[    1.493852] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.493914] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.499277]  sda:<5>scsi 1:0:0:0: CD-ROM            TSSTcorp
DVD+-RW TS-L633A D500 PQ: 0 ANSI: 5
[    1.522308] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    1.527326] Uniform CD-ROM driver Revision: 3.20
[    1.532874] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.533144] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.759234]  sda1 sda2 sda3 sda4 < sda5 >
[    1.805832] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.853368] ata6: SATA link down (SStatus 4 SControl 300)
[    1.997743] yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    2.003170] yenta_cardbus 0000:02:01.0: Socket status: 30000006
[    2.008653] pci_bus 0000:02: Raising subordinate bus# of parent bus
(#02) from #03 to #06
[    2.014243] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
I/O window: 0x2000 - 0x2fff
[    2.020016] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
Memory window: 0xf6700000 - 0xf67fffff
[    2.025749] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
Memory window: 0x50000000 - 0x53ffffff
[    2.283705] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.289463] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.295222] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.295228] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.301519] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    2.311123] ehci_hcd 0000:00:1a.7: debug port 1
[    2.316664] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.316694] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.334201] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.339836] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.345324] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.350844] usb usb1: Product: EHCI Host Controller
[    2.356339] usb usb1: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty ehci_hcd
[    2.361929] usb usb1: SerialNumber: 0000:00:1a.7
[    2.367828] usb usb1: configuration #1 chosen from 1 choice
[    2.373762] hub 1-0:1.0: USB hub found
[    2.379410] hub 1-0:1.0: 6 ports detected
[    2.385773] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.391237] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.391242] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.396704] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    2.406032] ehci_hcd 0000:00:1d.7: debug port 1
[    2.411412] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.411439] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.430851] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.436150] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.441475] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.446883] usb usb2: Product: EHCI Host Controller
[    2.452237] usb usb2: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty ehci_hcd
[    2.457677] usb usb2: SerialNumber: 0000:00:1d.7
[    2.463242] usb usb2: configuration #1 chosen from 1 choice
[    2.468769] hub 2-0:1.0: USB hub found
[    2.474113] hub 2-0:1.0: 6 ports detected
[    2.479491] async/1 used greatest stack depth: 6680 bytes left
[    2.479811] uhci_hcd: USB Universal Host Controller Interface driver
[    2.479855] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.479866] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.479870] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.479993] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    2.480043] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    2.480122] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.480124] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.480127] usb usb3: Product: UHCI Host Controller
[    2.480129] usb usb3: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty uhci_hcd
[    2.480132] usb usb3: SerialNumber: 0000:00:1a.0
[    2.480331] usb usb3: configuration #1 chosen from 1 choice
[    2.480474] hub 3-0:1.0: USB hub found
[    2.480542] hub 3-0:1.0: 2 ports detected
[    2.480926] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.480935] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.480940] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.481069] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    2.481119] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    2.481194] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.481197] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.481200] usb usb4: Product: UHCI Host Controller
[    2.481202] usb usb4: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty uhci_hcd
[    2.481204] usb usb4: SerialNumber: 0000:00:1a.1
[    2.481401] usb usb4: configuration #1 chosen from 1 choice
[    2.481545] hub 4-0:1.0: USB hub found
[    2.481560] hub 4-0:1.0: 2 ports detected
[    2.481912] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.481921] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    2.481925] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    2.482049] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    2.482084] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    2.482186] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.482189] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.482192] usb usb5: Product: UHCI Host Controller
[    2.482194] usb usb5: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty uhci_hcd
[    2.482196] usb usb5: SerialNumber: 0000:00:1a.2
[    2.482393] usb usb5: configuration #1 chosen from 1 choice
[    2.482536] hub 5-0:1.0: USB hub found
[    2.482549] hub 5-0:1.0: 2 ports detected
[    2.482908] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.482917] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.482922] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.483045] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    2.483080] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    2.483155] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.483158] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.483160] usb usb6: Product: UHCI Host Controller
[    2.483162] usb usb6: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty uhci_hcd
[    2.483164] usb usb6: SerialNumber: 0000:00:1d.0
[    2.483381] usb usb6: configuration #1 chosen from 1 choice
[    2.483532] hub 6-0:1.0: USB hub found
[    2.483546] hub 6-0:1.0: 2 ports detected
[    2.483899] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.483909] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.483913] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.484040] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    2.484075] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    2.484149] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.484152] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.484154] usb usb7: Product: UHCI Host Controller
[    2.484156] usb usb7: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty uhci_hcd
[    2.484159] usb usb7: SerialNumber: 0000:00:1d.1
[    2.484357] usb usb7: configuration #1 chosen from 1 choice
[    2.484502] hub 7-0:1.0: USB hub found
[    2.484515] hub 7-0:1.0: 2 ports detected
[    2.484871] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.484880] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.484884] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.485038] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    2.485073] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.485149] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.485152] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.485154] usb usb8: Product: UHCI Host Controller
[    2.485156] usb usb8: Manufacturer: Linux
2.6.30-rc7-00227-gd9244b5-dirty uhci_hcd
[    2.485159] usb usb8: SerialNumber: 0000:00:1d.2
[    2.485360] usb usb8: configuration #1 chosen from 1 choice
[    2.485503] hub 8-0:1.0: USB hub found
[    2.485517] hub 8-0:1.0: 2 ports detected
[    2.485970] Initializing USB Mass Storage driver...
[    2.486108] usbcore: registered new interface driver usb-storage
[    2.486113] USB Mass Storage support registered.
[    2.486509] usbcore: registered new interface driver libusual
[    2.486771] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[    2.487298] i8042.c: Warning: Keylock active.
[    2.877411] async/2 used greatest stack depth: 6456 bytes left
[    2.884291] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.889351] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.894483] async/0 used greatest stack depth: 6432 bytes left
[    2.894643] mice: PS/2 mouse device common for all mice
[    2.895990] rtc_cmos 00:03: RTC can wake from S4
[    2.896243] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.896286] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.896382] i2c /dev entries driver
[    2.896613] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    2.929803] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
[    2.935150] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    2.940480] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
[    2.945854] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.950921] iTCO_vendor_support: vendor-support=0
[    2.956194] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input5
[    2.956551] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    2.957625] cpuidle: using governor ladder
[    2.973578] cpuidle: using governor menu
[    2.979017] sdhci: Secure Digital Host Controller Interface driver
[    2.984394] sdhci: Copyright(c) Pierre Ossman
[    2.989745] sdhci-pci 0000:02:01.2: SDHCI controller found
[1180:0822] (rev 21)
[    2.995111] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[    3.002810] Registered led device: mmc0::
[    3.009323] mmc0: SDHCI controller on PCI [0000:02:01.2] using DMA
[    3.014980] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.020310] wbsd: Copyright(c) Pierre Ossman
[    3.026336] dcdbas dcdbas: Dell Systems Management Base Driver
(version 5.6.0-3.2)
[    3.034284] usbcore: registered new interface driver hiddev
[    3.039902] usbcore: registered new interface driver usbhid
[    3.045313] usbhid: v2.6:USB HID core driver
[    3.077224] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    3.082690] ALSA device list:
[    3.088067]   No soundcards found.
[    3.093396] Netfilter messages via NETLINK v0.30.
[    3.098826] nf_conntrack version 0.5.0 (15672 buckets, 62688 max)
[    3.105240] ctnetlink v0.93: registering with nfnetlink.
[    3.112508] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.117959] TCP cubic registered
[    3.123254] NET: Registered protocol family 17
[    3.128589] lib80211: common routines for IEEE802.11 drivers
[    3.133992] lib80211_crypt: registered algorithm 'NULL'
[    3.136209] Using IPI No-Shortcut mode
[    3.142008] PM: Checking image partition /dev/sda1
[    3.142052] PM: Resume from partition 8:1
[    3.142054] PM: Checking hibernation image.
[    3.142597] PM: Resume from disk failed.
[    3.142650] registered taskstats version 1
[    3.148330]   Magic number: 13:423:739
[    3.153687] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    3.282944] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
[    3.305659] input: AlpsPS/2 ALPS GlidePoint as
/devices/platform/i8042/serio1/input/input7
[    3.321298] md: Waiting for all devices to be available before autodetect
[    3.332390] md: If you don't use raid, use raid=noautodetect
[    3.346389] md: Autodetecting RAID arrays.
[    3.357595] md: Scanned 0 and added 0 devices.
[    3.368730] md: autorun ...
[    3.379668] md: ... autorun DONE.
[    3.500188] Clocksource tsc unstable (delta = -226952928 ns)
[    3.678889] kjournald starting.  Commit interval 5 seconds
[    3.690742] EXT3-fs: mounted filesystem with writeback data mode.
[    3.702033] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    3.713227] Freeing unused kernel memory: 352k freed
[    3.725244] Write protecting the kernel text: 3364k
[    3.736633] Write protecting the kernel read-only data: 1808k
[    4.876981] mount used greatest stack depth: 5944 bytes left
[    6.200137] modprobe used greatest stack depth: 5888 bytes left
[    6.343973] ACPI: WMI: Mapper loaded
[    6.589519] ohci1394 0000:02:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.656531] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    6.874071] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[    6.885322] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.294132] input: HDA Intel Mic at Ext Right Jack as
/devices/pci0000:00/0000:00:1b.0/input/input8
[    7.306218] input: HDA Intel Line Out at Sep Left Jack as
/devices/pci0000:00/0000:00:1b.0/input/input9
[    7.318869] input: HDA Intel HP Out at Ext Right Jack as
/devices/pci0000:00/0000:00:1b.0/input/input10
[    7.692016] Adding 1004020k swap on /dev/sda1.  Priority:-1
extents:1 across:1004020k
[    7.947364] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
[    9.385716] EXT3 FS on sda2, internal journal
[   13.884721] kjournald starting.  Commit interval 5 seconds
[   13.897477] EXT3 FS on sda3, internal journal
[   13.909591] EXT3-fs: mounted filesystem with writeback data mode.
[   14.092947] kjournald starting.  Commit interval 5 seconds
[   14.098695] EXT3-fs warning: maximal mount count reached, running
e2fsck is recommended
[   14.108890] EXT3 FS on sda5, internal journal
[   14.120900] EXT3-fs: mounted filesystem with writeback data mode.
[   23.427293] Bluetooth: Core ver 2.15
[   23.428189] NET: Registered protocol family 31
[   23.428195] Bluetooth: HCI device and connection manager initialized
[   23.428393] Bluetooth: HCI socket layer initialized
[   23.567284] Bluetooth: L2CAP ver 2.13
[   23.567292] Bluetooth: L2CAP socket layer initialized
[   24.143802] Bluetooth: SCO (Voice Link) ver 0.6
[   24.143810] Bluetooth: SCO socket layer initialized
[   24.217583] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.217593] Bluetooth: BNEP filters: protocol multicast
[   24.836796] update-mime-dat used greatest stack depth: 5864 bytes left
[   26.006159] smbd used greatest stack depth: 5636 bytes left
[   42.831168] mtrr: type mismatch for e0000000,10000000 old:
write-back new: write-combining
[  820.650435] tg3 0000:09:00.0: PME# disabled
[  820.651546] tg3 0000:09:00.0: irq 29 for MSI/MSI-X
[  822.270345] tg3: eth0: Link is up at 100 Mbps, full duplex.
[  822.270355] tg3: eth0: Flow control is on for TX and on for RX.
[ 1768.287580] kio_http used greatest stack depth: 5208 bytes left
[ 1818.286019] kio_http used greatest stack depth: 5124 bytes left
[ 3508.573910]
[ 3508.573911] =======================================================
[ 3508.574131] [ INFO: possible circular locking dependency detected ]
[ 3508.574298] 2.6.30-rc7-00227-gd9244b5-dirty #51
[ 3508.574416] -------------------------------------------------------
[ 3508.574571] 94cpufreq/5275 is trying to acquire lock:
[ 3508.574694]  (&(&dbs_info->work)->work){+.+...}, at: [<c10365ee>]
__cancel_work_timer+0x8c/0x18c
[ 3508.574936]
[ 3508.574937] but task is already holding lock:
[ 3508.575084]  (dbs_mutex){+.+.+.}, at: [<c127297b>]
cpufreq_governor_dbs+0x1ee/0x267
[ 3508.575299]
[ 3508.575299] which lock already depends on the new lock.
[ 3508.575301]
[ 3508.575509]
[ 3508.575510] the existing dependency chain (in reverse order) is:
[ 3508.575712]
[ 3508.575713] -> #2 (dbs_mutex){+.+.+.}:
[ 3508.575868]        [<c1047d33>] __lock_acquire+0x91e/0xaa9
[ 3508.576024]        [<c1047f59>] lock_acquire+0x9b/0xbe
[ 3508.576165]        [<c1344414>] __mutex_lock_common+0x35/0x2d2
[ 3508.576327]        [<c1344749>] mutex_lock_nested+0x2e/0x36
[ 3508.576486]        [<c12727fd>] cpufreq_governor_dbs+0x70/0x267
[ 3508.576650]        [<c1270007>] __cpufreq_governor+0x66/0x9d
[ 3508.576809]        [<c1270193>] __cpufreq_set_policy+0x155/0x1c3
[ 3508.576973]        [<c127109b>] cpufreq_add_dev+0x4d4/0x5f6
[ 3508.577120]        [<c11c2bc9>] sysdev_driver_register+0x96/0xe5
[ 3508.577175]        [<c12713df>] cpufreq_register_driver+0xa1/0x168
[ 3508.577175]        [<c156f8cf>] acpi_cpufreq_init+0x99/0xab
[ 3508.577175]        [<c1001137>] do_one_initcall+0x4a/0x11a
[ 3508.577175]        [<c156750a>] kernel_init+0xfe/0x14f
[ 3508.577175]        [<c1003d1f>] kernel_thread_helper+0x7/0x10
[ 3508.577175]        [<ffffffff>] 0xffffffff
[ 3508.577175]
[ 3508.577175] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[ 3508.577175]        [<c1047d33>] __lock_acquire+0x91e/0xaa9
[ 3508.577175]        [<c1047f59>] lock_acquire+0x9b/0xbe
[ 3508.577175]        [<c1344923>] down_write+0x2f/0x4b
[ 3508.577175]        [<c1270a1c>] lock_policy_rwsem_write+0x33/0x5b
[ 3508.578971]        [<c1272597>] do_dbs_timer+0x45/0x23b
[ 3508.578971]        [<c1036bc6>] worker_thread+0x170/0x23c
[ 3508.578971]        [<c1039409>] kthread+0x45/0x6c
[ 3508.578971]        [<c1003d1f>] kernel_thread_helper+0x7/0x10
[ 3508.578971]        [<ffffffff>] 0xffffffff
[ 3508.578971]
[ 3508.578971] -> #0 (&(&dbs_info->work)->work){+.+...}:
[ 3508.578971]        [<c1047c43>] __lock_acquire+0x82e/0xaa9
[ 3508.578971]        [<c1047f59>] lock_acquire+0x9b/0xbe
[ 3508.578971]        [<c1036619>] __cancel_work_timer+0xb7/0x18c
[ 3508.578971]        [<c10366f9>] cancel_delayed_work_sync+0xb/0xd
[ 3508.578971]        [<c127298a>] cpufreq_governor_dbs+0x1fd/0x267
[ 3508.578971]        [<c1270007>] __cpufreq_governor+0x66/0x9d
[ 3508.578971]        [<c127017d>] __cpufreq_set_policy+0x13f/0x1c3
[ 3508.578971]        [<c1270645>] store_scaling_governor+0x159/0x188
[ 3508.578971]        [<c12711ff>] store+0x42/0x5b
[ 3508.578971]        [<c10cc0ed>] sysfs_write_file+0xb8/0xe3
[ 3508.578971]        [<c10900a0>] vfs_write+0x82/0xdc
[ 3508.578971]        [<c109018f>] sys_write+0x3b/0x5d
[ 3508.578971]        [<c10032dd>] syscall_call+0x7/0xb
[ 3508.578971]        [<ffffffff>] 0xffffffff
[ 3508.578971]
[ 3508.578971] other info that might help us debug this:
[ 3508.578971]
[ 3508.578971] 3 locks held by 94cpufreq/5275:
[ 3508.578971]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10cc05a>]
sysfs_write_file+0x25/0xe3
[ 3508.578971]  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
[<c1270a1c>] lock_policy_rwsem_write+0x33/0x5b
[ 3508.578971]  #2:  (dbs_mutex){+.+.+.}, at: [<c127297b>]
cpufreq_governor_dbs+0x1ee/0x267
[ 3508.578971]
[ 3508.578971] stack backtrace:
[ 3508.578971] Pid: 5275, comm: 94cpufreq Not tainted
2.6.30-rc7-00227-gd9244b5-dirty #51
[ 3508.578971] Call Trace:
[ 3508.578971]  [<c10468b9>] print_circular_bug_tail+0x5d/0x68
[ 3508.578971]  [<c1047c43>] __lock_acquire+0x82e/0xaa9
[ 3508.578971]  [<c1046439>] ? mark_lock+0x1e/0x1c7
[ 3508.578971]  [<c1047f59>] lock_acquire+0x9b/0xbe
[ 3508.578971]  [<c10365ee>] ? __cancel_work_timer+0x8c/0x18c
[ 3508.578971]  [<c1036619>] __cancel_work_timer+0xb7/0x18c
[ 3508.578971]  [<c10365ee>] ? __cancel_work_timer+0x8c/0x18c
[ 3508.578971]  [<c1046747>] ? trace_hardirqs_on_caller+0x10a/0x146
[ 3508.578971]  [<c13446a7>] ? __mutex_lock_common+0x2c8/0x2d2
[ 3508.578971]  [<c10366f9>] cancel_delayed_work_sync+0xb/0xd
[ 3508.578971]  [<c127298a>] cpufreq_governor_dbs+0x1fd/0x267
[ 3508.578971]  [<c103c5ab>] ? up_read+0x16/0x29
[ 3508.578971]  [<c1270007>] __cpufreq_governor+0x66/0x9d
[ 3508.578971]  [<c127017d>] __cpufreq_set_policy+0x13f/0x1c3
[ 3508.578971]  [<c12704ec>] ? store_scaling_governor+0x0/0x188
[ 3508.578971]  [<c1270645>] store_scaling_governor+0x159/0x188
[ 3508.578971]  [<c1270b4d>] ? handle_update+0x0/0x28
[ 3508.578971]  [<c1270a1c>] ? lock_policy_rwsem_write+0x33/0x5b
[ 3508.578971]  [<c12704ec>] ? store_scaling_governor+0x0/0x188
[ 3508.578971]  [<c12711ff>] store+0x42/0x5b
[ 3508.578971]  [<c10cc0ed>] sysfs_write_file+0xb8/0xe3
[ 3508.578971]  [<c10900a0>] vfs_write+0x82/0xdc
[ 3508.578971]  [<c10cc035>] ? sysfs_write_file+0x0/0xe3
[ 3508.578971]  [<c109018f>] sys_write+0x3b/0x5d
[ 3508.578971]  [<c10032dd>] syscall_call+0x7/0xb
[ 3509.211597] PM: Syncing filesystems ... done.
[ 3509.215505] PM: Preparing system for mem sleep
[ 3509.215518] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 3509.215902] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[ 3509.215963] PM: Entering mem sleep
[ 3509.215976] Suspending console(s) (use no_console_suspend to debug)
[ 3509.723360] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3509.723603] sd 0:0:0:0: [sda] Stopping disk
[ 3510.107827] ACPI handle has no context!
[ 3510.107834] sdhci-pci 0000:02:01.2: PME# disabled
[ 3510.107842] sdhci-pci 0000:02:01.2: PCI INT C disabled
[ 3510.107849] ACPI handle has no context!
[ 3510.124990] ACPI handle has no context!
[ 3510.183595] tg3 0000:09:00.0: PME# enabled
[ 3510.263231] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 3510.263311] ehci_hcd 0000:00:1d.7: PME# disabled
[ 3510.276561] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 3510.276637] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 3510.276708] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 3510.303232] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 3510.316561] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 3510.316641] ehci_hcd 0000:00:1a.7: PME# disabled
[ 3510.329889] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 3510.329964] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 3510.330036] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 3510.338676] ACPI: Preparing to enter system sleep state S3
[ 3510.370343] Disabling non-boot CPUs ...
[ 3510.473013] CPU 1 is now offline
[ 3510.473016] lockdep: fixing up alternatives.
[ 3510.473019] SMP alternatives: switching to UP code
[ 3510.476717] CPU1 is down
[ 3510.476773] Extended CMOS year: 2000
[ 3510.476773] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 3510.476773] Back to C!
[ 3510.476773] Extended CMOS year: 2000
[ 3510.476773] Enabling non-boot CPUs ...
[ 3510.476773] lockdep: fixing up alternatives.
[ 3510.476773] SMP alternatives: switching to SMP code
[ 3510.479959] Booting processor 1 APIC 0x1 ip 0x6000
[ 3510.476374] Initializing CPU#1
[ 3510.476374] Calibrating delay using timer specific routine..
3991.33 BogoMIPS (lpj=6650129)
[ 3510.476374] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 3510.476374] CPU: L2 cache: 2048K
[ 3510.476374] CPU: Physical Processor ID: 0
[ 3510.476374] CPU: Processor Core ID: 1
[ 3510.476374] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 3510.574730] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[ 3510.576337] Switched to high resolution mode on CPU 1
[ 3510.586480] microcode: failed to init CPU1
[ 3510.587167] CPU1 is up
[ 3510.587170] ACPI: Waking up from system sleep state S3
[ 3510.773459] pci 0000:00:02.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[ 3510.773469] pci 0000:00:02.0: restoring config space at offset 0x8
(was 0x1, writing 0xefe9)
[ 3510.773476] pci 0000:00:02.0: restoring config space at offset 0x6
(was 0xc, writing 0xe000000c)
[ 3510.773484] pci 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900403)
[ 3510.773520] pci 0000:00:02.1: restoring config space at offset 0x4
(was 0x4, writing 0xf6b00004)
[ 3510.773527] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[ 3510.773545] uhci_hcd 0000:00:1a.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[ 3510.773562] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x8 (was 0x1, writing 0x6f61)
[ 3510.773579] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 3510.773603] uhci_hcd 0000:00:1a.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 3510.773620] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f81)
[ 3510.773637] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 3510.773660] uhci_hcd 0000:00:1a.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 3510.773677] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x8 (was 0x1, writing 0x6fa1)
[ 3510.773694] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 3510.773750] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 3510.773791] HDA Intel 0000:00:1b.0: restoring config space at
offset 0xf (was 0x100, writing 0x107)
[ 3510.773815] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x4 (was 0xfebfc004, writing 0xf6afc004)
[ 3510.773822] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x3 (was 0x0, writing 0x10)
[ 3510.773830] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100102)
[ 3510.773869] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 3510.773884] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 3510.773890] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x8 (was 0x0, writing 0xfff0)
[ 3510.773897] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 3510.773904] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0b00)
[ 3510.773914] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 3510.773923] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 3510.773989] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0xf (was 0x200, writing 0x20200)
[ 3510.774005] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 3510.774011] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x8 (was 0x0, writing 0xf690f690)
[ 3510.774018] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 3510.774025] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x6 (was 0x0, writing 0xc0c00)
[ 3510.774035] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 3510.774044] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 3510.774110] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 3510.774125] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 3510.774132] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x8 (was 0x0, writing 0xf680f680)
[ 3510.774139] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 3510.774146] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x6 (was 0x0, writing 0x90900)
[ 3510.774156] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 3510.774165] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x1 (was 0x100000, writing 0x100407)
[ 3510.774247] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[ 3510.774270] uhci_hcd 0000:00:1d.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 3510.774287] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f21)
[ 3510.774304] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 3510.774327] uhci_hcd 0000:00:1d.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 3510.774344] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x8 (was 0x1, writing 0x6f41)
[ 3510.774361] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 3510.774417] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 3510.774458] pci 0000:00:1e.0: restoring config space at offset 0x9
(was 0x1fff1, writing 0x53f15001)
[ 3510.774466] pci 0000:00:1e.0: restoring config space at offset 0x7
(was 0x2280e0f0, writing 0x22802020)
[ 3510.774473] pci 0000:00:1e.0: restoring config space at offset 0x6
(was 0x20020200, writing 0x20060200)
[ 3510.774538] pci 0000:00:1f.0: restoring config space at offset 0x1
(was 0x2100007, writing 0x2100107)
[ 3510.774576] ahci 0000:00:1f.2: restoring config space at offset 0xf
(was 0x400, writing 0x40a)
[ 3510.774605] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[ 3510.774654] i801_smbus 0000:00:1f.3: restoring config space at
offset 0xf (was 0x200, writing 0x204)
[ 3510.774678] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x4 (was 0x4, writing 0xf6afbf04)
[ 3510.774688] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x1 (was 0x2800001, writing 0x2800103)
[ 3510.774957] pci 0000:0c:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x104)
[ 3510.775022] pci 0000:0c:00.0: restoring config space at offset 0x4
(was 0x4, writing 0xf69fc004)
[ 3510.775036] pci 0000:0c:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 3510.775054] pci 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 3510.775203] tg3 0000:09:00.0: restoring config space at offset 0xc
(was 0x0, writing 0x33040000)
[ 3510.775230] tg3 0000:09:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 3510.775240] tg3 0000:09:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100506)
[ 3510.775335] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xf (was 0x7000100, writing 0x580010a)
[ 3510.775342] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xe (was 0x0, writing 0x24fc)
[ 3510.775349] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xd (was 0x0, writing 0x2400)
[ 3510.775355] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xc (was 0x0, writing 0x20fc)
[ 3510.775362] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xb (was 0x0, writing 0x2000)
[ 3510.775369] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xa (was 0x0, writing 0x57fff000)
[ 3510.775376] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x9 (was 0x0, writing 0x54000000)
[ 3510.775382] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x8 (was 0x0, writing 0x53fff000)
[ 3510.775389] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x7 (was 0x0, writing 0x50000000)
[ 3510.775396] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0060302)
[ 3510.775404] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x4 (was 0x0, writing 0xf6700000)
[ 3510.775411] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x3 (was 0x820000, writing 0x82a800)
[ 3510.775419] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100007)
[ 3510.775447] ohci1394 0000:02:01.1: restoring config space at offset
0xf (was 0x4020200, writing 0x4020204)
[ 3510.775475] ohci1394 0000:02:01.1: restoring config space at offset
0x3 (was 0x800000, writing 0x804010)
[ 3510.775484] ohci1394 0000:02:01.1: restoring config space at offset
0x1 (was 0x2100000, writing 0x2100106)
[ 3510.775510] sdhci-pci 0000:02:01.2: restoring config space at
offset 0xf (was 0x300, writing 0x303)
[ 3510.775536] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x4 (was 0x0, writing 0xf67ff600)
[ 3510.775542] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804010)
[ 3510.775552] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100106)
[ 3510.775577] pci 0000:02:01.3: restoring config space at offset 0xf
(was 0x300, writing 0x303)
[ 3510.775604] pci 0000:02:01.3: restoring config space at offset 0x4
(was 0x0, writing 0xf67ff700)
[ 3510.775610] pci 0000:02:01.3: restoring config space at offset 0x3
(was 0x800000, writing 0x804010)
[ 3510.775619] pci 0000:02:01.3: restoring config space at offset 0x1
(was 0x2100000, writing 0x2100106)
[ 3510.905711] pci 0000:00:02.0: PME# disabled
[ 3510.905718] pci 0000:00:02.1: PME# disabled
[ 3510.905771] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 3510.905779] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 3510.905806] usb usb3: root hub lost power or was reset
[ 3510.905868] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 3510.905876] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 3510.905903] usb usb4: root hub lost power or was reset
[ 3510.905964] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 3510.905971] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 3510.905998] usb usb5: root hub lost power or was reset
[ 3510.906074] ehci_hcd 0000:00:1a.7: PME# disabled
[ 3510.906079] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 3510.906087] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 3510.906095] ehci_hcd 0000:00:1a.7: PME# disabled
[ 3510.906160] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[ 3510.906167] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 3510.906241] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 3510.906248] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 3510.906275] usb usb6: root hub lost power or was reset
[ 3510.906335] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 3510.906362] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 3510.906389] usb usb7: root hub lost power or was reset
[ 3510.906450] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 3510.906457] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 3510.906484] usb usb8: root hub lost power or was reset
[ 3510.906560] ehci_hcd 0000:00:1d.7: PME# disabled
[ 3510.906565] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 3510.906573] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 3510.906581] ehci_hcd 0000:00:1d.7: PME# disabled
[ 3510.906593] pci 0000:00:1e.0: setting latency timer to 64
[ 3510.906688] ahci 0000:00:1f.2: setting latency timer to 64
[ 3510.910217] pci 0000:0c:00.0: PME# disabled
[ 3510.910301] tg3 0000:09:00.0: restoring config space at offset 0xc
(was 0x0, writing 0x33040000)
[ 3510.910415] tg3 0000:09:00.0: PME# disabled
[ 3510.912779] tg3: eth0: Link is down.
[ 3511.181915] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[ 3511.188023] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[ 3511.189049] pci 0000:02:01.3: PME# disabled
[ 3511.189208] pci 0000:00:02.0: setting latency timer to 64
[ 3511.190275] sd 0:0:0:0: [sda] Starting disk
[ 3511.303224] ata6: SATA link down (SStatus 4 SControl 300)
[ 3511.303252] ata5: SATA link down (SStatus 0 SControl 300)
[ 3511.303288] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3511.371362] ata2.00: configured for UDMA/100
[ 3511.433220] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[ 3511.433225] ata2: irq_stat 0x40000001
[ 3511.499083] ata2.00: configured for UDMA/100
[ 3511.499089] ata2: EH complete
[ 3512.529890] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3512.533700] ata1.00: configured for UDMA/133
[ 3512.546550] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[ 3512.546554] ata1: irq_stat 0x00400040, connection status changed
[ 3512.550306] ata1.00: configured for UDMA/133
[ 3512.550311] ata1: EH complete
[ 3512.586293] tg3: eth0: Link is up at 100 Mbps, full duplex.
[ 3512.586295] tg3: eth0: Flow control is on for TX and on for RX.
[ 3512.667745] PM: Finishing wakeup.
[ 3512.667750] Restarting tasks ... done.
