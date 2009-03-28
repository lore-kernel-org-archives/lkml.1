Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbZC1Gg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbZC1Gg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 02:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZC1GgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 02:36:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:3148 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZC1Gf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 02:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ozbWDeuUJqXDJiD6ggiROrNxkECDdbSVUtC7Sptqh1UeBQhatD5UZiqUnnmymL6YGj
         bDCEKcsmHURH7/Y2jS92WErpdQHxUCYeW+rukN8bQtIRZ85EeDNPsgfxuWLnMPtYvbwQ
         FZGtWa+fw31lc6qKSx6AiD65qStV4atnOOGU0=
MIME-Version: 1.0
Date: Sat, 28 Mar 2009 14:35:56 +0800
Message-ID: <a8e1da0903272335scc5ee66sdaaa170d982dc116@mail.gmail.com>
Subject: Clocksource tsc unstable
From: Dave Young <hidave.darkstar@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My laptop is dell e5400 with  intel core 2 duo 7250, kernel version
2.6.29, dmesg report tsc unstable, anyone can help to see?

bash-3.1$ dmesg|grep tsc
[    5.000170] Clocksource tsc unstable (delta = -367383694 ns)

bash-3.1$ dmesg|grep hpet
[    0.003333] hpet clockevent registered
[    0.573483] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.573483] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    4.287649] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   33.686946] CE: hpet increasing min_delta_ns to 15000 nsec
[ 2050.286749] CE: hpet increasing min_delta_ns to 22500 nsec

