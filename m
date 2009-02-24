Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZBXIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZBXIyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZBXIyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:54:44 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:54682 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZBXIyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:54:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LEmw3Cg680+wmuBX41mCUkKodB2KldumoFtZjfrlUz+K4JUa7Vdohe82qO2AFXFZfA
         iL9fLoxiETL1tlevSt1Z5uNQXX0JcW5hijD8MiBeHBwkqd4EYb/s1UM9ZbAYWUve+nvQ
         JYW45/i9QOI+EzEnLtD0s9vmI0acTDAlGT5UY=
MIME-Version: 1.0
In-Reply-To: <8db1092f0902232254q10826fei8b8125b3da5f233@mail.gmail.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
	 <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
	 <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
	 <8db1092f0902232254q10826fei8b8125b3da5f233@mail.gmail.com>
Date: Tue, 24 Feb 2009 09:54:37 +0100
Message-ID: <8db1092f0902240054jc2fd751m2c707bd687ddeab8@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/24 Maciej Rutecki <maciej.rutecki@gmail.com>:
> 2009/2/24 Yinghai Lu <yinghai@kernel.org>:
>
>>
>> CONFIG_MTRR=y
>> CONFIG_MTRR_SANITIZER=y
>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>
>> should help mtrr ones.
>>
>> please post bootlog with those option set.
>>
>> YH
>>
>
> It doesn't help, see previous mails.
>
>

l also update bios, and try:
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

