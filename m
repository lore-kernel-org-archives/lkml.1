Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZGVNZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZGVNZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZGVNZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:25:54 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:61769 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZGVNZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=kGLo/Xs9UsJXA0z+dod0409NWEIK0XAWPY8UtkwenxhFd2JQyS1umNXgsqsmRubJIj
         GtoK1tZVPWv0x2IosdXk+xyxLo9wDTfXqTa8dEfr6Sv8VhBEkOlFoLQddJzNFRmG4F4U
         dHQ7Yn/H+u3vFzCHVaINwciM8FPT8jKRIqGp8=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Alberto Gonzalez <alberto6674@gmail.com>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Wed, 22 Jul 2009 15:25:29 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907202306.52305.info@gnebu.es> <200907210048.37432.info@gnebu.es>
In-Reply-To: <200907210048.37432.info@gnebu.es>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JNxZK9PLjQtKOfr"
Message-Id: <200907221525.29507.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JNxZK9PLjQtKOfr
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 21 July 2009 00:48:36 Alberto Gonzalez wrote:
> If what you need is the exact lines just before the "storm" starts let me
> know and I'll keep trying, but it's not easy because I'll have to be very
> fast in detecting the problem has started and logging the output of dmesg.

Ok, I caught a complete log from boot to when the problem starts. There 
doesn't seem to be anything significantly different, but just in case.



