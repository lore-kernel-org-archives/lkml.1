Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZGTF1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZGTF1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 01:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZGTF1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 01:27:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:1548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGTF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 01:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CF0S87gMIqyhYMi4RH2nqcTBJPIGqknJ05wc1yu0NNkD/8rhnXFrFX+z4beuc/M/tY
         nGmj4dc+iaflBACMBfnrtsAzd9JSHJy4ByOlNn/FKF1YzqppEgCcyEJyHlRMMP4/SY4I
         aFOnAZP6SPHe2MwJ6DgMmaO6CAL1QOgEdqIYo=
Date: Mon, 20 Jul 2009 13:26:54 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: Input : regression - touchpad not detected
Message-ID: <20090720052653.GA2070@darkstar>
References: <a8e1da0907162213w13a5113dj556bb314e73fb19b@mail.gmail.com> <alpine.LRH.2.00.0907171200350.27150@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.00.0907171200350.27150@twin.jikos.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 12:01:33PM +0200, Jiri Kosina wrote:
> On Fri, 17 Jul 2009, Dave Young wrote:
> 
> > Hi,
> > 
> > since 2.6.31-rc3, sometimes the touchpad of my laptop will not be
> > detected, usually after reboot it will be there.
> > 
> > I have no such problem with 2.6.31-rc2
> > 
> > `dmesg|grep input` with touchpad detected:
> > 
> > [    2.447119] input: Lid Switch as
> > /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> > [    2.458089] input: Power Button as
> > /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> > [    2.459155] input: Sleep Button as
> > /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> > [    3.093556] input: Video Bus as
> > /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
> > [    3.120647] input: Video Bus as
> > /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
> > [    5.300364] input: AT Translated Set 2 keyboard as
> > /devices/platform/i8042/serio0/input/input5
> > [    5.669278] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
> > [    5.698278] input: AlpsPS/2 ALPS GlidePoint as
> > /devices/platform/i8042/serio1/input/input7
> > 
> > `dmesg|grep input` without touchpad detected:
> > 
> > [    2.454246] input: Lid Switch as
> > /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> > [    2.478038] input: Power Button as
> > /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> > [    2.487538] input: Sleep Button as
> > /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> > [    3.118063] input: Video Bus as
> > /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
> > [    3.164064] input: Video Bus as
> > /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
> > [    5.353006] input: AT Translated Set 2 keyboard as
> > /devices/platform/i8042/serio0/input/input5
> 
> Providing the dmesg output with 'i8042.debug' kernel parameter in place 
> from the situation the TouchPad doesn't get detected might be helpful.