it doesn't help:
[    0.000000] Linux version 2.6.29-rc6 (root@zlom) (gcc version 4.3.3
(Debian 4.3.3-3) ) #1 SMP PREEMPT Tue Feb 24 08:03:56 CET 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf5e0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf5e0000 - 00000000bf5e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf5e3000 - 00000000bf5f0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf5f0000 - 00000000bf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0xbf5e0 max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 3GB, range: 1GB, type UC
[    0.000000] reg 2, base: 3064MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3063MB, range: 1MB, type UC
[    0.000000] reg 4, base: 3062MB, range: 1MB, type UC
[    0.000000] total RAM coverred: 3062M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3062MB, range: 2MB, type UC
[    0.000000] reg 3, base: 3064MB, range: 8MB, type UC
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000F6BF0, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT BF5E3040, 0038 (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ACPI: FACP BF5E30C0, 0074 (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match
PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT BF5E3180, 40E8 (r1 GBT    GBTUACPI     1000
MSFT  100000C)
[    0.000000] ACPI: FACS BF5E0000, 0040
[    0.000000] ACPI: HPET BF5E73C0, 0038 (r1 GBT    GBTUACPI 42302E31
GBTU       98)
[    0.000000] ACPI: MCFG BF5E7440, 003C (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ACPI: APIC BF5E72C0, 0084 (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ACPI: SSDT BF5E7AE0, 03AB (r1  PmRef    CpuPm     3000
INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2173MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00005781b4]    TEXT DATA BSS ==>
[0000100000 - 00005781b4]
[    0.000000]   #4 [0000579000 - 000057c000]    INIT_PG_TABLE ==>
[0000579000 - 000057c000]
[    0.000000]   #5 [000009f800 - 0000100000]    BIOS reserved ==>
[000009f800 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00f5200] 000f5200
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000bf5e0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bf5e0
[    0.000000] On node 0 totalpages: 783743
[    0.000000] free_area_init_node: node 0, pgdat c04a56a0,
node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4348 pages used for memmap
[    0.000000]   HighMem zone: 552166 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
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
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d4000000 (gap:
d0000000:2ec00000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 32768 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 777619
[    0.000000] Kernel command line: root=/dev/sda2 ro resume=/dev/sda3
selinux=0
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1999.989 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 3104124k/3135360k available (2808k kernel code,
30056k reserved, 1012k data, 324k init, 2226056k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff9f000 - 0xfffff000   ( 384 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc04c1000 - 0xc0512000   ( 324 kB)
[    0.000999]       .data : 0xc03be2bf - 0xc04bb614   (1012 kB)
[    0.000999]       .text : 0xc0100000 - 0xc03be2bf   (2808 kB)
[    0.000999] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3999.97 BogoMIPS (lpj=1999989)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Disabled at boot.
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 1024K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#0.
[    0.000999] using mwait in idle threads.
[    0.000999] Checking 'hlt' instruction... OK.
[    0.004432] ACPI: Core revision 20081204
[    0.011373] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.021768] CPU0: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[    0.021996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine..
3999.72 BogoMIPS (lpj=1999863)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 1024K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.093322] CPU1: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[    0.093951] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.094009] Brought up 2 CPUs
[    0.094057] Total of 2 processors activated (7999.70 BogoMIPS).
[    0.094156] CPU0 attaching sched-domain:
[    0.094158]  domain 0: span 0-1 level MC
[    0.094161]   groups: 0 1
[    0.094166] CPU1 attaching sched-domain:
[    0.094168]  domain 0: span 0-1 level MC
[    0.094170]   groups: 1 0
[    0.094229] net_namespace: 764 bytes
[    0.094242] regulator: core version 0.5
[    0.094242] NET: Registered protocol family 16
[    0.095007] ACPI: bus type pci registered
[    0.095050] PCI: MCFG configuration 0: base c0000000 segment 0 buses 0 - 255
[    0.095070] PCI: MCFG area at c0000000 reserved in E820
[    0.095122] PCI: Using MMCONFIG for extended config space
[    0.095175] PCI: Using configuration type 1 for base access
[    0.097026] bio: create slab <bio-0> at 0
[    0.098443] ACPI: EC: Look up EC in DSDT
[    0.103418] ACPI: Interpreter enabled
[    0.103477] ACPI: (supports S0 S3 S4 S5)
[    0.103625] ACPI: Using IOAPIC for interrupt routing
[    0.109084] ACPI: No dock devices found.
[    0.109147] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.109221] pci 0000:00:02.0: reg 10 32bit mmio: [0xe1300000-0xe137ffff]
[    0.109221] pci 0000:00:02.0: reg 14 io port: [0xe400-0xe407]
[    0.109221] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.109221] pci 0000:00:02.0: reg 1c 32bit mmio: [0xe1000000-0xe10fffff]
[    0.109221] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe1380000-0xe1383fff]
[    0.109221] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.109244] pci 0000:00:1b.0: PME# disabled
[    0.109349] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.109987] pci 0000:00:1c.0: PME# disabled
[    0.110095] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.110152] pci 0000:00:1c.1: PME# disabled
[    0.110247] pci 0000:00:1d.0: reg 20 io port: [0xe000-0xe01f]
[    0.110295] pci 0000:00:1d.1: reg 20 io port: [0xe100-0xe11f]
[    0.110343] pci 0000:00:1d.2: reg 20 io port: [0xe200-0xe21f]
[    0.110390] pci 0000:00:1d.3: reg 20 io port: [0xe300-0xe31f]
[    0.110436] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe1384000-0xe13843ff]
[    0.110597] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
ICH6 ACPI/GPIO/TCO
[    0.110675] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.110734] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0800 (mask 000f)
[    0.110812] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
0290 (mask 000f)
[    0.110995] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.111001] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.111007] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.111012] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.111018] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.111042] pci 0000:00:1f.2: PME# supported from D3hot
[    0.111097] pci 0000:00:1f.2: PME# disabled
[    0.111907] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.111968] pci 0000:00:1c.0: bridge io port: [0xb000-0xbfff]
[    0.112021] pci 0000:02:00.0: reg 10 io port: [0xc000-0xc0ff]
[    0.112042] pci 0000:02:00.0: reg 18 64bit mmio: [0xe1110000-0xe1110fff]
[    0.112056] pci 0000:02:00.0: reg 20 64bit mmio: [0xe1100000-0xe110ffff]
[    0.112065] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.112105] pci 0000:02:00.0: supports D1 D2
[    0.112107] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.112167] pci 0000:02:00.0: PME# disabled
[    0.112268] pci 0000:00:1c.1: bridge io port: [0xc000-0xcfff]
[    0.112272] pci 0000:00:1c.1: bridge 32bit mmio: [0xe0000000-0xe0ffffff]
[    0.112279] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xe1100000-0xe11fffff]
[    0.112312] pci 0000:03:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.112319] pci 0000:03:00.0: reg 14 32bit mmio: [0xe1200000-0xe12000ff]
[    0.112363] pci 0000:03:00.0: supports D1 D2
[    0.112365] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.112423] pci 0000:03:00.0: PME# disabled
[    0.112517] pci 0000:00:1e.0: transparent bridge
[    0.112570] pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
[    0.112574] pci 0000:00:1e.0: bridge 32bit mmio: [0xe1200000-0xe12fffff]
[    0.112593] pci_bus 0000:00: on NUMA node 0
[    0.112599] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.112775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.112839] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.112904] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.124372] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 9 10
11 12 14 15)
[    0.125122] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10
11 12 14 15)
[    0.125565] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10
*11 12 14 15)
[    0.126038] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10
*11 12 14 15)
[    0.126480] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10
11 12 14 15)
[    0.126921] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11
12 14 15) *0, disabled.
[    0.127394] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11
12 14 15) *0, disabled.
[    0.127879] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *9 10
11 12 14 15)
[    0.128272] SCSI subsystem initialized
[    0.128272] libata version 3.00 loaded.
[    0.128272] ACPI: WMI: Mapper loaded
[    0.128272] PCI: Using ACPI for IRQ routing
[    0.133997] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.134156] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.140020] pnp: PnP ACPI init
[    0.140083] ACPI: bus type pnp registered
[    0.143349] pnp: PnP ACPI: found 14 devices
[    0.143400] ACPI: ACPI bus type pnp unregistered
[    0.143459] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.143516] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.143572] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.143628] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.143684] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.143747] system 00:0a: ioport range 0x400-0x4cf could not be reserved
[    0.143810] system 00:0b: iomem range 0xc0000000-0xcfffffff has been reserved
[    0.143872] system 00:0c: iomem range 0xcb400-0xcbfff has been reserved
[    0.143929] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[    0.143987] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.144059] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.144118] system 00:0c: iomem range 0xbf5e0000-0xbf5fffff could
not be reserved
[    0.144194] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.144252] system 00:0c: iomem range 0x100000-0xbf5dffff could not
be reserved
[    0.144328] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.144387] system 00:0c: iomem range 0xfed13000-0xfed1dfff has been reserved
[    0.144445] system 00:0c: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.144504] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.144562] system 00:0c: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.144621] system 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
[    0.144679] system 00:0c: iomem range 0xe0000-0xeffff has been reserved
[    0.179672] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.179729] pci 0000:00:1c.0:   IO window: 0xb000-0xbfff
[    0.179784] pci 0000:00:1c.0:   MEM window: disabled
[    0.179838] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.179896] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
[    0.179952] pci 0000:00:1c.1:   IO window: 0xc000-0xcfff
[    0.180007] pci 0000:00:1c.1:   MEM window: 0xe0000000-0xe0ffffff
[    0.180067] pci 0000:00:1c.1:   PREFETCH window:
0x000000e1100000-0x000000e11fffff
[    0.180147] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.180202] pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
[    0.180258] pci 0000:00:1e.0:   MEM window: 0xe1200000-0xe12fffff
[    0.180315] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.180382] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.180442] pci 0000:00:1c.0: setting latency timer to 64
[    0.180451] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.180509] pci 0000:00:1c.1: setting latency timer to 64
[    0.180516] pci 0000:00:1e.0: setting latency timer to 64
[    0.180520] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.180522] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.180524] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.180527] pci_bus 0000:01: resource 1 mem: [0x0-0x0]
[    0.180529] pci_bus 0000:01: resource 2 mem: [0x0-0x0]
[    0.180531] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.180533] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.180535] pci_bus 0000:02: resource 1 mem: [0xe0000000-0xe0ffffff]
[    0.180538] pci_bus 0000:02: resource 2 mem: [0xe1100000-0xe11fffff]
[    0.180540] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.180542] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.180544] pci_bus 0000:03: resource 1 mem: [0xe1200000-0xe12fffff]
[    0.180546] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.180549] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.180551] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffff]
[    0.180580] NET: Registered protocol family 2
[    0.192218] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.192548] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.193058] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.193463] TCP: Hash tables configured (established 131072 bind 65536)
[    0.193522] TCP reno registered
[    0.196291] NET: Registered protocol family 1
[    0.197255] audit: initializing netlink socket (disabled)
[    0.197318] type=2000 audit(1235468977.197:1): initialized
[    0.197594] highmem bounce pool size: 64 pages
[    0.200199] msgmni has been set to 1716
[    0.200440] alg: No test for stdrng (krng)
[    0.200499] io scheduler noop registered
[    0.200548] io scheduler anticipatory registered
[    0.200598] io scheduler deadline registered
[    0.200658] io scheduler cfq registered (default)
[    0.200720] pci 0000:00:02.0: Boot video device
[    0.200902] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.200963] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.201125] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.201180] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.201678] ACPI: SSDT BF5E74C0, 026C (r1  PmRef  Cpu0Ist     3000
INTL 20040311)
[    0.202052] processor ACPI_CPU:00: registered as cooling_device0
[    0.202109] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.202384] ACPI: SSDT BF5E7980, 0152 (r1  PmRef  Cpu1Ist     3000
INTL 20040311)
[    0.202724] processor ACPI_CPU:01: registered as cooling_device1
[    0.202782] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.204778] isapnp: Scanning for PnP cards...
[    0.500216] Switched to high resolution mode on CPU 1
[    0.501148] Switched to high resolution mode on CPU 0
[    0.560656] isapnp: No Plug & Play device found
[    0.563410] Linux agpgart interface v0.103
[    0.563476] agpgart-intel 0000:00:00.0: Intel G33 Chipset
[    0.563849] agpgart-intel 0000:00:00.0: detected 7164K stolen memory
[    0.566857] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.566960] intelfb: Framebuffer driver for Intel(R)
830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM
chipsets
[    0.567050] intelfb: Version 0.9.6
[    0.567136] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.567313] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.567887] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.569616] brd: module loaded
[    0.569669] Uniform Multi-Platform E-IDE driver
[    0.569842] ide-gd driver 1.18
[    0.569918] ide-cd driver 5.00
[    0.570046] Driver 'sd' needs updating - please use bus_type methods
[    0.570131] Driver 'sr' needs updating - please use bus_type methods
[    0.570314] ata_piix 0000:00:1f.2: version 2.12
[    0.570334] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.570395] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.570561] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.570619] scsi0 : ata_piix
[    0.570755] scsi1 : ata_piix
[    0.571573] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.571632] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    0.741332] ata1.00: HPA detected: current 625140335, native 625142448
[    0.741401] ata1.00: ATA-7: SAMSUNG HD322HJ, 1AC01113, max UDMA7
[    0.741464] ata1.00: 625140335 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.760357] ata1.00: configured for UDMA/133
[    0.760551] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
HD322HJ  1AC0 PQ: 0 ANSI: 5
[    0.760777] sd 0:0:0:0: [sda] 625140335 512-byte hardware sectors:
(320 GB/298 GiB)
[    0.760867] sd 0:0:0:0: [sda] Write Protect is off
[    0.760920] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.760942] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.761076] sd 0:0:0:0: [sda] 625140335 512-byte hardware sectors:
(320 GB/298 GiB)
[    0.761163] sd 0:0:0:0: [sda] Write Protect is off
[    0.761215] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.761235] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.761320]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    0.801962] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.802104] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.969879] ata2.00: HPA detected: current 312579695, native 312581808
[    0.969947] ata2.00: ATA-7: WDC WD1600AAJB-00PVA0, 00.07H00, max UDMA/100
[    0.970015] ata2.00: 312579695 sectors, multi 16: LBA48
[    0.970101] ata2.01: ATAPI: HL-DT-STDVD-RAM GSA-H55N, 1.04, max UDMA/66
[    0.973417] ata2.00: configured for UDMA/100
[    0.979294] ata2.01: configured for UDMA/66
[    0.991133] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD1600AAJB-0 00.0 PQ: 0 ANSI: 5
[    0.991351] sd 1:0:0:0: [sdb] 312579695 512-byte hardware sectors:
(160 GB/149 GiB)
[    0.991440] sd 1:0:0:0: [sdb] Write Protect is off
[    0.991492] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.991512] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.991639] sd 1:0:0:0: [sdb] 312579695 512-byte hardware sectors:
(160 GB/149 GiB)
[    0.991725] sd 1:0:0:0: [sdb] Write Protect is off
[    0.991777] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.991798] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.991879]  sdb: sdb1
[    1.001531] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.001663] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.003085] scsi 1:0:1:0: CD-ROM            HL-DT-ST DVD-RAM
GSA-H55N 1.04 PQ: 0 ANSI: 5
[    1.007355] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
[    1.007445] Uniform CD-ROM driver Revision: 3.20
[    1.007637] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    1.007713] sr 1:0:1:0: Attached scsi generic sg2 type 5
[    1.007938] PNP: No PS/2 controller found. Probing ports directly.
[    1.008359] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.008415] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.008587] mice: PS/2 mouse device common for all mice
[    1.008751] input: PC Speaker as /class/input/input0
[    1.012377] cpuidle: using governor ladder
[    1.012435] cpuidle: using governor menu
[    1.012865] TCP bic registered
[    1.012913] NET: Registered protocol family 17
[    1.012980] Using IPI No-Shortcut mode
[    1.250830] EXT3-fs: mounted filesystem with ordered data mode.
[    1.250906] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    1.251090] Freeing unused kernel memory: 324k freed
[    1.251199] Write protecting the kernel text: 2812k
[    1.251281] Write protecting the kernel read-only data: 784k
[    1.251400] kjournald starting.  Commit interval 5 seconds
[    2.742449] input: Power Button (FF) as /class/input/input1
[    2.750076] ACPI: Power Button (FF) [PWRF]
[    2.750192] input: Power Button (CM) as /class/input/input2
[    2.758073] ACPI: Power Button (CM) [PWRB]
[    2.840596] parport_pc 00:09: reported by Plug and Play ACPI
[    2.840684] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.862894] usbcore: registered new interface driver usbfs
[    2.862992] usbcore: registered new interface driver hub
[    2.864066] usbcore: registered new device driver usb
[    2.968418] rtc_cmos 00:04: RTC can wake from S4
[    2.968547] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    2.968633] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    3.085939] intel_rng: FWH not detected
[    3.205856] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.205936] r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.206016] r8169 0000:02:00.0: setting latency timer to 64
[    3.206105] r8169 0000:02:00.0: irq 26 for MSI/MSI-X
[    3.206399] eth0: RTL8168c/8111c at 0xf8070000, 00:1d:7d:a2:d0:70,
XID 3c2000c0 IRQ 26
[    3.216409] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    3.218617] uhci_hcd: USB Universal Host Controller Interface driver
[    3.218743] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.218821] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.218826] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.218937] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[    3.219060] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e000
[    3.219211] usb usb1: configuration #1 chosen from 1 choice
[    3.219307] hub 1-0:1.0: USB hub found
[    3.219366] hub 1-0:1.0: 2 ports detected
[    3.219533] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.219606] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.219609] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.219697] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[    3.219812] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e100
[    3.219943] usb usb2: configuration #1 chosen from 1 choice
[    3.220027] hub 2-0:1.0: USB hub found
[    3.220083] hub 2-0:1.0: 2 ports detected
[    3.220229] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.220308] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.220312] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.220390] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[    3.220494] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e200
[    3.220627] usb usb3: configuration #1 chosen from 1 choice
[    3.220708] hub 3-0:1.0: USB hub found
[    3.220762] hub 3-0:1.0: 2 ports detected
[    3.220906] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.220971] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.220975] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.221053] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[    3.221160] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e300
[    3.221292] usb usb4: configuration #1 chosen from 1 choice
[    3.221376] hub 4-0:1.0: USB hub found
[    3.221432] hub 4-0:1.0: 2 ports detected
[    3.235179] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.235257] Warning! ehci_hcd should always be loaded before
uhci_hcd and ohci_hcd, not after
[    3.235382] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.235475] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.235479] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.235569] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[    3.239544] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.239557] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe1384000
[    3.249268] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.249454] usb usb5: configuration #1 chosen from 1 choice
[    3.249555] hub 5-0:1.0: USB hub found
[    3.249621] hub 5-0:1.0: 8 ports detected
[    3.289258] 8139too Fast Ethernet driver 0.9.28
[    3.289350] 8139too 0000:03:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.290133] eth1: RealTek RTL8139 at 0xd000, 00:40:f4:b0:9f:6e, IRQ 20
[    3.290190] eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
[    3.295420] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    3.300076] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    3.300270] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2,
TCOBASE=0x0460)
[    3.300405] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.467260] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[    3.467441] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.757070] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    3.976991] usb 4-1: configuration #1 chosen from 1 choice
[    4.121120] usbcore: registered new interface driver hiddev
[    4.152539] input: PATEN USB/PS2 Combo Receiver as /class/input/input3
[    4.158308] generic-usb 0003:1020:0206.0001: input: USB HID v1.10
Mouse [PATEN USB/PS2 Combo Receiver] on usb-0000:00:1d.3-1/input0
[    4.158436] usbcore: registered new interface driver usbhid
[    4.158505] usbhid: v2.6:USB HID core driver
[    4.189035] usb 4-2: new low speed USB device using uhci_hcd and address 3
[    4.349689] usb 4-2: configuration #1 chosen from 1 choice
[    4.367550] input: USB-compliant keyboard as /class/input/input4
[    4.376086] generic-usb 0003:062A:0201.0002: input: USB HID v1.10
Keyboard [USB-compliant keyboard] on usb-0000:00:1d.3-2/input0
[    4.402631] input: USB-compliant keyboard as /class/input/input5
[    4.415236] generic-usb 0003:062A:0201.0003: input,hiddev96: USB
HID v1.10 Mouse [USB-compliant keyboard] on usb-0000:00:1d.3-2/input1
[    4.547234] Adding 2931852k swap on /dev/sda3.  Priority:-1
extents:1 across:2931852k
[    4.948366] EXT3 FS on sda2, internal journal
[    5.625653] loop: module loaded
[    5.639515] it87: Found IT8718F chip at 0x290, revision 4
[    5.639588] it87: in3 is VCC (+5V)
[    5.646684] coretemp coretemp.0: Using relative temperature scale!
[    5.646797] coretemp coretemp.1: Using relative temperature scale!
[    5.721727] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    6.238074] fuse init (API version 7.11)
[    6.281697] kjournald starting.  Commit interval 5 seconds
[    6.281953] EXT3 FS on sda5, internal journal
[    6.282042] EXT3-fs: mounted filesystem with ordered data mode.
[    7.638813] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[    9.536969] lp0: using parport0 (interrupt-driven).
[    9.544385] ppdev: user-space parallel port driver
[   10.317127] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.338786] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   10.339022] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[   10.339113] nf_conntrack.acct=1 kernel paramater, acct=1
nf_conntrack module option or
[   10.339209] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   12.963585] vboxdrv: disagrees about version of symbol struct_module
[   14.150244] Bluetooth: Core ver 2.14
[   14.150386] NET: Registered protocol family 31
[   14.150451] Bluetooth: HCI device and connection manager initialized
[   14.150523] Bluetooth: HCI socket layer initialized
[   14.195755] Bluetooth: L2CAP ver 2.11
[   14.195821] Bluetooth: L2CAP socket layer initialized
[   14.223109] Bluetooth: RFCOMM socket layer initialized
[   14.223191] Bluetooth: RFCOMM TTY layer initialized
[   14.223530] Bluetooth: RFCOMM ver 1.10
[   16.383701] [drm] Initialized drm 1.1.0 20060810
[   16.418166] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.418176] pci 0000:00:02.0: setting latency timer to 64
[   16.420993] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   16.421076] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   16.747905] set status page addr 0x00043000
[   16.747932] [drm:i915_set_status_page] *ERROR* can not ioremap
virtual address for G33 hw status page



-- 
Maciej Rutecki
http://www.maciek.unixy.pl