Full dmesg:
-------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29 (dave@darkstar) (gcc version
4.2.4) #14 SMP Thu Mar 26 15:24:29 CST 2009
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 373fe000 @ 7000-d000
[    0.000000] ACPI: RSDP 000FBD10, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 3D391E00, 0074 (r1 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI: FACP 3D391C9C, 00F4 (r4 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in
Gpe0Block: 128/64 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match
PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 3D392400, 632E (r2 INT430 SYSFexxx     1001
INTL 20050624)
[    0.000000] ACPI: FACS 3D3A0C00, 0040
[    0.000000] ACPI: HPET 3D391F00, 0038 (r1 DELL    M09            1
ASL        61)
[    0.000000] ACPI: DMAR 3D3A0400, 00F8 (r1 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI: APIC 3D392000, 0068 (r1 DELL    M09     27D8091A
ASL        47)
[    0.000000] ACPI: ASF! 3D391C00, 0076 (r32 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI: MCFG 3D391FC0, 003E (r16 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI: SLIC 3D39209C, 0024 (r1 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI: TCPA 3D392300, 0032 (r1                        0
ASL         0)
[    0.000000] ACPI: BOOT 3D391BC0, 0028 (r1 DELL    M09     27D8091A
ASL        61)
[    0.000000] ACPI: SSDT 3D3902EF, 066C (r1  PmRef    CpuPm     3000
INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 95MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 00000000 - 373fe000
[    0.000000]   bootmap 00008000 - 0000ee80
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00019e2fcc]    TEXT DATA BSS ==>
[0001000000 - 00019e2fcc]
[    0.000000]   #4 [00019e3000 - 00019eb000]    INIT_PG_TABLE ==>
[00019e3000 - 00019eb000]
[    0.000000]   #5 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003d38d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003d38d
[    0.000000] On node 0 totalpages: 250668
[    0.000000] free_area_init_node: node 0, pgdat c1510900,
node_mem_map c19eb000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2821 pages used for memmap
[    0.000000]   Normal zone: 219385 pages, LIFO batch:31
[    0.000000]   HighMem zone: 311 pages used for memmap
[    0.000000]   HighMem zone: 24152 pages, LIFO batch:3
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
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 247484
[    0.000000] Kernel command line: BOOT_IMAGE=29 ro root=802 vt.default_utf8=0
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1995.234 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2335 kB
[    0.003333]  per task-struct memory footprint: 1152 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 978516k/1003060k available (3251k kernel code,
23852k reserved, 2330k data, 352k init, 97852k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xffc78000 - 0xfffff000   (3612 kB)
[    0.003333]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.003333]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.003333]       .init : 0xc1579000 - 0xc15d1000   ( 352 kB)
[    0.003333]       .data : 0xc132ccc0 - 0xc15736c0   (2330 kB)
[    0.003333]       .text : 0xc1000000 - 0xc132ccc0   (3251 kB)
[    0.003333] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3992.73 BogoMIPS (lpj=6650780)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] [ds] using Core 2/Atom configuration
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] using mwait in idle threads.
[    0.003333] Checking 'hlt' instruction... OK.
[    0.014511] ACPI: Core revision 20081204
[    0.043553] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076570] CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.076666] lockdep: fixing up alternatives.
[    0.076666] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine..
3991.24 BogoMIPS (lpj=6649993)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] [ds] using Core 2/Atom configuration
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.168204] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.168250] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.170108] Brought up 2 CPUs
[    0.170114] Total of 2 processors activated (7983.98 BogoMIPS).
[    0.170384] khelper used greatest stack depth: 6936 bytes left
[    0.170440] net_namespace: 592 bytes
[    0.170440] Booting paravirtualized kernel on bare hardware
[    0.173423] regulator: core version 0.5
[    0.173454] Time: 10:36:30  Date: 03/27/09
[    0.173548] NET: Registered protocol family 16
[    0.173633] ACPI: bus type pci registered
[    0.173633] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.173633] PCI: MCFG area at f8000000 reserved in E820
[    0.173633] PCI: Using MMCONFIG for extended config space
[    0.173633] PCI: Using configuration type 1 for base access
[    0.196753] bio: create slab <bio-0> at 0
[    0.200762] ACPI: EC: Look up EC in DSDT
[    0.201414] ACPI: BIOS _OSI(Linux) query ignored
[    0.258469] ACPI: SSDT 3D3A0C80, 0043 (r1  LMPWR  DELLLOM     1001
INTL 20050624)
[    0.306707] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.307892] ACPI: Interpreter enabled
[    0.307892] ACPI: (supports S0 S3 S4 S5)
[    0.307892] ACPI: Using IOAPIC for interrupt routing
[    0.473745] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.473745] ACPI: EC: driver started in interrupt mode
[    0.477018] ACPI: No dock devices found.
[    0.477054] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.477194] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    0.477194] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.477194] pci 0000:00:02.0: reg 20 io port: [0xefe8-0xefef]
[    0.477194] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    0.477194] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    0.477235] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    0.477364] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    0.477493] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.477586] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.477597] pci 0000:00:1a.7: PME# disabled
[    0.477678] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6afc000-0xf6afffff]
[    0.477761] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.477771] pci 0000:00:1b.0: PME# disabled
[    0.477889] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.477899] pci 0000:00:1c.0: PME# disabled
[    0.478020] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.478030] pci 0000:00:1c.1: PME# disabled
[    0.478161] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.478171] pci 0000:00:1c.4: PME# disabled
[    0.478276] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    0.478404] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    0.478532] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.478660] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.478753] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.478763] pci 0000:00:1d.7: PME# disabled
[    0.479104] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    0.479114] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    0.479124] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    0.479134] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    0.479144] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6ebf]
[    0.479155] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfed1c800-0xfed1cfff]
[    0.479220] pci 0000:00:1f.2: PME# supported from D3hot
[    0.479230] pci 0000:00:1f.2: PME# disabled
[    0.479288] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6afbf00-0xf6afbfff]
[    0.479314] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.480384] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fc000-0xf69fffff]
[    0.480627] pci 0000:0c:00.0: supports D1 D2
[    0.480630] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.480647] pci 0000:0c:00.0: PME# disabled
[    0.480794] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    0.480952] pci 0000:09:00.0: reg 10 64bit mmio: [0xf68f0000-0xf68fffff]
[    0.481084] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.481095] pci 0000:09:00.0: PME# disabled
[    0.481192] pci 0000:00:1c.4: bridge 32bit mmio: [0xf6800000-0xf68fffff]
[    0.481270] pci 0000:02:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.481303] pci 0000:02:01.0: supports D1 D2
[    0.481305] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.481316] pci 0000:02:01.0: PME# disabled
[    0.481378] pci 0000:02:01.1: reg 10 32bit mmio: [0xf67ff800-0xf67fffff]
[    0.481457] pci 0000:02:01.1: supports D1 D2
[    0.481460] pci 0000:02:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.481471] pci 0000:02:01.1: PME# disabled
[    0.481532] pci 0000:02:01.2: reg 10 32bit mmio: [0xf67ff600-0xf67ff6ff]
[    0.481612] pci 0000:02:01.2: supports D1 D2
[    0.481614] pci 0000:02:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.481626] pci 0000:02:01.2: PME# disabled
[    0.481686] pci 0000:02:01.3: reg 10 32bit mmio: [0xf67ff700-0xf67ff7ff]
[    0.481765] pci 0000:02:01.3: supports D1 D2
[    0.481767] pci 0000:02:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.481778] pci 0000:02:01.3: PME# disabled
[    0.481867] pci 0000:00:1e.0: transparent bridge
[    0.481880] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6700000-0xf67fffff]
[    0.481951] pci_bus 0000:00: on NUMA node 0
[    0.481963] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.484314] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.484990] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.485347] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.485715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.537111] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.537577] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
[    0.538040] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *3
[    0.538499] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.540305] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.540775] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.541243] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.541621] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11
12 14 15) *0, disabled.
[    0.543605] SCSI subsystem initialized
[    0.543605] libata version 3.00 loaded.
[    0.543605] usbcore: registered new interface driver usbfs
[    0.543605] usbcore: registered new interface driver hub
[    0.543605] usbcore: registered new device driver usb
[    0.546804] PCI: Using ACPI for IRQ routing
[    0.573478] cfg80211: Using static regulatory domain info
[    0.573478] cfg80211: Regulatory domain: US
[    0.573478] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    0.573478] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.573478] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.573478] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.573478] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.573478] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.573478] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.573478] cfg80211: Calling CRDA for country: US
[    0.573478] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.573478] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.580023] Switched to high resolution mode on CPU 0
[    0.581691] Switched to high resolution mode on CPU 1
[    0.594205] pnp: PnP ACPI init
[    0.594247] ACPI: bus type pnp registered
[    0.736606] pnp: PnP ACPI: found 13 devices
[    0.736613] ACPI: ACPI bus type pnp unregistered
[    0.736640] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.736650] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.736670] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.736688] system 00:09: ioport range 0xcb0-0xcbb has been reserved
[    0.736696] system 00:09: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.736714] system 00:0a: ioport range 0x900-0x92f has been reserved
[    0.736721] system 00:0a: ioport range 0x931-0x933 has been reserved
[    0.736729] system 00:0a: ioport range 0x935-0x97f has been reserved
[    0.736737] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.736745] system 00:0a: ioport range 0x1000-0x1005 has been reserved
[    0.736753] system 00:0a: ioport range 0x1008-0x100f has been reserved
[    0.736770] system 00:0b: ioport range 0xf400-0xf4fe has been reserved
[    0.736778] system 00:0b: ioport range 0x1006-0x1007 has been reserved
[    0.736788] system 00:0b: ioport range 0x100a-0x1059 could not be reserved
[    0.736796] system 00:0b: ioport range 0x1060-0x107f has been reserved
[    0.736804] system 00:0b: ioport range 0x1080-0x10bf has been reserved
[    0.736812] system 00:0b: ioport range 0x1100-0x111f has been reserved
[    0.736819] system 00:0b: ioport range 0x1010-0x102f has been reserved
[    0.736827] system 00:0b: ioport range 0x809-0x809 has been reserved
[    0.736846] system 00:0c: iomem range 0x0-0x9efff could not be reserved
[    0.736857] system 00:0c: iomem range 0x9f000-0x9ffff could not be reserved
[    0.736867] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.736877] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.736888] system 00:0c: iomem range 0x100000-0x3d38d3ff could not
be reserved
[    0.736899] system 00:0c: iomem range 0x3d38d400-0x3dafffff could
not be reserved
[    0.736908] system 00:0c: iomem range 0x3db00000-0x3dbfffff has been reserved
[    0.736916] system 00:0c: iomem range 0xffe80000-0xffffffff has been reserved
[    0.736925] system 00:0c: iomem range 0xffa00000-0xffb7ffff has been reserved
[    0.736933] system 00:0c: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.736941] system 00:0c: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.736958] system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.736967] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.736975] system 00:0c: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.736983] system 00:0c: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.736992] system 00:0c: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.737000] system 00:0c: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.737008] system 00:0c: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    0.737016] system 00:0c: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.737024] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.773886] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.773894] pci 0000:00:1c.0:   IO window: disabled
[    0.773905] pci 0000:00:1c.0:   MEM window: disabled
[    0.773914] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.773928] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.773933] pci 0000:00:1c.1:   IO window: disabled
[    0.773945] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    0.773955] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.773968] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
[    0.773974] pci 0000:00:1c.4:   IO window: disabled
[    0.773985] pci 0000:00:1c.4:   MEM window: 0xf6800000-0xf68fffff
[    0.773995] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.774022] pci 0000:02:01.0: CardBus bridge, secondary bus 0000:03
[    0.774029] pci 0000:02:01.0:   IO window: 0x002000-0x0020ff
[    0.774038] pci 0000:02:01.0:   IO window: 0x002400-0x0024ff
[    0.774048] pci 0000:02:01.0:   PREFETCH window: 0x50000000-0x53ffffff
[    0.774059] pci 0000:02:01.0:   MEM window: 0x54000000-0x57ffffff
[    0.774068] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.774076] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.774088] pci 0000:00:1e.0:   MEM window: 0xf6700000-0xf67fffff
[    0.774098] pci 0000:00:1e.0:   PREFETCH window:
0x00000050000000-0x00000053ffffff
[    0.774128] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.774139] pci 0000:00:1c.0: setting latency timer to 64
[    0.774154] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.774164] pci 0000:00:1c.1: setting latency timer to 64
[    0.774182] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.774192] pci 0000:00:1c.4: setting latency timer to 64
[    0.774204] pci 0000:00:1e.0: setting latency timer to 64
[    0.774218] pci 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.774230] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.774233] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.774236] pci_bus 0000:0b: resource 0 mem: [0x0-0x0]
[    0.774238] pci_bus 0000:0b: resource 1 mem: [0x0-0x0]
[    0.774240] pci_bus 0000:0b: resource 2 mem: [0x0-0x0]
[    0.774242] pci_bus 0000:0b: resource 3 mem: [0x0-0x0]
[    0.774245] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.774247] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    0.774250] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.774252] pci_bus 0000:0c: resource 3 mem: [0x0-0x0]
[    0.774254] pci_bus 0000:09: resource 0 mem: [0x0-0x0]
[    0.774257] pci_bus 0000:09: resource 1 mem: [0xf6800000-0xf68fffff]
[    0.774259] pci_bus 0000:09: resource 2 mem: [0x0-0x0]
[    0.774261] pci_bus 0000:09: resource 3 mem: [0x0-0x0]
[    0.774264] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.774266] pci_bus 0000:02: resource 1 mem: [0xf6700000-0xf67fffff]
[    0.774269] pci_bus 0000:02: resource 2 mem: [0x50000000-0x53ffffff]
[    0.774271] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.774273] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    0.774276] pci_bus 0000:03: resource 0 io:  [0x2000-0x20ff]
[    0.774278] pci_bus 0000:03: resource 1 io:  [0x2400-0x24ff]
[    0.774281] pci_bus 0000:03: resource 2 mem: [0x50000000-0x53ffffff]
[    0.774283] pci_bus 0000:03: resource 3 mem: [0x54000000-0x57ffffff]
[    0.774371] NET: Registered protocol family 2
[    0.817664] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.818345] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.818794] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.824355] TCP: Hash tables configured (established 131072 bind 65536)
[    0.824405] TCP reno registered
[    0.834393] NET: Registered protocol family 1
[    0.835362] Simple Boot Flag at 0x79 set to 0x1
[    0.838748] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.839531] audit: initializing netlink socket (disabled)
[    0.839581] type=2000 audit(1238150190.837:1): initialized
[    0.847488] highmem bounce pool size: 64 pages
[    0.847507] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.863744] VFS: Disk quotas dquot_6.5.2
[    0.863987] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.866650] msgmni has been set to 1720
[    0.868353] alg: No test for stdrng (krng)
[    0.868692] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.868714] io scheduler noop registered
[    0.868719] io scheduler anticipatory registered
[    0.868724] io scheduler deadline registered
[    0.869070] io scheduler cfq registered (default)
[    0.869097] pci 0000:00:02.0: Boot video device
[    0.869736] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.869847] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.870347] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.870454] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.870952] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.871059] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
[    0.871821] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.872875] ALI M7101 PMU not found.
[    0.873468] vesafb: framebuffer at 0xe0000000, mapped to
0xf7c80000, using 3072k, total 32704k
[    0.873477] vesafb: mode is 1024x768x16, linelength=2048, pages=20
[    0.873483] vesafb: scrolling: redraw
[    0.873488] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.886616] Console: switching to colour frame buffer device 128x48
[    0.898981] fb0: VESA VGA frame buffer device
[    0.899577] ACPI: AC Adapter [AC] (on-line)
[    0.981557] ACPI: Battery Slot [BAT0] (battery present)
[    0.982380] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.986958] ACPI: Lid Switch [LID]
[    0.988190] input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.988401] ACPI: Power Button (CM) [PBTN]
[    0.988736] input: Sleep Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.988942] ACPI: Sleep Button (CM) [SBTN]
[    0.994482] ACPI: SSDT 3D39095B, 02C3 (r1  PmRef   BspIst     3000
INTL 20050624)
[    0.996079] ACPI: SSDT 3D390DF5, 05C6 (r1  PmRef   BspCst     3001
INTL 20050624)
[    0.998868] Monitor-Mwait will be used to enter C-1 state
[    0.998909] Monitor-Mwait will be used to enter C-2 state
[    0.998922] Monitor-Mwait will be used to enter C-3 state
[    0.999241] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.002780] processor ACPI_CPU:00: registered as cooling_device0
[    1.002931] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.004960] ACPI: SSDT 3D390C1E, 01D7 (r1  PmRef    ApIst     3000
INTL 20050624)
[    1.006630] ACPI: SSDT 3D3913BB, 008D (r1  PmRef    ApCst     3000
INTL 20050624)
[    1.010221] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.010530] processor ACPI_CPU:01: registered as cooling_device1
[    1.010679] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.059400] thermal LNXTHERM:01: registered as thermal_zone0
[    1.069211] ACPI: Thermal Zone [THM] (26 C)
[    1.101786] Non-volatile memory driver v1.3
[    1.102404] i8k: unable to get SMM BIOS version
[    1.107808] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal
Zotto (dz@debian.org)
[    1.113660] Linux agpgart interface v0.103
[    1.119243] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45
Express Chipset
[    1.125574] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    1.134743] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.140367] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    1.145929] Hangcheck: Using get_cycles().
[    1.151552] [drm] Initialized drm 1.1.0 20060810
[    1.157240] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.162781] pci 0000:00:02.0: setting latency timer to 64
[    1.164683] mtrr: type mismatch for e0000000,10000000 old:
write-back new: write-combining
[    1.170347] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    1.176029] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    1.176058] [drm] Initialized i915 1.6.0 20080730 on minor 0
[    1.181716] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.194720] brd: module loaded
[    1.203514] loop: module loaded
[    1.209352] tg3.c:v3.97 (December 10, 2008)
[    1.215308] tg3 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.221109] tg3 0000:09:00.0: setting latency timer to 64
[    1.227740] tg3 0000:09:00.0: PME# disabled
[    1.245961] eth0: Tigon3 [partno(BCM95756m) rev a200] (PCI Express)
MAC address 00:21:9b:f5:60:0f
[    1.251805] eth0: attached PHY is 5722/5756 (10/100/1000Base-T
Ethernet) (WireSpeed[1])
[    1.257633] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.263441] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.269494] sky2 driver version 1.22
[    1.276369] PPP generic driver version 2.4.2
[    1.282412] PPP Deflate Compression module registered
[    1.288133] PPP BSD Compression module registered
[    1.294096] PPP MPPE Compression module registered
[    1.299814] NET: Registered protocol family 24
[    1.305459] PPPoL2TP kernel driver, V1.0
[    1.310994] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels,
max=256) (6 bit encapsulation enabled).
[    1.316680] CSLIP: code copyright 1989 Regents of the University of
California.
[    1.322344] SLIP linefill/keepalive option.
[    1.328109] console [netcon0] enabled
[    1.333563] netconsole: network logging started
[    1.339227] Loading iSCSI transport class v2.0-870.
[    1.345489] Driver 'sd' needs updating - please use bus_type methods
[    1.351126] Driver 'sr' needs updating - please use bus_type methods
[    1.356913] ahci 0000:00:1f.2: version 3.0
[    1.356927] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.362438] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    1.362506] ahci: SSS flag set, parallel bus scan disabled
[    1.367943] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3
Gbps 0x33 impl SATA mode
[    1.373529] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ems
[    1.379113] ahci 0000:00:1f.2: setting latency timer to 64
[    1.379532] scsi0 : ahci
[    1.385974] scsi1 : ahci
[    1.391697] scsi2 : ahci
[    1.397350] scsi3 : ahci
[    1.402890] scsi4 : ahci
[    1.408375] scsi5 : ahci
[    1.414942] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1c900 irq 28
[    1.420126] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1c980 irq 28
[    1.425164] ata3: DUMMY
[    1.430070] ata4: DUMMY
[    1.434905] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1cb00 irq 28
[    1.439909] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1cb80 irq 28
[    1.763357] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.769360] ata1.00: ATA-8: ST9160310AS, DE04, max UDMA/133
[    1.774173] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    1.780457] ata1.00: configured for UDMA/133
[    1.797268] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS
  DE04 PQ: 0 ANSI: 5