--Boundary-00=_JNxZK9PLjQtKOfr
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg-complete.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-complete.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.1 (root@localhost) (gcc version 4.4.0 20090630 (prerelease) (GCC) ) #1 SMP Sat Jul 4 22:19:30 CEST 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7d90000 (usable)
[    0.000000]  BIOS-e820: 00000000c7d90000 - 00000000c7d9e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7d9e000 - 00000000c7de0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7de0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0xc7d90 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 120000000 mask FF0000000 write-back
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 base 0C7E00000 mask FFFE00000 uncachable
[    0.000000]   6 base 0C8000000 mask FF8000000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c7e00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7d90000 (usable)
[    0.000000]  modified: 00000000c7d90000 - 00000000c7d9e000 (ACPI data)
[    0.000000]  modified: 00000000c7d9e000 - 00000000c7de0000 (ACPI NVS)
[    0.000000]  modified: 00000000c7de0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37fa0000 - 37fefc1e
[    0.000000] Allocated new RAMDISK: 00008000 - 00057c1e
[    0.000000] Move RAMDISK from 0000000037fa0000 - 0000000037fefc1d to 00008000 - 00057c1d
[    0.000000] ACPI: RSDP 000f9cd0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT c7d90000 00044 (v01 DELL    AS09    20090511 MSFT 00000097)
[    0.000000] ACPI: FACP c7d90200 00084 (v01 051109 FACP1620 20090511 MSFT 00000097)
[    0.000000] ACPI: DSDT c7d905c0 05270 (v01  1ADXP 1ADXP005 00000005 INTL 20051117)
[    0.000000] ACPI: FACS c7d9e000 00040
[    0.000000] ACPI: APIC c7d90390 0006C (v01 051109 APIC1620 20090511 MSFT 00000097)
[    0.000000] ACPI: MCFG c7d90400 0003C (v01 051109 OEMMCFG  20090511 MSFT 00000097)
[    0.000000] ACPI: SLIC c7d90440 00176 (v01 DELL    AS09    20090511 MSFT 00000097)
[    0.000000] ACPI: OEMB c7d9e040 00072 (v01 051109 OEMB1620 20090511 MSFT 00000097)
[    0.000000] ACPI: HPET c7d985c0 00038 (v01 051109 OEMHPET  20090511 MSFT 00000097)
[    0.000000] ACPI: GSCI c7d9e0c0 02024 (v01 051109 GMCHSCI  20090511 MSFT 00000097)
[    0.000000] ACPI: SSDT c7da0b40 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2309MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00058000 - 0005ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00016f1500]    TEXT DATA BSS ==> [0001000000 - 00016f1500]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [00016f2000 - 00016f90e0]              BRK ==> [00016f2000 - 00016f90e0]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 0000057c1e]      NEW RAMDISK ==> [0000008000 - 0000057c1e]
[    0.000000]   #8 [0000058000 - 000005f000]          BOOTMAP ==> [0000058000 - 000005f000]
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000c7d90
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7d90
[    0.000000] On node 0 totalpages: 818475
[    0.000000] free_area_init_node: node 0, pgdat c15d6500, node_mem_map c16fa000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4620 pages used for memmap
[    0.000000]   HighMem zone: 586630 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages at c300a000, static data 23772 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 812079
[    0.000000] Kernel command line: root=/dev/disk/by-uuid/2bfe816c-08ba-4962-9cb7-f54396fba685 ro i915.modeset=1 enable_mtrr_cleanup
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2500.105 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Initializing HighMem for node 0 (000377fe:000c7d90)
[    0.000999] Memory: 3238812k/3274304k available (3880k kernel code, 34196k reserved, 2157k data, 344k init, 2365000k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc15ed000 - 0xc1643000   ( 344 kB)
[    0.000999]       .data : 0xc13ca3d9 - 0xc15e5b4c   (2157 kB)
[    0.000999]       .text : 0xc1000000 - 0xc13ca3d9   (3880 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.21 BogoMIPS (lpj=2500105)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] Initializing cgroup subsys ns
[    0.000999] Initializing cgroup subsys cpuacct
[    0.000999] Initializing cgroup subsys freezer
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.001009] Intel machine check architecture supported.
[    0.001079] Intel machine check reporting enabled on CPU#0.
[    0.001148] using mwait in idle threads.
[    0.001219] Checking 'hlt' instruction... OK.
[    0.005486] ACPI: Core revision 20090320
[    0.013359] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023698] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.023996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 6983.99 BogoMIPS (lpj=3491996)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.096127] CPU1: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.096991] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.098003] Brought up 2 CPUs
[    0.098068] Total of 2 processors activated (11984.20 BogoMIPS).
[    0.099039] khelper used greatest stack depth: 7048 bytes left
[    0.099119] net_namespace: 1028 bytes
[    0.099119] Time: 15:07:46  Date: 07/22/09
[    0.099119] NET: Registered protocol family 16
[    0.099196] ACPI: bus type pci registered
[    0.100023] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.100091] PCI: Not using MMCONFIG.
[    0.100288] PCI: Using configuration type 1 for base access
[    0.105065] bio: create slab <bio-0> at 0
[    0.106333] ACPI: EC: Look up EC in DSDT
[    0.112367] ACPI: Interpreter enabled
[    0.112436] ACPI: (supports S0 S1 S3 S4 S5)
[    0.112612] ACPI: Using IOAPIC for interrupt routing
[    0.112725] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.114171] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.114245] PCI: Using MMCONFIG for extended config space
[    0.121476] ACPI: No dock devices found.
[    0.121727] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.121815] pci 0000:00:02.0: reg 10 64bit mmio: [0xfe400000-0xfe7fffff]
[    0.121815] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.121815] pci 0000:00:02.0: reg 20 io port: [0xdc00-0xdc07]
[    0.121815] pci 0000:00:02.1: reg 10 64bit mmio: [0xfe800000-0xfe8fffff]
[    0.122029] pci 0000:00:1a.0: reg 20 io port: [0xd880-0xd89f]
[    0.122092] pci 0000:00:1a.1: reg 20 io port: [0xd800-0xd81f]
[    0.122154] pci 0000:00:1a.2: reg 20 io port: [0xd480-0xd49f]
[    0.122218] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe9fbc00-0xfe9fbfff]
[    0.122268] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.122342] pci 0000:00:1a.7: PME# disabled
[    0.122442] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe9f4000-0xfe9f7fff]
[    0.122480] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.122552] pci 0000:00:1b.0: PME# disabled
[    0.122668] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.122741] pci 0000:00:1c.0: PME# disabled
[    0.122858] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.122931] pci 0000:00:1c.2: PME# disabled
[    0.123044] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.123117] pci 0000:00:1c.5: PME# disabled
[    0.123229] pci 0000:00:1d.0: reg 20 io port: [0xd400-0xd41f]
[    0.123292] pci 0000:00:1d.1: reg 20 io port: [0xd080-0xd09f]
[    0.123354] pci 0000:00:1d.2: reg 20 io port: [0xd000-0xd01f]
[    0.123419] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe9fb800-0xfe9fbbff]
[    0.123468] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.123541] pci 0000:00:1d.7: PME# disabled
[    0.123713] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.123825] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.123900] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.124029] pci 0000:00:1f.2: reg 10 io port: [0xcc00-0xcc07]
[    0.124035] pci 0000:00:1f.2: reg 14 io port: [0xc880-0xc883]
[    0.124040] pci 0000:00:1f.2: reg 18 io port: [0xc800-0xc807]
[    0.124045] pci 0000:00:1f.2: reg 1c io port: [0xc480-0xc483]
[    0.124050] pci 0000:00:1f.2: reg 20 io port: [0xc400-0xc40f]
[    0.124055] pci 0000:00:1f.2: reg 24 io port: [0xc080-0xc08f]
[    0.124096] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe9fb400-0xfe9fb4ff]
[    0.124109] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.124147] pci 0000:00:1f.5: reg 10 io port: [0xbc00-0xbc07]
[    0.124152] pci 0000:00:1f.5: reg 14 io port: [0xb880-0xb883]
[    0.124157] pci 0000:00:1f.5: reg 18 io port: [0xb800-0xb807]
[    0.124162] pci 0000:00:1f.5: reg 1c io port: [0xb480-0xb483]
[    0.124167] pci 0000:00:1f.5: reg 20 io port: [0xb400-0xb40f]
[    0.124173] pci 0000:00:1f.5: reg 24 io port: [0xb080-0xb08f]
[    0.124284] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.124294] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.124321] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.124331] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.124422] pci 0000:00:1c.2: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.124468] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.124487] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
[    0.124500] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.124508] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.124545] pci 0000:03:00.0: supports D1 D2
[    0.124546] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.124621] pci 0000:03:00.0: PME# disabled
[    0.124734] pci 0000:00:1c.5: bridge io port: [0xe000-0xefff]
[    0.124737] pci 0000:00:1c.5: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.124743] pci 0000:00:1c.5: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.124785] pci 0000:00:1e.0: transparent bridge
[    0.124874] pci_bus 0000:00: on NUMA node 0
[    0.124879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.125053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.125118] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.125168] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.125215] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.141119] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.141441] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.142037] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.142419] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.142800] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.143173] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.143554] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.143936] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.144274] SCSI subsystem initialized
[    0.144274] libata version 3.00 loaded.
[    0.144274] usbcore: registered new interface driver usbfs
[    0.144274] usbcore: registered new interface driver hub
[    0.144994] usbcore: registered new device driver usb
[    0.145054] PCI: Using ACPI for IRQ routing
[    0.147987] NetLabel: Initializing
[    0.148058] NetLabel:  domain hash size = 128
[    0.148131] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.148215] NetLabel:  unlabeled traffic allowed by default
[    0.148292] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.148292] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.153987] pnp: PnP ACPI init
[    0.154067] ACPI: bus type pnp registered
[    0.156087] pnp: PnP ACPI: found 12 devices
[    0.156154] ACPI: ACPI bus type pnp unregistered
[    0.156227] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.156301] system 00:01: iomem range 0xfed90000-0xfed93fff has been reserved
[    0.156378] system 00:06: ioport range 0xa00-0xadf has been reserved
[    0.156453] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.156526] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.156598] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.156671] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.156745] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.156819] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.156895] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.156969] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.157049] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.157127] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.157199] system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
[    0.157273] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[    0.157346] system 00:0b: iomem range 0x100000-0xc7dfffff could not be reserved
[    0.157457] system 00:0b: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.192495] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.192565] pci 0000:00:1c.0:   IO window: disabled
[    0.192636] pci 0000:00:1c.0:   MEM window: disabled
[    0.192705] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.192778] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.192849] pci 0000:00:1c.2:   IO window: disabled
[    0.192920] pci 0000:00:1c.2:   MEM window: 0xfea00000-0xfeafffff
[    0.192995] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.193068] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
[    0.193139] pci 0000:00:1c.5:   IO window: 0xe000-0xefff
[    0.193210] pci 0000:00:1c.5:   MEM window: 0xfeb00000-0xfebfffff
[    0.193283] pci 0000:00:1c.5:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.193397] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.193467] pci 0000:00:1e.0:   IO window: disabled
[    0.193537] pci 0000:00:1e.0:   MEM window: disabled
[    0.193607] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.193685]   alloc irq_desc for 17 on cpu 0 node 0
[    0.193687]   alloc kstat_irqs on cpu 0 node 0
[    0.193691] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.193766] pci 0000:00:1c.0: setting latency timer to 64
[    0.193772]   alloc irq_desc for 18 on cpu 0 node 0
[    0.193773]   alloc kstat_irqs on cpu 0 node 0
[    0.193776] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.193850] pci 0000:00:1c.2: setting latency timer to 64
[    0.193855]   alloc irq_desc for 16 on cpu 0 node 0
[    0.193857]   alloc kstat_irqs on cpu 0 node 0
[    0.193859] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.193933] pci 0000:00:1c.5: setting latency timer to 64
[    0.193938] pci 0000:00:1e.0: setting latency timer to 64
[    0.193941] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.193944] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.193946] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.193948] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.193950] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.193952] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.193954] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.193956] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    0.193981] NET: Registered protocol family 2
[    0.203055] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.203338] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.203806] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.204074] TCP: Hash tables configured (established 131072 bind 65536)
[    0.204147] TCP reno registered
[    0.206086] NET: Registered protocol family 1
[    0.206215] Trying to unpack rootfs image as initramfs...
[    0.214451] Freeing initrd memory: 319k freed
[    0.214992] Machine check exception polling timer started.
[    0.215474] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.215586] Scanning for low memory corruption every 60 seconds
[    0.215903] audit: initializing netlink socket (disabled)
[    0.216001] type=2000 audit(1248275266.215:1): initialized
[    0.225228] highmem bounce pool size: 64 pages
[    0.225298] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.227555] VFS: Disk quotas dquot_6.5.2
[    0.227685] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.228529] msgmni has been set to 1709
[    0.228677] SELinux:  Registering netfilter hooks
[    0.228970] alg: No test for stdrng (krng)
[    0.229118] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.229229] io scheduler noop registered
[    0.229295] io scheduler anticipatory registered
[    0.229362] io scheduler deadline registered
[    0.229475] io scheduler cfq registered (default)
[    0.229553] pci 0000:00:02.0: Boot video device
[    0.229560] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.229561] pci 0000:00:1a.0: Performing full reset
[    0.229575] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229577] pci 0000:00:1a.1: Performing full reset
[    0.229591] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229592] pci 0000:00:1a.2: Performing full reset
[    0.229626] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.229627] pci 0000:00:1d.0: Performing full reset
[    0.229641] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229643] pci 0000:00:1d.1: Performing full reset
[    0.229656] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229658] pci 0000:00:1d.2: Performing full reset
[    0.229798]   alloc irq_desc for 24 on cpu 0 node 0
[    0.229799]   alloc kstat_irqs on cpu 0 node 0
[    0.229808] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.229821] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.230013]   alloc irq_desc for 25 on cpu 0 node 0
[    0.230015]   alloc kstat_irqs on cpu 0 node 0
[    0.230021] pcieport-driver 0000:00:1c.2: irq 25 for MSI/MSI-X
[    0.230032] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.230202]   alloc irq_desc for 26 on cpu 0 node 0
[    0.230203]   alloc kstat_irqs on cpu 0 node 0
[    0.230209] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.230220] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.230397] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.230680] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.230792] ACPI: Power Button [PWRF]
[    0.230926] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.231040] ACPI: Power Button [PWRB]
[    0.231481] ACPI: SSDT c7da00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.231877] ACPI: SSDT c7da05f0 004B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.232283] Monitor-Mwait will be used to enter C-1 state
[    0.232302] Monitor-Mwait will be used to enter C-2 state
[    0.232309] Marking TSC unstable due to TSC halts in idle
[    0.232393] Switched to high resolution mode on CPU 0
[    0.232420] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    0.232582] processor ACPI_CPU:00: registered as cooling_device0
[    0.232741] Switched to high resolution mode on CPU 1
[    0.232927] ACPI: SSDT c7da0370 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    0.233301] ACPI: SSDT c7da0ab0 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    0.233774] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    0.233932] processor ACPI_CPU:01: registered as cooling_device1
[    0.238260] Non-volatile memory driver v1.3
[    0.238408] Linux agpgart interface v0.103
[    0.238520] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    0.239267] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    0.241273] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.241431] [drm] Initialized drm 1.1.0 20060810
[    0.241513] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.241587] i915 0000:00:02.0: setting latency timer to 64
[    0.242726] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    0.242843] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.242931]   alloc irq_desc for 27 on cpu 0 node 0
[    0.242932]   alloc kstat_irqs on cpu 0 node 0
[    0.242940] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.243298] ------------[ cut here ]------------
[    0.243373] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[    0.243486] Hardware name: Studio 540      
[    0.243552] hotplug uevent
[    0.243613] Modules linked in:
[    0.243698] Pid: 1, comm: swapper Not tainted 2.6.30.1 #1
[    0.243767] Call Trace:
[    0.243833]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[    0.243903]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[    0.243974]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[    0.244050]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[    0.244121]  [<c11ea2e7>] drm_sysfs_connector_add+0x137/0x16c
[    0.244199]  [<c11fe996>] intel_crt_init+0x100/0x10a
[    0.244268]  [<c11fddb7>] intel_modeset_init+0x324/0x6c1
[    0.244339]  [<c11f2ab6>] i915_driver_load+0x872/0x8cb
[    0.244409]  [<c11e8659>] drm_get_dev+0x2b9/0x398
[    0.244479]  [<c13b779b>] i915_pci_probe+0xd/0xf
[    0.244548]  [<c1184fc6>] local_pci_probe+0xe/0x10
[    0.244617]  [<c11859cf>] pci_device_probe+0x43/0x66
[    0.245393]  [<c120f4a3>] driver_probe_device+0x79/0xed
[    0.245463]  [<c120f55a>] __driver_attach+0x43/0x5f
[    0.245531]  [<c120ed61>] bus_for_each_dev+0x3d/0x67
[    0.245600]  [<c120f37c>] driver_attach+0x14/0x16
[    0.245668]  [<c120f517>] ? __driver_attach+0x0/0x5f
[    0.245737]  [<c120f103>] bus_add_driver+0x8f/0x1b8
[    0.245807]  [<c1175ad0>] ? kset_find_obj+0x23/0x4e
[    0.245875]  [<c120f787>] driver_register+0x79/0xdd
[    0.245944]  [<c1185b94>] __pci_register_driver+0x38/0x95
[    0.246020]  [<c13c4e62>] ? printk+0xf/0x11
[    0.246087]  [<c11e4c28>] drm_init+0x5b/0xb3
[    0.246159]  [<c160c8e4>] i915_init+0x46/0x48
[    0.246226]  [<c1001137>] do_one_initcall+0x4a/0x10c
[    0.246296]  [<c160c89e>] ? i915_init+0x0/0x48
[    0.246364]  [<c105c2cd>] ? register_irq_proc+0x7c/0x95
[    0.246433]  [<c105c339>] ? init_irq_proc+0x53/0x60
[    0.246502]  [<c15ed2de>] kernel_init+0x10b/0x15c
[    0.246570]  [<c15ed1d3>] ? kernel_init+0x0/0x15c
[    0.246639]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[    0.246712] ---[ end trace 27037b79aef5c5c2 ]---
[    0.251484] ------------[ cut here ]------------
[    0.251554] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[    0.251666] Hardware name: Studio 540      
[    0.251732] hotplug uevent
[    0.251794] Modules linked in:
[    0.251877] Pid: 1, comm: swapper Tainted: G        W  2.6.30.1 #1
[    0.251948] Call Trace:
[    0.252016]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[    0.252087]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[    0.252161]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[    0.252231]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[    0.252302]  [<c11ea2e7>] drm_sysfs_connector_add+0x137/0x16c
[    0.252373]  [<c11ff738>] intel_hdmi_init+0xe2/0x13e
[    0.252442]  [<c11fdf10>] intel_modeset_init+0x47d/0x6c1
[    0.252512]  [<c11f2ab6>] i915_driver_load+0x872/0x8cb
[    0.252582]  [<c11e8659>] drm_get_dev+0x2b9/0x398
[    0.252650]  [<c13b779b>] i915_pci_probe+0xd/0xf
[    0.252718]  [<c1184fc6>] local_pci_probe+0xe/0x10
[    0.252787]  [<c11859cf>] pci_device_probe+0x43/0x66
[    0.252855]  [<c120f4a3>] driver_probe_device+0x79/0xed
[    0.252925]  [<c120f55a>] __driver_attach+0x43/0x5f
[    0.252993]  [<c120ed61>] bus_for_each_dev+0x3d/0x67
[    0.253067]  [<c120f37c>] driver_attach+0x14/0x16
[    0.253138]  [<c120f517>] ? __driver_attach+0x0/0x5f
[    0.253207]  [<c120f103>] bus_add_driver+0x8f/0x1b8
[    0.253276]  [<c1175ad0>] ? kset_find_obj+0x23/0x4e
[    0.253344]  [<c120f787>] driver_register+0x79/0xdd
[    0.253414]  [<c1185b94>] __pci_register_driver+0x38/0x95
[    0.253483]  [<c13c4e62>] ? printk+0xf/0x11
[    0.253550]  [<c11e4c28>] drm_init+0x5b/0xb3
[    0.253617]  [<c160c8e4>] i915_init+0x46/0x48
[    0.253685]  [<c1001137>] do_one_initcall+0x4a/0x10c
[    0.253753]  [<c160c89e>] ? i915_init+0x0/0x48
[    0.253821]  [<c105c2cd>] ? register_irq_proc+0x7c/0x95
[    0.253891]  [<c105c339>] ? init_irq_proc+0x53/0x60
[    0.253959]  [<c15ed2de>] kernel_init+0x10b/0x15c
[    0.254034]  [<c15ed1d3>] ? kernel_init+0x0/0x15c
[    0.254102]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[    0.254173] ---[ end trace 27037b79aef5c5c3 ]---
[    0.451458] ------------[ cut here ]------------
[    0.451527] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[    0.451639] Hardware name: Studio 540      
[    0.451704] hotplug uevent
[    0.451766] Modules linked in:
[    0.451849] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[    0.451920] Call Trace:
[    0.451984]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[    0.452060]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[    0.452133]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[    0.452202]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[    0.452273]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[    0.452344]  [<c1032f28>] worker_thread+0x131/0x1ab
[    0.452412]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[    0.452483]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[    0.452554]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[    0.452622]  [<c1035c84>] kthread+0x46/0x6a
[    0.452689]  [<c1035c3e>] ? kthread+0x0/0x6a
[    0.452756]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[    0.452824] ---[ end trace 27037b79aef5c5c4 ]---
[    0.498811] allocated 1152x864 fb: 0x08020000, bo f73b6900
[    0.560256] [drm] DAC-6: set mode 1152x864 19
[    0.583506] Console: switching to colour frame buffer device 144x54
[    0.586410] fb0: inteldrmfb frame buffer device
[    0.586435] registered panic notifier
[    0.586466] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.586549] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.588301] brd: module loaded
[    0.588964] loop: module loaded
[    0.589078] Driver 'sd' needs updating - please use bus_type methods
[    0.589160] Driver 'sr' needs updating - please use bus_type methods
[    0.589313] ata_piix 0000:00:1f.2: version 2.13
[    0.589327]   alloc irq_desc for 19 on cpu 0 node 0
[    0.589329]   alloc kstat_irqs on cpu 0 node 0
[    0.589335] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.589376] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.589458] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.589499] scsi0 : ata_piix
[    0.589628] scsi1 : ata_piix
[    0.590818] ata1: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    0.590859] ata2: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    0.590911] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.590951] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    0.591028] ata_piix 0000:00:1f.5: setting latency timer to 64
[    0.591081] scsi2 : ata_piix
[    0.591188] scsi3 : ata_piix
[    0.592187] ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    0.592227] ata4: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    0.592429] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    0.592464] Copyright (c) 1999-2006 Intel Corporation.
[    0.592527] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    0.592560] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.592628] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.592661] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.592766] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.592805] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.593580] r8169 0000:03:00.0: setting latency timer to 64
[    0.593645]   alloc irq_desc for 28 on cpu 0 node 0
[    0.593646]   alloc kstat_irqs on cpu 0 node 0
[    0.593657] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    0.593865] eth0: RTL8168c/8111c at 0xf8056000, 00:21:70:4c:c3:ac, XID 3c4000c0 IRQ 28
[    0.597461] console [netcon0] enabled
[    0.598275] netconsole: network logging started
[    0.599233] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.600109] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    0.600124] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.601034] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.601037] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.601994] drivers/usb/core/inode.c: creating file 'devices'
[    0.601998] drivers/usb/core/inode.c: creating file '001'
[    0.602041] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.602994] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.602997] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.603017] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.606907] ehci_hcd 0000:00:1a.7: debug port 1
[    0.607868] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.607870] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.607880] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[    0.608863] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.612731] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.619012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.620085] usb usb1: default language 0x0409
[    0.620090] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.621117] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.622163] usb usb1: Product: EHCI Host Controller
[    0.623224] usb usb1: Manufacturer: Linux 2.6.30.1 ehci_hcd
[    0.624310] usb usb1: SerialNumber: 0000:00:1a.7
[    0.625440] usb usb1: uevent
[    0.625469] usb usb1: usb_probe_device
[    0.625471] usb usb1: configuration #1 chosen from 1 choice
[    0.626595] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.626608] usb 1-0:1.0: uevent
[    0.626638] hub 1-0:1.0: usb_probe_interface
[    0.626639] hub 1-0:1.0: usb_probe_interface - got id
[    0.626641] hub 1-0:1.0: USB hub found
[    0.627782] hub 1-0:1.0: 6 ports detected
[    0.628930] hub 1-0:1.0: standalone hub
[    0.628932] hub 1-0:1.0: no power switching (usb 1.0)
[    0.628933] hub 1-0:1.0: individual port over-current protection
[    0.628935] hub 1-0:1.0: power on to power good time: 20ms
[    0.628938] hub 1-0:1.0: local power source is good
[    0.628940] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.629026] drivers/usb/core/inode.c: creating file '001'
[    0.629077]   alloc irq_desc for 23 on cpu 0 node 0
[    0.629079]   alloc kstat_irqs on cpu 0 node 0
[    0.629082] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.630259] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.630262] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.631455] drivers/usb/core/inode.c: creating file '002'
[    0.631494] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.632668] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.632672] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.632688] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.636569] ehci_hcd 0000:00:1d.7: debug port 1
[    0.637734] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.637735] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.637746] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[    0.638914] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.642790] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.649012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.650232] usb usb2: default language 0x0409
[    0.650237] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.651379] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.652548] usb usb2: Product: EHCI Host Controller
[    0.653688] usb usb2: Manufacturer: Linux 2.6.30.1 ehci_hcd
[    0.654846] usb usb2: SerialNumber: 0000:00:1d.7
[    0.656017] usb usb2: uevent
[    0.656046] usb usb2: usb_probe_device
[    0.656048] usb usb2: configuration #1 chosen from 1 choice
[    0.657195] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.657206] usb 2-0:1.0: uevent
[    0.657235] hub 2-0:1.0: usb_probe_interface
[    0.657237] hub 2-0:1.0: usb_probe_interface - got id
[    0.657238] hub 2-0:1.0: USB hub found
[    0.658379] hub 2-0:1.0: 6 ports detected
[    0.659526] hub 2-0:1.0: standalone hub
[    0.659527] hub 2-0:1.0: no power switching (usb 1.0)
[    0.659528] hub 2-0:1.0: individual port over-current protection
[    0.659530] hub 2-0:1.0: power on to power good time: 20ms
[    0.659533] hub 2-0:1.0: local power source is good
[    0.659535] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.659590] drivers/usb/core/inode.c: creating file '001'
[    0.659662] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.660808] ohci_hcd: block sizes: ed 64 td 64
[    0.660843] uhci_hcd: USB Universal Host Controller Interface driver
[    0.662043] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.663212] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.663214] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.664407] drivers/usb/core/inode.c: creating file '003'
[    0.664448] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.665624] uhci_hcd 0000:00:1a.0: detected 2 ports
[    0.666803] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.666805] uhci_hcd 0000:00:1a.0: Performing full reset
[    0.666817] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    0.666827] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[    0.668016] usb usb3: default language 0x0409
[    0.668021] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.669212] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.670410] usb usb3: Product: UHCI Host Controller
[    0.671583] usb usb3: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.672757] usb usb3: SerialNumber: 0000:00:1a.0
[    0.673945] usb usb3: uevent
[    0.673975] usb usb3: usb_probe_device
[    0.673977] usb usb3: configuration #1 chosen from 1 choice
[    0.675142] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    0.675153] usb 3-0:1.0: uevent
[    0.675182] hub 3-0:1.0: usb_probe_interface
[    0.675184] hub 3-0:1.0: usb_probe_interface - got id
[    0.675185] hub 3-0:1.0: USB hub found
[    0.676344] hub 3-0:1.0: 2 ports detected
[    0.677486] hub 3-0:1.0: standalone hub
[    0.677487] hub 3-0:1.0: no power switching (usb 1.0)
[    0.677488] hub 3-0:1.0: individual port over-current protection
[    0.677490] hub 3-0:1.0: power on to power good time: 2ms
[    0.677493] hub 3-0:1.0: local power source is good
[    0.677495] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    0.677539] drivers/usb/core/inode.c: creating file '001'
[    0.677595]   alloc irq_desc for 21 on cpu 0 node 0
[    0.677596]   alloc kstat_irqs on cpu 0 node 0
[    0.677600] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.678770] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.678773] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.679953] drivers/usb/core/inode.c: creating file '004'
[    0.679992] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.681139] uhci_hcd 0000:00:1a.1: detected 2 ports
[    0.682277] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.682279] uhci_hcd 0000:00:1a.1: Performing full reset
[    0.682291] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    0.682301] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[    0.683441] usb usb4: default language 0x0409
[    0.683446] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.684577] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.685724] usb usb4: Product: UHCI Host Controller
[    0.686847] usb usb4: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.687966] usb usb4: SerialNumber: 0000:00:1a.1
[    0.689111] usb usb4: uevent
[    0.689143] usb usb4: usb_probe_device
[    0.689145] usb usb4: configuration #1 chosen from 1 choice
[    0.690273] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    0.690285] usb 4-0:1.0: uevent
[    0.690313] hub 4-0:1.0: usb_probe_interface
[    0.690314] hub 4-0:1.0: usb_probe_interface - got id
[    0.690316] hub 4-0:1.0: USB hub found
[    0.691434] hub 4-0:1.0: 2 ports detected
[    0.692541] hub 4-0:1.0: standalone hub
[    0.692543] hub 4-0:1.0: no power switching (usb 1.0)
[    0.692544] hub 4-0:1.0: individual port over-current protection
[    0.692546] hub 4-0:1.0: power on to power good time: 2ms
[    0.692549] hub 4-0:1.0: local power source is good
[    0.692551] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    0.692595] drivers/usb/core/inode.c: creating file '001'
[    0.692651] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    0.693795] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.693797] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.694955] drivers/usb/core/inode.c: creating file '005'
[    0.694995] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.696137] uhci_hcd 0000:00:1a.2: detected 2 ports
[    0.697267] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.697269] uhci_hcd 0000:00:1a.2: Performing full reset
[    0.697282] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    0.697286] uhci_hcd 0000:00:1a.2: irq 21, io base 0x0000d480
[    0.698428] usb usb5: default language 0x0409
[    0.698433] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.699580] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.700732] usb usb5: Product: UHCI Host Controller
[    0.701862] usb usb5: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.702992] usb usb5: SerialNumber: 0000:00:1a.2
[    0.704136] usb usb5: uevent
[    0.704174] usb usb5: usb_probe_device
[    0.704176] usb usb5: configuration #1 chosen from 1 choice
[    0.705301] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    0.705315] usb 5-0:1.0: uevent
[    0.705348] hub 5-0:1.0: usb_probe_interface
[    0.705350] hub 5-0:1.0: usb_probe_interface - got id
[    0.705351] hub 5-0:1.0: USB hub found
[    0.706482] hub 5-0:1.0: 2 ports detected
[    0.707588] hub 5-0:1.0: standalone hub
[    0.707590] hub 5-0:1.0: no power switching (usb 1.0)
[    0.707591] hub 5-0:1.0: individual port over-current protection
[    0.707593] hub 5-0:1.0: power on to power good time: 2ms
[    0.707596] hub 5-0:1.0: local power source is good
[    0.707598] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    0.707645] drivers/usb/core/inode.c: creating file '001'
[    0.707702] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.708840] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.708843] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.709999] drivers/usb/core/inode.c: creating file '006'
[    0.710049] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.711194] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.712329] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.712331] uhci_hcd 0000:00:1d.0: Performing full reset
[    0.712343] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    0.712347] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    0.713498] usb usb6: default language 0x0409
[    0.713503] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.714645] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.715813] usb usb6: Product: UHCI Host Controller
[    0.716969] usb usb6: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.718113] usb usb6: SerialNumber: 0000:00:1d.0
[    0.719271] usb usb6: uevent
[    0.719301] usb usb6: usb_probe_device
[    0.719303] usb usb6: configuration #1 chosen from 1 choice
[    0.720430] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    0.720442] usb 6-0:1.0: uevent
[    0.720472] hub 6-0:1.0: usb_probe_interface
[    0.720473] hub 6-0:1.0: usb_probe_interface - got id
[    0.720475] hub 6-0:1.0: USB hub found
[    0.721598] hub 6-0:1.0: 2 ports detected
[    0.722707] hub 6-0:1.0: standalone hub
[    0.722708] hub 6-0:1.0: no power switching (usb 1.0)
[    0.722709] hub 6-0:1.0: individual port over-current protection
[    0.722711] hub 6-0:1.0: power on to power good time: 2ms
[    0.722714] hub 6-0:1.0: local power source is good
[    0.722716] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    0.722762] drivers/usb/core/inode.c: creating file '001'
[    0.722818]   alloc irq_desc for 20 on cpu 0 node 0
[    0.722820]   alloc kstat_irqs on cpu 0 node 0
[    0.722823] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    0.723970] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.723972] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.725141] drivers/usb/core/inode.c: creating file '007'
[    0.725184] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.726332] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.727461] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.727463] uhci_hcd 0000:00:1d.1: Performing full reset
[    0.727475] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    0.727485] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000d080
[    0.728633] usb usb7: default language 0x0409
[    0.728638] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.729782] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.730943] usb usb7: Product: UHCI Host Controller
[    0.732082] usb usb7: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.733229] usb usb7: SerialNumber: 0000:00:1d.1
[    0.734384] usb usb7: uevent
[    0.734403] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[    0.734405] hub 1-0:1.0: port 5: status 0501 change 0001
[    0.734412] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[    0.734415] hub 1-0:1.0: port 6: status 0501 change 0001
[    0.734422] usb usb7: usb_probe_device
[    0.734424] usb usb7: configuration #1 chosen from 1 choice
[    0.735553] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    0.735565] usb 7-0:1.0: uevent
[    0.735596] hub 7-0:1.0: usb_probe_interface
[    0.735598] hub 7-0:1.0: usb_probe_interface - got id
[    0.735599] hub 7-0:1.0: USB hub found
[    0.736724] hub 7-0:1.0: 2 ports detected
[    0.737829] hub 7-0:1.0: standalone hub
[    0.737830] hub 7-0:1.0: no power switching (usb 1.0)
[    0.737832] hub 7-0:1.0: individual port over-current protection
[    0.737833] hub 7-0:1.0: power on to power good time: 2ms
[    0.737837] hub 7-0:1.0: local power source is good
[    0.737838] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    0.737885] drivers/usb/core/inode.c: creating file '001'
[    0.737940] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.739087] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.739090] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.740254] drivers/usb/core/inode.c: creating file '008'
[    0.740298] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.741447] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.742575] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.742576] uhci_hcd 0000:00:1d.2: Performing full reset
[    0.742589] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    0.742593] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[    0.743743] usb usb8: default language 0x0409
[    0.743748] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.744891] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.746053] usb usb8: Product: UHCI Host Controller
[    0.747188] usb usb8: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.748335] usb usb8: SerialNumber: 0000:00:1d.2
[    0.749489] usb usb8: uevent
[    0.749518] usb usb8: usb_probe_device
[    0.749520] usb usb8: configuration #1 chosen from 1 choice
[    0.750649] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    0.750660] usb 8-0:1.0: uevent
[    0.750689] hub 8-0:1.0: usb_probe_interface
[    0.750691] hub 8-0:1.0: usb_probe_interface - got id
[    0.750693] hub 8-0:1.0: USB hub found
[    0.751815] hub 8-0:1.0: 2 ports detected
[    0.752924] hub 8-0:1.0: standalone hub
[    0.752925] hub 8-0:1.0: no power switching (usb 1.0)
[    0.752927] hub 8-0:1.0: individual port over-current protection
[    0.752928] hub 8-0:1.0: power on to power good time: 2ms
[    0.752932] hub 8-0:1.0: local power source is good
[    0.752933] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    0.752979] drivers/usb/core/inode.c: creating file '001'
[    0.753098] usbcore: registered new interface driver usblp
[    0.754238] Initializing USB Mass Storage driver...
[    0.755419] usbcore: registered new interface driver usb-storage
[    0.756563] USB Mass Storage support registered.
[    0.757745] usbcore: registered new interface driver libusual
[    0.759000] PNP: No PS/2 controller found. Probing ports directly.
[    0.760229] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    0.760231] hub 2-0:1.0: port 3: status 0501 change 0001
[    0.762469] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.763633] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.764800] mice: PS/2 mouse device common for all mice
[    0.766126] rtc_cmos 00:03: RTC can wake from S4
[    0.767304] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.768467] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.769644] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.771074] cpuidle: using governor ladder
[    0.772567] cpuidle: using governor menu
[    0.774702] usbcore: registered new interface driver hiddev
[    0.775906] usbcore: registered new interface driver usbhid
[    0.777026] usbhid: v2.6:USB HID core driver
[    0.778166] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.778190] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.780020]   alloc irq_desc for 22 on cpu 0 node 0
[    0.780022]   alloc kstat_irqs on cpu 0 node 0
[    0.780026] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.781204] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.792594] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.807029] uhci_hcd 0000:00:1a.2: port 1 portsc 008a,00
[    0.807043] uhci_hcd 0000:00:1a.2: port 2 portsc 008a,00
[    0.817121] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    0.822045] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.834030] hub 1-0:1.0: state 7 ports 6 chg 0060 evt 0000
[    0.834039] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    0.834048] ehci_hcd 0000:00:1a.7: port 5 low speed --> companion
[    0.837028] uhci_hcd 0000:00:1d.1: port 1 portsc 0082,00
[    0.844240] ALSA device list:
[    0.845404]   #0: HDA Intel at 0xfe9f4000 irq 22
[    0.846599] Netfilter messages via NETLINK v0.30.
[    0.847771] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.849161] ctnetlink v0.93: registering with nfnetlink.
[    0.850808] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.851999] TCP cubic registered
[    0.853157] Initializing XFRM netlink socket
[    0.854567] NET: Registered protocol family 10
[    0.856518] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.857724] IPv6 over IPv4 tunneling driver
[    0.859387] NET: Registered protocol family 17
[    0.860719] RPC: Registered udp transport module.
[    0.861871] RPC: Registered tcp transport module.
[    0.863537] Using IPI No-Shortcut mode
[    0.864804] PM: Resume from disk failed.
[    0.864815] registered taskstats version 1
[    0.866058]   Magic number: 1:315:134
[    0.867217] acpi device:09: hash matches
[    0.885030] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    0.885056] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    0.885065] ehci_hcd 0000:00:1a.7: port 6 low speed --> companion
[    0.914691] ata3: SATA link down (SStatus 0 SControl 300)
[    0.936029] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    0.936049] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    0.936057] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.936063] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    0.936070] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    0.987317] ehci_hcd 0000:00:1d.7: port 3 high speed
[    0.987320] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.038028] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    1.356079] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.357275] ata1.01: SATA link down (SStatus 0 SControl 300)
[    1.388622] ata1.00: ATA-8: ST3320613AS, DE13, max UDMA/133
[    1.389832] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.440640] ata1.00: configured for UDMA/133
[    1.441928] scsi 0:0:0:0: Direct-Access     ATA      ST3320613AS      DE13 PQ: 0 ANSI: 5
[    1.443322] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.443329] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.443340] sd 0:0:0:0: [sda] Write Protect is off
[    1.443342] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.443358] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.443435]  sda: sda1 sda2 sda3 sda4
[    1.536878] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.599318] ehci_hcd 0000:00:1d.7: port 3 high speed
[    1.599321] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.704028] usb usb3: suspend_rh (auto-stop)
[    1.704049] usb usb4: suspend_rh (auto-stop)
[    1.723586] usb 2-3: default language 0x0409
[    1.729084] usb 2-3: New USB device found, idVendor=0bda, idProduct=0151
[    1.730329] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.731535] usb 2-3: Product: USB2.0-CRW
[    1.732749] usb 2-3: Manufacturer: Generic
[    1.733954] usb 2-3: SerialNumber: 20060413092100000
[    1.735192] usb 2-3: uevent
[    1.735235] usb 2-3: usb_probe_device
[    1.735237] usb 2-3: configuration #1 chosen from 1 choice
[    1.737088] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[    1.737841] usb 2-3:1.0: uevent
[    1.737910] usb-storage 2-3:1.0: usb_probe_interface
[    1.737918] usb-storage 2-3:1.0: usb_probe_interface - got id
[    1.738011] scsi4 : SCSI emulation for USB Mass Storage devices
[    1.739332] usb-storage: device found at 2
[    1.739334] usb-storage: waiting for device to settle before scanning
[    1.739417] drivers/usb/core/inode.c: creating file '002'
[    1.739471] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    1.739477] uhci_hcd 0000:00:1a.2: port 1 portsc 01a3,00
[    1.739482] hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    1.843027] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    1.945030] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    1.954023] usb usb6: suspend_rh (auto-stop)
[    1.954043] usb usb8: suspend_rh (auto-stop)
[    1.954074] usb usb7: suspend_rh (auto-stop)
[    2.115447] usb 5-1: skipped 1 descriptor after interface
[    2.115452] usb 5-1: skipped 1 descriptor after interface
[    2.121444] usb 5-1: default language 0x0409
[    2.145444] usb 5-1: New USB device found, idVendor=0d62, idProduct=2106
[    2.146699] usb 5-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.147920] usb 5-1: Product: USB Multimedia Keyboard
[    2.149159] usb 5-1: uevent
[    2.149195] usb 5-1: usb_probe_device
[    2.149197] usb 5-1: configuration #1 chosen from 1 choice
[    2.153449] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    2.153475] usb 5-1:1.0: uevent
[    2.153559] usbhid 5-1:1.0: usb_probe_interface
[    2.153561] usbhid 5-1:1.0: usb_probe_interface - got id
[    2.184738] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input2
[    2.186011] uhci_hcd 0000:00:1a.2: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    2.186102] generic-usb 0003:0D62:2106.0001: input,hidraw0: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input0
[    2.187456] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    2.187468] usb 5-1:1.1: uevent
[    2.187509] usbhid 5-1:1.1: usb_probe_interface
[    2.187511] usbhid 5-1:1.1: usb_probe_interface - got id
[    2.209077] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.210423] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.214217] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    2.221233] ata2.00: configured for UDMA/100
[    2.224120] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    2.225558] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/input/input3
[    2.226920] uhci_hcd 0000:00:1a.2: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    2.227087] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Device [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input1
[    2.228592] drivers/usb/core/inode.c: creating file '002'
[    2.228651] uhci_hcd 0000:00:1a.2: port 2 portsc 01a3,00
[    2.228656] hub 5-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    2.231300] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.232742] Uniform CD-ROM driver Revision: 3.20
[    2.234221] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.234309] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.332031] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    2.434029] usb 5-2: new low speed USB device using uhci_hcd and address 3
[    2.448027] async/0 used greatest stack depth: 6948 bytes left
[    2.538027] async/4 used greatest stack depth: 6828 bytes left
[    2.554773] ata4: SATA link down (SStatus 0 SControl 300)
[    2.556191] Freeing unused kernel memory: 344k freed
[    2.557749] Write protecting the kernel text: 3884k
[    2.559202] Write protecting the kernel read-only data: 1708k
[    2.581624] usb usb3: uevent
[    2.581639] usb 3-0:1.0: uevent
[    2.581708] usb usb4: uevent
[    2.581722] usb 4-0:1.0: uevent
[    2.581789] usb usb5: uevent
[    2.581803] usb 5-0:1.0: uevent
[    2.581829] usb 5-1: uevent
[    2.581844] usb 5-1:1.0: uevent
[    2.581946] usb 5-1:1.1: uevent
[    2.582095] usb usb1: uevent
[    2.582109] usb 1-0:1.0: uevent
[    2.582512] usb usb6: uevent
[    2.582526] usb 6-0:1.0: uevent
[    2.582593] usb usb7: uevent
[    2.582607] usb 7-0:1.0: uevent
[    2.582677] usb usb8: uevent
[    2.582691] usb 8-0:1.0: uevent
[    2.582761] usb usb2: uevent
[    2.582775] usb 2-0:1.0: uevent
[    2.582801] usb 2-3: uevent
[    2.582815] usb 2-3:1.0: uevent
[    2.585031] udevadm used greatest stack depth: 6792 bytes left
[    2.588444] usb 5-2: skipped 1 descriptor after interface
[    2.593445] usb 5-2: default language 0x0409
[    2.593480] replace used greatest stack depth: 6568 bytes left
[    2.609442] usb 5-2: New USB device found, idVendor=413c, idProduct=3012
[    2.611080] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.612781] usb 5-2: Product: Dell USB Optical Mouse
[    2.614389] usb 5-2: Manufacturer: Dell
[    2.616035] usb 5-2: uevent
[    2.616052] usb 5-2: usb_probe_device
[    2.616055] usb 5-2: configuration #1 chosen from 1 choice
[    2.620450] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    2.620482] usb 5-2:1.0: uevent
[    2.620503] usbhid 5-2:1.0: usb_probe_interface
[    2.620504] usbhid 5-2:1.0: usb_probe_interface - got id
[    2.633638] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input4
[    2.635262] generic-usb 0003:413C:3012.0003: input,hidraw2: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.2-2/input0
[    2.636870] drivers/usb/core/inode.c: creating file '003'
[    2.636904] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.636908] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    2.638784] udevd used greatest stack depth: 6516 bytes left
[    3.023680] kjournald starting.  Commit interval 5 seconds
[    3.025205] EXT3-fs: mounted filesystem with writeback data mode.
[    3.557372] stty used greatest stack depth: 6376 bytes left
[    3.704044] hub 3-0:1.0: hub_suspend
[    3.704054] usb usb3: bus auto-suspend
[    3.704058] usb usb3: suspend_rh
[    3.704074] hub 4-0:1.0: hub_suspend
[    3.704079] usb usb4: bus auto-suspend
[    3.704082] usb usb4: suspend_rh
[    3.704097] hub 6-0:1.0: hub_suspend
[    3.704101] usb usb6: bus auto-suspend
[    3.704104] usb usb6: suspend_rh
[    3.704120] hub 1-0:1.0: hub_suspend
[    3.704125] usb usb1: bus auto-suspend
[    3.704128] ehci_hcd 0000:00:1a.7: suspend root hub
[    3.704153] hub 8-0:1.0: hub_suspend
[    3.704156] usb usb8: bus auto-suspend
[    3.704157] usb usb8: suspend_rh
[    4.594015] udev: starting version 141
[    4.625469] usb usb3: uevent
[    4.625486] usb 3-0:1.0: uevent
[    4.625561] usb usb4: uevent
[    4.625576] usb 4-0:1.0: uevent
[    4.625646] usb usb5: uevent
[    4.625660] usb 5-0:1.0: uevent
[    4.625691] usb 5-1: uevent
[    4.625705] usb 5-1:1.0: uevent
[    4.625805] usb 5-1:1.1: uevent
[    4.625907] usb 5-2: uevent
[    4.625922] usb 5-2:1.0: uevent
[    4.626101] usb usb1: uevent
[    4.626115] usb 1-0:1.0: uevent
[    4.626525] usb usb6: uevent
[    4.626539] usb 6-0:1.0: uevent
[    4.626610] usb usb7: uevent
[    4.626626] usb 7-0:1.0: uevent
[    4.626694] usb usb8: uevent
[    4.626708] usb 8-0:1.0: uevent
[    4.626777] usb usb2: uevent
[    4.626792] usb 2-0:1.0: uevent
[    4.626820] usb 2-3: uevent
[    4.626836] usb 2-3:1.0: uevent
[    4.629103] udevadm used greatest stack depth: 6212 bytes left
[    4.701148] hub 7-0:1.0: hub_suspend
[    4.701156] usb usb7: bus auto-suspend
[    4.701158] usb usb7: suspend_rh
[    4.886541] cdrom_id used greatest stack depth: 6168 bytes left
[    5.083693] usb 5-1:1.0: uevent
[    5.083773] usb 5-1: uevent
[    5.086574] usb 5-1:1.1: uevent
[    5.086653] usb 5-1: uevent
[    5.089340] usb 5-2:1.0: uevent
[    5.089422] usb 5-2: uevent
[    5.096627] usb 5-2:1.0: uevent
[    5.096704] usb 5-2: uevent
[    5.798026] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    5.820806] EXT3 FS on sda3, internal journal
[    6.087816] EXT4-fs: barriers enabled
[    6.088111] kjournald2 starting: pid 3203, dev sda2:8, commit interval 5 seconds
[    6.088142] EXT4-fs: delayed allocation enabled
[    6.088146] EXT4-fs: file extents enabled
[    6.099542] EXT4-fs: mballoc enabled
[    6.099554] EXT4-fs: mounted filesystem sda2 with ordered data mode
[    6.139277] Adding 8426084k swap on /dev/sda4.  Priority:-1 extents:1 across:8426084k 
[    6.745487] scsi 4:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 CCS
[    6.745608] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    6.746915] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    6.748162] usb-storage: device scan complete
[    6.749992] usb 2-3:1.0: uevent
[    6.750096] usb 2-3: uevent
[   10.661096] usb usb3: uevent
[   10.661157] usb 3-0:1.0: uevent
[   10.661363] usb usb4: uevent
[   10.661408] usb 4-0:1.0: uevent
[   10.661618] usb usb5: uevent
[   10.661664] usb 5-0:1.0: uevent
[   10.661742] usb 5-1: uevent
[   10.661789] usb 5-1:1.0: uevent
[   10.662078] usb 5-1:1.1: uevent
[   10.662394] usb 5-2: uevent
[   10.662442] usb 5-2:1.0: uevent
[   10.662951] usb usb1: uevent
[   10.662997] usb 1-0:1.0: uevent
[   10.664173] usb usb6: uevent
[   10.664220] usb 6-0:1.0: uevent
[   10.664422] usb usb7: uevent
[   10.664468] usb 7-0:1.0: uevent
[   10.664672] usb usb8: uevent
[   10.664721] usb 8-0:1.0: uevent
[   10.664924] usb usb2: uevent
[   10.664970] usb 2-0:1.0: uevent
[   10.665050] usb 2-3: uevent
[   10.665097] usb 2-3:1.0: uevent
[   11.329571] r8169: eth0: link up
[   11.329578] r8169: eth0: link up
[   13.494755] [drm] DAC-6: set mode 1024x768 1b
[   14.075157] uhci_hcd 0000:00:1a.2: reserve dev 3 ep81-INT, period 8, phase 4, 99 us
[   21.935016] eth0: no IPv6 routers present
[   41.469415] ksplashx used greatest stack depth: 5888 bytes left
[  296.949182] gtkperf used greatest stack depth: 5816 bytes left
[  356.702756] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[  455.309803] ------------[ cut here ]------------
[  455.309816] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  455.309820] Hardware name: Studio 540      
[  455.309823] hotplug uevent
[  455.309825] Modules linked in:
[  455.309831] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  455.309835] Call Trace:
[  455.309844]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  455.309851]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  455.309857]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  455.309863]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  455.309871]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  455.309877]  [<c1032f28>] worker_thread+0x131/0x1ab
[  455.309883]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  455.309889]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  455.309895]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  455.309900]  [<c1035c84>] kthread+0x46/0x6a
[  455.309905]  [<c1035c3e>] ? kthread+0x0/0x6a
[  455.309911]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  455.309915] ---[ end trace 27037b79aef5c5c6 ]---
[  457.084304] ------------[ cut here ]------------
[  457.084318] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  457.084322] Hardware name: Studio 540      
[  457.084324] hotplug uevent
[  457.084326] Modules linked in:
[  457.084332] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  457.084336] Call Trace:
[  457.084345]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  457.084351]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  457.084357]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  457.084363]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  457.084370]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  457.084377]  [<c1032f28>] worker_thread+0x131/0x1ab
[  457.084383]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  457.084389]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  457.084394]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  457.084399]  [<c1035c84>] kthread+0x46/0x6a
[  457.084404]  [<c1035c3e>] ? kthread+0x0/0x6a
[  457.084410]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  457.084414] ---[ end trace 27037b79aef5c5c7 ]---
[  458.072197] ------------[ cut here ]------------
[  458.072210] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  458.072214] Hardware name: Studio 540      
[  458.072217] hotplug uevent
[  458.072219] Modules linked in:
[  458.072225] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  458.072228] Call Trace:
[  458.072237]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  458.072244]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  458.072250]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  458.072256]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  458.072263]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  458.072269]  [<c1032f28>] worker_thread+0x131/0x1ab
[  458.072276]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  458.072282]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  458.072287]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  458.072292]  [<c1035c84>] kthread+0x46/0x6a
[  458.072296]  [<c1035c3e>] ? kthread+0x0/0x6a
[  458.072302]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  458.072306] ---[ end trace 27037b79aef5c5c8 ]---
[  458.385219] ------------[ cut here ]------------
[  458.385232] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  458.385236] Hardware name: Studio 540      
[  458.385238] hotplug uevent
[  458.385241] Modules linked in:
[  458.385247] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  458.385250] Call Trace:
[  458.385259]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  458.385266]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  458.385272]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  458.385278]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  458.385285]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  458.385292]  [<c1032f28>] worker_thread+0x131/0x1ab
[  458.385298]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  458.385304]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  458.385310]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  458.385314]  [<c1035c84>] kthread+0x46/0x6a
[  458.385319]  [<c1035c3e>] ? kthread+0x0/0x6a
[  458.385325]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  458.385329] ---[ end trace 27037b79aef5c5c9 ]---
[  458.605586] ------------[ cut here ]------------
[  458.605599] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  458.605603] Hardware name: Studio 540      
[  458.605606] hotplug uevent
[  458.605608] Modules linked in:
[  458.605614] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  458.605618] Call Trace:
[  458.605627]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  458.605633]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  458.605639]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  458.605645]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  458.605652]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  458.605659]  [<c1032f28>] worker_thread+0x131/0x1ab
[  458.605665]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  458.605671]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  458.605677]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  458.605682]  [<c1035c84>] kthread+0x46/0x6a
[  458.605686]  [<c1035c3e>] ? kthread+0x0/0x6a
[  458.605692]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  458.605696] ---[ end trace 27037b79aef5c5ca ]---
[  459.382483] ------------[ cut here ]------------
[  459.382496] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  459.382500] Hardware name: Studio 540      
[  459.382502] hotplug uevent
[  459.382504] Modules linked in:
[  459.382510] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  459.382514] Call Trace:
[  459.382523]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  459.382529]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  459.382535]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  459.382541]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  459.382548]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  459.382555]  [<c1032f28>] worker_thread+0x131/0x1ab
[  459.382561]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  459.382567]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  459.382573]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  459.382577]  [<c1035c84>] kthread+0x46/0x6a
[  459.382582]  [<c1035c3e>] ? kthread+0x0/0x6a
[  459.382588]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  459.382592] ---[ end trace 27037b79aef5c5cb ]---
[  459.412915] ------------[ cut here ]------------
[  459.412928] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  459.412932] Hardware name: Studio 540      
[  459.412934] hotplug uevent
[  459.412936] Modules linked in:
[  459.412942] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  459.412946] Call Trace:
[  459.412955]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  459.412961]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  459.412967]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  459.412973]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  459.412981]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  459.412987]  [<c1032f28>] worker_thread+0x131/0x1ab
[  459.412993]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  459.412999]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  459.413019]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  459.413024]  [<c1035c84>] kthread+0x46/0x6a
[  459.413029]  [<c1035c3e>] ? kthread+0x0/0x6a
[  459.413035]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  459.413039] ---[ end trace 27037b79aef5c5cc ]---
[  460.256548] ------------[ cut here ]------------
[  460.256562] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.256566] Hardware name: Studio 540      
[  460.256568] hotplug uevent
[  460.256571] Modules linked in:
[  460.256577] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.256580] Call Trace:
[  460.256589]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.256596]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.256602]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.256608]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.256615]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.256622]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.256628]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.256634]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.256639]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.256644]  [<c1035c84>] kthread+0x46/0x6a
[  460.256649]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.256655]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.256659] ---[ end trace 27037b79aef5c5cd ]---
[  460.262239] ------------[ cut here ]------------
[  460.262251] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.262254] Hardware name: Studio 540      
[  460.262257] hotplug uevent
[  460.262259] Modules linked in:
[  460.262265] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.262268] Call Trace:
[  460.262276]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.262283]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.262289]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.262295]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.262301]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.262308]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.262314]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.262320]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.262325]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.262330]  [<c1035c84>] kthread+0x46/0x6a
[  460.262334]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.262341]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.262344] ---[ end trace 27037b79aef5c5ce ]---
[  460.648253] ------------[ cut here ]------------
[  460.648265] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.648269] Hardware name: Studio 540      
[  460.648271] hotplug uevent
[  460.648274] Modules linked in:
[  460.648279] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.648283] Call Trace:
[  460.648292]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.648298]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.648304]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.648310]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.648317]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.648324]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.648330]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.648336]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.648341]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.648346]  [<c1035c84>] kthread+0x46/0x6a
[  460.648351]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.648357]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.648360] ---[ end trace 27037b79aef5c5cf ]---
[  460.652809] ------------[ cut here ]------------
[  460.652820] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.652824] Hardware name: Studio 540      
[  460.652827] hotplug uevent
[  460.652829] Modules linked in:
[  460.652835] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.652838] Call Trace:
[  460.652846]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.652852]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.652858]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.652865]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.652872]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.652878]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.652884]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.652890]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.652896]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.652901]  [<c1035c84>] kthread+0x46/0x6a
[  460.652905]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.652911]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.652915] ---[ end trace 27037b79aef5c5d0 ]---
[  460.733074] ------------[ cut here ]------------
[  460.733085] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.733089] Hardware name: Studio 540      
[  460.733092] hotplug uevent
[  460.733094] Modules linked in:
[  460.733100] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.733103] Call Trace:
[  460.733111]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.733118]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.733124]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.733130]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.733137]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.733144]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.733150]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.733156]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.733161]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.733166]  [<c1035c84>] kthread+0x46/0x6a
[  460.733171]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.733177]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.733181] ---[ end trace 27037b79aef5c5d1 ]---
[  460.737736] ------------[ cut here ]------------
[  460.737747] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.737751] Hardware name: Studio 540      
[  460.737753] hotplug uevent
[  460.737756] Modules linked in:
[  460.737761] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.737764] Call Trace:
[  460.737772]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.737779]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.737785]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.737791]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.737797]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.737804]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.737810]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.737815]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.737821]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.737826]  [<c1035c84>] kthread+0x46/0x6a
[  460.737830]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.737836]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.737840] ---[ end trace 27037b79aef5c5d2 ]---
[  460.757474] ------------[ cut here ]------------
[  460.757485] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  460.757489] Hardware name: Studio 540      
[  460.757491] hotplug uevent
[  460.757493] Modules linked in:
[  460.757499] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  460.757502] Call Trace:
[  460.757510]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  460.757517]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  460.757523]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  460.757529]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  460.757536]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  460.757542]  [<c1032f28>] worker_thread+0x131/0x1ab
[  460.757548]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  460.757554]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  460.757559]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  460.757564]  [<c1035c84>] kthread+0x46/0x6a
[  460.757569]  [<c1035c3e>] ? kthread+0x0/0x6a
[  460.757575]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  460.757578] ---[ end trace 27037b79aef5c5d3 ]---
[  461.424955] ------------[ cut here ]------------
[  461.424968] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  461.424972] Hardware name: Studio 540      
[  461.424975] hotplug uevent
[  461.424977] Modules linked in:
[  461.424983] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  461.424986] Call Trace:
[  461.424996]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  461.425002]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  461.425023]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  461.425029]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  461.425036]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  461.425043]  [<c1032f28>] worker_thread+0x131/0x1ab
[  461.425049]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  461.425055]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  461.425060]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  461.425066]  [<c1035c84>] kthread+0x46/0x6a
[  461.425070]  [<c1035c3e>] ? kthread+0x0/0x6a
[  461.425076]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  461.425080] ---[ end trace 27037b79aef5c5d4 ]---
[  461.579166] ------------[ cut here ]------------
[  461.579178] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  461.579183] Hardware name: Studio 540      
[  461.579185] hotplug uevent
[  461.579187] Modules linked in:
[  461.579193] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  461.579196] Call Trace:
[  461.579204]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  461.579211]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  461.579217]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  461.579223]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  461.579230]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  461.579236]  [<c1032f28>] worker_thread+0x131/0x1ab
[  461.579242]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  461.579248]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  461.579254]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  461.579259]  [<c1035c84>] kthread+0x46/0x6a
[  461.579263]  [<c1035c3e>] ? kthread+0x0/0x6a
[  461.579269]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  461.579273] ---[ end trace 27037b79aef5c5d5 ]---
[  462.118230] ------------[ cut here ]------------
[  462.118243] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  462.118247] Hardware name: Studio 540      
[  462.118249] hotplug uevent
[  462.118252] Modules linked in:
[  462.118258] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  462.118261] Call Trace:
[  462.118269]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  462.118276]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  462.118282]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  462.118288]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  462.118295]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  462.118301]  [<c1032f28>] worker_thread+0x131/0x1ab
[  462.118307]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  462.118313]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  462.118319]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  462.118324]  [<c1035c84>] kthread+0x46/0x6a
[  462.118328]  [<c1035c3e>] ? kthread+0x0/0x6a
[  462.118335]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  462.118338] ---[ end trace 27037b79aef5c5d6 ]---
[  463.016482] ------------[ cut here ]------------
[  463.016495] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  463.016499] Hardware name: Studio 540      
[  463.016501] hotplug uevent
[  463.016503] Modules linked in:
[  463.016509] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  463.016512] Call Trace:
[  463.016522]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  463.016528]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  463.016534]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  463.016540]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  463.016547]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  463.016554]  [<c1032f28>] worker_thread+0x131/0x1ab
[  463.016560]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  463.016566]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  463.016572]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  463.016577]  [<c1035c84>] kthread+0x46/0x6a
[  463.016581]  [<c1035c3e>] ? kthread+0x0/0x6a
[  463.016587]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  463.016591] ---[ end trace 27037b79aef5c5d7 ]---
[  464.441774] ------------[ cut here ]------------
[  464.441788] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.441792] Hardware name: Studio 540      
[  464.441794] hotplug uevent
[  464.441796] Modules linked in:
[  464.441802] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.441806] Call Trace:
[  464.441816]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.441822]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.441828]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.441835]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.441842]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.441848]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.441854]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.441861]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.441866]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.441871]  [<c1035c84>] kthread+0x46/0x6a
[  464.441876]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.441882]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.441891] ---[ end trace 27037b79aef5c5d8 ]---
[  464.443357] ------------[ cut here ]------------
[  464.443367] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.443371] Hardware name: Studio 540      
[  464.443373] hotplug uevent
[  464.443375] Modules linked in:
[  464.443381] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.443384] Call Trace:
[  464.443392]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.443398]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.443404]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.443410]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.443417]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.443423]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.443429]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.443435]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.443440]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.443445]  [<c1035c84>] kthread+0x46/0x6a
[  464.443449]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.443455]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.443459] ---[ end trace 27037b79aef5c5d9 ]---
[  464.480479] ------------[ cut here ]------------
[  464.480493] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.480497] Hardware name: Studio 540      
[  464.480499] hotplug uevent
[  464.480501] Modules linked in:
[  464.480507] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.480510] Call Trace:
[  464.480520]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.480526]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.480532]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.480538]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.480545]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.480552]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.480558]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.480564]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.480570]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.480575]  [<c1035c84>] kthread+0x46/0x6a
[  464.480579]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.480585]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.480589] ---[ end trace 27037b79aef5c5da ]---
[  464.489847] ------------[ cut here ]------------
[  464.489858] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.489862] Hardware name: Studio 540      
[  464.489864] hotplug uevent
[  464.489866] Modules linked in:
[  464.489872] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.489875] Call Trace:
[  464.489883]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.489890]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.489896]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.489902]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.489908]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.489915]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.489921]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.489927]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.489932]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.489937]  [<c1035c84>] kthread+0x46/0x6a
[  464.489942]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.489948]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.489952] ---[ end trace 27037b79aef5c5db ]---
[  464.632998] ------------[ cut here ]------------
[  464.633030] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.633034] Hardware name: Studio 540      
[  464.633037] hotplug uevent
[  464.633039] Modules linked in:
[  464.633045] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.633048] Call Trace:
[  464.633058]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.633064]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.633070]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.633076]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.633083]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.633090]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.633096]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.633102]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.633108]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.633113]  [<c1035c84>] kthread+0x46/0x6a
[  464.633117]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.633123]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.633127] ---[ end trace 27037b79aef5c5dc ]---
[  464.746742] ------------[ cut here ]------------
[  464.746755] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.746759] Hardware name: Studio 540      
[  464.746761] hotplug uevent
[  464.746763] Modules linked in:
[  464.746769] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.746773] Call Trace:
[  464.746782]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.746788]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.746794]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.746801]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.746808]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.746814]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.746820]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.746826]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.746832]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.746837]  [<c1035c84>] kthread+0x46/0x6a
[  464.746841]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.746847]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.746851] ---[ end trace 27037b79aef5c5dd ]---
[  464.748629] ------------[ cut here ]------------
[  464.748640] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  464.748644] Hardware name: Studio 540      
[  464.748646] hotplug uevent
[  464.748648] Modules linked in:
[  464.748654] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  464.748657] Call Trace:
[  464.748665]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  464.748671]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  464.748677]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  464.748683]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  464.748690]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  464.748696]  [<c1032f28>] worker_thread+0x131/0x1ab
[  464.748702]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  464.748708]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  464.748714]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  464.748719]  [<c1035c84>] kthread+0x46/0x6a
[  464.748723]  [<c1035c3e>] ? kthread+0x0/0x6a
[  464.748729]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  464.748733] ---[ end trace 27037b79aef5c5de ]---
[  465.019361] ------------[ cut here ]------------
[  465.019374] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.019378] Hardware name: Studio 540      
[  465.019380] hotplug uevent
[  465.019383] Modules linked in:
[  465.019389] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.019392] Call Trace:
[  465.019401]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.019408]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.019414]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.019421]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.019428]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.019434]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.019441]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.019447]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.019452]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.019457]  [<c1035c84>] kthread+0x46/0x6a
[  465.019462]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.019468]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.019472] ---[ end trace 27037b79aef5c5df ]---
[  465.077112] ------------[ cut here ]------------
[  465.077126] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.077130] Hardware name: Studio 540      
[  465.077132] hotplug uevent
[  465.077134] Modules linked in:
[  465.077140] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.077144] Call Trace:
[  465.077153]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.077159]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.077165]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.077171]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.077178]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.077184]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.077190]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.077196]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.077202]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.077207]  [<c1035c84>] kthread+0x46/0x6a
[  465.077211]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.077217]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.077221] ---[ end trace 27037b79aef5c5e0 ]---
[  465.085907] ------------[ cut here ]------------
[  465.085918] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.085922] Hardware name: Studio 540      
[  465.085924] hotplug uevent
[  465.085927] Modules linked in:
[  465.085932] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.085935] Call Trace:
[  465.085943]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.085950]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.085956]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.085962]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.085969]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.085975]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.085981]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.085987]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.085992]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.085997]  [<c1035c84>] kthread+0x46/0x6a
[  465.086013]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.086020]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.086023] ---[ end trace 27037b79aef5c5e1 ]---
[  465.089489] ------------[ cut here ]------------
[  465.089500] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.089504] Hardware name: Studio 540      
[  465.089506] hotplug uevent
[  465.089508] Modules linked in:
[  465.089514] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.089517] Call Trace:
[  465.089525]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.089531]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.089538]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.089544]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.089551]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.089557]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.089563]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.089569]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.089575]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.089580]  [<c1035c84>] kthread+0x46/0x6a
[  465.089584]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.089590]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.089594] ---[ end trace 27037b79aef5c5e2 ]---
[  465.532042] ------------[ cut here ]------------
[  465.532055] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.532059] Hardware name: Studio 540      
[  465.532062] hotplug uevent
[  465.532064] Modules linked in:
[  465.532070] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.532073] Call Trace:
[  465.532082]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.532089]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.532095]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.532101]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.532108]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.532114]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.532121]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.532127]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.532132]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.532137]  [<c1035c84>] kthread+0x46/0x6a
[  465.532141]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.532148]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.532151] ---[ end trace 27037b79aef5c5e3 ]---
[  465.587174] ------------[ cut here ]------------
[  465.587184] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.587188] Hardware name: Studio 540      
[  465.587190] hotplug uevent
[  465.587193] Modules linked in:
[  465.587198] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.587202] Call Trace:
[  465.587210]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.587216]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.587222]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.587228]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.587235]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.587242]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.587248]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.587254]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.587259]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.587264]  [<c1035c84>] kthread+0x46/0x6a
[  465.587269]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.587274]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.587278] ---[ end trace 27037b79aef5c5e4 ]---
[  465.963565] ------------[ cut here ]------------
[  465.963576] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  465.963580] Hardware name: Studio 540      
[  465.963583] hotplug uevent
[  465.963585] Modules linked in:
[  465.963591] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  465.963594] Call Trace:
[  465.963602]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  465.963608]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  465.963614]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  465.963621]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  465.963627]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  465.963634]  [<c1032f28>] worker_thread+0x131/0x1ab
[  465.963640]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  465.963645]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  465.963651]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  465.963656]  [<c1035c84>] kthread+0x46/0x6a
[  465.963661]  [<c1035c3e>] ? kthread+0x0/0x6a
[  465.963667]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  465.963670] ---[ end trace 27037b79aef5c5e5 ]---
[  466.198644] ------------[ cut here ]------------
[  466.198656] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.198660] Hardware name: Studio 540      
[  466.198663] hotplug uevent
[  466.198665] Modules linked in:
[  466.198671] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.198674] Call Trace:
[  466.198683]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.198690]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.198696]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.198702]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.198709]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.198716]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.198722]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.198728]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.198733]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.198738]  [<c1035c84>] kthread+0x46/0x6a
[  466.198743]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.198749]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.198752] ---[ end trace 27037b79aef5c5e6 ]---
[  466.207513] ------------[ cut here ]------------
[  466.207524] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.207528] Hardware name: Studio 540      
[  466.207530] hotplug uevent
[  466.207532] Modules linked in:
[  466.207538] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.207541] Call Trace:
[  466.207550]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.207556]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.207562]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.207568]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.207575]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.207582]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.207588]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.207594]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.207600]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.207604]  [<c1035c84>] kthread+0x46/0x6a
[  466.207609]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.207615]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.207619] ---[ end trace 27037b79aef5c5e7 ]---
[  466.209664] ------------[ cut here ]------------
[  466.209674] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.209678] Hardware name: Studio 540      
[  466.209680] hotplug uevent
[  466.209682] Modules linked in:
[  466.209688] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.209691] Call Trace:
[  466.209698]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.209705]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.209711]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.209717]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.209724]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.209730]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.209736]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.209742]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.209747]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.209752]  [<c1035c84>] kthread+0x46/0x6a
[  466.209757]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.209763]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.209766] ---[ end trace 27037b79aef5c5e8 ]---
[  466.223559] ------------[ cut here ]------------
[  466.223572] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.223576] Hardware name: Studio 540      
[  466.223578] hotplug uevent
[  466.223580] Modules linked in:
[  466.223587] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.223590] Call Trace:
[  466.223599]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.223606]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.223612]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.223618]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.223625]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.223631]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.223637]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.223643]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.223649]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.223654]  [<c1035c84>] kthread+0x46/0x6a
[  466.223658]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.223664]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.223668] ---[ end trace 27037b79aef5c5e9 ]---
[  466.233432] ------------[ cut here ]------------
[  466.233444] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.233447] Hardware name: Studio 540      
[  466.233450] hotplug uevent
[  466.233452] Modules linked in:
[  466.233457] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.233461] Call Trace:
[  466.233468]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.233475]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.233481]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.233487]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.233494]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.233500]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.233506]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.233512]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.233517]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.233522]  [<c1035c84>] kthread+0x46/0x6a
[  466.233527]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.233533]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.233536] ---[ end trace 27037b79aef5c5ea ]---
[  466.235263] ------------[ cut here ]------------
[  466.235272] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.235276] Hardware name: Studio 540      
[  466.235278] hotplug uevent
[  466.235280] Modules linked in:
[  466.235285] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.235288] Call Trace:
[  466.235295]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.235302]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.235308]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.235314]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.235321]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.235327]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.235333]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.235338]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.235344]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.235349]  [<c1035c84>] kthread+0x46/0x6a
[  466.235353]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.235359]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.235362] ---[ end trace 27037b79aef5c5eb ]---
[  466.236247] ------------[ cut here ]------------
[  466.236256] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.236260] Hardware name: Studio 540      
[  466.236262] hotplug uevent
[  466.236264] Modules linked in:
[  466.236269] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.236272] Call Trace:
[  466.236280]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.236286]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.236292]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.236298]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.236305]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.236311]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.236317]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.236322]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.236328]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.236333]  [<c1035c84>] kthread+0x46/0x6a
[  466.236338]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.236343]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.236347] ---[ end trace 27037b79aef5c5ec ]---
[  466.237070] ------------[ cut here ]------------
[  466.237079] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.237083] Hardware name: Studio 540      
[  466.237085] hotplug uevent
[  466.237087] Modules linked in:
[  466.237092] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.237095] Call Trace:
[  466.237103]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.237109]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.237116]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.237122]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.237129]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.237135]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.237141]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.237146]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.237152]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.237157]  [<c1035c84>] kthread+0x46/0x6a
[  466.237161]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.237167]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.237171] ---[ end trace 27037b79aef5c5ed ]---
[  466.239949] ------------[ cut here ]------------
[  466.239958] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.239962] Hardware name: Studio 540      
[  466.239965] hotplug uevent
[  466.239967] Modules linked in:
[  466.239972] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.239975] Call Trace:
[  466.239982]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.239988]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.239994]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.240000]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.240022]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.240028]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.240034]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.240039]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.240045]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.240050]  [<c1035c84>] kthread+0x46/0x6a
[  466.240054]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.240060]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.240063] ---[ end trace 27037b79aef5c5ee ]---
[  466.241208] ------------[ cut here ]------------
[  466.241217] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.241221] Hardware name: Studio 540      
[  466.241224] hotplug uevent
[  466.241226] Modules linked in:
[  466.241231] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.241234] Call Trace:
[  466.241241]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.241247]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.241253]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.241259]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.241266]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.241272]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.241278]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.241283]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.241289]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.241294]  [<c1035c84>] kthread+0x46/0x6a
[  466.241298]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.241304]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.241308] ---[ end trace 27037b79aef5c5ef ]---
[  466.241482] ------------[ cut here ]------------
[  466.241490] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.241493] Hardware name: Studio 540      
[  466.241496] hotplug uevent
[  466.241498] Modules linked in:
[  466.241502] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.241505] Call Trace:
[  466.241512]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.241518]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.241525]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.241531]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.241537]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.241543]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.241549]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.241555]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.241560]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.241565]  [<c1035c84>] kthread+0x46/0x6a
[  466.241570]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.241576]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.241579] ---[ end trace 27037b79aef5c5f0 ]---
[  466.257804] ------------[ cut here ]------------
[  466.257815] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.257819] Hardware name: Studio 540      
[  466.257821] hotplug uevent
[  466.257823] Modules linked in:
[  466.257829] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.257832] Call Trace:
[  466.257840]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.257847]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.257853]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.257859]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.257866]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.257872]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.257878]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.257884]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.257890]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.257895]  [<c1035c84>] kthread+0x46/0x6a
[  466.257899]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.257905]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.257909] ---[ end trace 27037b79aef5c5f1 ]---
[  466.264213] ------------[ cut here ]------------
[  466.264223] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.264227] Hardware name: Studio 540      
[  466.264229] hotplug uevent
[  466.264231] Modules linked in:
[  466.264237] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.264240] Call Trace:
[  466.264247]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.264254]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.264260]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.264266]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.264272]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.264279]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.264285]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.264290]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.264296]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.264301]  [<c1035c84>] kthread+0x46/0x6a
[  466.264305]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.264312]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.264315] ---[ end trace 27037b79aef5c5f2 ]---
[  466.271215] ------------[ cut here ]------------
[  466.271225] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.271228] Hardware name: Studio 540      
[  466.271231] hotplug uevent
[  466.271233] Modules linked in:
[  466.271238] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.271241] Call Trace:
[  466.271249]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.271255]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.271261]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.271267]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.271274]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.271280]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.271286]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.271292]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.271297]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.271302]  [<c1035c84>] kthread+0x46/0x6a
[  466.271307]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.271313]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.271317] ---[ end trace 27037b79aef5c5f3 ]---
[  466.284760] ------------[ cut here ]------------
[  466.284771] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.284775] Hardware name: Studio 540      
[  466.284777] hotplug uevent
[  466.284779] Modules linked in:
[  466.284785] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.284788] Call Trace:
[  466.284796]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.284803]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.284809]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.284815]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.284822]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.284829]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.284835]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.284841]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.284846]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.284851]  [<c1035c84>] kthread+0x46/0x6a
[  466.284856]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.284862]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.284866] ---[ end trace 27037b79aef5c5f4 ]---
[  466.298227] ------------[ cut here ]------------
[  466.298240] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.298243] Hardware name: Studio 540      
[  466.298246] hotplug uevent
[  466.298248] Modules linked in:
[  466.298254] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.298257] Call Trace:
[  466.298267]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.298273]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.298280]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.298286]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.298293]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.298299]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.298305]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.298311]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.298317]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.298322]  [<c1035c84>] kthread+0x46/0x6a
[  466.298326]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.298332]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.298336] ---[ end trace 27037b79aef5c5f5 ]---
[  466.314413] ------------[ cut here ]------------
[  466.314426] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.314430] Hardware name: Studio 540      
[  466.314432] hotplug uevent
[  466.314435] Modules linked in:
[  466.314441] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.314444] Call Trace:
[  466.314453]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.314460]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.314466]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.314472]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.314479]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.314486]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.314492]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.314498]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.314503]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.314508]  [<c1035c84>] kthread+0x46/0x6a
[  466.314513]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.314519]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.314523] ---[ end trace 27037b79aef5c5f6 ]---
[  466.409952] ------------[ cut here ]------------
[  466.409964] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.409968] Hardware name: Studio 540      
[  466.409970] hotplug uevent
[  466.409973] Modules linked in:
[  466.409978] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.409982] Call Trace:
[  466.409990]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.409997]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.410016]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.410022]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.410030]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.410036]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.410042]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.410048]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.410054]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.410059]  [<c1035c84>] kthread+0x46/0x6a
[  466.410063]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.410069]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.410073] ---[ end trace 27037b79aef5c5f7 ]---
[  466.450614] ------------[ cut here ]------------
[  466.450626] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.450630] Hardware name: Studio 540      
[  466.450633] hotplug uevent
[  466.450635] Modules linked in:
[  466.450641] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.450644] Call Trace:
[  466.450654]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.450660]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.450666]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.450672]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.450679]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.450686]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.450692]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.450698]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.450703]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.450708]  [<c1035c84>] kthread+0x46/0x6a
[  466.450713]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.450719]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.450723] ---[ end trace 27037b79aef5c5f8 ]---
[  466.467068] ------------[ cut here ]------------
[  466.467079] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.467083] Hardware name: Studio 540      
[  466.467085] hotplug uevent
[  466.467088] Modules linked in:
[  466.467094] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.467097] Call Trace:
[  466.467105]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.467112]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.467118]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.467124]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.467131]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.467137]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.467143]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.467149]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.467155]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.467160]  [<c1035c84>] kthread+0x46/0x6a
[  466.467164]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.467170]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.467174] ---[ end trace 27037b79aef5c5f9 ]---
[  466.469851] ------------[ cut here ]------------
[  466.469861] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.469865] Hardware name: Studio 540      
[  466.469868] hotplug uevent
[  466.469870] Modules linked in:
[  466.469875] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.469879] Call Trace:
[  466.469887]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.469893]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.469899]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.469905]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.469912]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.469919]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.469925]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.469931]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.469936]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.469941]  [<c1035c84>] kthread+0x46/0x6a
[  466.469946]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.469952]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.469956] ---[ end trace 27037b79aef5c5fa ]---
[  466.471641] ------------[ cut here ]------------
[  466.471651] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.471655] Hardware name: Studio 540      
[  466.471657] hotplug uevent
[  466.471659] Modules linked in:
[  466.471665] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.471668] Call Trace:
[  466.471676]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.471682]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.471688]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.471695]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.471702]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.471708]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.471714]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.471720]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.471725]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.471730]  [<c1035c84>] kthread+0x46/0x6a
[  466.471735]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.471741]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.471744] ---[ end trace 27037b79aef5c5fb ]---
[  466.473971] ------------[ cut here ]------------
[  466.473981] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.473985] Hardware name: Studio 540      
[  466.473987] hotplug uevent
[  466.473989] Modules linked in:
[  466.473995] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.473998] Call Trace:
[  466.474017]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.474024]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.474030]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.474039]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.474046]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.474052]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.474058]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.474064]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.474069]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.474074]  [<c1035c84>] kthread+0x46/0x6a
[  466.474079]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.474084]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.474088] ---[ end trace 27037b79aef5c5fc ]---
[  466.474109] ------------[ cut here ]------------
[  466.474115] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.474118] Hardware name: Studio 540      
[  466.474120] hotplug uevent
[  466.474122] Modules linked in:
[  466.474127] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.474130] Call Trace:
[  466.474136]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.474142]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.474148]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.474154]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.474161]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.474166]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.474172]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.474178]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.474183]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.474188]  [<c1035c84>] kthread+0x46/0x6a
[  466.474193]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.474198]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.474202] ---[ end trace 27037b79aef5c5fd ]---
[  466.477106] ------------[ cut here ]------------
[  466.477116] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.477120] Hardware name: Studio 540      
[  466.477122] hotplug uevent
[  466.477124] Modules linked in:
[  466.477129] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.477133] Call Trace:
[  466.477141]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.477147]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.477154]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.477160]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.477167]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.477173]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.477179]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.477185]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.477190]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.477195]  [<c1035c84>] kthread+0x46/0x6a
[  466.477200]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.477206]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.477210] ---[ end trace 27037b79aef5c5fe ]---
[  466.479851] ------------[ cut here ]------------
[  466.479862] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.479866] Hardware name: Studio 540      
[  466.479868] hotplug uevent
[  466.479870] Modules linked in:
[  466.479876] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.479879] Call Trace:
[  466.479887]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.479893]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.479899]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.479905]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.479916]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.479922]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.479928]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.479933]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.479939]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.479944]  [<c1035c84>] kthread+0x46/0x6a
[  466.479948]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.479954]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.479958] ---[ end trace 27037b79aef5c5ff ]---
[  466.479978] ------------[ cut here ]------------
[  466.479984] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.479988] Hardware name: Studio 540      
[  466.479990] hotplug uevent
[  466.479992] Modules linked in:
[  466.479997] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.480000] Call Trace:
[  466.480017]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.480023]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.480029]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.480035]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.480041]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.480047]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.480053]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.480059]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.480064]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.480069]  [<c1035c84>] kthread+0x46/0x6a
[  466.480074]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.480079]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.480083] ---[ end trace 27037b79aef5c600 ]---
[  466.618331] ------------[ cut here ]------------
[  466.618344] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.618348] Hardware name: Studio 540      
[  466.618350] hotplug uevent
[  466.618352] Modules linked in:
[  466.618359] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.618362] Call Trace:
[  466.618371]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.618377]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.618383]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.618390]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.618397]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.618403]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.618409]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.618415]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.618421]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.618426]  [<c1035c84>] kthread+0x46/0x6a
[  466.618430]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.618436]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.618440] ---[ end trace 27037b79aef5c601 ]---
[  466.623178] ------------[ cut here ]------------
[  466.623189] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.623193] Hardware name: Studio 540      
[  466.623196] hotplug uevent
[  466.623198] Modules linked in:
[  466.623203] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.623207] Call Trace:
[  466.623215]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.623221]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.623227]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.623234]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.623241]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.623247]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.623253]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.623259]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.623264]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.623269]  [<c1035c84>] kthread+0x46/0x6a
[  466.623274]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.623280]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.623284] ---[ end trace 27037b79aef5c602 ]---
[  466.625936] ------------[ cut here ]------------
[  466.625947] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.625951] Hardware name: Studio 540      
[  466.625953] hotplug uevent
[  466.625955] Modules linked in:
[  466.625961] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.625964] Call Trace:
[  466.625971]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.625978]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.625984]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.625990]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.625997]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.626003]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.626020]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.626026]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.626031]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.626036]  [<c1035c84>] kthread+0x46/0x6a
[  466.626040]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.626046]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.626050] ---[ end trace 27037b79aef5c603 ]---
[  466.628705] ------------[ cut here ]------------
[  466.628715] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.628719] Hardware name: Studio 540      
[  466.628722] hotplug uevent
[  466.628724] Modules linked in:
[  466.628729] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.628732] Call Trace:
[  466.628740]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.628747]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.628753]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.628759]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.628765]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.628772]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.628778]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.628784]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.628789]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.628794]  [<c1035c84>] kthread+0x46/0x6a
[  466.628799]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.628805]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.628808] ---[ end trace 27037b79aef5c604 ]---
[  466.630832] ------------[ cut here ]------------
[  466.630842] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.630846] Hardware name: Studio 540      
[  466.630849] hotplug uevent
[  466.630851] Modules linked in:
[  466.630856] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.630859] Call Trace:
[  466.630867]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.630873]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.630879]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.630885]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.630895]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.630901]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.630908]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.630913]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.630919]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.630924]  [<c1035c84>] kthread+0x46/0x6a
[  466.630928]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.630934]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.630938] ---[ end trace 27037b79aef5c605 ]---
[  466.630959] ------------[ cut here ]------------
[  466.630965] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.630968] Hardware name: Studio 540      
[  466.630971] hotplug uevent
[  466.630973] Modules linked in:
[  466.630977] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.630980] Call Trace:
[  466.630986]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.630993]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.630998]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.631014]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.631021]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.631027]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.631033]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.631039]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.631044]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.631049]  [<c1035c84>] kthread+0x46/0x6a
[  466.631054]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.631059]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.631063] ---[ end trace 27037b79aef5c606 ]---
[  466.633671] ------------[ cut here ]------------
[  466.633681] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.633685] Hardware name: Studio 540      
[  466.633687] hotplug uevent
[  466.633689] Modules linked in:
[  466.633695] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.633698] Call Trace:
[  466.633705]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.633712]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.633718]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.633724]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.633731]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.633736]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.633743]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.633748]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.633754]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.633758]  [<c1035c84>] kthread+0x46/0x6a
[  466.633763]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.633769]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.633772] ---[ end trace 27037b79aef5c607 ]---
[  466.636634] ------------[ cut here ]------------
[  466.636644] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.636648] Hardware name: Studio 540      
[  466.636651] hotplug uevent
[  466.636653] Modules linked in:
[  466.636658] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.636661] Call Trace:
[  466.636669]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.636675]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.636681]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.636688]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.636694]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.636700]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.636706]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.636712]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.636718]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.636723]  [<c1035c84>] kthread+0x46/0x6a
[  466.636727]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.636733]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.636737] ---[ end trace 27037b79aef5c608 ]---
[  466.640340] ------------[ cut here ]------------
[  466.640350] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.640354] Hardware name: Studio 540      
[  466.640356] hotplug uevent
[  466.640359] Modules linked in:
[  466.640364] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.640367] Call Trace:
[  466.640375]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.640381]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.640387]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.640393]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.640400]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.640406]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.640413]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.640418]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.640424]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.640429]  [<c1035c84>] kthread+0x46/0x6a
[  466.640434]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.640440]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.640443] ---[ end trace 27037b79aef5c609 ]---
[  466.640467] ------------[ cut here ]------------
[  466.640473] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.640477] Hardware name: Studio 540      
[  466.640479] hotplug uevent
[  466.640481] Modules linked in:
[  466.640485] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.640488] Call Trace:
[  466.640495]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.640501]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.640507]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.640513]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.640519]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.640525]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.640531]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.640536]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.640542]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.640547]  [<c1035c84>] kthread+0x46/0x6a
[  466.640551]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.640557]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.640560] ---[ end trace 27037b79aef5c60a ]---
[  466.642129] ------------[ cut here ]------------
[  466.642140] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.642143] Hardware name: Studio 540      
[  466.642146] hotplug uevent
[  466.642148] Modules linked in:
[  466.642153] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.642156] Call Trace:
[  466.642164]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.642170]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.642176]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.642182]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.642189]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.642195]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.642202]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.642207]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.642213]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.642218]  [<c1035c84>] kthread+0x46/0x6a
[  466.642222]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.642228]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.642232] ---[ end trace 27037b79aef5c60b ]---
[  466.812247] ------------[ cut here ]------------
[  466.812260] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.812264] Hardware name: Studio 540      
[  466.812267] hotplug uevent
[  466.812269] Modules linked in:
[  466.812275] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.812279] Call Trace:
[  466.812288]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.812294]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.812301]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.812307]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.812314]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.812320]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.812327]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.812333]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.812338]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.812343]  [<c1035c84>] kthread+0x46/0x6a
[  466.812348]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.812354]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.812358] ---[ end trace 27037b79aef5c60c ]---
[  466.816314] ------------[ cut here ]------------
[  466.816324] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.816328] Hardware name: Studio 540      
[  466.816330] hotplug uevent
[  466.816333] Modules linked in:
[  466.816338] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.816342] Call Trace:
[  466.816349]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.816356]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.816362]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.816368]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.816375]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.816382]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.816388]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.816394]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.816399]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.816404]  [<c1035c84>] kthread+0x46/0x6a
[  466.816409]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.816415]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.816419] ---[ end trace 27037b79aef5c60d ]---
[  466.819124] ------------[ cut here ]------------
[  466.819135] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.819139] Hardware name: Studio 540      
[  466.819141] hotplug uevent
[  466.819143] Modules linked in:
[  466.819148] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.819152] Call Trace:
[  466.819159]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.819165]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.819171]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.819177]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.819184]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.819190]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.819196]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.819202]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.819207]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.819212]  [<c1035c84>] kthread+0x46/0x6a
[  466.819217]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.819223]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.819227] ---[ end trace 27037b79aef5c60e ]---
[  466.822313] ------------[ cut here ]------------
[  466.822323] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.822326] Hardware name: Studio 540      
[  466.822329] hotplug uevent
[  466.822331] Modules linked in:
[  466.822336] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.822339] Call Trace:
[  466.822347]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.822353]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.822359]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.822365]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.822373]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.822379]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.822385]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.822391]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.822396]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.822401]  [<c1035c84>] kthread+0x46/0x6a
[  466.822406]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.822411]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.822415] ---[ end trace 27037b79aef5c60f ]---
[  466.823866] ------------[ cut here ]------------
[  466.823876] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.823880] Hardware name: Studio 540      
[  466.823882] hotplug uevent
[  466.823884] Modules linked in:
[  466.823889] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.823892] Call Trace:
[  466.823900]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.823906]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.823912]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.823918]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.823926]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.823932]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.823938]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.823944]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.823950]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.823955]  [<c1035c84>] kthread+0x46/0x6a
[  466.823959]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.823965]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.823969] ---[ end trace 27037b79aef5c610 ]---
[  466.827403] ------------[ cut here ]------------
[  466.827414] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.827418] Hardware name: Studio 540      
[  466.827420] hotplug uevent
[  466.827422] Modules linked in:
[  466.827428] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.827431] Call Trace:
[  466.827438]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.827445]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.827451]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.827457]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.827464]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.827470]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.827476]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.827482]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.827487]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.827492]  [<c1035c84>] kthread+0x46/0x6a
[  466.827496]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.827502]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.827506] ---[ end trace 27037b79aef5c611 ]---
[  466.830698] ------------[ cut here ]------------
[  466.830709] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.830712] Hardware name: Studio 540      
[  466.830715] hotplug uevent
[  466.830717] Modules linked in:
[  466.830722] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.830725] Call Trace:
[  466.830733]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.830739]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.830745]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.830751]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.830758]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.830764]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.830770]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.830776]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.830782]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.830786]  [<c1035c84>] kthread+0x46/0x6a
[  466.830791]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.830797]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.830801] ---[ end trace 27037b79aef5c612 ]---
[  466.832151] ------------[ cut here ]------------
[  466.832161] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.832165] Hardware name: Studio 540      
[  466.832167] hotplug uevent
[  466.832169] Modules linked in:
[  466.832175] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.832178] Call Trace:
[  466.832185]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.832192]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.832198]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.832204]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.832211]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.832217]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.832223]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.832229]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.832235]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.832240]  [<c1035c84>] kthread+0x46/0x6a
[  466.832244]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.832250]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.832254] ---[ end trace 27037b79aef5c613 ]---
[  466.834342] ------------[ cut here ]------------
[  466.834352] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.834356] Hardware name: Studio 540      
[  466.834358] hotplug uevent
[  466.834360] Modules linked in:
[  466.834366] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.834369] Call Trace:
[  466.834376]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.834383]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.834389]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.834395]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.834402]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.834408]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.834414]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.834420]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.834425]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.834430]  [<c1035c84>] kthread+0x46/0x6a
[  466.834435]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.834441]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.834444] ---[ end trace 27037b79aef5c614 ]---
[  466.838021] ------------[ cut here ]------------
[  466.838031] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.838035] Hardware name: Studio 540      
[  466.838037] hotplug uevent
[  466.838039] Modules linked in:
[  466.838045] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.838048] Call Trace:
[  466.838055]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.838062]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.838068]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.838074]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.838080]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.838087]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.838093]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.838098]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.838104]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.838109]  [<c1035c84>] kthread+0x46/0x6a
[  466.838114]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.838120]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.838123] ---[ end trace 27037b79aef5c615 ]---
[  466.851423] ------------[ cut here ]------------
[  466.851435] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.851439] Hardware name: Studio 540      
[  466.851441] hotplug uevent
[  466.851443] Modules linked in:
[  466.851449] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.851452] Call Trace:
[  466.851461]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.851467]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.851473]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.851479]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.851486]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.851493]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.851499]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.851505]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.851510]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.851515]  [<c1035c84>] kthread+0x46/0x6a
[  466.851520]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.851526]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.851530] ---[ end trace 27037b79aef5c616 ]---
[  466.882378] ------------[ cut here ]------------
[  466.882389] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.882393] Hardware name: Studio 540      
[  466.882396] hotplug uevent
[  466.882398] Modules linked in:
[  466.882403] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.882406] Call Trace:
[  466.882414]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.882421]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.882427]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.882433]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.882440]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.882446]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.882452]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.882458]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.882464]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.882469]  [<c1035c84>] kthread+0x46/0x6a
[  466.882473]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.882479]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.882483] ---[ end trace 27037b79aef5c617 ]---
[  466.884270] ------------[ cut here ]------------
[  466.884280] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.884284] Hardware name: Studio 540      
[  466.884286] hotplug uevent
[  466.884288] Modules linked in:
[  466.884294] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.884297] Call Trace:
[  466.884305]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.884311]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.884317]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.884323]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.884330]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.884336]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.884342]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.884348]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.884354]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.884358]  [<c1035c84>] kthread+0x46/0x6a
[  466.884363]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.884369]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.884373] ---[ end trace 27037b79aef5c618 ]---
[  466.887398] ------------[ cut here ]------------
[  466.887408] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.887412] Hardware name: Studio 540      
[  466.887414] hotplug uevent
[  466.887416] Modules linked in:
[  466.887421] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.887424] Call Trace:
[  466.887432]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.887438]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.887444]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.887450]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.887457]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.887463]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.887469]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.887475]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.887480]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.887485]  [<c1035c84>] kthread+0x46/0x6a
[  466.887490]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.887496]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.887499] ---[ end trace 27037b79aef5c619 ]---
[  466.953272] ------------[ cut here ]------------
[  466.953283] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  466.953286] Hardware name: Studio 540      
[  466.953289] hotplug uevent
[  466.953291] Modules linked in:
[  466.953296] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  466.953299] Call Trace:
[  466.953307]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  466.953314]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  466.953320]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  466.953326]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  466.953333]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  466.953340]  [<c1032f28>] worker_thread+0x131/0x1ab
[  466.953346]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  466.953352]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  466.953357]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  466.953362]  [<c1035c84>] kthread+0x46/0x6a
[  466.953367]  [<c1035c3e>] ? kthread+0x0/0x6a
[  466.953373]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  466.953377] ---[ end trace 27037b79aef5c61a ]---
[  467.072503] ------------[ cut here ]------------
[  467.072514] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.072518] Hardware name: Studio 540      
[  467.072521] hotplug uevent
[  467.072523] Modules linked in:
[  467.072529] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.072532] Call Trace:
[  467.072539]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.072546]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.072552]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.072558]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.072565]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.072571]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.072577]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.072583]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.072589]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.072593]  [<c1035c84>] kthread+0x46/0x6a
[  467.072598]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.072604]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.072608] ---[ end trace 27037b79aef5c61b ]---
[  467.078415] ------------[ cut here ]------------
[  467.078426] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.078429] Hardware name: Studio 540      
[  467.078432] hotplug uevent
[  467.078434] Modules linked in:
[  467.078439] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.078442] Call Trace:
[  467.078450]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.078457]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.078463]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.078469]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.078476]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.078482]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.078488]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.078494]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.078499]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.078504]  [<c1035c84>] kthread+0x46/0x6a
[  467.078509]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.078514]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.078518] ---[ end trace 27037b79aef5c61c ]---
[  467.085516] ------------[ cut here ]------------
[  467.085527] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.085530] Hardware name: Studio 540      
[  467.085533] hotplug uevent
[  467.085535] Modules linked in:
[  467.085540] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.085543] Call Trace:
[  467.085551]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.085557]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.085563]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.085569]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.085576]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.085582]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.085588]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.085594]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.085599]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.085604]  [<c1035c84>] kthread+0x46/0x6a
[  467.085609]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.085614]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.085618] ---[ end trace 27037b79aef5c61d ]---
[  467.158243] ------------[ cut here ]------------
[  467.158254] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.158258] Hardware name: Studio 540      
[  467.158260] hotplug uevent
[  467.158263] Modules linked in:
[  467.158268] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.158271] Call Trace:
[  467.158279]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.158285]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.158291]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.158298]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.158305]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.158311]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.158318]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.158324]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.158329]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.158334]  [<c1035c84>] kthread+0x46/0x6a
[  467.158339]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.158345]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.158349] ---[ end trace 27037b79aef5c61e ]---
[  467.413622] ------------[ cut here ]------------
[  467.413636] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.413640] Hardware name: Studio 540      
[  467.413642] hotplug uevent
[  467.413644] Modules linked in:
[  467.413650] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.413654] Call Trace:
[  467.413663]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.413669]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.413675]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.413681]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.413689]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.413695]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.413701]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.413707]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.413713]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.413718]  [<c1035c84>] kthread+0x46/0x6a
[  467.413722]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.413728]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.413732] ---[ end trace 27037b79aef5c61f ]---
[  467.417994] ------------[ cut here ]------------
[  467.418005] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.418023] Hardware name: Studio 540      
[  467.418026] hotplug uevent
[  467.418028] Modules linked in:
[  467.418034] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.418037] Call Trace:
[  467.418045]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.418051]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.418057]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.418063]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.418070]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.418077]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.418083]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.418089]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.418094]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.418099]  [<c1035c84>] kthread+0x46/0x6a
[  467.418103]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.418109]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.418113] ---[ end trace 27037b79aef5c620 ]---
[  467.539172] ------------[ cut here ]------------
[  467.539185] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.539189] Hardware name: Studio 540      
[  467.539192] hotplug uevent
[  467.539194] Modules linked in:
[  467.539200] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.539203] Call Trace:
[  467.539212]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.539219]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.539225]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.539231]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.539238]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.539244]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.539250]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.539257]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.539262]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.539267]  [<c1035c84>] kthread+0x46/0x6a
[  467.539271]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.539277]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.539281] ---[ end trace 27037b79aef5c621 ]---
[  467.543698] ------------[ cut here ]------------
[  467.543709] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.543713] Hardware name: Studio 540      
[  467.543716] hotplug uevent
[  467.543718] Modules linked in:
[  467.543724] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.543727] Call Trace:
[  467.543735]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.543741]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.543747]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.543754]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.543761]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.543767]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.543773]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.543779]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.543785]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.543790]  [<c1035c84>] kthread+0x46/0x6a
[  467.543795]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.543800]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.543804] ---[ end trace 27037b79aef5c622 ]---
[  467.546365] ------------[ cut here ]------------
[  467.546376] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.546379] Hardware name: Studio 540      
[  467.546382] hotplug uevent
[  467.546384] Modules linked in:
[  467.546389] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.546393] Call Trace:
[  467.546400]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.546406]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.546412]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.546418]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.546425]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.546431]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.546437]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.546443]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.546449]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.546454]  [<c1035c84>] kthread+0x46/0x6a
[  467.546458]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.546464]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.546468] ---[ end trace 27037b79aef5c623 ]---
[  467.548281] ------------[ cut here ]------------
[  467.548291] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.548295] Hardware name: Studio 540      
[  467.548297] hotplug uevent
[  467.548299] Modules linked in:
[  467.548305] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.548308] Call Trace:
[  467.548315]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.548322]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.548328]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.548334]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.548340]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.548346]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.548352]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.548358]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.548364]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.548369]  [<c1035c84>] kthread+0x46/0x6a
[  467.548373]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.548379]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.548383] ---[ end trace 27037b79aef5c624 ]---
[  467.562503] ------------[ cut here ]------------
[  467.562514] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  467.562518] Hardware name: Studio 540      
[  467.562521] hotplug uevent
[  467.562523] Modules linked in:
[  467.562529] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  467.562532] Call Trace:
[  467.562540]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  467.562546]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  467.562552]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  467.562558]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  467.562565]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  467.562571]  [<c1032f28>] worker_thread+0x131/0x1ab
[  467.562578]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  467.562584]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  467.562589]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  467.562594]  [<c1035c84>] kthread+0x46/0x6a
[  467.562599]  [<c1035c3e>] ? kthread+0x0/0x6a
[  467.562605]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  467.562608] ---[ end trace 27037b79aef5c625 ]---
[  468.066076] ------------[ cut here ]------------
[  468.066090] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.066094] Hardware name: Studio 540      
[  468.066096] hotplug uevent
[  468.066098] Modules linked in:
[  468.066104] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.066108] Call Trace:
[  468.066117]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.066124]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.066130]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.066136]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.066143]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.066149]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.066155]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.066161]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.066167]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.066172]  [<c1035c84>] kthread+0x46/0x6a
[  468.066176]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.066183]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.066186] ---[ end trace 27037b79aef5c626 ]---
[  468.075249] ------------[ cut here ]------------
[  468.075259] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.075263] Hardware name: Studio 540      
[  468.075265] hotplug uevent
[  468.075268] Modules linked in:
[  468.075273] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.075276] Call Trace:
[  468.075284]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.075290]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.075296]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.075302]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.075309]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.075315]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.075321]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.075327]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.075333]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.075337]  [<c1035c84>] kthread+0x46/0x6a
[  468.075342]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.075348]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.075352] ---[ end trace 27037b79aef5c627 ]---
[  468.080155] ------------[ cut here ]------------
[  468.080166] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.080170] Hardware name: Studio 540      
[  468.080172] hotplug uevent
[  468.080174] Modules linked in:
[  468.080180] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.080183] Call Trace:
[  468.080190]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.080197]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.080203]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.080209]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.080216]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.080222]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.080228]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.080234]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.080240]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.080245]  [<c1035c84>] kthread+0x46/0x6a
[  468.080249]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.080255]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.080259] ---[ end trace 27037b79aef5c628 ]---
[  468.108059] ------------[ cut here ]------------
[  468.108071] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.108075] Hardware name: Studio 540      
[  468.108077] hotplug uevent
[  468.108079] Modules linked in:
[  468.108085] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.108089] Call Trace:
[  468.108096]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.108103]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.108109]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.108115]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.108122]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.108129]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.108135]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.108141]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.108147]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.108152]  [<c1035c84>] kthread+0x46/0x6a
[  468.108156]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.108162]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.108166] ---[ end trace 27037b79aef5c629 ]---
[  468.114634] ------------[ cut here ]------------
[  468.114644] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.114648] Hardware name: Studio 540      
[  468.114650] hotplug uevent
[  468.114653] Modules linked in:
[  468.114658] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.114661] Call Trace:
[  468.114669]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.114675]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.114681]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.114687]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.114694]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.114701]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.114707]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.114713]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.114718]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.114723]  [<c1035c84>] kthread+0x46/0x6a
[  468.114728]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.114734]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.114737] ---[ end trace 27037b79aef5c62a ]---
[  468.116865] ------------[ cut here ]------------
[  468.116875] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.116879] Hardware name: Studio 540      
[  468.116881] hotplug uevent
[  468.116884] Modules linked in:
[  468.116889] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.116892] Call Trace:
[  468.116900]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.116906]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.116912]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.116918]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.116925]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.116931]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.116938]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.116944]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.116949]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.116954]  [<c1035c84>] kthread+0x46/0x6a
[  468.116962]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.116968]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.116972] ---[ end trace 27037b79aef5c62b ]---
[  468.116994] ------------[ cut here ]------------
[  468.117000] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.117013] Hardware name: Studio 540      
[  468.117015] hotplug uevent
[  468.117017] Modules linked in:
[  468.117022] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.117025] Call Trace:
[  468.117031]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.117037]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.117043]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.117049]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.117056]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.117062]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.117068]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.117074]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.117080]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.117085]  [<c1035c84>] kthread+0x46/0x6a
[  468.117089]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.117095]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.117098] ---[ end trace 27037b79aef5c62c ]---
[  468.121461] ------------[ cut here ]------------
[  468.121471] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.121475] Hardware name: Studio 540      
[  468.121478] hotplug uevent
[  468.121480] Modules linked in:
[  468.121485] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.121489] Call Trace:
[  468.121496]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.121503]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.121509]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.121515]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.121521]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.121528]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.121534]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.121540]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.121545]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.121550]  [<c1035c84>] kthread+0x46/0x6a
[  468.121554]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.121561]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.121564] ---[ end trace 27037b79aef5c62d ]---
[  468.126845] ------------[ cut here ]------------
[  468.126855] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.126859] Hardware name: Studio 540      
[  468.126861] hotplug uevent
[  468.126863] Modules linked in:
[  468.126869] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.126872] Call Trace:
[  468.126879]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.126886]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.126892]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.126898]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.126905]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.126911]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.126917]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.126923]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.126928]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.126933]  [<c1035c84>] kthread+0x46/0x6a
[  468.126937]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.126943]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.126947] ---[ end trace 27037b79aef5c62e ]---
[  468.128762] ------------[ cut here ]------------
[  468.128773] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.128776] Hardware name: Studio 540      
[  468.128779] hotplug uevent
[  468.128781] Modules linked in:
[  468.128786] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.128789] Call Trace:
[  468.128797]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.128803]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.128809]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.128815]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.128822]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.128828]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.128834]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.128840]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.128846]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.128851]  [<c1035c84>] kthread+0x46/0x6a
[  468.128855]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.128861]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.128865] ---[ end trace 27037b79aef5c62f ]---
[  468.129934] ------------[ cut here ]------------
[  468.129944] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.129948] Hardware name: Studio 540      
[  468.129951] hotplug uevent
[  468.129953] Modules linked in:
[  468.129959] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.129962] Call Trace:
[  468.129969]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.129976]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.129982]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.129988]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.129995]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.130001]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.130017]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.130023]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.130029]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.130034]  [<c1035c84>] kthread+0x46/0x6a
[  468.130038]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.130044]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.130048] ---[ end trace 27037b79aef5c630 ]---
[  468.130206] ------------[ cut here ]------------
[  468.130214] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.130218] Hardware name: Studio 540      
[  468.130220] hotplug uevent
[  468.130222] Modules linked in:
[  468.130227] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.130230] Call Trace:
[  468.130237]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.130243]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.130249]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.130255]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.130262]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.130268]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.130274]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.130279]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.130285]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.130289]  [<c1035c84>] kthread+0x46/0x6a
[  468.130294]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.130300]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.130303] ---[ end trace 27037b79aef5c631 ]---
[  468.131348] ------------[ cut here ]------------
[  468.131358] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.131362] Hardware name: Studio 540      
[  468.131364] hotplug uevent
[  468.131366] Modules linked in:
[  468.131371] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.131375] Call Trace:
[  468.131382]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.131389]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.131395]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.131401]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.131407]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.131413]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.131419]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.131425]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.131431]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.131436]  [<c1035c84>] kthread+0x46/0x6a
[  468.131440]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.131446]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.131450] ---[ end trace 27037b79aef5c632 ]---
[  468.132057] ------------[ cut here ]------------
[  468.132065] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.132069] Hardware name: Studio 540      
[  468.132071] hotplug uevent
[  468.132073] Modules linked in:
[  468.132078] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.132081] Call Trace:
[  468.132088]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.132094]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.132100]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.132106]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.132113]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.132118]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.132125]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.132130]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.132136]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.132141]  [<c1035c84>] kthread+0x46/0x6a
[  468.132145]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.132151]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.132154] ---[ end trace 27037b79aef5c633 ]---
[  468.133733] ------------[ cut here ]------------
[  468.133742] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.133746] Hardware name: Studio 540      
[  468.133748] hotplug uevent
[  468.133750] Modules linked in:
[  468.133755] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.133758] Call Trace:
[  468.133766]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.133772]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.133778]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.133784]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.133791]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.133797]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.133803]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.133808]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.133814]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.133819]  [<c1035c84>] kthread+0x46/0x6a
[  468.133823]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.133829]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.133832] ---[ end trace 27037b79aef5c634 ]---
[  468.134116] ------------[ cut here ]------------
[  468.134124] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.134128] Hardware name: Studio 540      
[  468.134130] hotplug uevent
[  468.134132] Modules linked in:
[  468.134137] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.134140] Call Trace:
[  468.134146]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.134153]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.134159]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.134165]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.134171]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.134177]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.134183]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.134188]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.134194]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.134202]  [<c1035c84>] kthread+0x46/0x6a
[  468.134207]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.134212]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.134215] ---[ end trace 27037b79aef5c635 ]---
[  468.134234] ------------[ cut here ]------------
[  468.134240] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.134244] Hardware name: Studio 540      
[  468.134246] hotplug uevent
[  468.134248] Modules linked in:
[  468.134252] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.134255] Call Trace:
[  468.134261]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.134267]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.134273]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.134279]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.134286]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.134292]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.134298]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.134304]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.134309]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.134314]  [<c1035c84>] kthread+0x46/0x6a
[  468.134319]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.134324]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.134328] ---[ end trace 27037b79aef5c636 ]---
[  468.134799] ------------[ cut here ]------------
[  468.134807] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.134811] Hardware name: Studio 540      
[  468.134814] hotplug uevent
[  468.134816] Modules linked in:
[  468.134821] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.134824] Call Trace:
[  468.134830]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.134837]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.134843]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.134849]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.134856]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.134862]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.134868]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.134873]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.134879]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.134884]  [<c1035c84>] kthread+0x46/0x6a
[  468.134888]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.134894]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.134898] ---[ end trace 27037b79aef5c637 ]---
[  468.135057] ------------[ cut here ]------------
[  468.135065] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.135068] Hardware name: Studio 540      
[  468.135070] hotplug uevent
[  468.135073] Modules linked in:
[  468.135077] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.135080] Call Trace:
[  468.135087]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.135093]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.135099]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.135105]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.135112]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.135118]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.135124]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.135129]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.135135]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.135140]  [<c1035c84>] kthread+0x46/0x6a
[  468.135144]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.135150]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.135153] ---[ end trace 27037b79aef5c638 ]---
[  468.135821] ------------[ cut here ]------------
[  468.135830] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.135833] Hardware name: Studio 540      
[  468.135835] hotplug uevent
[  468.135837] Modules linked in:
[  468.135842] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.135845] Call Trace:
[  468.135852]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.135858]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.135864]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.135871]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.135877]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.135883]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.135889]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.135895]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.135900]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.135905]  [<c1035c84>] kthread+0x46/0x6a
[  468.135910]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.135915]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.135919] ---[ end trace 27037b79aef5c639 ]---
[  468.137161] ------------[ cut here ]------------
[  468.137170] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.137173] Hardware name: Studio 540      
[  468.137176] hotplug uevent
[  468.137178] Modules linked in:
[  468.137183] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.137186] Call Trace:
[  468.137193]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.137199]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.137205]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.137211]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.137218]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.137224]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.137230]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.137236]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.137241]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.137247]  [<c1035c84>] kthread+0x46/0x6a
[  468.137251]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.137257]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.137260] ---[ end trace 27037b79aef5c63a ]---
[  468.139180] ------------[ cut here ]------------
[  468.139189] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.139193] Hardware name: Studio 540      
[  468.139195] hotplug uevent
[  468.139197] Modules linked in:
[  468.139202] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.139205] Call Trace:
[  468.139212]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.139218]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.139225]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.139231]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.139237]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.139243]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.139249]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.139254]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.139260]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.139265]  [<c1035c84>] kthread+0x46/0x6a
[  468.139269]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.139275]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.139279] ---[ end trace 27037b79aef5c63b ]---
[  468.139836] ------------[ cut here ]------------
[  468.139844] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.139848] Hardware name: Studio 540      
[  468.139850] hotplug uevent
[  468.139852] Modules linked in:
[  468.139857] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.139860] Call Trace:
[  468.139867]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.139873]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.139879]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.139885]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.139892]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.139898]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.139904]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.139909]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.139915]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.139920]  [<c1035c84>] kthread+0x46/0x6a
[  468.139924]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.139930]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.139937] ---[ end trace 27037b79aef5c63c ]---
[  468.139955] ------------[ cut here ]------------
[  468.139961] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.139964] Hardware name: Studio 540      
[  468.139967] hotplug uevent
[  468.139969] Modules linked in:
[  468.139973] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.139976] Call Trace:
[  468.139982]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.139988]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.139994]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.140000]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.140017]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.140023]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.140029]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.140035]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.140040]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.140045]  [<c1035c84>] kthread+0x46/0x6a
[  468.140050]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.140055]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.140059] ---[ end trace 27037b79aef5c63d ]---
[  468.141886] ------------[ cut here ]------------
[  468.141895] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.141899] Hardware name: Studio 540      
[  468.141901] hotplug uevent
[  468.141903] Modules linked in:
[  468.141908] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.141911] Call Trace:
[  468.141918]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.141925]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.141931]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.141937]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.141943]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.141949]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.141955]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.141961]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.141967]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.141971]  [<c1035c84>] kthread+0x46/0x6a
[  468.141976]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.141982]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.141985] ---[ end trace 27037b79aef5c63e ]---
[  468.142787] ------------[ cut here ]------------
[  468.142795] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  468.142799] Hardware name: Studio 540      
[  468.142801] hotplug uevent
[  468.142803] Modules linked in:
[  468.142808] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  468.142811] Call Trace:
[  468.142818]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  468.142824]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  468.142830]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  468.142836]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  468.142843]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  468.142849]  [<c1032f28>] worker_thread+0x131/0x1ab
[  468.142855]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  468.142860]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  468.142866]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  468.142870]  [<c1035c84>] kthread+0x46/0x6a
[  468.142875]  [<c1035c3e>] ? kthread+0x0/0x6a
[  468.142880]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  468.142884] ---[ end trace 27037b79aef5c63f ]---

--Boundary-00=_JNxZK9PLjQtKOfr--
