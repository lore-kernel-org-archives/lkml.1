Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZLJJac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZLJJac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 04:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbZLJJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 04:30:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49859 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbZLJJaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 04:30:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M2vM/Ke95xAb9MDEX3jhYpVE236HXDPg/lkbbtd+F9Bobe0hcNlsJf8RLVUJR/Xa6r
         amDzEjXMlPnP8kpWYgZwOurF+M9vs5SxR4umJTJwtpuc+kEaO8rxheA2fXG3LpydokXi
         9xHJvyd1mKPdrEYYNPH9I24VLVDTQvF6kNRmA=
MIME-Version: 1.0
In-Reply-To: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com>
References: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com>
Date: Thu, 10 Dec 2009 17:30:16 +0800
Message-ID: <a8e1da0912100130i2e654796mf899dd27df869673@mail.gmail.com>
Subject: Re: mmotm-2009-12-08-17-45 resume slowly
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry forgot cc list


On Thu, Dec 10, 2009 at 5:27 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
>
> With rencent mm patch sets (since 2.6.32), the resume is too slow with
> screen being black over 5 minutes
>
> (Dell e5400 with intel graphic card)
>
> Here is the full dmesg:
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.32-mm1 (dave@darkstar) (gcc version
> 4.2.4) #5 SMP Thu Dec 10 15:23:34 CST 2009
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003d38d400 (usable)
> [    0.000000]  BIOS-e820: 000000003d38d400 - 000000003d38f400 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003d38f400 - 0000000040000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
> [    0.000000] Notice: NX (Execute Disable) protection missing in CPU
> or disabled in BIOS!
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x3d38d max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask C00000000 write-back
> [    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   2 base 03DC00000 mask FFFC00000 uncachable
> [    0.000000]   3 base 03E000000 mask FFE000000 uncachable
> [    0.000000]   4 base 03DB00000 mask FFFF00000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820 update range: 000000003db00000 - 0000000040000000
> (usable) ==> (reserved)
> [    0.000000] e820 update range: 00000000e0000000 - 0000000100000000
> (usable) ==> (reserved)
> [    0.000000] initial memory mapped : 0 - 02000000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 0037400000 page 2M
> [    0.000000]  0037400000 - 00377fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
> [    0.000000] ACPI: RSDP 000fbce0 00024 (v02 DELL  )
> [    0.000000] ACPI: XSDT 3d391e00 00064 (v01 DELL    M09     27D9041D
> ASL  00000061)
> [    0.000000] ACPI: FACP 3d391c9c 000F4 (v04 DELL    M09     27D9041D
> ASL  00000061)
> [    0.000000] ACPI: DSDT 3d392400 06857 (v02 INT430 SYSFexxx 00001001
> INTL 20050624)
> [    0.000000] ACPI: FACS 3d3a0c00 00040
> [    0.000000] ACPI: HPET 3d391f00 00038 (v01 DELL    M09     00000001
> ASL  00000061)
> [    0.000000] ACPI: DMAR 3d3a0400 000F8 (v01 DELL    M09     27D9041D
> ASL  00000061)
> [    0.000000] ACPI: APIC 3d392000 00068 (v01 DELL    M09     27D9041D
> ASL  00000047)
> [    0.000000] ACPI: ASF! 3d391c00 00076 (v32 DELL    M09     27D9041D
> ASL  00000061)
> [    0.000000] ACPI: MCFG 3d391fc0 0003E (v16 DELL    M09     27D9041D
> ASL  00000061)
> [    0.000000] ACPI: TCPA 3d392300 00032 (v01                 00000000
> ASL  00000000)
> [    0.000000] ACPI: SSDT 3d3902e7 0066C (v01  PmRef    CpuPm 00003000
> INTL 20050624)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 91MB HIGHMEM available.
> [    0.000000] 887MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 377fe000
> [    0.000000]   low ram: 0 - 377fe000
> [    0.000000]   node 0 low ram: 00000000 - 377fe000
> [    0.000000]   node 0 bootmap 00008000 - 0000ef00
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
> [0000001000 - 0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
> [0000006000 - 0000007000]
> [    0.000000]   #3 [0001000000 - 0001c1ed78]    TEXT DATA BSS ==>
> [0001000000 - 0001c1ed78]
> [    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
> [000009f000 - 0000100000]
> [    0.000000]   #5 [0001c1f000 - 0001c27184]              BRK ==>
> [0001c1f000 - 0001c27184]
> [    0.000000]   #6 [0000002000 - 0000006000]      ACPI WAKEUP ==>
> [0000002000 - 0000006000]
> [    0.000000]   #7 [0000007000 - 0000008000]          PGTABLE ==>
> [0000007000 - 0000008000]
> [    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==>
> [0000008000 - 000000f000]
> [    0.000000] sizeof(struct page) = 32
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000377fe
> [    0.000000]   HighMem  0x000377fe -> 0x0003d38d
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0003d38d
> [    0.000000] On node 0 totalpages: 250668
> [    0.000000] Node 0 memmap at 0xc1c29000 size 8028160 first pfn 0xc1c29000
> [    0.000000] free_area_init_node: node 0, pgdat c162db40,
> node_mem_map c1c29000
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3967 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1744 pages used for memmap
> [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 184 pages used for memmap
> [    0.000000]   HighMem zone: 23255 pages, LIFO batch:3
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 40000000 (gap:
> 40000000:b8000000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 14 pages/cpu @c2400000 s33048 r0 d24296 u2097152
> [    0.000000] pcpu-alloc: s33048 r0 d24296 u2097152 alloc=1*4194304
> [    0.000000] pcpu-alloc: [0] 0 1
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 248708
> [    0.000000] Kernel command line: BOOT_IMAGE=mm ro root=802
> vt.default_utf8=0 resume=/dev/sda8
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (000377fe:0003d38d)
> [    0.000000] Memory: 980956k/1003060k available (3904k kernel code,
> 21272k reserved, 2488k data, 408k init, 93756k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff90000 - 0xfffff000   ( 444 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
> [    0.000000]       .init : 0xc163f000 - 0xc16a5000   ( 408 kB)
> [    0.000000]       .data : 0xc13d0244 - 0xc163e5a0   (2488 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc13d0244   (3904 kB)
> [    0.000000] Checking if this processor honours the WP bit even in
> supervisor mode...Ok.
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] NR_IRQS:320
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
> Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3567 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 1995.100 MHz processor.
> [    0.003349] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 3991.45 BogoMIPS (lpj=6650333)
> [    0.003611] Security Framework initialized
> [    0.003717] Mount-cache hash table entries: 512
> [    0.006964] Initializing cgroup subsys ns
> [    0.006972] Initializing cgroup subsys cpuacct
> [    0.007103] CPU: Physical Processor ID: 0
> [    0.007108] CPU: Processor Core ID: 0
> [    0.007114] using mwait in idle threads.
> [    0.007122] Performance Events: Core2 events, Intel PMU driver.
> [    0.007153] ... version:                2
> [    0.007158] ... bit width:              40
> [    0.007163] ... generic registers:      2
> [    0.007168] ... value mask:             000000ffffffffff
> [    0.007173] ... max period:             000000007fffffff
> [    0.007179] ... fixed-purpose events:   3
> [    0.007184] ... event mask:             0000000700000003
> [    0.007199] Checking 'hlt' instruction... OK.
> [    0.021587] ACPI: Core revision 20091112
> [    0.043974] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.079689] CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
> [    0.079999] lockdep: fixing up alternatives.
> [    0.079999] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.079999] Initializing CPU#1
> [    0.079999] CPU: Physical Processor ID: 0
> [    0.079999] CPU: Processor Core ID: 1
> [    0.170015] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
> [    0.173386] Brought up 2 CPUs
> [    0.173393] Total of 2 processors activated (7983.61 BogoMIPS).
> [    0.175046] khelper used greatest stack depth: 6928 bytes left
> [    0.175046] regulator: core version 0.5
> [    0.176722] Time: 15:30:08  Date: 12/10/09
> [    0.176823] khelper used greatest stack depth: 6728 bytes left
> [    0.176984] NET: Registered protocol family 16
> [    0.180083] ACPI: bus type pci registered
> [    0.180201] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.180201] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.180201] PCI: Using MMCONFIG for extended config space
> [    0.180201] PCI: Using configuration type 1 for base access
> [    0.203625] bio: create slab <bio-0> at 0
> [    0.213198] ACPI: EC: Look up EC in DSDT
> [    0.213825] ACPI: BIOS _OSI(Linux) query ignored
> [    0.276349] ACPI: SSDT 3d3a0c80 00043 (v01  LMPWR  DELLLOM 00001001
> INTL 20050624)
> [    0.323792] ACPI: Interpreter enabled
> [    0.323804] ACPI: (supports S0 S3 S4 S5)
> [    0.323895] ACPI: Using IOAPIC for interrupt routing
> [    0.490535] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
> [    0.493757] ACPI: No dock devices found.
> [    0.529913] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.530130] pci_root PNP0A03:00: ignoring host bridge windows from
> ACPI; boot with "pci=use_crs" to use them
> [    0.600625] pci_root PNP0A03:00: host bridge window [io
> 0x0000-0x0cf7] (ignored)
> [    0.600630] pci_root PNP0A03:00: host bridge window [io
> 0x0d00-0xffff] (ignored)
> [    0.600634] pci_root PNP0A03:00: host bridge window [mem
> 0x000a0000-0x000bffff] (ignored)
> [    0.600637] pci_root PNP0A03:00: host bridge window [mem
> 0x000d0000-0x000dffff] (ignored)
> [    0.600641] pci_root PNP0A03:00: host bridge window [mem
> 0x40000000-0xf7ffffff] (ignored)
> [    0.600645] pci_root PNP0A03:00: host bridge window [mem
> 0xfc000000-0xfebfffff] (ignored)
> [    0.600648] pci_root PNP0A03:00: host bridge window [mem
> 0xfec10000-0xfecfffff] (ignored)
> [    0.600652] pci_root PNP0A03:00: host bridge window [mem
> 0xfed1c000-0xfed1ffff] (ignored)
> [    0.600656] pci_root PNP0A03:00: host bridge window [mem
> 0xfed90000-0xfed9ffff] (ignored)
> [    0.600659] pci_root PNP0A03:00: host bridge window [mem
> 0xfed40000-0xfed44fff] (ignored)
> [    0.600663] pci_root PNP0A03:00: host bridge window [mem
> 0xfeda7000-0xfedfffff] (ignored)
> [    0.600667] pci_root PNP0A03:00: host bridge window [mem
> 0xfee10000-0xff9fffff] (ignored)
> [    0.600670] pci_root PNP0A03:00: host bridge window [mem
> 0xffb80000-0xffe7ffff] (ignored)
> [    0.600882] pci 0000:00:02.0: reg 10: [mem 0xf6c00000-0xf6ffffff 64bit]
> [    0.600897] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.600906] pci 0000:00:02.0: reg 20: [io  0xefe8-0xefef]
> [    0.600999] pci 0000:00:02.1: reg 10: [mem 0xf6b00000-0xf6bfffff 64bit]
> [    0.601223] pci 0000:00:1a.0: reg 20: [io  0x6f60-0x6f7f]
> [    0.601374] pci 0000:00:1a.1: reg 20: [io  0x6f80-0x6f9f]
> [    0.601525] pci 0000:00:1a.2: reg 20: [io  0x6fa0-0x6fbf]
> [    0.601673] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
> [    0.601783] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.601791] pci 0000:00:1a.7: PME# disabled
> [    0.601875] pci 0000:00:1b.0: reg 10: [mem 0xf6afc000-0xf6afffff 64bit]
> [    0.601974] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.601981] pci 0000:00:1b.0: PME# disabled
> [    0.602144] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.602151] pci 0000:00:1c.0: PME# disabled
> [    0.602322] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.602329] pci 0000:00:1c.1: PME# disabled
> [    0.602501] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.602509] pci 0000:00:1c.4: PME# disabled
> [    0.602629] pci 0000:00:1d.0: reg 20: [io  0x6f00-0x6f1f]
> [    0.602783] pci 0000:00:1d.1: reg 20: [io  0x6f20-0x6f3f]
> [    0.602934] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
> [    0.603078] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
> [    0.603187] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.603195] pci 0000:00:1d.7: PME# disabled
> [    0.603580] pci 0000:00:1f.2: reg 10: [io  0x6e70-0x6e77]
> [    0.603592] pci 0000:00:1f.2: reg 14: [io  0x6e78-0x6e7b]
> [    0.603604] pci 0000:00:1f.2: reg 18: [io  0x6e80-0x6e87]
> [    0.603616] pci 0000:00:1f.2: reg 1c: [io  0x6e88-0x6e8b]
> [    0.603628] pci 0000:00:1f.2: reg 20: [io  0x6ea0-0x6eaf]
> [    0.603640] pci 0000:00:1f.2: reg 24: [io  0x6e90-0x6e9f]
> [    0.603762] pci 0000:00:1f.3: reg 10: [mem 0xf6afbf00-0xf6afbfff 64bit]
> [    0.603793] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
> [    0.603905] pci 0000:00:1f.5: reg 10: [io  0x6eb0-0x6eb7]
> [    0.603917] pci 0000:00:1f.5: reg 14: [io  0x6eb8-0x6ebb]
> [    0.603929] pci 0000:00:1f.5: reg 18: [io  0x6ec0-0x6ec7]
> [    0.603941] pci 0000:00:1f.5: reg 1c: [io  0x6ec8-0x6ecb]
> [    0.603953] pci 0000:00:1f.5: reg 20: [io  0x6ee0-0x6eef]
> [    0.603965] pci 0000:00:1f.5: reg 24: [io  0xeff0-0xefff]
> [    0.604140] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
> [    0.604519] pci 0000:0c:00.0: reg 10: [mem 0xf69fc000-0xf69fffff 64bit]
> [    0.604778] pci 0000:0c:00.0: supports D1 D2
> [    0.604781] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
> [    0.604796] pci 0000:0c:00.0: PME# disabled
> [    0.604958] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
> [    0.604974] pci 0000:00:1c.1:   bridge window [mem 0xf6900000-0xf69fffff]
> [    0.605134] pci 0000:09:00.0: reg 10: [mem 0xf68f0000-0xf68fffff 64bit]
> [    0.605282] pci 0000:09:00.0: PME# supported from D3hot D3cold
> [    0.605291] pci 0000:09:00.0: PME# disabled
> [    0.605402] pci 0000:00:1c.4: PCI bridge to [bus 09-09]
> [    0.605418] pci 0000:00:1c.4:   bridge window [mem 0xf6800000-0xf68fffff]
> [    0.605503] pci 0000:02:01.0: reg 10: [mem 0x00000000-0x00000fff]
> [    0.605541] pci 0000:02:01.0: supports D1 D2
> [    0.605544] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.605552] pci 0000:02:01.0: PME# disabled
> [    0.605617] pci 0000:02:01.1: reg 10: [mem 0xf67ff800-0xf67fffff]
> [    0.605711] pci 0000:02:01.1: supports D1 D2
> [    0.605714] pci 0000:02:01.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.605721] pci 0000:02:01.1: PME# disabled
> [    0.605790] pci 0000:02:01.2: reg 10: [mem 0xf67ff700-0xf67ff7ff]
> [    0.605884] pci 0000:02:01.2: supports D1 D2
> [    0.605887] pci 0000:02:01.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.605895] pci 0000:02:01.2: PME# disabled
> [    0.606011] pci 0000:00:1e.0: PCI bridge to [bus 02-03] (subtractive decode)
> [    0.606028] pci 0000:00:1e.0:   bridge window [mem 0xf6700000-0xf67fffff]
> [    0.606075] pci_bus 0000:03: [bus 03-06] partially hidden behind
> transparent bridge 0000:02 [bus 02-03]
> [    0.606125] pci_bus 0000:00: on NUMA node 0
> [    0.606134] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.607778] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
> [    0.608386] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    0.608653] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> [    0.608946] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
> [    0.667029] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
> [    0.667370] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
> [    0.667708] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *3
> [    0.668044] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
> [    0.668382] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.670294] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.670639] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.670927] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11
> 12 14 15) *0, disabled.
> [    0.671151] vgaarb: device added:
> PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.671151] vgaarb: loaded
> [    0.673347] SCSI subsystem initialized
> [    0.673534] libata version 3.00 loaded.
> [    0.673633] usbcore: registered new interface driver usbfs
> [    0.673633] usbcore: registered new interface driver hub
> [    0.673633] usbcore: registered new device driver usb
> [    0.673697] PCI: Using ACPI for IRQ routing
> [    0.673697] PCI: pci_cache_line_size set to 64 bytes
> [    0.677479] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.677479] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.677479] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.686678] Switching to clocksource tsc
> [    0.698122] pnp: PnP ACPI init
> [    0.698167] ACPI: bus type pnp registered
> [    0.810987] pnp: PnP ACPI: found 13 devices
> [    0.810996] ACPI: ACPI bus type pnp unregistered
> [    0.811028] system 00:05: [io  0x0c80-0x0caf] has been reserved
> [    0.811038] system 00:05: [io  0x0cc0-0x0cff] could not be reserved
> [    0.811062] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
> [    0.811085] system 00:09: [io  0x0cb0-0x0cbb] has been reserved
> [    0.811104] system 00:09: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.811126] system 00:0a: [io  0x0900-0x092f] has been reserved
> [    0.811135] system 00:0a: [io  0x0931-0x0933] has been reserved
> [    0.811144] system 00:0a: [io  0x0935-0x097f] has been reserved
> [    0.811152] system 00:0a: [io  0x04d0-0x04d1] has been reserved
> [    0.811161] system 00:0a: [io  0x1000-0x1005] has been reserved
> [    0.811170] system 00:0a: [io  0x1008-0x100f] has been reserved
> [    0.811192] system 00:0b: [io  0xf400-0xf4fe] has been reserved
> [    0.811201] system 00:0b: [io  0x1006-0x1007] has been reserved
> [    0.811211] system 00:0b: [io  0x100a-0x1059] could not be reserved
> [    0.811219] system 00:0b: [io  0x1060-0x107f] has been reserved
> [    0.811228] system 00:0b: [io  0x1080-0x10bf] has been reserved
> [    0.811236] system 00:0b: [io  0x1100-0x111f] has been reserved
> [    0.811245] system 00:0b: [io  0x1010-0x102f] has been reserved
> [    0.811253] system 00:0b: [io  0x0809] has been reserved
> [    0.811276] system 00:0c: [mem 0x00000000-0x0009efff] could not be reserved
> [    0.811287] system 00:0c: [mem 0x0009f000-0x0009ffff] could not be reserved
> [    0.811297] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
> [    0.811307] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
> [    0.811318] system 00:0c: [mem 0x00100000-0x3d38d3ff] could not be reserved
> [    0.811328] system 00:0c: [mem 0x3d38d400-0x3dafffff] could not be reserved
> [    0.811338] system 00:0c: [mem 0x3db00000-0x3dbfffff] has been reserved
> [    0.811347] system 00:0c: [mem 0xffe80000-0xffffffff] has been reserved
> [    0.811356] system 00:0c: [mem 0xffa00000-0xffb7ffff] has been reserved
> [    0.811366] system 00:0c: [mem 0xfec00000-0xfec0ffff] could not be reserved
> [    0.811376] system 00:0c: [mem 0xfee00000-0xfee0ffff] has been reserved
> [    0.811385] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.811394] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.811403] system 00:0c: [mem 0xfeda0000-0xfeda3fff] has been reserved
> [    0.811413] system 00:0c: [mem 0xfeda4000-0xfeda4fff] has been reserved
> [    0.811423] system 00:0c: [mem 0xfeda5000-0xfeda5fff] has been reserved
> [    0.811432] system 00:0c: [mem 0xfeda6000-0xfeda6fff] has been reserved
> [    0.811441] system 00:0c: [mem 0xfed1c800-0xfed1cfff] has been reserved
> [    0.811451] system 00:0c: [mem 0xfed18000-0xfed1bfff] has been reserved
> [    0.811460] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.848952] b43-pci-bridge 0000:0c:00.0: PCI INT A -> GSI 17
> (level, low) -> IRQ 17
> [    0.848977] b43-pci-bridge 0000:0c:00.0: setting latency timer to 64
> [    0.863385] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
> [    0.863405] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F,
> vendor 0x4243)
> [    0.863425] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
> [    0.863445] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
> [    0.879792] ssb: Found rev 1 PMU (capabilities 0x02A62F01)
> [    0.889038] ssb: SPROM revision 8 detected.
> [    0.903507] ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
> [    0.903853] pci 0000:00:1e.0: BAR 9: assigned [mem
> 0x40000000-0x43ffffff pref]
> [    0.903864] pci 0000:00:1c.0: BAR 8: assigned [mem 0x44000000-0x441fffff]
> [    0.903873] pci 0000:00:1c.0: BAR 9: assigned [mem
> 0x44200000-0x443fffff 64bit pref]
> [    0.903883] pci 0000:00:1c.1: BAR 9: assigned [mem
> 0x44400000-0x445fffff 64bit pref]
> [    0.903893] pci 0000:00:1c.4: BAR 9: assigned [mem
> 0x44600000-0x447fffff 64bit pref]
> [    0.903903] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
> [    0.903911] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
> [    0.903919] pci 0000:00:1c.4: BAR 7: assigned [io  0x4000-0x4fff]
> [    0.903927] pci 0000:00:1e.0: BAR 7: assigned [io  0x5000-0x5fff]
> [    0.903935] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
> [    0.903944] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.903958] pci 0000:00:1c.0:   bridge window [mem 0x44000000-0x441fffff]
> [    0.903970] pci 0000:00:1c.0:   bridge window [mem
> 0x44200000-0x443fffff 64bit pref]
> [    0.903987] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
> [    0.903996] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
> [    0.904009] pci 0000:00:1c.1:   bridge window [mem 0xf6900000-0xf69fffff]
> [    0.904021] pci 0000:00:1c.1:   bridge window [mem
> 0x44400000-0x445fffff 64bit pref]
> [    0.904038] pci 0000:00:1c.4: PCI bridge to [bus 09-09]
> [    0.904047] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
> [    0.904061] pci 0000:00:1c.4:   bridge window [mem 0xf6800000-0xf68fffff]
> [    0.904073] pci 0000:00:1c.4:   bridge window [mem
> 0x44600000-0x447fffff 64bit pref]
> [    0.904094] pci 0000:02:01.0: BAR 9: assigned [mem
> 0x40000000-0x43ffffff pref]
> [    0.904105] pci 0000:02:01.0: BAR 10: assigned [mem 0x48000000-0x4bffffff]
> [    0.904113] pci 0000:02:01.0: BAR 0: assigned [mem 0xf6700000-0xf6700fff]
> [    0.904126] pci 0000:02:01.0: BAR 0: set to [mem
> 0xf6700000-0xf6700fff] (PCI address [0xf6700000-0xf6700fff]
> [    0.904137] pci 0000:02:01.0: BAR 7: assigned [io  0x5000-0x50ff]
> [    0.904145] pci 0000:02:01.0: BAR 8: assigned [io  0x5100-0x51ff]
> [    0.904152] pci 0000:02:01.0: CardBus bridge to [bus 03-06]
> [    0.904159] pci 0000:02:01.0:   bridge window [io  0x5000-0x50ff]
> [    0.904170] pci 0000:02:01.0:   bridge window [io  0x5100-0x51ff]
> [    0.904182] pci 0000:02:01.0:   bridge window [mem
> 0x40000000-0x43ffffff pref]
> [    0.904194] pci 0000:02:01.0:   bridge window [mem 0x48000000-0x4bffffff]
> [    0.904206] pci 0000:00:1e.0: PCI bridge to [bus 02-03]
> [    0.904214] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
> [    0.904228] pci 0000:00:1e.0:   bridge window [mem 0xf6700000-0xf67fffff]
> [    0.904240] pci 0000:00:1e.0:   bridge window [mem
> 0x40000000-0x43ffffff pref]
> [    0.904273] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.904285] pci 0000:00:1c.0: setting latency timer to 64
> [    0.904302] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    0.904314] pci 0000:00:1c.1: setting latency timer to 64
> [    0.904330] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.904342] pci 0000:00:1c.4: setting latency timer to 64
> [    0.904355] pci 0000:00:1e.0: setting latency timer to 64
> [    0.904375] pci 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    0.904388] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> [    0.904392] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
> [    0.904395] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
> [    0.904398] pci_bus 0000:0b: resource 1 [mem 0x44000000-0x441fffff]
> [    0.904402] pci_bus 0000:0b: resource 2 [mem 0x44200000-0x443fffff
> 64bit pref]
> [    0.904405] pci_bus 0000:0c: resource 0 [io  0x3000-0x3fff]
> [    0.904408] pci_bus 0000:0c: resource 1 [mem 0xf6900000-0xf69fffff]
> [    0.904412] pci_bus 0000:0c: resource 2 [mem 0x44400000-0x445fffff
> 64bit pref]
> [    0.904415] pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
> [    0.904418] pci_bus 0000:09: resource 1 [mem 0xf6800000-0xf68fffff]
> [    0.904422] pci_bus 0000:09: resource 2 [mem 0x44600000-0x447fffff
> 64bit pref]
> [    0.904425] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
> [    0.904428] pci_bus 0000:02: resource 1 [mem 0xf6700000-0xf67fffff]
> [    0.904432] pci_bus 0000:02: resource 2 [mem 0x40000000-0x43ffffff pref]
> [    0.904435] pci_bus 0000:02: resource 3 [io  0x0000-0xffff]
> [    0.904438] pci_bus 0000:02: resource 4 [mem 0x00000000-0xffffffff]
> [    0.904441] pci_bus 0000:03: resource 0 [io  0x5000-0x50ff]
> [    0.904444] pci_bus 0000:03: resource 1 [io  0x5100-0x51ff]
> [    0.904447] pci_bus 0000:03: resource 2 [mem 0x40000000-0x43ffffff pref]
> [    0.904451] pci_bus 0000:03: resource 3 [mem 0x48000000-0x4bffffff]
> [    0.904632] NET: Registered protocol family 2
> [    0.904933] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.905890] TCP established hash table entries: 131072 (order: 8,
> 1048576 bytes)
> [    0.906395] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
> [    0.914821] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.914889] TCP reno registered
> [    0.914906] UDP hash table entries: 512 (order: 3, 40960 bytes)
> [    0.915056] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
> [    0.915548] NET: Registered protocol family 1
> [    0.915594] pci 0000:00:02.0: Boot video device
> [    0.916138] PCI: CLS 64 bytes, default 64
> [    0.920703] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa3
> [    0.920737] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
> [    0.920934] Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.921968] audit: initializing netlink socket (disabled)
> [    0.922049] type=2000 audit(1260459007.916:1): initialized
> [    0.930909] highmem bounce pool size: 64 pages
> [    0.930924] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    0.931615] VFS: Disk quotas dquot_6.5.2
> [    0.931702] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.933146] Btrfs loaded
> [    0.933162] msgmni has been set to 1733
> [    0.934396] alg: No test for stdrng (krng)
> [    0.934614] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 253)
> [    0.934641] io scheduler noop registered
> [    0.934647] io scheduler deadline registered
> [    0.934697] io scheduler cfq registered (default)
> [    0.935545] pcieport 0000:00:1c.0: setting latency timer to 64
> [    0.935634] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
> [    0.936286] pcieport 0000:00:1c.1: setting latency timer to 64
> [    0.936377] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
> [    0.937034] pcieport 0000:00:1c.4: setting latency timer to 64
> [    0.937118] pcieport 0000:00:1c.4: irq 26 for MSI/MSI-X
> [    0.938238] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.939692] ALI M7101 PMU not found.
> [    0.940148] vesafb: framebuffer at 0xe0000000, mapped to
> 0xf8080000, using 3072k, total 32704k
> [    0.940158] vesafb: mode is 1024x768x16, linelength=2048, pages=20
> [    0.940165] vesafb: scrolling: redraw
> [    0.940171] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> [    0.953782] Console: switching to colour frame buffer device 128x48
> [    0.966131] fb0: VESA VGA frame buffer device
> [    0.967114] ACPI: AC Adapter [AC] (on-line)
> [    0.968048] input: Lid Switch as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    0.970682] ACPI: Lid Switch [LID]
> [    0.971064] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
> [    0.971270] ACPI: Power Button [PBTN]
> [    0.971668] input: Sleep Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
> [    0.971869] ACPI: Sleep Button [SBTN]
> [    0.973787] ACPI: SSDT 3d390953 002C3 (v01  PmRef   BspIst 00003000
> INTL 20050624)
> [    0.976373] ACPI: SSDT 3d390ded 005C6 (v01  PmRef   BspCst 00003001
> INTL 20050624)
> [    0.978792] Monitor-Mwait will be used to enter C-1 state
> [    0.978888] Monitor-Mwait will be used to enter C-2 state
> [    0.978969] Monitor-Mwait will be used to enter C-3 state
> [    0.978985] Marking TSC unstable due to TSC halts in idle
> [    0.979117] Switching to clocksource hpet
> [    0.980233] processor LNXCPU:00: registered as cooling_device0
> [    0.981727] ACPI: SSDT 3d390c16 001D7 (v01  PmRef    ApIst 00003000
> INTL 20050624)
> [    0.984297] ACPI: SSDT 3d3913b3 0008D (v01  PmRef    ApCst 00003000
> INTL 20050624)
> [    0.987470] processor LNXCPU:01: registered as cooling_device1
> [    1.036564] thermal LNXTHERM:01: registered as thermal_zone0
> [    1.036744] ACPI: Thermal Zone [THM] (50 C)
> [    1.057169] Non-volatile memory driver v1.3
> [    1.058010] i8k: unable to get SMM BIOS version
> [    1.058127] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal
> Zotto (dz@debian.org)
> [    1.058728] Linux agpgart interface v0.103
> [    1.059781] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45
> Express Chipset
> [    1.066202] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
> [    1.075474] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> [    1.081183] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
> seconds, margin is 60 seconds).
> [    1.086768] Hangcheck: Using get_cycles().
> [    1.092487] [drm] Initialized drm 1.1.0 20060810
> [    1.098041] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.103610] i915 0000:00:02.0: setting latency timer to 64
> [    1.109032] mtrr: type mismatch for e0000000,10000000 old:
> write-back new: write-combining
> [    1.114711] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [    1.120525] i915 0000:00:02.0: irq 27 for MSI/MSI-X
> [    1.120541] [drm] set up 31M of stolen space
> [    1.173585] ACPI: Battery Slot [BAT0] (battery present)
> [    1.743361] [drm] TV-21: set mode NTSC 480i 0
> [    1.917419] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
> removing generic driver
> [    1.923290] Console: switching to colour dummy device 80x25
> [    1.993413] [drm] LVDS-8: set mode 1280x800 c
> [    2.180028] async/0 used greatest stack depth: 6240 bytes left
> [    2.311701] Console: switching to colour frame buffer device 160x50
> [    2.344161] fb0: inteldrmfb frame buffer device
> [    2.344163] registered panic notifier
> [    2.381263] acpi device:3b: registered as cooling_device2
> [    2.383064] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input3
> [    2.383507] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
> [    2.383961] ACPI Warning for \_SB_.PCI0.VID2._DOD: Return Package
> has no elements (empty) (20091112/nspredef-439)
> [    2.384794] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:02/input/input4
> [    2.385220] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
> [    2.385736] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    2.386291] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    2.397666] brd: module loaded
> [    2.402531] loop: module loaded
> [    2.403545] Loading iSCSI transport class v2.0-870.
> [    2.405776] ata_piix 0000:00:1f.2: version 2.13
> [    2.405803] ata_piix 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    2.406147] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
> [    2.406810] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    2.406998] scsi0 : ata_piix
> [    2.407806] scsi1 : ata_piix
> [    2.410373] ata1: SATA max UDMA/133 cmd 0x6e70 ctl 0x6e78 bmdma 0x6ea0 irq 19
> [    2.410705] ata2: SATA max UDMA/133 cmd 0x6e80 ctl 0x6e88 bmdma 0x6ea8 irq 19
> [    2.411165] ata_piix 0000:00:1f.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    2.411501] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [    2.563394] ata_piix 0000:00:1f.5: setting latency timer to 64
> [    2.563493] scsi2 : ata_piix
> [    2.564121] scsi3 : ata_piix
> [    2.575834] ata3: SATA max UDMA/133 cmd 0x6eb0 ctl 0x6eb8 bmdma 0x6ee0 irq 19
> [    2.586887] ata4: SATA max UDMA/133 cmd 0x6ec0 ctl 0x6ec8 bmdma 0x6ee8 irq 19
> [    2.600548] tg3.c:v3.105 (December 2, 2009)
> [    2.611593] tg3 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.622751] tg3 0000:09:00.0: setting latency timer to 64
> [    2.638698] eth0: Tigon3 [partno(BCM95756m) rev a200] (PCI Express)
> MAC address 00:21:9b:f5:60:0f
> [    2.650064] eth0: attached PHY is 5722/5756 (10/100/1000Base-T
> Ethernet) (WireSpeed[1])
> [    2.661533] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> [    2.673063] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> [    2.684889] sky2 driver version 1.26
> [    2.696408] PPP generic driver version 2.4.2
> [    2.708158] PPP Deflate Compression module registered
> [    2.719445] PPP BSD Compression module registered
> [    2.731444] PPP MPPE Compression module registered
> [    2.742638] NET: Registered protocol family 24
> [    2.753770] PPPoL2TP kernel driver, V1.0
> [    2.764836] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels,
> max=256) (6 bit encapsulation enabled).
> [    2.776283] CSLIP: code copyright 1989 Regents of the University of
> California.
> [    2.787734] SLIP linefill/keepalive option.
> [    2.799316] console [netcon0] enabled
> [    2.810537] netconsole: network logging started
> [    2.822002] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.833433] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    2.844842] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    2.844848] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    2.856214] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
> bus number 1
> [    2.867638] ehci_hcd 0000:00:1a.7: debug port 1
> [    2.882679] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
> [    2.882717] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
> [    2.894255] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.905663] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.906708] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    2.906949] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.906952] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.906955] usb usb1: Product: EHCI Host Controller
> [    2.906958] usb usb1: Manufacturer: Linux 2.6.32-mm1 ehci_hcd
> [    2.906960] usb usb1: SerialNumber: 0000:00:1a.7
> [    2.908100] hub 1-0:1.0: USB hub found
> [    2.908116] hub 1-0:1.0: 6 ports detected
> [    2.908556] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    2.908581] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    2.908585] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    2.908603] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
> bus number 2
> [    2.908679] ehci_hcd 0000:00:1d.7: debug port 1
> [    2.912557] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    2.912592] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
> [    2.934701] ata3: SATA link down (SStatus 0 SControl 300)
> [    2.946085] ata4: SATA link down (SStatus 4 SControl 300)
> [    2.946126] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    2.946207] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.946210] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.946212] usb usb2: Product: EHCI Host Controller
> [    2.946215] usb usb2: Manufacturer: Linux 2.6.32-mm1 ehci_hcd
> [    2.946217] usb usb2: SerialNumber: 0000:00:1d.7
> [    2.946808] hub 2-0:1.0: USB hub found
> [    2.946831] hub 2-0:1.0: 6 ports detected
> [    2.947216] uhci_hcd: USB Universal Host Controller Interface driver
> [    3.159489] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    3.160208] ata1.00: ATA-8: ST9160310AS, DE04, max UDMA/133
> [    3.160212] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
> [    3.189480] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    3.189485] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    3.191391] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633A, D500, max UDMA/100
> [    3.191405] ata2.00: applying bridge limits
> [    3.219002] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
> bus number 3
> [    3.229172] ata1.00: configured for UDMA/133
> [    3.229191] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
> [    3.229343] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.229347] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.229349] usb usb3: Product: UHCI Host Controller
> [    3.229351] usb usb3: Manufacturer: Linux 2.6.32-mm1 uhci_hcd
> [    3.229354] usb usb3: SerialNumber: 0000:00:1a.0
> [    3.229946] hub 3-0:1.0: USB hub found
> [    3.230036] hub 3-0:1.0: 2 ports detected
> [    3.230281] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    3.230296] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    3.230301] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    3.230323] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
> bus number 4
> [    3.230400] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
> [    3.230538] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.230541] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.230544] usb usb4: Product: UHCI Host Controller
> [    3.230546] usb usb4: Manufacturer: Linux 2.6.32-mm1 uhci_hcd
> [    3.230549] usb usb4: SerialNumber: 0000:00:1a.1
> [    3.231135] hub 4-0:1.0: USB hub found
> [    3.231150] hub 4-0:1.0: 2 ports detected
> [    3.231310] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    3.231324] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    3.231329] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    3.231346] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
> bus number 5
> [    3.231393] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
> [    3.231521] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.231524] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.231526] usb usb5: Product: UHCI Host Controller
> [    3.231529] usb usb5: Manufacturer: Linux 2.6.32-mm1 uhci_hcd
> [    3.231531] usb usb5: SerialNumber: 0000:00:1a.2
> [    3.232101] hub 5-0:1.0: USB hub found
> [    3.232121] hub 5-0:1.0: 2 ports detected
> [    3.232287] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    3.232302] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    3.232306] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    3.232323] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
> bus number 6
> [    3.232370] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
> [    3.232504] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.232507] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.232510] usb usb6: Product: UHCI Host Controller
> [    3.232512] usb usb6: Manufacturer: Linux 2.6.32-mm1 uhci_hcd
> [    3.232514] usb usb6: SerialNumber: 0000:00:1d.0
> [    3.233084] hub 6-0:1.0: USB hub found
> [    3.233100] hub 6-0:1.0: 2 ports detected
> [    3.233273] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    3.233287] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    3.233292] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    3.233310] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
> bus number 7
> [    3.233380] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
> [    3.233513] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.233516] usb usb7: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.233518] usb usb7: Product: UHCI Host Controller
> [    3.233521] usb usb7: Manufacturer: Linux 2.6.32-mm1 uhci_hcd
> [    3.233523] usb usb7: SerialNumber: 0000:00:1d.1
> [    3.234086] hub 7-0:1.0: USB hub found
> [    3.234101] hub 7-0:1.0: 2 ports detected
> [    3.234263] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    3.234277] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    3.234282] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    3.234299] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
> bus number 8
> [    3.234347] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
> [    3.234480] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.234483] usb usb8: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.234486] usb usb8: Product: UHCI Host Controller
> [    3.234488] usb usb8: Manufacturer: Linux 2.6.32-mm1 uhci_hcd
> [    3.234490] usb usb8: SerialNumber: 0000:00:1d.2
> [    3.235059] hub 8-0:1.0: USB hub found
> [    3.235082] hub 8-0:1.0: 2 ports detected
> [    3.235437] Initializing USB Mass Storage driver...
> [    3.235668] usbcore: registered new interface driver usb-storage
> [    3.235673] USB Mass Storage support registered.
> [    3.236109] usbcore: registered new interface driver libusual
> [    3.236534] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at
> 0x60,0x64 irq 1,12
> [    3.237387] i8042.c: Warning: Keylock active.
> [    3.240564] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.240605] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.241694] mice: PS/2 mouse device common for all mice
> [    3.243828] Driver 'rtc_cmos' needs updating - please use bus_type methods
> [    3.243873] rtc_cmos 00:03: RTC can wake from S4
> [    3.244268] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    3.244314] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    3.244498] i2c /dev entries driver
> [    3.246702] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
> low) -> IRQ 19
> [    3.982537] ata2.00: configured for UDMA/100
> [    3.983129] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS
>  DE04 PQ: 0 ANSI: 5
> [    3.984407] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
> [    3.985019] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks:
> (160 GB/149 GiB)
> [    3.985213] sd 0:0:0:0: [sda] Write Protect is off
> [    3.985217] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.985296] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.986007]  sda:
> [    3.987294] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
> [    3.987559] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.988645] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
> [    3.988921] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    3.988927] iTCO_vendor_support: vendor-support=0
> [    4.103269] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05)
> initialised: dm-devel@redhat.com
> [    4.114089] device-mapper: dm-log-userspace: version 1.0.0 loaded
> [    4.115717] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW
> TS-L633A D500 PQ: 0 ANSI: 5
> [    4.136170] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input5
> [    4.137513] cpuidle: using governor ladder
> [    4.160918] cpuidle: using governor menu
> [    4.172702] sdhci: Secure Digital Host Controller Interface driver
> [    4.183721] sdhci: Copyright(c) Pierre Ossman
> [    4.187247] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
> xa/form2 cdda tray
> [    4.187251] Uniform CD-ROM driver Revision: 3.20
> [    4.188050] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    4.188595] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    4.228490] dcdbas dcdbas: Dell Systems Management Base Driver
> (version 5.6.0-3.2)
> [    4.244671]  sda1 sda2 sda3 sda4 <
> [    4.246859] usbcore: registered new interface driver hiddev
> [    4.269823] usbcore: registered new interface driver usbhid
> [    4.281086] usbhid: USB HID core driver
> [    4.292291]  sda5
> [    4.292837] Advanced Linux Sound Architecture Driver Version 1.0.21.
> [    4.314873] ALSA device list:
> [    4.325942]   No soundcards found.
> [    4.336996] Netfilter messages via NETLINK v0.30.
> [    4.348290]  sda6nf_conntrack version 0.5.0 (15334 buckets, 61336 max)
> [    4.360287] ctnetlink v0.93: registering with nfnetlink.
> [    4.374177] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    4.385662] TCP cubic registered
> [    4.396917] NET: Registered protocol family 17
> [    4.408204] lib80211: common routines for IEEE802.11 drivers
> [    4.419455] lib80211_crypt: registered algorithm 'NULL'
> [    4.421640]  sda7
> [    4.422604] Using IPI No-Shortcut mode
> [    4.444566]  sda8 >
> [    4.457176] PM: Checking image partition /dev/sda8
> [    4.457222] PM: Resume from partition 8:8
> [    4.457225] PM: Checking hibernation image.
> [    4.457992] PM: Error -22 checking image file
> [    4.457994] PM: Resume from disk failed.
> [    4.458061] registered taskstats version 1
> [    4.460011] sd 0:0:0:0: [sda] Attached SCSI disk
> [    4.481540]   Magic number: 5:855:537
> [    4.492483] bdi 1:15: hash matches
> [    4.503405] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> [    4.650495] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
> [    4.692892] input: AlpsPS/2 ALPS GlidePoint as
> /devices/platform/i8042/serio1/input/input7
> [    4.720082] md: Waiting for all devices to be available before autodetect
> [    4.742549] md: If you don't use raid, use raid=noautodetect
> [    4.767844] md: Autodetecting RAID arrays.
> [    4.778687] md: Scanned 0 and added 0 devices.
> [    4.789416] md: autorun ...
> [    4.800012] md: ... autorun DONE.
> [    5.003501] Clocksource tsc unstable (delta = -321604132 ns)
> [    5.079096] kjournald starting.  Commit interval 5 seconds
> [    5.079824] EXT3-fs (sda2): mounted filesystem with writeback data mode
> [    5.080120] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
> [    5.142808] Freeing unused kernel memory: 408k freed
> [    5.165214] Write protecting the kernel text: 3908k
> [    5.186530] async/1 used greatest stack depth: 6064 bytes left
> [    5.196969] Write protecting the kernel read-only data: 2088k
> [    6.333570] mount used greatest stack depth: 6040 bytes left
> [    6.951249] udevd used greatest stack depth: 5952 bytes left
> [    7.234948] modprobe used greatest stack depth: 5828 bytes left
> [    7.651236] cfg80211: Using static regulatory domain info
> [    7.661764] cfg80211: Regulatory domain: US
> [    7.671985]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [    7.682267]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [    7.692698]     (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    7.703043]     (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    7.713325]     (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    7.723694]     (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    7.733671]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [    7.771924] sdhci-pci 0000:02:01.2: SDHCI controller found
> [1180:0822] (rev 21)
> [    7.781951] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
> low) -> IRQ 18
> [    7.794964] ACPI: WMI: Mapper loaded
> [    7.879419] Registered led device: mmc0::
> [    7.944622] mmc0: SDHCI controller on PCI [0000:02:01.2] using DMA
> [    7.966785] mmc0: Minimum clock frequency too high for identification mode
> [    7.997256] ohci1394 0000:02:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    8.016459] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
> low) -> IRQ 21
> [    8.036194] cfg80211: Calling CRDA for country: US
> [    8.069726] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
> MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [    8.080275] HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
> [    8.080357] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    8.512355] input: Dell WMI hotkeys as /devices/virtual/input/input8
> [    9.389757] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
> [    9.532991] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
> [    9.580380] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
> [    9.580405] b43-phy0 debug: Found Radio: Manuf 0x17F, Version
> 0x2062, Revision 2
> [    9.604678] phy0: Selected rate control algorithm 'minstrel'
> [    9.608519] Registered led device: b43-phy0::tx
> [    9.630314] Registered led device: b43-phy0::rx
> [    9.651887] Registered led device: b43-phy0::radio
> [    9.662725] Broadcom 43xx driver loaded [ Features: PLS, Firmware-ID: FW13 ]
> [   10.307938] Adding 2008084k swap on /dev/sda8.  Priority:-1
> extents:1 across:2008084k
> [   12.595365] EXT3-fs (sda2): using internal journal
> [   17.969618] kjournald starting.  Commit interval 5 seconds
> [   17.991570] EXT3-fs (sda3): using internal journal
> [   18.013380] EXT3-fs (sda3): mounted filesystem with writeback data mode
> [   18.237351] modprobe used greatest stack depth: 5816 bytes left
> [   18.299750] REISERFS (device sda5): found reiserfs format "3.6"
> with standard journal
> [   18.322229] REISERFS warning (device sda5):  reiserfs_fill_super:
> CONFIG_REISERFS_CHECK is set ON
> [   18.344705] REISERFS warning (device sda5):  reiserfs_fill_super: -
> it is slow mode for debugging.
> [   18.366916] REISERFS (device sda5): using ordered data mode
> [   18.402628] REISERFS (device sda5): journal params: device sda5,
> size 8192, journal first block 18, max trans len 1024, max batch 900,
> max commit age 30, max trans age 30
> [   18.425822] REISERFS (device sda5): checking transaction log (sda5)
> [   18.437324] REISERFS debug (device sda5): journal-1153: found in
> header: first_unflushed_offset 1203, last_flushed_trans_id 124057
> [   18.441500] REISERFS debug (device sda5): journal-1006: found valid
> transaction start offset 4294968499, len 121333 id 4096
> [   18.441510] REISERFS debug (device sda5): journal-1206: Starting
> replay from offset 532825052808371, trans_id 2823643143
> [   18.441519] REISERFS debug (device sda5): journal-1037:
> journal_read_transaction, offset 4294968499, len 359 mount_id
> -1471324153
> [   18.441527] REISERFS debug (device sda5): journal-1039:
> journal_read_trans skipping because 1203 is too old
> [   18.441534] REISERFS debug (device sda5): journal-1299: Setting
> newest_mount_id to 457
> [   18.465006] REISERFS (device sda5): Using r5 hash to sort names
> [   18.517772] mount used greatest stack depth: 5740 bytes left
> [   19.151072] rc.S used greatest stack depth: 5424 bytes left
> [   27.284345] smbd used greatest stack depth: 5296 bytes left
> [  224.256014] PM: Syncing filesystems ... done.
> [  224.295550] PM: Preparing system for mem sleep
> [  224.295734] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  224.306948] Freezing remaining freezable tasks ... (elapsed 0.01
> seconds) done.
> [  224.320225] PM: Entering mem sleep
> [  224.320350] Suspending console(s) (use no_console_suspend to debug)
> [  224.335095] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  224.538141] sd 0:0:0:0: [sda] Stopping disk
> [  225.379324] ACPI handle has no context!
> [  225.379364] sdhci-pci 0000:02:01.2: PCI INT C disabled
> [  225.379374] ACPI handle has no context!
> [  225.395501] ACPI handle has no context!
> [  225.407487] b43-pci-bridge 0000:0c:00.0: PCI INT A disabled
> [  225.420718] ata_piix 0000:00:1f.5: PCI INT D disabled
> [  225.433838] ata_piix 0000:00:1f.2: PCI INT D disabled
> [  225.446992] ehci_hcd 0000:00:1d.7: PCI INT A disabled
> [  225.447061] uhci_hcd 0000:00:1d.2: PCI INT C disabled
> [  225.447076] uhci_hcd 0000:00:1d.1: PCI INT B disabled
> [  225.447090] uhci_hcd 0000:00:1d.0: PCI INT A disabled
> [  225.653729] HDA Intel 0000:00:1b.0: PCI INT A disabled
> [  225.666930] ehci_hcd 0000:00:1a.7: PCI INT C disabled
> [  225.666952] uhci_hcd 0000:00:1a.2: PCI INT C disabled
> [  225.666974] uhci_hcd 0000:00:1a.1: PCI INT B disabled
> [  225.667001] uhci_hcd 0000:00:1a.0: PCI INT A disabled
> [  225.680708] render error detected, EIR: 0x00000010
> [  225.680711]   IPEIR: 0x00000000
> [  225.680714]   IPEHR: 0x01000000
> [  225.680716]   INSTDONE: 0xfffffffe
> [  225.680718]   INSTPS: 0x0001e000
> [  225.680720]   INSTDONE1: 0xffffffff
> [  225.680722]   ACTHD: 0x02000018
> [  225.680725] page table error
> [  225.680727]   PGTBL_ER: 0x00100000
> [  225.680731] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
> [  225.731462] ACPI: Preparing to enter system sleep state S3
> [  225.754167] Disabling non-boot CPUs ...
> [  225.809478] CPU 1 is now offline
> [  225.809481] lockdep: fixing up alternatives.
> [  225.809487] SMP alternatives: switching to UP code
> [  225.816500] Extended CMOS year: 2000
> [  225.816500] Back to C!
> [  225.816500] Extended CMOS year: 2000
> [  225.816720] Enabling non-boot CPUs ...
> [  225.818422] lockdep: fixing up alternatives.
> [  225.818425] SMP alternatives: switching to SMP code
> [  225.822188] Booting processor 1 APIC 0x1 ip 0x6000
> [  225.818021] Initializing CPU#1
> [  225.818021] CPU: Physical Processor ID: 0
> [  225.818021] CPU: Processor Core ID: 1
> [  225.913392] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
> [  225.937046] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
> [  225.937053] platform microcode: firmware: requesting intel-ucode/06-0f-0d
> [  225.937179] firmware microcode: parent microcode should not be sleeping
> [  285.940840] CPU1 is up
> [  285.941309] ACPI: Waking up from system sleep state S3
> [  285.991446] i915 0000:00:02.0: restoring config space at offset 0xf
> (was 0x100, writing 0x10b)
> [  285.991465] i915 0000:00:02.0: restoring config space at offset 0x8
> (was 0x1, writing 0xefe9)
> [  285.991474] i915 0000:00:02.0: restoring config space at offset 0x6
> (was 0xc, writing 0xe000000c)
> [  285.991488] i915 0000:00:02.0: restoring config space at offset 0x1
> (was 0x900007, writing 0x900407)
> [  285.991554] pci 0000:00:02.1: restoring config space at offset 0x4
> (was 0x4, writing 0xf6b00004)
> [  285.991564] pci 0000:00:02.1: restoring config space at offset 0x1
> (was 0x900000, writing 0x900007)
> [  285.991594] uhci_hcd 0000:00:1a.0: restoring config space at offset
> 0xf (was 0x100, writing 0x10a)
> [  285.991618] uhci_hcd 0000:00:1a.0: restoring config space at offset
> 0x8 (was 0x1, writing 0x6f61)
> [  285.991643] uhci_hcd 0000:00:1a.0: restoring config space at offset
> 0x1 (was 0x2900000, writing 0x2900001)
> [  285.991678] uhci_hcd 0000:00:1a.1: restoring config space at offset
> 0xf (was 0x200, writing 0x207)
> [  285.991703] uhci_hcd 0000:00:1a.1: restoring config space at offset
> 0x8 (was 0x1, writing 0x6f81)
> [  285.991727] uhci_hcd 0000:00:1a.1: restoring config space at offset
> 0x1 (was 0x2900000, writing 0x2900001)
> [  285.991762] uhci_hcd 0000:00:1a.2: restoring config space at offset
> 0xf (was 0x300, writing 0x305)
> [  285.991786] uhci_hcd 0000:00:1a.2: restoring config space at offset
> 0x8 (was 0x1, writing 0x6fa1)
> [  285.991811] uhci_hcd 0000:00:1a.2: restoring config space at offset
> 0x1 (was 0x2900000, writing 0x2900001)
> [  285.991895] ehci_hcd 0000:00:1a.7: restoring config space at offset
> 0x1 (was 0x2900106, writing 0x2900102)
> [  285.991956] HDA Intel 0000:00:1b.0: restoring config space at
> offset 0xf (was 0x100, writing 0x107)
> [  285.991991] HDA Intel 0000:00:1b.0: restoring config space at
> offset 0x4 (was 0xfebfc004, writing 0xf6afc004)
> [  285.992000] HDA Intel 0000:00:1b.0: restoring config space at
> offset 0x3 (was 0x0, writing 0x10)
> [  285.992011] HDA Intel 0000:00:1b.0: restoring config space at
> offset 0x1 (was 0x100000, writing 0x100102)
> [  285.992068] pcieport 0000:00:1c.0: restoring config space at offset
> 0xf (was 0x100, writing 0x20100)
> [  285.992090] pcieport 0000:00:1c.0: restoring config space at offset
> 0x9 (was 0x10001, writing 0x44314421)
> [  285.992098] pcieport 0000:00:1c.0: restoring config space at offset
> 0x8 (was 0x0, writing 0x44104400)
> [  285.992107] pcieport 0000:00:1c.0: restoring config space at offset
> 0x7 (was 0x20000000, writing 0x2020)
> [  285.992115] pcieport 0000:00:1c.0: restoring config space at offset
> 0x6 (was 0x0, writing 0xb0b00)
> [  285.992129] pcieport 0000:00:1c.0: restoring config space at offset
> 0x3 (was 0x810000, writing 0x810010)
> [  285.992140] pcieport 0000:00:1c.0: restoring config space at offset
> 0x1 (was 0x100000, writing 0x100507)
> [  285.992227] pcieport 0000:00:1c.1: restoring config space at offset
> 0xf (was 0x200, writing 0x20200)
> [  285.992249] pcieport 0000:00:1c.1: restoring config space at offset
> 0x9 (was 0x10001, writing 0x44514441)
> [  285.992257] pcieport 0000:00:1c.1: restoring config space at offset
> 0x8 (was 0x0, writing 0xf690f690)
> [  285.992266] pcieport 0000:00:1c.1: restoring config space at offset
> 0x7 (was 0x20000000, writing 0x3030)
> [  285.992275] pcieport 0000:00:1c.1: restoring config space at offset
> 0x6 (was 0x0, writing 0xc0c00)
> [  285.992289] pcieport 0000:00:1c.1: restoring config space at offset
> 0x3 (was 0x810000, writing 0x810010)
> [  285.992300] pcieport 0000:00:1c.1: restoring config space at offset
> 0x1 (was 0x100000, writing 0x100507)
> [  285.992386] pcieport 0000:00:1c.4: restoring config space at offset
> 0xf (was 0x100, writing 0x20100)
> [  285.992408] pcieport 0000:00:1c.4: restoring config space at offset
> 0x9 (was 0x10001, writing 0x44714461)
> [  285.992417] pcieport 0000:00:1c.4: restoring config space at offset
> 0x8 (was 0x0, writing 0xf680f680)
> [  285.992425] pcieport 0000:00:1c.4: restoring config space at offset
> 0x7 (was 0x20000000, writing 0x4040)
> [  285.992434] pcieport 0000:00:1c.4: restoring config space at offset
> 0x6 (was 0x0, writing 0x90900)
> [  285.992448] pcieport 0000:00:1c.4: restoring config space at offset
> 0x3 (was 0x810000, writing 0x810010)
> [  285.992459] pcieport 0000:00:1c.4: restoring config space at offset
> 0x1 (was 0x100000, writing 0x100407)
> [  285.992571] uhci_hcd 0000:00:1d.0: restoring config space at offset
> 0x1 (was 0x2900005, writing 0x2900001)
> [  285.992606] uhci_hcd 0000:00:1d.1: restoring config space at offset
> 0xf (was 0x200, writing 0x207)
> [  285.992630] uhci_hcd 0000:00:1d.1: restoring config space at offset
> 0x8 (was 0x1, writing 0x6f21)
> [  285.992655] uhci_hcd 0000:00:1d.1: restoring config space at offset
> 0x1 (was 0x2900000, writing 0x2900001)
> [  285.992689] uhci_hcd 0000:00:1d.2: restoring config space at offset
> 0xf (was 0x300, writing 0x305)
> [  285.992714] uhci_hcd 0000:00:1d.2: restoring config space at offset
> 0x8 (was 0x1, writing 0x6f41)
> [  285.992738] uhci_hcd 0000:00:1d.2: restoring config space at offset
> 0x1 (was 0x2900000, writing 0x2900001)
> [  285.992823] ehci_hcd 0000:00:1d.7: restoring config space at offset
> 0x1 (was 0x2900106, writing 0x2900102)
> [  285.992883] pci 0000:00:1e.0: restoring config space at offset 0x9
> (was 0x1fff1, writing 0x43f14001)
> [  285.992895] pci 0000:00:1e.0: restoring config space at offset 0x7
> (was 0x2280e0f0, writing 0x22805050)
> [  285.992903] pci 0000:00:1e.0: restoring config space at offset 0x6
> (was 0x20020200, writing 0x20030200)
> [  285.992997] pci 0000:00:1f.0: restoring config space at offset 0x1
> (was 0x2100007, writing 0x2100107)
> [  285.993041] ata_piix 0000:00:1f.2: restoring config space at offset
> 0xf (was 0x400, writing 0x40a)
> [  285.993109] i801_smbus 0000:00:1f.3: restoring config space at
> offset 0xf (was 0x200, writing 0x204)
> [  285.993144] i801_smbus 0000:00:1f.3: restoring config space at
> offset 0x4 (was 0x4, writing 0xf6afbf04)
> [  285.993159] i801_smbus 0000:00:1f.3: restoring config space at
> offset 0x1 (was 0x2800001, writing 0x2800103)
> [  285.993192] ata_piix 0000:00:1f.5: restoring config space at offset
> 0xf (was 0x400, writing 0x40a)
> [  285.993214] ata_piix 0000:00:1f.5: restoring config space at offset
> 0x9 (was 0x1, writing 0xeff1)
> [  285.993241] ata_piix 0000:00:1f.5: restoring config space at offset
> 0x1 (was 0x2b00000, writing 0x2b00007)
> [  285.993557] b43-pci-bridge 0000:0c:00.0: restoring config space at
> offset 0xf (was 0x100, writing 0x104)
> [  285.993632] b43-pci-bridge 0000:0c:00.0: restoring config space at
> offset 0x4 (was 0x4, writing 0xf69fc004)
> [  285.993648] b43-pci-bridge 0000:0c:00.0: restoring config space at
> offset 0x3 (was 0x0, writing 0x10)
> [  285.993669] b43-pci-bridge 0000:0c:00.0: restoring config space at
> offset 0x1 (was 0x100000, writing 0x100106)
> [  285.993877] tg3 0000:09:00.0: restoring config space at offset 0x3
> (was 0x0, writing 0x10)
> [  285.993890] tg3 0000:09:00.0: restoring config space at offset 0x1
> (was 0x100000, writing 0x100106)
> [  285.993958] pci 0000:02:01.0: restoring config space at offset 0xf
> (was 0x7000100, writing 0x700010a)
> [  285.993966] pci 0000:02:01.0: restoring config space at offset 0xe
> (was 0x0, writing 0x51fc)
> [  285.993975] pci 0000:02:01.0: restoring config space at offset 0xd
> (was 0x0, writing 0x5100)
> [  285.993983] pci 0000:02:01.0: restoring config space at offset 0xc
> (was 0x0, writing 0x50fc)
> [  285.993992] pci 0000:02:01.0: restoring config space at offset 0xb
> (was 0x0, writing 0x5000)
> [  285.994000] pci 0000:02:01.0: restoring config space at offset 0xa
> (was 0x0, writing 0x4bfff000)
> [  285.994009] pci 0000:02:01.0: restoring config space at offset 0x9
> (was 0x0, writing 0x48000000)
> [  285.994017] pci 0000:02:01.0: restoring config space at offset 0x8
> (was 0x0, writing 0x43fff000)
> [  285.994026] pci 0000:02:01.0: restoring config space at offset 0x7
> (was 0x0, writing 0x40000000)
> [  285.994035] pci 0000:02:01.0: restoring config space at offset 0x6
> (was 0x0, writing 0xb0060302)
> [  285.994046] pci 0000:02:01.0: restoring config space at offset 0x4
> (was 0x0, writing 0xf6700000)
> [  285.994054] pci 0000:02:01.0: restoring config space at offset 0x3
> (was 0x820000, writing 0x824000)
> [  285.994066] pci 0000:02:01.0: restoring config space at offset 0x1
> (was 0x2100000, writing 0x2100107)
> [  285.994106] ohci1394 0000:02:01.1: restoring config space at offset
> 0xf (was 0x4020200, writing 0x4020204)
> [  285.994146] ohci1394 0000:02:01.1: restoring config space at offset
> 0x3 (was 0x800000, writing 0x804010)
> [  285.994159] ohci1394 0000:02:01.1: restoring config space at offset
> 0x1 (was 0x2100000, writing 0x2100106)
> [  285.994197] sdhci-pci 0000:02:01.2: restoring config space at
> offset 0xf (was 0x300, writing 0x303)
> [  285.994232] sdhci-pci 0000:02:01.2: restoring config space at
> offset 0x4 (was 0x0, writing 0xf67ff700)
> [  285.994241] sdhci-pci 0000:02:01.2: restoring config space at
> offset 0x3 (was 0x800000, writing 0x804010)
> [  285.994253] sdhci-pci 0000:02:01.2: restoring config space at
> offset 0x1 (was 0x2100000, writing 0x2100106)
> [  286.009482] PM: Device PNP0C0D:00 failed to resume: error 1
> [  286.039022] dell-wmi: Unknown key e044 pressed
> [  286.151069] i915 0000:00:02.0: setting latency timer to 64
> [  286.243570] [drm] LVDS-8: set mode 1280x800 c
> [  286.290393] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [  286.290404] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [  286.290441] usb usb3: root hub lost power or was reset
> [  286.290466] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [  286.290475] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [  286.290505] usb usb4: root hub lost power or was reset
> [  286.290527] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [  286.290537] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [  286.290565] usb usb5: root hub lost power or was reset
> [  286.290588] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [  286.290598] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [  286.290613] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
> low) -> IRQ 21
> [  286.290623] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [  286.290689] HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
> [  286.290764] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [  286.290773] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [  286.290801] usb usb6: root hub lost power or was reset
> [  286.290846] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [  286.290856] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [  286.290887] usb usb7: root hub lost power or was reset
> [  286.290911] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [  286.290921] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [  286.290950] usb usb8: root hub lost power or was reset
> [  286.290972] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [  286.290982] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [  286.291001] pci 0000:00:1e.0: setting latency timer to 64
> [  286.291018] ata_piix 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [  286.291025] ata_piix 0000:00:1f.2: setting latency timer to 64
> [  286.291110] ata_piix 0000:00:1f.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [  286.291119] ata_piix 0000:00:1f.5: setting latency timer to 64
> [  286.291394] b43-pci-bridge 0000:0c:00.0: PCI INT A -> GSI 17
> (level, low) -> IRQ 17
> [  286.307121] pci 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [  286.362261] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
> MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [  286.368333] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
> low) -> IRQ 18
> [  286.383529] mmc0: Minimum clock frequency too high for identification mode
> [  286.423034] sd 0:0:0:0: [sda] Starting disk
> [  286.621595] ata3: SATA link down (SStatus 0 SControl 300)
> [  286.632845] ata4: SATA link down (SStatus 4 SControl 300)
> [  286.763599] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  286.763812] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  286.823841] ata2.00: configured for UDMA/100
> [  287.027642] ata1.00: configured for UDMA/133
> [  287.095609] PM: Finishing wakeup.
> [  287.095611] Restarting tasks ... done.
> [  457.056279] dell-wmi: Unknown key 48 pressed
> [  457.249535] dell-wmi: Unknown key 48 pressed
> [  457.423506] dell-wmi: Unknown key 48 pressed
> [  457.608626] dell-wmi: Unknown key 48 pressed
> [  457.788025] dell-wmi: Unknown key 48 pressed
> [  457.947402] dell-wmi: Unknown key 48 pressed
> [  460.438540] dell-wmi: Unknown key 48 pressed
> [  475.910065] dell-wmi: Unknown key 48 pressed
> [  476.103445] dell-wmi: Unknown key 48 pressed
> [  477.844084] dell-wmi: Unknown key 48 pressed
> [  478.093328] dell-wmi: Unknown key 48 pressed
> [  478.950676] dell-wmi: Unknown key 48 pressed
> [  479.229816] dell-wmi: Unknown key 48 pressed
> [  479.459126] dell-wmi: Unknown key 48 pressed
> [  479.658534] dell-wmi: Unknown key 48 pressed
> [  480.525933] dell-wmi: Unknown key 48 pressed
> [  480.748745] dell-wmi: Unknown key 48 pressed
> [  480.944699] dell-wmi: Unknown key 48 pressed
> [  549.103799] b43 ssb0:0: firmware: requesting b43/ucode15.fw
> [  549.215863] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
> [  549.244516] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
> [  549.403735] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> [  549.406244] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
> [  553.990808] b43-phy0 debug: Chip initialized
> [  553.991181] b43-phy0 debug: PIO initialized
> [  553.991297] b43-phy0 debug: QoS enabled
> [  554.010624] b43-phy0 debug: Wireless interface started
> [  554.018136] b43-phy0 debug: Adding Interface type 2
> [  555.225635] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 1)
> [  555.227406] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 1)
> [  555.247446] wlan0: direct probe responded
> [  555.247504] wlan0: authenticate with AP 00:02:2d:08:51:2b (try 1)
> [  555.275021] wlan0: authenticated
> [  555.275905] wlan0: associate with AP 00:02:2d:08:51:2b (try 1)
> [  555.284599] wlan0: RX AssocResp from 00:02:2d:08:51:2b (capab=0x1
> status=0 aid=12)
> [  555.284608] wlan0: associated
> [  561.323866] mtrr: type mismatch for e0000000,10000000 old:
> write-back new: write-combining
> [ 2688.500033] No probe response from AP 00:02:2d:08:51:2b after
> 500ms, disconnecting.
> [ 2689.580376] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 1)
> [ 2689.780643] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 2)
> [ 2689.798772] wlan0: direct probe responded
> [ 2689.798778] wlan0: authenticate with AP 00:02:2d:08:51:2b (try 1)
> [ 2689.986996] wlan0: authenticated
> [ 2689.987691] wlan0: associate with AP 00:02:2d:08:51:2b (try 1)
> [ 2690.006697] wlan0: RX ReassocResp from 00:02:2d:08:51:2b (capab=0x1
> status=0 aid=1)
> [ 2690.006706] wlan0: associated
>
> --
> Regards
> dave
>



-- 
Regards
dave