[    1.803007] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[    1.807824] sd 0:0:0:0: [sda] Write Protect is off
[    1.812526] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.812601] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.818012] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[    1.822922] sd 0:0:0:0: [sda] Write Protect is off
[    1.827772] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.827851] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.832815]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    2.144263] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.149885] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.473357] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.491048] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633A, D500, max UDMA/100
[    2.495854] ata2.00: applying bridge limits
[    2.515246] ata2.00: configured for UDMA/100
[    2.535725] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW
TS-L633A D500 PQ: 0 ANSI: 5
[    2.548010] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.552974] Uniform CD-ROM driver Revision: 3.20
[    2.558435] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.558735] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.883355] ata5: SATA link down (SStatus 0 SControl 300)
[    3.220020] ata6: SATA link down (SStatus 4 SControl 300)
[    3.237420] yenta_cardbus 0000:02:01.0: CardBus bridge found [1028:0262]
[    3.368817] yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    3.373549] yenta_cardbus 0000:02:01.0: Socket status: 30000006
[    3.378248] pci_bus 0000:02: Raising subordinate bus# of parent bus
(#02) from #03 to #06
[    3.383107] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
I/O window: 0x2000 - 0x2fff
[    3.388078] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
Memory window: 0xf6700000 - 0xf67fffff
[    3.392994] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
Memory window: 0x50000000 - 0x53ffffff
[    3.650372] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.655315] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.660257] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.660262] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.665885] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    3.674660] ehci_hcd 0000:00:1a.7: debug port 1
[    3.679396] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.679424] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    3.700010] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.704992] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.709988] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.715056] usb usb1: Product: EHCI Host Controller
[    3.720182] usb usb1: Manufacturer: Linux 2.6.29 ehci_hcd
[    3.725269] usb usb1: SerialNumber: 0000:00:1a.7
[    3.730781] usb usb1: configuration #1 chosen from 1 choice
[    3.736184] hub 1-0:1.0: USB hub found
[    3.741394] hub 1-0:1.0: 6 ports detected
[    3.747347] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.752606] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.752611] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.757919] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    3.767058] ehci_hcd 0000:00:1d.7: debug port 1
[    3.772174] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.772202] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    3.793343] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.798440] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.803470] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.808486] usb usb2: Product: EHCI Host Controller
[    3.813450] usb usb2: Manufacturer: Linux 2.6.29 ehci_hcd
[    3.818359] usb usb2: SerialNumber: 0000:00:1d.7
[    3.823429] usb usb2: configuration #1 chosen from 1 choice
[    3.828424] hub 2-0:1.0: USB hub found
[    3.833163] hub 2-0:1.0: 6 ports detected
[    3.838389] uhci_hcd: USB Universal Host Controller Interface driver
[    3.843384] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.848203] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.848208] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.853203] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    3.857990] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    3.862846] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.867609] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.872310] usb usb3: Product: UHCI Host Controller
[    3.876954] usb usb3: Manufacturer: Linux 2.6.29 uhci_hcd
[    3.876955] usb usb3: SerialNumber: 0000:00:1a.0
[    3.886345] usb usb3: configuration #1 chosen from 1 choice
[    3.891191] hub 3-0:1.0: USB hub found
[    3.895850] hub 3-0:1.0: 2 ports detected
[    3.900872] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.905576] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.905581] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.910342] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    3.914953] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    3.919583] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.924245] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.928822] usb usb4: Product: UHCI Host Controller
[    3.933337] usb usb4: Manufacturer: Linux 2.6.29 uhci_hcd
[    3.937865] usb usb4: SerialNumber: 0000:00:1a.1
[    3.942599] usb usb4: configuration #1 chosen from 1 choice
[    3.947285] hub 4-0:1.0: USB hub found
[    3.951802] hub 4-0:1.0: 2 ports detected
[    3.956708] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.961269] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.961273] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.965934] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    3.970486] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    3.975079] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.979662] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.984259] usb usb5: Product: UHCI Host Controller
[    3.988831] usb usb5: Manufacturer: Linux 2.6.29 uhci_hcd
[    3.993447] usb usb5: SerialNumber: 0000:00:1a.2
[    3.998268] usb usb5: configuration #1 chosen from 1 choice
[    4.003020] hub 5-0:1.0: USB hub found
[    4.007588] hub 5-0:1.0: 2 ports detected
[    4.012522] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.017169] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.017173] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.022001] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    4.026663] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    4.031362] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.035996] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.040645] usb usb6: Product: UHCI Host Controller
[    4.045294] usb usb6: Manufacturer: Linux 2.6.29 uhci_hcd
[    4.049953] usb usb6: SerialNumber: 0000:00:1d.0
[    4.054806] usb usb6: configuration #1 chosen from 1 choice
[    4.059665] hub 6-0:1.0: USB hub found
[    4.064301] hub 6-0:1.0: 2 ports detected
[    4.069273] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.073946] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.073950] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.078730] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    4.083420] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    4.088102] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.092758] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.097380] usb usb7: Product: UHCI Host Controller
[    4.102047] usb usb7: Manufacturer: Linux 2.6.29 uhci_hcd
[    4.106684] usb usb7: SerialNumber: 0000:00:1d.1
[    4.111528] usb usb7: configuration #1 chosen from 1 choice
[    4.116339] hub 7-0:1.0: USB hub found
[    4.120989] hub 7-0:1.0: 2 ports detected
[    4.125956] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.130634] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.130639] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.135422] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    4.140124] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    4.144822] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.149472] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.154099] usb usb8: Product: UHCI Host Controller
[    4.158709] usb usb8: Manufacturer: Linux 2.6.29 uhci_hcd
[    4.163336] usb usb8: SerialNumber: 0000:00:1d.2
[    4.168177] usb usb8: configuration #1 chosen from 1 choice
[    4.172979] hub 8-0:1.0: USB hub found
[    4.177624] hub 8-0:1.0: 2 ports detected
[    4.182737] Initializing USB Mass Storage driver...
[    4.187464] usbcore: registered new interface driver usb-storage
[    4.192365] USB Mass Storage support registered.
[    4.197249] usbcore: registered new interface driver libusual
[    4.202129] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[    4.207338] i8042.c: Warning: Keylock active.
[    4.215813] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.220503] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.225353] mice: PS/2 mouse device common for all mice
[    4.271487] rtc_cmos 00:03: RTC can wake from S4
[    4.276397] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.281112] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.285912] i2c /dev entries driver
[    4.290946] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    4.295993] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    4.301486] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    4.306647] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
[    4.311715] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.316714] iTCO_vendor_support: vendor-support=0
[    4.322619] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    4.328640] cpuidle: using governor ladder
[    4.335631] cpuidle: using governor menu
[    4.340003] Marking TSC unstable due to TSC halts in idle
[    4.345789] sdhci: Secure Digital Host Controller Interface driver
[    4.350817] sdhci: Copyright(c) Pierre Ossman
[    4.355857] sdhci-pci 0000:02:01.2: SDHCI controller found
[1180:0822] (rev 21)
[    4.360963] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[    4.368532] Registered led device: mmc0::
[    4.373835] mmc0: SDHCI controller on PCI [0000:02:01.2] using DMA
[    4.379079] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    4.384132] wbsd: Copyright(c) Pierre Ossman
[    4.390078] dcdbas dcdbas: Dell Systems Management Base Driver
(version 5.6.0-3.2)
[    4.398578] usbcore: registered new interface driver hiddev
[    4.403991] usbcore: registered new interface driver usbhid
[    4.409191] usbhid: v2.6:USB HID core driver
[    4.414669] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    4.419883] ALSA device list:
[    4.425206]   No soundcards found.
[    4.430437] Netfilter messages via NETLINK v0.30.
[    4.435615] nf_conntrack version 0.5.0 (15672 buckets, 62688 max)
[    4.441539] ctnetlink v0.93: registering with nfnetlink.
[    4.448313] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.453565] TCP cubic registered
[    4.458677] NET: Registered protocol family 17
[    4.463846] lib80211: common routines for IEEE802.11 drivers
[    4.469057] lib80211_crypt: registered algorithm 'NULL'
[    4.472374] Using IPI No-Shortcut mode
[    4.478184] registered taskstats version 1
[    4.483784]   Magic number: 1:650:629
[    4.488978] pci_bus 0000:0b: hash matches
[    4.693418] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input4
[    4.747786] input: AlpsPS/2 ALPS GlidePoint as
/devices/platform/i8042/serio1/input/input5
[    4.806974] md: Waiting for all devices to be available before autodetect
[    4.817713] md: If you don't use raid, use raid=noautodetect
[    4.830929] md: Autodetecting RAID arrays.
[    4.841489] md: Scanned 0 and added 0 devices.
[    4.852156] md: autorun ...
[    4.862719] md: ... autorun DONE.
[    5.000171] Clocksource tsc unstable (delta = -360351512 ns)
[    5.161134] kjournald starting.  Commit interval 5 seconds
[    5.172298] EXT3-fs: mounted filesystem with ordered data mode.
[    5.183152] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    5.194143] Freeing unused kernel memory: 352k freed
[    5.205313] Write protecting the kernel text: 3252k
[    5.216004] Write protecting the kernel read-only data: 1552k
[    5.348178] khelper used greatest stack depth: 6668 bytes left
[    6.269771] mount used greatest stack depth: 6096 bytes left
[    7.668233] ohci1394 0000:02:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    7.729734] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    7.784404] wl: module license 'unspecified' taints kernel.
[    7.792096] wl 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.797590] wl 0000:0c:00.0: setting latency timer to 64
[    7.814285] eth1 (wl): not using net_device_ops yet
[    7.828952] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[    7.834305] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.879201] lib80211_crypt: registered algorithm 'TKIP'
[    7.879552] eth1: Broadcom BCM4315 802.11 Wireless Controller 5.10.27.14
[    7.951293] input: HDA Intel Mic at Ext Right Jack as
/devices/pci0000:00/0000:00:1b.0/input/input6
[    7.964432] input: HDA Intel Line Out at Sep Left Jack as
/devices/pci0000:00/0000:00:1b.0/input/input7
[    7.977751] input: HDA Intel HP Out at Ext Right Jack as
/devices/pci0000:00/0000:00:1b.0/input/input8
[    8.467123] Adding 1004020k swap on /dev/sda1.  Priority:-1
extents:1 across:1004020k
[    9.017022] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
[   10.687669] EXT3 FS on sda2, internal journal
[   15.755858] kjournald starting.  Commit interval 5 seconds
[   15.756479] EXT3 FS on sda3, internal journal
[   15.756496] EXT3-fs: mounted filesystem with ordered data mode.
[   16.008579] kjournald starting.  Commit interval 5 seconds
[   16.020308] EXT3-fs warning: maximal mount count reached, running
e2fsck is recommended
[   16.032688] EXT3 FS on sda5, internal journal
[   16.044465] EXT3-fs: mounted filesystem with ordered data mode.
[   16.640639] rc.S used greatest stack depth: 5904 bytes left
[   21.692491] iwconfig used greatest stack depth: 5420 bytes left
[   42.299246] mtrr: type mismatch for e0000000,10000000 old:
write-back new: write-combining
[  152.863673] CE: hpet increasing min_delta_ns to 15000 nsec
[ 2927.775405] PM: Syncing filesystems ... done.
[ 2927.800325] PM: Preparing system for mem sleep
[ 2929.160688] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 2929.167256] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[ 2929.184348] PM: Entering mem sleep
[ 2929.184367] Suspending console(s) (use no_console_suspend to debug)
[ 2929.706785] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 2929.707105] sd 0:0:0:0: [sda] Stopping disk
[ 2930.078276] ACPI handle has no context!
[ 2930.078291] sdhci-pci 0000:02:01.2: PME# disabled
[ 2930.078305] sdhci-pci 0000:02:01.2: PCI INT C disabled
[ 2930.078318] ACPI handle has no context!
[ 2930.095106] ACPI handle has no context!
[ 2930.117153] wl 0000:0c:00.0: PCI INT A disabled
[ 2930.193478] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 2930.193585] ehci_hcd 0000:00:1d.7: PME# disabled
[ 2930.206605] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 2930.206708] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 2930.206808] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 2930.233328] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 2930.246689] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 2930.246796] ehci_hcd 0000:00:1a.7: PME# disabled
[ 2930.260059] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 2930.260162] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 2930.260261] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 2930.282484] ACPI: Preparing to enter system sleep state S3
[ 2930.288488] Disabling non-boot CPUs ...
[ 2930.291167] CPU 1 is now offline
[ 2930.291172] lockdep: fixing up alternatives.
[ 2930.291177] SMP alternatives: switching to UP code
[ 2930.421810] CPU1 is down
[ 2930.421917] Extended CMOS year: 2000
[ 2930.421917] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 2930.421917] Back to C!
[ 2930.421917] Extended CMOS year: 2000
[ 2930.421917] pci 0000:00:02.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[ 2930.421917] pci 0000:00:02.0: restoring config space at offset 0x8
(was 0x1, writing 0xefe9)
[ 2930.421917] pci 0000:00:02.0: restoring config space at offset 0x6
(was 0xc, writing 0xe000000c)
[ 2930.421917] pci 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900403)
[ 2930.421917] pci 0000:00:02.1: restoring config space at offset 0x4
(was 0x4, writing 0xf6b00004)
[ 2930.421917] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[ 2930.421917] uhci_hcd 0000:00:1a.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[ 2930.421917] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x8 (was 0x1, writing 0x6f61)
[ 2930.421917] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 2930.421917] uhci_hcd 0000:00:1a.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 2930.421917] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f81)
[ 2930.421917] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 2930.421917] uhci_hcd 0000:00:1a.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 2930.421917] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x8 (was 0x1, writing 0x6fa1)
[ 2930.421917] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 2930.421917] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 2930.421917] HDA Intel 0000:00:1b.0: restoring config space at
offset 0xf (was 0x100, writing 0x107)
[ 2930.421917] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x4 (was 0xfebfc004, writing 0xf6afc004)
[ 2930.421917] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x3 (was 0x0, writing 0x10)
[ 2930.421917] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100102)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x8 (was 0x0, writing 0xfff0)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0b00)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 2930.421917] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0xf (was 0x200, writing 0x20200)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x8 (was 0x0, writing 0xf690f690)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x6 (was 0x0, writing 0xc0c00)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 2930.421917] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x8 (was 0x0, writing 0xf680f680)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x6 (was 0x0, writing 0x90900)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 2930.421917] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x1 (was 0x100000, writing 0x100407)
[ 2930.421917] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[ 2930.421917] uhci_hcd 0000:00:1d.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 2930.421917] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f21)
[ 2930.421917] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 2930.421917] uhci_hcd 0000:00:1d.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 2930.421917] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x8 (was 0x1, writing 0x6f41)
[ 2930.421917] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 2930.421917] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 2930.421917] pci 0000:00:1e.0: restoring config space at offset 0x9
(was 0x1fff1, writing 0x53f15001)
[ 2930.421917] pci 0000:00:1e.0: restoring config space at offset 0x7
(was 0x2280e0f0, writing 0x22802020)
[ 2930.421917] pci 0000:00:1e.0: restoring config space at offset 0x6
(was 0x20020200, writing 0x20060200)
[ 2930.421917] pci 0000:00:1f.0: restoring config space at offset 0x1
(was 0x2100007, writing 0x2100107)
[ 2930.421917] ahci 0000:00:1f.2: restoring config space at offset 0xf
(was 0x400, writing 0x40a)
[ 2930.421917] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[ 2930.421917] i801_smbus 0000:00:1f.3: restoring config space at
offset 0xf (was 0x200, writing 0x204)
[ 2930.421917] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x4 (was 0x4, writing 0xf6afbf04)
[ 2930.421917] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x1 (was 0x2800001, writing 0x2800103)
[ 2930.421917] wl 0000:0c:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x104)
[ 2930.421917] wl 0000:0c:00.0: restoring config space at offset 0x4
(was 0x4, writing 0xf69fc004)
[ 2930.421917] wl 0000:0c:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 2930.421917] wl 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 2930.421917] tg3 0000:09:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 2930.421917] tg3 0000:09:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xf (was 0x7000100, writing 0x580010a)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xe (was 0x0, writing 0x24fc)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xd (was 0x0, writing 0x2400)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xc (was 0x0, writing 0x20fc)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xb (was 0x0, writing 0x2000)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xa (was 0x0, writing 0x57fff000)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x9 (was 0x0, writing 0x54000000)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x8 (was 0x0, writing 0x53fff000)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x7 (was 0x0, writing 0x50000000)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0060302)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x4 (was 0x0, writing 0xf6700000)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x3 (was 0x820000, writing 0x82a800)
[ 2930.421917] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100007)
[ 2930.421917] ohci1394 0000:02:01.1: restoring config space at offset
0xf (was 0x4020200, writing 0x4020204)
[ 2930.421917] ohci1394 0000:02:01.1: restoring config space at offset
0x3 (was 0x800000, writing 0x804010)
[ 2930.421917] ohci1394 0000:02:01.1: restoring config space at offset
0x1 (was 0x2100000, writing 0x2100106)
[ 2930.421917] sdhci-pci 0000:02:01.2: restoring config space at
offset 0xf (was 0x300, writing 0x303)
[ 2930.421917] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x4 (was 0x0, writing 0xf67ff600)
[ 2930.421917] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804010)
[ 2930.421917] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100106)
[ 2930.421917] pci 0000:02:01.3: restoring config space at offset 0xf
(was 0x300, writing 0x303)
[ 2930.421917] pci 0000:02:01.3: restoring config space at offset 0x4
(was 0x0, writing 0xf67ff700)
[ 2930.421917] pci 0000:02:01.3: restoring config space at offset 0x3
(was 0x800000, writing 0x804010)
[ 2930.421917] pci 0000:02:01.3: restoring config space at offset 0x1
(was 0x2100000, writing 0x2100106)
[ 2930.423988] Enabling non-boot CPUs ...
[ 2930.424250] lockdep: fixing up alternatives.
[ 2930.424252] SMP alternatives: switching to SMP code
[ 2930.486607] Booting processor 1 APIC 0x1 ip 0x6000
[ 2930.421412] Initializing CPU#1
[ 2930.421412] Calibrating delay using timer specific routine..
3991.26 BogoMIPS (lpj=6650029)
[ 2930.421412] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 2930.421412] CPU: L2 cache: 2048K
[ 2930.421412] [ds] using Core 2/Atom configuration
[ 2930.421412] CPU: Physical Processor ID: 0
[ 2930.421412] CPU: Processor Core ID: 1
[ 2930.421412] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 2930.581408] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[ 2930.583887] Switched to high resolution mode on CPU 1
[ 2930.597223] CPU1 is up
[ 2930.597226] ACPI: Waking up from system sleep state S3
[ 2930.623334] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[ 2930.937302] pci 0000:00:02.0: PME# disabled
[ 2930.937318] pci 0000:00:02.1: PME# disabled
[ 2930.937459] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 2930.937475] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 2930.937515] usb usb3: root hub lost power or was reset
[ 2930.937684] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 2930.937698] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 2930.937737] usb usb4: root hub lost power or was reset
[ 2930.940022] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 2930.940037] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 2930.940075] usb usb5: root hub lost power or was reset
[ 2930.940198] ehci_hcd 0000:00:1a.7: PME# disabled
[ 2930.940210] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 2930.940224] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 2930.940291] ehci_hcd 0000:00:1a.7: PME# disabled
[ 2930.940524] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[ 2930.940538] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 2930.944423] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 2930.944446] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 2930.944467] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[ 2930.944560] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 2930.944575] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 2930.944614] usb usb6: root hub lost power or was reset
[ 2930.944714] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 2930.944728] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 2930.944765] usb usb7: root hub lost power or was reset
[ 2930.944863] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 2930.944877] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 2930.944914] usb usb8: root hub lost power or was reset
[ 2930.945037] ehci_hcd 0000:00:1d.7: PME# disabled
[ 2930.945048] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 2930.945062] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 2930.945077] ehci_hcd 0000:00:1d.7: PME# disabled
[ 2930.945098] pci 0000:00:1e.0: setting latency timer to 64
[ 2930.945313] ahci 0000:00:1f.2: setting latency timer to 64
[ 2930.946292] wl 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 2930.946311] wl 0000:0c:00.0: setting latency timer to 64
[ 2931.175372] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[ 2931.182263] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[ 2931.183350] pci 0000:02:01.3: PME# disabled
[ 2931.183750] pci 0000:00:02.0: setting latency timer to 64
[ 2931.224936] sd 0:0:0:0: [sda] Starting disk
[ 2931.293233] ata6: SATA link down (SStatus 4 SControl 300)
[ 2931.293276] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2931.293319] ata5: SATA link down (SStatus 0 SControl 300)
[ 2931.359212] ata2.00: configured for UDMA/100
[ 2932.253230] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2932.257762] ata1.00: configured for UDMA/133
[ 2932.270078] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[ 2932.270174] sd 0:0:0:0: [sda] Write Protect is off
[ 2932.270180] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 2932.270330] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 2932.381926] PM: Finishing wakeup.
[ 2932.381933] Restarting tasks ... done.
[ 3061.149942] Hangcheck: hangcheck value past margin!
[ 4702.215145] PM: Syncing filesystems ... done.
[ 4702.219177] PM: Preparing system for mem sleep
[ 4703.515755] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 4703.520436] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[ 4703.533778] PM: Entering mem sleep
[ 4703.533819] Suspending console(s) (use no_console_suspend to debug)
[ 4704.056677] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 4704.057085] sd 0:0:0:0: [sda] Stopping disk
[ 4704.427976] ACPI handle has no context!
[ 4704.427991] sdhci-pci 0000:02:01.2: PME# disabled
[ 4704.428004] sdhci-pci 0000:02:01.2: PCI INT C disabled
[ 4704.428018] ACPI handle has no context!
[ 4704.444920] ACPI handle has no context!
[ 4704.457229] wl 0000:0c:00.0: PCI INT A disabled
[ 4704.536666] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 4704.536774] ehci_hcd 0000:00:1d.7: PME# disabled
[ 4704.549793] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 4704.549894] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 4704.549994] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 4704.550420] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 4704.563123] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 4704.563228] ehci_hcd 0000:00:1a.7: PME# disabled
[ 4704.576465] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 4704.576565] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 4704.576665] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 4704.599377] ACPI: Preparing to enter system sleep state S3
[ 4704.605378] Disabling non-boot CPUs ...
[ 4704.608054] CPU 1 is now offline
[ 4704.608059] lockdep: fixing up alternatives.
[ 4704.608065] SMP alternatives: switching to UP code
[ 4704.711321] CPU1 is down
[ 4704.711423] Extended CMOS year: 2000
[ 4704.711423] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 4704.711423] Back to C!
[ 4704.711423] Extended CMOS year: 2000
[ 4704.711423] pci 0000:00:02.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[ 4704.711423] pci 0000:00:02.0: restoring config space at offset 0x8
(was 0x1, writing 0xefe9)
[ 4704.711423] pci 0000:00:02.0: restoring config space at offset 0x6
(was 0xc, writing 0xe000000c)
[ 4704.711423] pci 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900403)
[ 4704.711423] pci 0000:00:02.1: restoring config space at offset 0x4
(was 0x4, writing 0xf6b00004)
[ 4704.711423] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[ 4704.711423] uhci_hcd 0000:00:1a.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[ 4704.711423] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x8 (was 0x1, writing 0x6f61)
[ 4704.711423] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 4704.711423] uhci_hcd 0000:00:1a.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 4704.711423] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f81)
[ 4704.711423] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 4704.711423] uhci_hcd 0000:00:1a.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 4704.711423] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x8 (was 0x1, writing 0x6fa1)
[ 4704.711423] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 4704.711423] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 4704.711423] HDA Intel 0000:00:1b.0: restoring config space at
offset 0xf (was 0x100, writing 0x107)
[ 4704.711423] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x4 (was 0xfebfc004, writing 0xf6afc004)
[ 4704.711423] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x3 (was 0x0, writing 0x10)
[ 4704.711423] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100102)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x8 (was 0x0, writing 0xfff0)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x7 (was 0x20000000, writing 0xf0)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0b00)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 4704.711423] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0xf (was 0x200, writing 0x20200)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x8 (was 0x0, writing 0xf690f690)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x7 (was 0x20000000, writing 0xf0)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x6 (was 0x0, writing 0xc0c00)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 4704.711423] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x8 (was 0x0, writing 0xf680f680)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x7 (was 0x20000000, writing 0xf0)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x6 (was 0x0, writing 0x90900)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 4704.711423] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x1 (was 0x100000, writing 0x100407)
[ 4704.711423] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[ 4704.711423] uhci_hcd 0000:00:1d.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 4704.711423] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f21)
[ 4704.711423] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 4704.711423] uhci_hcd 0000:00:1d.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 4704.711423] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x8 (was 0x1, writing 0x6f41)
[ 4704.711423] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 4704.711423] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 4704.711423] pci 0000:00:1e.0: restoring config space at offset 0x9
(was 0x1fff1, writing 0x53f15001)
[ 4704.711423] pci 0000:00:1e.0: restoring config space at offset 0x7
(was 0x2280e0f0, writing 0x22802020)
[ 4704.711423] pci 0000:00:1e.0: restoring config space at offset 0x6
(was 0x20020200, writing 0x20060200)
[ 4704.711423] pci 0000:00:1f.0: restoring config space at offset 0x1
(was 0x2100007, writing 0x2100107)
[ 4704.711423] ahci 0000:00:1f.2: restoring config space at offset 0xf
(was 0x400, writing 0x40a)
[ 4704.711423] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[ 4704.711423] i801_smbus 0000:00:1f.3: restoring config space at
offset 0xf (was 0x200, writing 0x204)
[ 4704.711423] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x4 (was 0x4, writing 0xf6afbf04)
[ 4704.711423] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x1 (was 0x2800001, writing 0x2800103)
[ 4704.711423] wl 0000:0c:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x104)
[ 4704.711423] wl 0000:0c:00.0: restoring config space at offset 0x4
(was 0x4, writing 0xf69fc004)
[ 4704.711423] wl 0000:0c:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 4704.711423] wl 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 4704.711423] tg3 0000:09:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 4704.711423] tg3 0000:09:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xf (was 0x7000100, writing 0x580010a)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xe (was 0x0, writing 0x24fc)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xd (was 0x0, writing 0x2400)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xc (was 0x0, writing 0x20fc)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xb (was 0x0, writing 0x2000)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xa (was 0x0, writing 0x57fff000)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x9 (was 0x0, writing 0x54000000)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x8 (was 0x0, writing 0x53fff000)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x7 (was 0x0, writing 0x50000000)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0060302)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x4 (was 0x0, writing 0xf6700000)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x3 (was 0x820000, writing 0x82a800)
[ 4704.711423] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100007)
[ 4704.711423] ohci1394 0000:02:01.1: restoring config space at offset
0xf (was 0x4020200, writing 0x4020204)
[ 4704.711423] ohci1394 0000:02:01.1: restoring config space at offset
0x3 (was 0x800000, writing 0x804010)
[ 4704.711423] ohci1394 0000:02:01.1: restoring config space at offset
0x1 (was 0x2100000, writing 0x2100106)
[ 4704.711423] sdhci-pci 0000:02:01.2: restoring config space at
offset 0xf (was 0x300, writing 0x303)
[ 4704.711423] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x4 (was 0x0, writing 0xf67ff600)
[ 4704.711423] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804010)
[ 4704.711423] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100106)
[ 4704.711423] pci 0000:02:01.3: restoring config space at offset 0xf
(was 0x300, writing 0x303)
[ 4704.711423] pci 0000:02:01.3: restoring config space at offset 0x4
(was 0x0, writing 0xf67ff700)
[ 4704.711423] pci 0000:02:01.3: restoring config space at offset 0x3
(was 0x800000, writing 0x804010)
[ 4704.711423] pci 0000:02:01.3: restoring config space at offset 0x1
(was 0x2100000, writing 0x2100106)
[ 4704.713506] Enabling non-boot CPUs ...
[ 4704.713771] lockdep: fixing up alternatives.
[ 4704.713773] SMP alternatives: switching to SMP code
[ 4704.777172] Booting processor 1 APIC 0x1 ip 0x6000
[ 4704.710903] Initializing CPU#1
[ 4704.710903] Calibrating delay using timer specific routine..
3991.29 BogoMIPS (lpj=6650079)
[ 4704.710903] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 4704.710903] CPU: L2 cache: 2048K
[ 4704.710903] [ds] using Core 2/Atom configuration
[ 4704.710903] CPU: Physical Processor ID: 0
[ 4704.710903] CPU: Processor Core ID: 1
[ 4704.710903] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 4704.871271] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[ 4704.873710] Switched to high resolution mode on CPU 1
[ 4704.887045] CPU1 is up
[ 4704.887048] ACPI: Waking up from system sleep state S3
[ 4704.910117] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[ 4705.206268] pci 0000:00:02.0: PME# disabled
[ 4705.206284] pci 0000:00:02.1: PME# disabled
[ 4705.206425] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 4705.206441] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 4705.206481] usb usb3: root hub lost power or was reset
[ 4705.206649] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 4705.206663] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 4705.206701] usb usb4: root hub lost power or was reset
[ 4705.208971] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 4705.208986] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 4705.209025] usb usb5: root hub lost power or was reset
[ 4705.209148] ehci_hcd 0000:00:1a.7: PME# disabled
[ 4705.209211] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 4705.209226] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 4705.209241] ehci_hcd 0000:00:1a.7: PME# disabled
[ 4705.209473] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[ 4705.209488] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 4705.213386] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 4705.213409] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 4705.213430] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[ 4705.213524] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 4705.213539] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 4705.213577] usb usb6: root hub lost power or was reset
[ 4705.213679] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 4705.213693] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 4705.213743] usb usb7: root hub lost power or was reset
[ 4705.213846] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 4705.213859] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 4705.213897] usb usb8: root hub lost power or was reset
[ 4705.214019] ehci_hcd 0000:00:1d.7: PME# disabled
[ 4705.214030] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 4705.214044] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 4705.214059] ehci_hcd 0000:00:1d.7: PME# disabled
[ 4705.214081] pci 0000:00:1e.0: setting latency timer to 64
[ 4705.214407] ahci 0000:00:1f.2: setting latency timer to 64
[ 4705.218659] wl 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 4705.218677] wl 0000:0c:00.0: setting latency timer to 64
[ 4705.408532] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[ 4705.415012] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[ 4705.416068] pci 0000:02:01.3: PME# disabled
[ 4705.446994] pci 0000:00:02.0: setting latency timer to 64
[ 4705.450055] sd 0:0:0:0: [sda] Starting disk
[ 4705.533100] ata6: SATA link down (SStatus 4 SControl 300)
[ 4705.533147] ata5: SATA link down (SStatus 0 SControl 300)
[ 4705.533182] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 4705.593027] ata2.00: configured for UDMA/100
[ 4706.546386] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4706.550980] ata1.00: configured for UDMA/133
[ 4706.563229] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[ 4706.563324] sd 0:0:0:0: [sda] Write Protect is off
[ 4706.563330] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 4706.563480] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 4706.681723] PM: Finishing wakeup.
[ 4706.681730] Restarting tasks ... done.
[ 4723.653166] mmc0: new high speed SDHC card at address 1234
[ 4723.653641] mmcblk0: mmc0:1234 SA04G 3.69 GiB
[ 4723.653857]  mmcblk0: p1 p2 p3 p4
[ 4767.316468] usb 2-1: new high speed USB device using ehci_hcd and address 2
[ 4767.593364] usb 2-1: New USB device found, idVendor=0ed1, idProduct=6990
[ 4767.593373] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 4767.593380] usb 2-1: SerialNumber: 7B64B1C7
[ 4767.593754] usb 2-1: configuration #1 chosen from 1 choice
[ 4767.605758] scsi6 : SCSI emulation for USB Mass Storage devices
[ 4767.607214] usb-storage: device found at 2
[ 4767.607220] usb-storage: waiting for device to settle before scanning
[ 4772.608039] scsi 6:0:0:0: Direct-Access     aigo     Miniking
  8.07 PQ: 0 ANSI: 2