I got the debug message, please see:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc3 (dave@darkstar) (gcc version 4.2.4) #91 SMP Fri Jul 17 21:54:40 CST 2009
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
[    0.000000] e820 update range: 000000003db00000 - 0000000040000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 02000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000fbd10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 3d391e00 0006C (v01 DELL    M09     27D90219 ASL  00000061)
[    0.000000] ACPI: FACP 3d391c9c 000F4 (v04 DELL    M09     27D90219 ASL  00000061)
[    0.000000] ACPI: DSDT 3d392400 06357 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 3d3a0c00 00040
[    0.000000] ACPI: HPET 3d391f00 00038 (v01 DELL    M09     00000001 ASL  00000061)
[    0.000000] ACPI: DMAR 3d3a0400 000F8 (v01 DELL    M09     27D90219 ASL  00000061)
[    0.000000] ACPI: APIC 3d392000 00068 (v01 DELL    M09     27D90219 ASL  00000047)
[    0.000000] ACPI: ASF! 3d391c00 00076 (v32 DELL    M09     27D90219 ASL  00000061)
[    0.000000] ACPI: MCFG 3d391fc0 0003E (v16 DELL    M09     27D90219 ASL  00000061)
[    0.000000] ACPI: TCPA 3d392300 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: BOOT 3d391bc0 00028 (v01 DELL    M09     27D90219 ASL  00000061)
[    0.000000] ACPI: SSDT 3d3902eb 0066C (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 91MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001afc5a4]    TEXT DATA BSS ==> [0001000000 - 0001afc5a4]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0001afd000 - 0001b0517c]              BRK ==> [0001afd000 - 0001b0517c]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003d38d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003d38d
[    0.000000] On node 0 totalpages: 250668
[    0.000000] free_area_init_node: node 0, pgdat c153ab80, node_mem_map c1b06000
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
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:b8000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages at c22b9000, static data 30236 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 248708
[    0.000000] Kernel command line: BOOT_IMAGE=test ro root=802 vt.default_utf8=0 resume=/dev/sda8 i8042.debug=1
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003d38d)
[    0.000000] Memory: 982360k/1003060k available (3317k kernel code, 20096k reserved, 2149k data, 364k init, 93756k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff90000 - 0xfffff000   ( 444 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc155d000 - 0xc15b8000   ( 364 kB)
[    0.000000]       .data : 0xc133d5a1 - 0xc1556aa0   (2149 kB)
[    0.000000]       .text : 0xc1000000 - 0xc133d5a1   (3317 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1995.019 MHz processor.
[    0.000039] Console: colour dummy device 80x25
[    0.000056] console [tty0] enabled
[    0.002134] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.002141] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.002146] ... MAX_LOCK_DEPTH:          48
[    0.002151] ... MAX_LOCKDEP_KEYS:        8191
[    0.002156] ... CLASSHASH_SIZE:          4096
[    0.002161] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.002166] ... MAX_LOCKDEP_CHAINS:      32768
[    0.002170] ... CHAINHASH_SIZE:          16384
[    0.002175]  memory used by lock dependency info: 3487 kB
[    0.002181]  per task-struct memory footprint: 1152 bytes
[    0.002650] hpet clockevent registered
[    0.002659] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.002679] Calibrating delay loop (skipped), value calculated using timer frequency.. 3991.28 BogoMIPS (lpj=6650063)
[    0.002841] Security Framework initialized
[    0.002892] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] using mwait in idle threads.
[    0.003333] Performance Counters: Core2 events, Intel PMU driver.
[    0.003333] ... version:                 2
[    0.003333] ... bit width:               40
[    0.003333] ... generic counters:        2
[    0.003333] ... value mask:              000000ffffffffff
[    0.003333] ... max period:              000000007fffffff
[    0.003333] ... fixed-purpose counters:  3
[    0.003333] ... counter mask:            0000000700000003
[    0.003333] Checking 'hlt' instruction... OK.
[    0.014613] ACPI: Core revision 20090521
[    0.096994] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.130031] CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.133332] lockdep: fixing up alternatives.
[    0.133332] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3991.22 BogoMIPS (lpj=6649953)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.224988] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.225034] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.226756] Brought up 2 CPUs
[    0.226763] Total of 2 processors activated (7983.51 BogoMIPS).
[    0.231327] khelper used greatest stack depth: 6804 bytes left
[    0.233522] Booting paravirtualized kernel on bare hardware
[    0.233855] regulator: core version 0.5
[    0.233931] Time: 13:12:21  Date: 07/20/09
[    0.233931] NET: Registered protocol family 16
[    0.240275] ACPI: bus type pci registered
[    0.240553] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.240553] PCI: MCFG area at f8000000 reserved in E820
[    0.240553] PCI: Using MMCONFIG for extended config space
[    0.240553] PCI: Using configuration type 1 for base access
[    0.246739] khelper used greatest stack depth: 6768 bytes left
[    0.297310] bio: create slab <bio-0> at 0
[    0.304200] ACPI: EC: Look up EC in DSDT
[    0.307193] ACPI: BIOS _OSI(Linux) query ignored
[    0.478072] ACPI: SSDT 3d3a0c80 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.631246] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.650698] ACPI: Interpreter enabled
[    0.650708] ACPI: (supports S0 S3 S4 S5)
[    0.651055] ACPI: Using IOAPIC for interrupt routing
[    1.200583] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    1.200594] ACPI: EC: driver started in interrupt mode
[    1.208072] ACPI: No dock devices found.
[    1.382843] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.383761] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    1.383775] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    1.383784] pci 0000:00:02.0: reg 20 io port: [0xefe8-0xefef]
[    1.383884] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    1.384114] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    1.384276] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    1.384437] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    1.384600] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    1.384706] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.384718] pci 0000:00:1a.7: PME# disabled
[    1.384827] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6afc000-0xf6afffff]
[    1.384929] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.384940] pci 0000:00:1b.0: PME# disabled
[    1.385097] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.385108] pci 0000:00:1c.0: PME# disabled
[    1.385268] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.385279] pci 0000:00:1c.1: PME# disabled
[    1.385444] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.385455] pci 0000:00:1c.4: PME# disabled
[    1.385592] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    1.385753] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    1.385914] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    1.386077] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    1.386182] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.386194] pci 0000:00:1d.7: PME# disabled
[    1.386598] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    1.386610] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    1.386622] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    1.386634] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    1.386646] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6eaf]
[    1.386657] pci 0000:00:1f.2: reg 24 io port: [0x6e90-0x6e9f]
[    1.386992] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6afbf00-0xf6afbfff]
[    1.387021] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    1.387137] pci 0000:00:1f.5: reg 10 io port: [0x6eb0-0x6eb7]
[    1.387149] pci 0000:00:1f.5: reg 14 io port: [0x6eb8-0x6ebb]
[    1.387161] pci 0000:00:1f.5: reg 18 io port: [0x6ec0-0x6ec7]
[    1.387173] pci 0000:00:1f.5: reg 1c io port: [0x6ec8-0x6ecb]
[    1.387184] pci 0000:00:1f.5: reg 20 io port: [0x6ee0-0x6eef]
[    1.387196] pci 0000:00:1f.5: reg 24 io port: [0xeff0-0xefff]
[    1.387814] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fc000-0xf69fffff]
[    1.388078] pci 0000:0c:00.0: supports D1 D2
[    1.388081] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    1.388099] pci 0000:0c:00.0: PME# disabled
[    1.388269] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    1.388472] pci 0000:09:00.0: reg 10 64bit mmio: [0xf68f0000-0xf68fffff]
[    1.388624] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    1.388636] pci 0000:09:00.0: PME# disabled
[    1.388763] pci 0000:00:1c.4: bridge 32bit mmio: [0xf6800000-0xf68fffff]
[    1.388874] pci 0000:02:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    1.388911] pci 0000:02:01.0: supports D1 D2
[    1.388914] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.388925] pci 0000:02:01.0: PME# disabled
[    1.389013] pci 0000:02:01.1: reg 10 32bit mmio: [0xf67ff800-0xf67fffff]
[    1.389102] pci 0000:02:01.1: supports D1 D2
[    1.389105] pci 0000:02:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.389117] pci 0000:02:01.1: PME# disabled
[    1.389203] pci 0000:02:01.2: reg 10 32bit mmio: [0xf67ff600-0xf67ff6ff]
[    1.389294] pci 0000:02:01.2: supports D1 D2
[    1.389297] pci 0000:02:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.389308] pci 0000:02:01.2: PME# disabled
[    1.389392] pci 0000:02:01.3: reg 10 32bit mmio: [0xf67ff700-0xf67ff7ff]
[    1.389482] pci 0000:02:01.3: supports D1 D2
[    1.389485] pci 0000:02:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.389497] pci 0000:02:01.3: PME# disabled
[    1.389608] pci 0000:00:1e.0: transparent bridge
[    1.389623] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6700000-0xf67fffff]
[    1.389719] pci_bus 0000:00: on NUMA node 0
[    1.389744] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.405246] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    1.409605] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.411587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.413922] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    1.735019] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    1.737462] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
[    1.739416] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *3
[    1.741505] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    1.743492] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    1.745462] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    1.747589] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    1.749107] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.751263] SCSI subsystem initialized
[    1.753520] libata version 3.00 loaded.
[    1.754925] usbcore: registered new interface driver usbfs
[    1.754925] usbcore: registered new interface driver hub
[    1.754925] usbcore: registered new device driver usb
[    1.756955] PCI: Using ACPI for IRQ routing
[    1.767145] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.767159] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.776679] Switched to high resolution mode on CPU 0
[    1.778426] Switched to high resolution mode on CPU 1
[    1.790908] pnp: PnP ACPI init
[    1.790997] ACPI: bus type pnp registered
[    2.284697] pnp: PnP ACPI: found 13 devices
[    2.284711] ACPI: ACPI bus type pnp unregistered
[    2.284806] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    2.284835] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    2.284896] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    2.284955] system 00:09: ioport range 0xcb0-0xcbb has been reserved
[    2.284976] system 00:09: iomem range 0xfed40000-0xfed44fff has been reserved
[    2.285036] system 00:0a: ioport range 0x900-0x92f has been reserved
[    2.285058] system 00:0a: ioport range 0x931-0x933 has been reserved
[    2.285079] system 00:0a: ioport range 0x935-0x97f has been reserved
[    2.285100] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    2.285121] system 00:0a: ioport range 0x1000-0x1005 has been reserved
[    2.285142] system 00:0a: ioport range 0x1008-0x100f has been reserved
[    2.285201] system 00:0b: ioport range 0xf400-0xf4fe has been reserved
[    2.285223] system 00:0b: ioport range 0x1006-0x1007 has been reserved
[    2.285251] system 00:0b: ioport range 0x100a-0x1059 could not be reserved
[    2.285273] system 00:0b: ioport range 0x1060-0x107f has been reserved
[    2.285294] system 00:0b: ioport range 0x1080-0x10bf has been reserved
[    2.285315] system 00:0b: ioport range 0x1100-0x111f has been reserved
[    2.285336] system 00:0b: ioport range 0x1010-0x102f has been reserved
[    2.285357] system 00:0b: ioport range 0x809-0x809 has been reserved
[    2.285422] system 00:0c: iomem range 0x0-0x9efff could not be reserved
[    2.285451] system 00:0c: iomem range 0x9f000-0x9ffff could not be reserved
[    2.285479] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    2.285507] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    2.285534] system 00:0c: iomem range 0x100000-0x3d38d3ff could not be reserved
[    2.285563] system 00:0c: iomem range 0x3d38d400-0x3dafffff could not be reserved
[    2.285585] system 00:0c: iomem range 0x3db00000-0x3dbfffff has been reserved
[    2.285607] system 00:0c: iomem range 0xffe80000-0xffffffff has been reserved
[    2.285628] system 00:0c: iomem range 0xffa00000-0xffb7ffff has been reserved
[    2.285649] system 00:0c: iomem range 0xfec00000-0xfec0ffff has been reserved
[    2.285671] system 00:0c: iomem range 0xfee00000-0xfee0ffff has been reserved
[    2.285694] system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
[    2.285715] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
[    2.285736] system 00:0c: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    2.285758] system 00:0c: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    2.285779] system 00:0c: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    2.285801] system 00:0c: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    2.285822] system 00:0c: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    2.285843] system 00:0c: iomem range 0xfed18000-0xfed1bfff has been reserved
[    2.285865] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    2.329905] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    2.329915] pci 0000:00:1c.0:   IO window: disabled
[    2.329927] pci 0000:00:1c.0:   MEM window: disabled
[    2.329938] pci 0000:00:1c.0:   PREFETCH window: disabled
[    2.329948] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    2.329954] pci 0000:00:1c.1:   IO window: disabled
[    2.329967] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    2.329977] pci 0000:00:1c.1:   PREFETCH window: disabled
[    2.329988] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
[    2.329994] pci 0000:00:1c.4:   IO window: disabled
[    2.330015] pci 0000:00:1c.4:   MEM window: 0xf6800000-0xf68fffff
[    2.330026] pci 0000:00:1c.4:   PREFETCH window: disabled
[    2.330092] pci 0000:02:01.0: CardBus bridge, secondary bus 0000:03
[    2.330099] pci 0000:02:01.0:   IO window: 0x002000-0x0020ff
[    2.330110] pci 0000:02:01.0:   IO window: 0x002400-0x0024ff
[    2.330121] pci 0000:02:01.0:   PREFETCH window: 0x40000000-0x43ffffff
[    2.330132] pci 0000:02:01.0:   MEM window: 0x44000000-0x47ffffff
[    2.330143] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    2.330152] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    2.330165] pci 0000:00:1e.0:   MEM window: 0xf6700000-0xf67fffff
[    2.330176] pci 0000:00:1e.0:   PREFETCH window: 0x40000000-0x43ffffff
[    2.330218] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.330230] pci 0000:00:1c.0: setting latency timer to 64
[    2.330254] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.330266] pci 0000:00:1c.1: setting latency timer to 64
[    2.330280] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.330291] pci 0000:00:1c.4: setting latency timer to 64
[    2.330304] pci 0000:00:1e.0: setting latency timer to 64
[    2.330329] pci 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.330342] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.330345] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    2.330349] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    2.330352] pci_bus 0000:09: resource 1 mem: [0xf6800000-0xf68fffff]
[    2.330355] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    2.330358] pci_bus 0000:02: resource 1 mem: [0xf6700000-0xf67fffff]
[    2.330361] pci_bus 0000:02: resource 2 pref mem [0x40000000-0x43ffffff]
[    2.330364] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    2.330367] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    2.330371] pci_bus 0000:03: resource 0 io:  [0x2000-0x20ff]
[    2.330373] pci_bus 0000:03: resource 1 io:  [0x2400-0x24ff]
[    2.330376] pci_bus 0000:03: resource 2 pref mem [0x40000000-0x43ffffff]
[    2.330380] pci_bus 0000:03: resource 3 mem: [0x44000000-0x47ffffff]
[    2.330522] NET: Registered protocol family 2
[    2.330895] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    2.331987] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.332488] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    2.341325] TCP: Hash tables configured (established 131072 bind 65536)
[    2.341375] TCP reno registered
[    2.341864] NET: Registered protocol family 1
[    2.343113] Simple Boot Flag at 0x79 set to 0x1
[    2.350195] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa3
[    2.350276] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
[    2.351070] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.352842] audit: initializing netlink socket (disabled)
[    2.352914] type=2000 audit(1248095542.350:1): initialized
[    2.361180] highmem bounce pool size: 64 pages
[    2.361206] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.390758] Kmemleak testing
[    2.390771] kmemleak: kmalloc(32) = f7127860
[    2.390782] kmemleak: kmalloc(32) = f7127880
[    2.390791] kmemleak: kmalloc(1024) = f72e3000
[    2.390801] kmemleak: kmalloc(1024) = f72e3400
[    2.390812] kmemleak: kmalloc(2048) = f7262000
[    2.390822] kmemleak: kmalloc(2048) = f7262800
[    2.390831] kmemleak: kmalloc(4096) = f702c000
[    2.390841] kmemleak: kmalloc(4096) = f702d000
[    2.390877] kmemleak: vmalloc(64) = f803b000
[    2.390907] kmemleak: vmalloc(64) = f803e000
[    2.390936] kmemleak: vmalloc(64) = f8041000
[    2.390965] kmemleak: vmalloc(64) = f8044000
[    2.390994] kmemleak: vmalloc(64) = f8047000
[    2.391004] kmemleak: kmalloc(sizeof(*elem)) = f7281100
[    2.391015] kmemleak: kmalloc(sizeof(*elem)) = f7281200
[    2.391025] kmemleak: kmalloc(sizeof(*elem)) = f7281300
[    2.391035] kmemleak: kmalloc(sizeof(*elem)) = f7281400
[    2.391046] kmemleak: kmalloc(sizeof(*elem)) = f7281500
[    2.391056] kmemleak: kmalloc(sizeof(*elem)) = f7281600
[    2.391066] kmemleak: kmalloc(sizeof(*elem)) = f7281700
[    2.391077] kmemleak: kmalloc(sizeof(*elem)) = f7281800
[    2.391087] kmemleak: kmalloc(sizeof(*elem)) = f7281900
[    2.391097] kmemleak: kmalloc(sizeof(*elem)) = f7281a00
[    2.391108] kmemleak: kmalloc(129) = f71da600
[    2.391118] kmemleak: kmalloc(129) = f71da780
[    2.391708] VFS: Disk quotas dquot_6.5.2
[    2.392326] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.398939] msgmni has been set to 1735
[    2.401422] alg: No test for stdrng (krng)
[    2.402297] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.402322] io scheduler noop registered
[    2.402327] io scheduler anticipatory registered
[    2.402334] io scheduler deadline registered
[    2.402888] io scheduler cfq registered (default)
[    2.402950] pci 0000:00:02.0: Boot video device
[    2.405038] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    2.405056] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.406543] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    2.406560] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    2.408045] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
[    2.408062] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    2.410197] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.411119] Platform driver 'platform-lcd' needs updating - please use dev_pm_ops
[    2.413109] ALI M7101 PMU not found.
[    2.414101] vesafb: framebuffer at 0xe0000000, mapped to 0xf8080000, using 3072k, total 32704k
[    2.414111] vesafb: mode is 1024x768x16, linelength=2048, pages=20
[    2.414118] vesafb: scrolling: redraw
[    2.414123] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    2.429080] Console: switching to colour frame buffer device 128x48
[    2.441544] fb0: VESA VGA frame buffer device
[    2.443454] ACPI: AC Adapter [AC] (on-line)
[    2.445539] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.458539] ACPI: Lid Switch [LID]
[    2.460610] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.460823] ACPI: Power Button [PBTN]
[    2.461742] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    2.461942] ACPI: Sleep Button [SBTN]
[    2.488453] ACPI: SSDT 3d390957 002C3 (v01  PmRef   BspIst 00003000 INTL 20050624)
[    2.495161] ACPI: SSDT 3d390df1 005C6 (v01  PmRef   BspCst 00003001 INTL 20050624)
[    2.500253] Monitor-Mwait will be used to enter C-1 state
[    2.500361] Monitor-Mwait will be used to enter C-2 state
[    2.500453] Monitor-Mwait will be used to enter C-3 state
[    2.500470] Marking TSC unstable due to TSC halts in idle
[    2.501175] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.502060] processor LNXCPU:00: registered as cooling_device0
[    2.502238] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.512946] ACPI: SSDT 3d390c1a 001D7 (v01  PmRef    ApIst 00003000 INTL 20050624)
[    2.520216] ACPI: SSDT 3d3913b7 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    2.526559] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    2.527196] processor LNXCPU:01: registered as cooling_device1
[    2.527373] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.674082] thermal LNXTHERM:01: registered as thermal_zone0
[    2.674369] ACPI: Thermal Zone [THM] (66 C)
[    2.717712] Non-volatile memory driver v1.3
[    2.718365] i8k: unable to get SMM BIOS version
[    2.724182] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
[    2.730126] Linux agpgart interface v0.103
[    2.735925] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    2.742345] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    2.752319] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    2.768179] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    2.773832] Hangcheck: Using get_cycles().
[    2.779872] [drm] Initialized drm 1.1.0 20060810
[    2.785830] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.791507] pci 0000:00:02.0: setting latency timer to 64
[    2.794586] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    2.800334] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    2.806164] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    3.052691] acpi device:36: registered as cooling_device2
[    3.102151] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
[    3.108185] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.133141] ACPI Warning: \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) 20090521 nspredef-434
[    3.160339] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
[    3.166635] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[    3.173248] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.179756] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.189238] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    3.218602] brd: module loaded
[    3.243989] loop: module loaded
[    3.251386] Loading iSCSI transport class v2.0-870.
[    3.262102] ata_piix 0000:00:1f.2: version 2.13
[    3.262133] ata_piix 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.268948] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
[    3.275370] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.278273] scsi0 : ata_piix
[    3.286023] scsi1 : ata_piix
[    3.334558] ata1: SATA max UDMA/133 cmd 0x6e70 ctl 0x6e78 bmdma 0x6ea0 irq 19
[    3.340802] ata2: SATA max UDMA/133 cmd 0x6e80 ctl 0x6e88 bmdma 0x6ea8 irq 19
[    3.346891] ata_piix 0000:00:1f.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.352803] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    3.373900] ACPI: Battery Slot [BAT0] (battery present)
[    3.510077] ata_piix 0000:00:1f.5: setting latency timer to 64
[    3.510260] scsi2 : ata_piix
[    3.517033] scsi3 : ata_piix
[    3.525666] ata3: SATA max UDMA/133 cmd 0x6eb0 ctl 0x6eb8 bmdma 0x6ee0 irq 19
[    3.531355] ata4: SATA max UDMA/133 cmd 0x6ec0 ctl 0x6ec8 bmdma 0x6ee8 irq 19
[    3.538438] tg3.c:v3.99 (April 20, 2009)
[    3.544050] tg3 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.549732] tg3 0000:09:00.0: setting latency timer to 64
[    3.554357] tg3 0000:09:00.0: PME# disabled
[    3.569539] eth0: Tigon3 [partno(BCM95756m) rev a200] (PCI Express) MAC address 00:21:9b:f5:60:0f
[    3.575301] eth0: attached PHY is 5722/5756 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    3.581070] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    3.586830] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    3.593216] sky2 driver version 1.23
[    3.601654] PPP generic driver version 2.4.2
[    3.608270] PPP Deflate Compression module registered
[    3.613979] PPP BSD Compression module registered
[    3.620713] PPP MPPE Compression module registered
[    3.626346] NET: Registered protocol family 24
[    3.631989] PPPoL2TP kernel driver, V1.0
[    3.637470] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[    3.643232] CSLIP: code copyright 1989 Regents of the University of California.
[    3.649004] SLIP linefill/keepalive option.
[    3.655083] console [netcon0] enabled
[    3.660660] netconsole: network logging started
[    3.666517] yenta_cardbus 0000:02:01.0: CardBus bridge found [1028:0262]
[    3.813423] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.823995] ata1.00: ATA-8: ST9160310AS, DE04, max UDMA/133
[    3.826744] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.835043] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    3.850353] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633A, D500, max UDMA/100
[    3.855813] ata2.00: applying bridge limits
[    3.861355] ata4: SATA link down (SStatus 4 SControl 300)
[    3.875474] ata3: SATA link down (SStatus 0 SControl 300)
[    3.880613] ata1.00: configured for UDMA/133
[    3.886642] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS      DE04 PQ: 0 ANSI: 5
[    3.895590] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.900773] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.907302] sd 0:0:0:0: [sda] Write Protect is off
[    3.912290] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.912567] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.914555] ata2.00: configured for UDMA/100
[    3.924510]  sda:
[    3.929498] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L633A D500 PQ: 0 ANSI: 5
[    3.957586] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.962889] Uniform CD-ROM driver Revision: 3.20
[    3.970038] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.971128] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.174400]  sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    4.296031] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.427743] yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    4.433098] yenta_cardbus 0000:02:01.0: Socket status: 30000006
[    4.438433] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
[    4.443995] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[    4.449619] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge Memory window: 0xf6700000 - 0xf67fffff
[    4.455273] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge Memory window: 0x40000000 - 0x43ffffff
[    4.714291] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.719943] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.725608] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.725614] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.731304] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.740777] ehci_hcd 0000:00:1a.7: debug port 1
[    4.746117] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.746242] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    4.764204] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.770040] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.775396] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.780768] usb usb1: Product: EHCI Host Controller
[    4.786125] usb usb1: Manufacturer: Linux 2.6.31-rc3 ehci_hcd
[    4.791510] usb usb1: SerialNumber: 0000:00:1a.7
[    4.798119] usb usb1: configuration #1 chosen from 1 choice
[    4.804429] hub 1-0:1.0: USB hub found
[    4.809809] hub 1-0:1.0: 6 ports detected
[    4.816073] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.821290] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.821295] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.826486] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.835688] ehci_hcd 0000:00:1d.7: debug port 1
[    4.840790] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.840922] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    4.857521] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.862923] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.867979] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.873020] usb usb2: Product: EHCI Host Controller
[    4.878023] usb usb2: Manufacturer: Linux 2.6.31-rc3 ehci_hcd
[    4.883009] usb usb2: SerialNumber: 0000:00:1d.7
[    4.888808] usb usb2: configuration #1 chosen from 1 choice
[    4.894526] hub 2-0:1.0: USB hub found
[    4.899606] hub 2-0:1.0: 6 ports detected
[    4.905678] uhci_hcd: USB Universal Host Controller Interface driver
[    4.910735] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.913395] async/1 used greatest stack depth: 6484 bytes left
[    4.921127] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.921132] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.926158] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.931176] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    4.936563] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.941517] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.946413] usb usb3: Product: UHCI Host Controller
[    4.951257] usb usb3: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    4.956108] usb usb3: SerialNumber: 0000:00:1a.0
[    4.961754] usb usb3: configuration #1 chosen from 1 choice
[    4.967244] hub 3-0:1.0: USB hub found
[    4.972123] hub 3-0:1.0: 2 ports detected
[    4.976852] async/0 used greatest stack depth: 6372 bytes left
[    4.981567] async/2 used greatest stack depth: 6184 bytes left
[    4.982348] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.982371] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.982376] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.982433] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.982597] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    4.983049] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.983052] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.983054] usb usb4: Product: UHCI Host Controller
[    4.983056] usb usb4: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    4.983059] usb usb4: SerialNumber: 0000:00:1a.1
[    4.983934] usb usb4: configuration #1 chosen from 1 choice
[    4.984660] hub 4-0:1.0: USB hub found
[    4.984755] hub 4-0:1.0: 2 ports detected
[    4.985445] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.985468] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.985473] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.985529] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    4.985609] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    4.986059] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.986062] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.986065] usb usb5: Product: UHCI Host Controller
[    4.986067] usb usb5: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    4.986069] usb usb5: SerialNumber: 0000:00:1a.2
[    4.986936] usb usb5: configuration #1 chosen from 1 choice
[    4.987649] hub 5-0:1.0: USB hub found
[    4.987743] hub 5-0:1.0: 2 ports detected
[    4.988435] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.988457] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.988462] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.988516] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.988598] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    4.989053] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.989056] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.989059] usb usb6: Product: UHCI Host Controller
[    4.989061] usb usb6: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    4.989063] usb usb6: SerialNumber: 0000:00:1d.0
[    4.990164] usb usb6: configuration #1 chosen from 1 choice
[    4.990927] hub 6-0:1.0: USB hub found
[    4.991018] hub 6-0:1.0: 2 ports detected
[    4.991702] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.991725] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.991729] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.991785] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.991866] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    4.992315] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.992318] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.992320] usb usb7: Product: UHCI Host Controller
[    4.992322] usb usb7: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    4.992325] usb usb7: SerialNumber: 0000:00:1d.1
[    4.993200] usb usb7: configuration #1 chosen from 1 choice
[    4.993900] hub 7-0:1.0: USB hub found
[    4.993994] hub 7-0:1.0: 2 ports detected
[    4.994697] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.994721] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.994725] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.994780] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.994861] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    4.995307] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.995310] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.995312] usb usb8: Product: UHCI Host Controller
[    4.995314] usb usb8: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    4.995316] usb usb8: SerialNumber: 0000:00:1d.2
[    4.996194] usb usb8: configuration #1 chosen from 1 choice
[    4.996895] hub 8-0:1.0: USB hub found
[    4.996987] hub 8-0:1.0: 2 ports detected
[    4.998034] Initializing USB Mass Storage driver...
[    4.998470] usbcore: registered new interface driver usb-storage
[    4.998481] USB Mass Storage support registered.
[    4.999204] usbcore: registered new interface driver libusual
[    4.999970] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    5.000009] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    5.000756] drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
[    5.000841] drivers/input/serio/i8042.c: 65 <- i8042 (return) [0]
[    5.000998] i8042.c: Warning: Keylock active.
[    5.001003] drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
[    5.001062] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [1]
[    5.001176] drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
[    5.001287] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [1]
[    5.001611] drivers/input/serio/i8042.c: 5a <- i8042 (return) [1]
[    5.001616] drivers/input/serio/i8042.c: a7 -> i8042 (command) [1]
[    5.001673] drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
[    5.002046] drivers/input/serio/i8042.c: 74 <- i8042 (return) [1]
[    5.002051] drivers/input/serio/i8042.c: a8 -> i8042 (command) [1]
[    5.002108] drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
[    5.002430] drivers/input/serio/i8042.c: 54 <- i8042 (return) [1]
[    5.002481] drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
[    5.002540] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
[    5.002652] drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
[    5.002815] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [1]
[    5.250908] drivers/input/serio/i8042.c: a5 <- i8042 (flush, aux) [76]
[    5.250916] drivers/input/serio/i8042.c: 60 -> i8042 (command) [76]
[    5.250975] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [76]
[    5.251131] drivers/input/serio/i8042.c: 60 -> i8042 (command) [76]
[    5.251295] drivers/input/serio/i8042.c: 65 -> i8042 (parameter) [76]
[    5.251300] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.251828] mice: PS/2 mouse device common for all mice
[    5.258377] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [78]
[    5.258629] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [78]
[    5.271446] rtc_cmos 00:03: RTC can wake from S4
[    5.272266] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.272344] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.272648] i2c /dev entries driver
[    5.273398] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.322617] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [97]
[    5.322746] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [97]
[    5.322832] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [97]
[    5.323076] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [97]
[    5.323095] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [97]
[    5.323434] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [97]
[    5.323451] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [97]
[    5.323716] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [97]
[    5.323733] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [97]
[    5.324008] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [97]
[    5.324047] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [97]
[    5.324303] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [98]
[    5.324647] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
[    5.329826] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    5.330441] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    5.331487] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
[    5.332016] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.332022] iTCO_vendor_support: vendor-support=0
[    5.333804] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    5.334894] device-mapper: dm-log-userspace: version 1.0.0 loaded
[    5.337967] cpuidle: using governor ladder
[    5.377203] cpuidle: using governor menu
[    5.383629] sdhci: Secure Digital Host Controller Interface driver
[    5.388737] sdhci: Copyright(c) Pierre Ossman
[    5.394429] sdhci-pci 0000:02:01.2: SDHCI controller found [1180:0822] (rev 21)
[    5.399633] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.407836] Registered led device: mmc0::
[    5.414691] mmc0: SDHCI controller on PCI [0000:02:01.2] using DMA
[    5.420189] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    5.425372] wbsd: Copyright(c) Pierre Ossman
[    5.432716] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.447890] usbcore: registered new interface driver hiddev
[    5.453693] usbcore: registered new interface driver usbhid
[    5.459018] usbhid: v2.6:USB HID core driver
[    5.465378] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    5.470786] ALSA device list:
[    5.476058]   No soundcards found.
[    5.481302] Netfilter messages via NETLINK v0.30.
[    5.486640] nf_conntrack version 0.5.0 (15672 buckets, 62688 max)
[    5.493681] ctnetlink v0.93: registering with nfnetlink.
[    5.501226] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.506715] TCP cubic registered
[    5.511970] NET: Registered protocol family 17
[    5.517291] lib80211: common routines for IEEE802.11 drivers
[    5.522625] lib80211_crypt: registered algorithm 'NULL'
[    5.536326] Using IPI No-Shortcut mode
[    5.543200] PM: Checking image partition /dev/sda8
[    5.543248] PM: Resume from partition 8:8
[    5.543250] PM: Checking hibernation image.
[    5.544002] PM: Resume from disk failed.
[    5.544160] registered taskstats version 1
[    5.549715] kmemleak: Kernel memory leak detector initialized
[    5.549734] kmemleak: Automatic memory scanning thread started
[    5.561726]   Magic number: 1:56:231
[    5.567085] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    5.573474] md: Waiting for all devices to be available before autodetect
[    5.578806] md: If you don't use raid, use raid=noautodetect
[    5.586768] md: Autodetecting RAID arrays.
[    5.592049] md: Scanned 0 and added 0 devices.
[    5.597384] md: autorun ...
[    5.602568] md: ... autorun DONE.
[    6.000175] Clocksource tsc unstable (delta = -369139176 ns)
[    6.163739] kjournald starting.  Commit interval 5 seconds
[    6.164566] EXT3-fs: mounted filesystem with writeback data mode.
[    6.164804] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    6.164948] Freeing unused kernel memory: 364k freed
[    6.206618] Write protecting the kernel text: 3320k
[    6.217382] Write protecting the kernel read-only data: 1804k
[    7.389871] mount used greatest stack depth: 5824 bytes left
[    8.798837] ACPI: WMI: Mapper loaded
[    9.090486] ohci1394 0000:02:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.152253] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    9.482043] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    9.487398] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.443602] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
[   10.923588] Adding 2008084k swap on /dev/sda8.  Priority:-1 extents:1 across:2008084k 
[   12.888801] EXT3 FS on sda2, internal journal
[   17.921669] kjournald starting.  Commit interval 5 seconds
[   17.932861] EXT3 FS on sda3, internal journal
[   17.943927] EXT3-fs: mounted filesystem with writeback data mode.
[   18.172713] EXT4-fs (sda5): Filesystem with huge files cannot be mounted read-write without CONFIG_LBDAF
[   18.887657] rc.S used greatest stack depth: 5632 bytes left
[   22.203257] EXT4-fs (sda5): Filesystem with huge files cannot be mounted read-write without CONFIG_LBDAF
[   28.388638] Bluetooth: Core ver 2.15
[   28.398963] NET: Registered protocol family 31
[   28.398966] Bluetooth: HCI device and connection manager initialized
[   28.399050] Bluetooth: HCI socket layer initialized
[   28.630593] Bluetooth: L2CAP ver 2.13
[   28.630596] Bluetooth: L2CAP socket layer initialized
[   29.129104] Bluetooth: SCO (Voice Link) ver 0.6
[   29.129107] Bluetooth: SCO socket layer initialized
[   29.214037] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   29.214047] Bluetooth: BNEP filters: protocol multicast
[   30.308459] update-mime-dat used greatest stack depth: 5596 bytes left
[   33.661414] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [8599]
[   33.789868] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [8637]
[   33.789995] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [8637]
[   34.020628] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [8707]
[   34.020755] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [8707]
[   34.150717] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [8746]
[   34.484818] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [8846]
[   34.581876] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [8875]
[   34.981511] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [8995]
[   35.053109] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [9016]
[   35.150116] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [9046]
[   35.253640] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [9077]
[   35.259713] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [9078]
[   35.333874] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [9101]
[   36.450513] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [9436]
[   36.567044] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [9471]
[   36.642408] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [9493]
[   36.757566] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [9528]
[   36.853179] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [9556]
[   36.988196] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [9597]
[   37.105273] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [9632]
[   37.238873] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [9672]
[   37.258874] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [9678]
[   37.309019] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [9693]
[   37.416305] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [9725]
[   37.519618] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [9756]
[   37.539620] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [9762]
[   37.639949] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [9792]
[   37.669980] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [9801]
[   37.710140] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [9814]
[   37.820392] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [9847]
[   37.850488] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [9856]
[   38.086403] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 0, 1) [9926]
[   38.151281] drivers/input/serio/i8042.c: 82 <- i8042 (interrupt, 0, 1) [9946]
[   38.165788] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [9950]
[   38.231603] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [9970]
[   40.164573] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [10550]
[   40.246838] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [10575]
[   40.418751] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [10626]
[   40.527664] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [10659]
[   40.587865] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [10677]
[   40.647965] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [10695]
[   40.733997] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [10721]
[   40.788398] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [10737]
[   40.908691] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [10773]
[   40.938889] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [10782]
[   41.260142] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [10879]
[   41.329889] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [10899]
[   41.400068] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [10921]
[   41.460256] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [10939]
[   41.531642] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [10960]
[   41.630764] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [10990]
[   41.730180] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [11020]
[   41.831392] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [11050]
[   41.891520] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [11068]
[   41.921609] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [11077]
[   42.099553] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [11130]
[   42.172344] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [11152]
[   42.396378] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [11219]
[   42.483281] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [11245]
[   42.523353] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [11257]
[   42.583542] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [11276]
[   42.651095] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [11296]
[   42.824459] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [11348]
[   42.824621] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [11348]
[   42.894486] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [11369]
[   43.583779] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [11576]
[   43.689647] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [11607]
[   43.778594] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [11634]
[   43.818355] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [11646]
[   43.818479] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [11646]
[   43.996188] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [11699]
[   44.778216] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [11934]
[   44.856465] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [11957]
[   45.018022] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 0, 1) [12006]
[   45.123487] drivers/input/serio/i8042.c: 89 <- i8042 (interrupt, 0, 1) [12038]
[   45.197539] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [12060]
[   45.340953] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [12103]
[   46.265169] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0, 1) [12380]
[   46.349623] drivers/input/serio/i8042.c: 8b <- i8042 (interrupt, 0, 1) [12405]
[   46.401028] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [12421]
[   46.567184] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [12471]
[   47.287279] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [12687]
[   47.377953] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [12714]
[   47.388745] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [12717]
[   47.506522] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [12752]
[   47.631593] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [12790]
[   47.813081] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [12844]
[   48.641110] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [13093]
[   48.762366] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [13129]
[   48.857266] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [13158]
[   49.009589] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [13203]
[   49.724819] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [13418]
[   49.810572] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [13444]
[   49.885832] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [13466]
[   49.968892] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [13491]
[   50.083303] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [13525]
[   50.265679] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [13580]
[   50.612746] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [13684]
[   71.407654] kmemleak: 11 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

> 
> -- 
> Jiri Kosina
> SUSE Labs
> 