[ 4772.609809] sd 6:0:0:0: [sdb] 256000 512-byte hardware sectors:
(131 MB/125 MiB)
[ 4772.610370] sd 6:0:0:0: [sdb] Write Protect is off
[ 4772.610373] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[ 4772.610376] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 4772.612533] sd 6:0:0:0: [sdb] 256000 512-byte hardware sectors:
(131 MB/125 MiB)
[ 4772.614144] sd 6:0:0:0: [sdb] Write Protect is off
[ 4772.614152] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[ 4772.614158] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 4772.614189]  sdb: sdb1 sdb2 sdb3 sdb4
[ 4772.615960] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[ 4772.617432] sd 6:0:0:0: Attached scsi generic sg2 type 0
[ 4772.619134] usb-storage: device scan complete
[ 4818.073985] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[ 4861.149765] Hangcheck: hangcheck value past margin!
[ 4992.443558] mmc0: card 1234 removed
[ 5280.541223] usb 2-1: USB disconnect, address 2
[ 5376.466978] wpa_supplicant used greatest stack depth: 5368 bytes left
[ 7155.106274] mmc0: new high speed SDHC card at address 1234
[ 7155.106737] mmcblk0: mmc0:1234 SA04G 3.69 GiB
[ 7155.106956]  mmcblk0: p1 p2 p3 p4
[ 7176.968616] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[ 7409.489995] mmc0: card 1234 removed
[ 8492.975230] PM: Syncing filesystems ... done.
[ 8492.987480] PM: Preparing system for mem sleep
[ 8494.257289] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 8494.257506] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[ 8494.257583] PM: Entering mem sleep
[ 8494.257609] Suspending console(s) (use no_console_suspend to debug)
[ 8494.782923] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 8494.783230] sd 0:0:0:0: [sda] Stopping disk
[ 8495.161066] ACPI handle has no context!
[ 8495.161081] sdhci-pci 0000:02:01.2: PME# disabled
[ 8495.161095] sdhci-pci 0000:02:01.2: PCI INT C disabled
[ 8495.161108] ACPI handle has no context!
[ 8495.177877] ACPI handle has no context!
[ 8495.199887] wl 0000:0c:00.0: PCI INT A disabled
[ 8495.279581] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 8495.279688] ehci_hcd 0000:00:1d.7: PME# disabled
[ 8495.292750] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 8495.292851] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 8495.292951] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 8495.293377] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 8495.306076] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 8495.306182] ehci_hcd 0000:00:1a.7: PME# disabled
[ 8495.319407] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 8495.319508] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 8495.319608] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 8495.342278] ACPI: Preparing to enter system sleep state S3
[ 8495.348611] Disabling non-boot CPUs ...
[ 8495.351286] CPU 1 is now offline
[ 8495.351291] lockdep: fixing up alternatives.
[ 8495.351296] SMP alternatives: switching to UP code
[ 8495.448586] CPU1 is down
[ 8495.448690] Extended CMOS year: 2000
[ 8495.448690] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 8495.448690] Back to C!
[ 8495.448690] Extended CMOS year: 2000
[ 8495.448690] pci 0000:00:02.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[ 8495.448690] pci 0000:00:02.0: restoring config space at offset 0x8
(was 0x1, writing 0xefe9)
[ 8495.448690] pci 0000:00:02.0: restoring config space at offset 0x6
(was 0xc, writing 0xe000000c)
[ 8495.448690] pci 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900403)
[ 8495.448690] pci 0000:00:02.1: restoring config space at offset 0x4
(was 0x4, writing 0xf6b00004)
[ 8495.448690] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[ 8495.448690] uhci_hcd 0000:00:1a.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[ 8495.448690] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x8 (was 0x1, writing 0x6f61)
[ 8495.448690] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 8495.448690] uhci_hcd 0000:00:1a.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 8495.448690] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f81)
[ 8495.448690] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 8495.448690] uhci_hcd 0000:00:1a.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 8495.448690] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x8 (was 0x1, writing 0x6fa1)
[ 8495.448690] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 8495.448690] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 8495.448690] HDA Intel 0000:00:1b.0: restoring config space at
offset 0xf (was 0x100, writing 0x107)
[ 8495.448690] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x4 (was 0xfebfc004, writing 0xf6afc004)
[ 8495.448690] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x3 (was 0x0, writing 0x10)
[ 8495.448690] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100102)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x8 (was 0x0, writing 0xfff0)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0b00)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 8495.448690] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0xf (was 0x200, writing 0x20200)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x8 (was 0x0, writing 0xf690f690)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x6 (was 0x0, writing 0xc0c00)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 8495.448690] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x8 (was 0x0, writing 0xf680f680)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x6 (was 0x0, writing 0x90900)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[ 8495.448690] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x1 (was 0x100000, writing 0x100407)
[ 8495.448690] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[ 8495.448690] uhci_hcd 0000:00:1d.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[ 8495.448690] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f21)
[ 8495.448690] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 8495.448690] uhci_hcd 0000:00:1d.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[ 8495.448690] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x8 (was 0x1, writing 0x6f41)
[ 8495.448690] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[ 8495.448690] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[ 8495.448690] pci 0000:00:1e.0: restoring config space at offset 0x9
(was 0x1fff1, writing 0x53f15001)
[ 8495.448690] pci 0000:00:1e.0: restoring config space at offset 0x7
(was 0x2280e0f0, writing 0x22802020)
[ 8495.448690] pci 0000:00:1e.0: restoring config space at offset 0x6
(was 0x20020200, writing 0x20060200)
[ 8495.448690] pci 0000:00:1f.0: restoring config space at offset 0x1
(was 0x2100007, writing 0x2100107)
[ 8495.448690] ahci 0000:00:1f.2: restoring config space at offset 0xf
(was 0x400, writing 0x40a)
[ 8495.448690] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[ 8495.448690] i801_smbus 0000:00:1f.3: restoring config space at
offset 0xf (was 0x200, writing 0x204)
[ 8495.448690] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x4 (was 0x4, writing 0xf6afbf04)
[ 8495.448690] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x1 (was 0x2800001, writing 0x2800103)
[ 8495.448690] wl 0000:0c:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x104)
[ 8495.448690] wl 0000:0c:00.0: restoring config space at offset 0x4
(was 0x4, writing 0xf69fc004)
[ 8495.448690] wl 0000:0c:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 8495.448690] wl 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 8495.448690] tg3 0000:09:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[ 8495.448690] tg3 0000:09:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xf (was 0x7000100, writing 0x580010a)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xe (was 0x0, writing 0x24fc)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xd (was 0x0, writing 0x2400)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xc (was 0x0, writing 0x20fc)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xb (was 0x0, writing 0x2000)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xa (was 0x0, writing 0x57fff000)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x9 (was 0x0, writing 0x54000000)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x8 (was 0x0, writing 0x53fff000)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x7 (was 0x0, writing 0x50000000)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0060302)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x4 (was 0x0, writing 0xf6700000)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x3 (was 0x820000, writing 0x82a800)
[ 8495.448690] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100007)
[ 8495.448690] ohci1394 0000:02:01.1: restoring config space at offset
0xf (was 0x4020200, writing 0x4020204)
[ 8495.448690] ohci1394 0000:02:01.1: restoring config space at offset
0x3 (was 0x800000, writing 0x804010)
[ 8495.448690] ohci1394 0000:02:01.1: restoring config space at offset
0x1 (was 0x2100000, writing 0x2100106)
[ 8495.448690] sdhci-pci 0000:02:01.2: restoring config space at
offset 0xf (was 0x300, writing 0x303)
[ 8495.448690] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x4 (was 0x0, writing 0xf67ff600)
[ 8495.448690] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804010)
[ 8495.448690] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100106)
[ 8495.448690] pci 0000:02:01.3: restoring config space at offset 0xf
(was 0x300, writing 0x303)
[ 8495.448690] pci 0000:02:01.3: restoring config space at offset 0x4
(was 0x0, writing 0xf67ff700)
[ 8495.448690] pci 0000:02:01.3: restoring config space at offset 0x3
(was 0x800000, writing 0x804010)
[ 8495.448690] pci 0000:02:01.3: restoring config space at offset 0x1
(was 0x2100000, writing 0x2100106)
[ 8495.450758] Enabling non-boot CPUs ...
[ 8495.451027] lockdep: fixing up alternatives.
[ 8495.451029] SMP alternatives: switching to SMP code
[ 8495.515135] Booting processor 1 APIC 0x1 ip 0x6000
[ 8495.448154] Initializing CPU#1
[ 8495.448154] Calibrating delay using timer specific routine..
3991.34 BogoMIPS (lpj=6650147)
[ 8495.448154] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 8495.448154] CPU: L2 cache: 2048K
[ 8495.448154] [ds] using Core 2/Atom configuration
[ 8495.448154] CPU: Physical Processor ID: 0
[ 8495.448154] CPU: Processor Core ID: 1
[ 8495.448154] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 8495.610841] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[ 8495.613331] Switched to high resolution mode on CPU 1
[ 8495.623334] CPU1 is up
[ 8495.623336] ACPI: Waking up from system sleep state S3
[ 8495.647712] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[ 8495.944102] pci 0000:00:02.0: PME# disabled
[ 8495.944118] pci 0000:00:02.1: PME# disabled
[ 8495.944263] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 8495.944278] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 8495.944317] usb usb3: root hub lost power or was reset
[ 8495.944485] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 8495.944499] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 8495.944537] usb usb4: root hub lost power or was reset
[ 8495.946846] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 8495.946861] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 8495.946898] usb usb5: root hub lost power or was reset
[ 8495.947183] ehci_hcd 0000:00:1a.7: PME# disabled
[ 8495.947195] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 8495.947210] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 8495.947225] ehci_hcd 0000:00:1a.7: PME# disabled
[ 8495.947411] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[ 8495.947425] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 8495.951243] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 8495.951266] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 8495.951288] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[ 8495.951381] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 8495.951395] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 8495.951434] usb usb6: root hub lost power or was reset
[ 8495.951533] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 8495.951547] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 8495.951584] usb usb7: root hub lost power or was reset
[ 8495.951682] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 8495.951696] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 8495.951732] usb usb8: root hub lost power or was reset
[ 8495.951907] ehci_hcd 0000:00:1d.7: PME# disabled
[ 8495.951918] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 8495.951932] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 8495.951947] ehci_hcd 0000:00:1d.7: PME# disabled
[ 8495.952032] pci 0000:00:1e.0: setting latency timer to 64
[ 8495.952245] ahci 0000:00:1f.2: setting latency timer to 64
[ 8495.956551] wl 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 8495.956570] wl 0000:0c:00.0: setting latency timer to 64
[ 8496.181406] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[ 8496.188085] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[ 8496.189141] pci 0000:02:01.3: PME# disabled
[ 8496.220311] pci 0000:00:02.0: setting latency timer to 64
[ 8496.223632] sd 0:0:0:0: [sda] Starting disk
[ 8496.269357] ata5: SATA link down (SStatus 0 SControl 300)
[ 8496.269395] ata6: SATA link down (SStatus 4 SControl 300)
[ 8496.269430] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 8496.332178] ata2.00: configured for UDMA/100
[ 8497.336006] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8497.340564] ata1.00: configured for UDMA/133
[ 8497.352858] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[ 8497.352958] sd 0:0:0:0: [sda] Write Protect is off
[ 8497.352964] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 8497.353127] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 8497.471405] PM: Finishing wakeup.
[ 8497.471413] Restarting tasks ... done.
[ 8509.236303] mmc0: new high speed SDHC card at address 1234
[ 8509.236741] mmcblk0: mmc0:1234 SA04G 3.69 GiB
[ 8509.236969]  mmcblk0: p1 p2 p3 p4
[ 8535.005444] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[ 8641.149293] Hangcheck: hangcheck value past margin!
[ 8744.072246] mmc0: card 1234 removed
[ 9366.787126] tg3 0000:09:00.0: PME# disabled
[ 9366.787292] tg3 0000:09:00.0: irq 29 for MSI/MSI-X
[ 9368.431916] tg3: eth0: Link is up at 100 Mbps, full duplex.
[ 9368.431920] tg3: eth0: Flow control is off for TX and off for RX.

config file:
------------
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29
# Thu Mar 26 15:06:11 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
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
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
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
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_VMI is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
# CONFIG_MK8 is not set
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
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CONFIG_APM is not set

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
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
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
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
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
CONFIG_PATA_MPIIX=y
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
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
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_HOSTAP_CS is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_PCMCIA is not set
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
# CONFIG_B43_FORCE_PIO is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

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
# CONFIG_USB_USBNET is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=y
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_WISTRON_BTNS=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
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
CONFIG_DEVKMEM=y
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
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
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
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
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
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_GPIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
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
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
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
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
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
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
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
# CONFIG_SENSORS_W83627EHF is not set
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
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
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
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_TPS65010 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
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
# CONFIG_FB_BACKLIGHT is not set
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
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
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
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
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
# CONFIG_SND_CS5535AUDIO is not set
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
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
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
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
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
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
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
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

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
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
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
# CONFIG_USB_PHIDGET is not set
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
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
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
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set

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
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
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
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

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
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=m

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
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
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
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
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
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_HW_BRANCH_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
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
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
# CONFIG_SECURITY_SELINUX is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
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
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
CONFIG_LGUEST=m
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y

-- 
Regards
dave
