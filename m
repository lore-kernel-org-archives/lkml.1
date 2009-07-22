Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbZGVQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbZGVQvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZGVQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:51:38 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55029 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZGVQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=g7UoWei5iZBbDfqDJx2tLLMhNcqQLvf1tEh/Z/AF33TPc+UWdEzn6zBdMhfGNvhgNy
         +DtbpJim7mZF9J5IdOhTsjFodrjhC8fL/kYYbdAgHVFcLbCgRzwlmM+/NnAyUCzYHRPV
         f36cY/zKBIJF4Os3uRP85ma2EryuL81UpAsUw=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Wed, 22 Jul 2009 18:51:20 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907221525.29507.info@gnebu.es> <20090722090834.6ab45aae@jbarnes-g45>
In-Reply-To: <20090722090834.6ab45aae@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IO0ZKhDEQBStq76"
Message-Id: <200907221851.20916.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_IO0ZKhDEQBStq76
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 22 July 2009 18:08:34 Jesse Barnes wrote:
> On Wed, 22 Jul 2009 15:25:29 +0200
> Alberto Gonzalez <alberto6674@gmail.com> wrote:
> > Ok, I caught a complete log from boot to when the problem starts.
> > There doesn't seem to be anything significantly different, but just
> > in case.
>
> Oh I guess this is without the debug patch I attached...  this one
> should be a bit less noisy but tell me which bit is stuck.

Actually it was with the debug patch found here applied:

http://lkml.org/lkml/2009/7/2/290

Now I captured another one with the latest patch. This time the problem 
started after opening Amarok.



--Boundary-00=_IO0ZKhDEQBStq76
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg-new.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-new.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.1 (root@localhost) (gcc version 4.4.0 20090630 (prerelease) (GCC) ) #1 SMP Wed Jul 22 18:33:09 CEST 2009
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
[    0.000000] RAMDISK: 37fa0000 - 37fefc22
[    0.000000] Allocated new RAMDISK: 00008000 - 00057c22
[    0.000000] Move RAMDISK from 0000000037fa0000 - 0000000037fefc21 to 00008000 - 00057c21
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
[    0.000000]   #7 [0000008000 - 0000057c22]      NEW RAMDISK ==> [0000008000 - 0000057c22]
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
[    0.000000] Detected 2499.678 MHz processor.
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
[    0.000999]       .data : 0xc13ca3b9 - 0xc15e5b4c   (2157 kB)
[    0.000999]       .text : 0xc1000000 - 0xc13ca3b9   (3880 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4999.35 BogoMIPS (lpj=2499678)
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
[    0.001008] Intel machine check architecture supported.
[    0.001077] Intel machine check reporting enabled on CPU#0.
[    0.001147] using mwait in idle threads.
[    0.001218] Checking 'hlt' instruction... OK.
[    0.005479] ACPI: Core revision 20090320
[    0.013360] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023705] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.023996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 7000.02 BogoMIPS (lpj=3500014)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.095370] CPU1: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.096832] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.097987] Brought up 2 CPUs
[    0.098051] Total of 2 processors activated (11999.38 BogoMIPS).
[    0.098194] khelper used greatest stack depth: 7048 bytes left
[    0.098194] net_namespace: 1028 bytes
[    0.098194] Time: 18:35:43  Date: 07/22/09
[    0.098194] NET: Registered protocol family 16
[    0.099014] ACPI: bus type pci registered
[    0.099070] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.099079] PCI: Not using MMCONFIG.
[    0.099274] PCI: Using configuration type 1 for base access
[    0.104147] bio: create slab <bio-0> at 0
[    0.105600] ACPI: EC: Look up EC in DSDT
[    0.111458] ACPI: Interpreter enabled
[    0.111527] ACPI: (supports S0 S1 S3 S4 S5)
[    0.111703] ACPI: Using IOAPIC for interrupt routing
[    0.111817] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.113260] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.113334] PCI: Using MMCONFIG for extended config space
[    0.120491] ACPI: No dock devices found.
[    0.120740] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.120829] pci 0000:00:02.0: reg 10 64bit mmio: [0xfe400000-0xfe7fffff]
[    0.120829] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.120829] pci 0000:00:02.0: reg 20 io port: [0xdc00-0xdc07]
[    0.120829] pci 0000:00:02.1: reg 10 64bit mmio: [0xfe800000-0xfe8fffff]
[    0.121035] pci 0000:00:1a.0: reg 20 io port: [0xd880-0xd89f]
[    0.121098] pci 0000:00:1a.1: reg 20 io port: [0xd800-0xd81f]
[    0.121161] pci 0000:00:1a.2: reg 20 io port: [0xd480-0xd49f]
[    0.121226] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe9fbc00-0xfe9fbfff]
[    0.121277] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.121352] pci 0000:00:1a.7: PME# disabled
[    0.121453] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe9f4000-0xfe9f7fff]
[    0.121490] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.121563] pci 0000:00:1b.0: PME# disabled
[    0.121681] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.121755] pci 0000:00:1c.0: PME# disabled
[    0.121873] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.121946] pci 0000:00:1c.2: PME# disabled
[    0.122034] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.122107] pci 0000:00:1c.5: PME# disabled
[    0.122220] pci 0000:00:1d.0: reg 20 io port: [0xd400-0xd41f]
[    0.122282] pci 0000:00:1d.1: reg 20 io port: [0xd080-0xd09f]
[    0.122344] pci 0000:00:1d.2: reg 20 io port: [0xd000-0xd01f]
[    0.122409] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe9fb800-0xfe9fbbff]
[    0.122459] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.122531] pci 0000:00:1d.7: PME# disabled
[    0.122704] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.122816] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.122890] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.123030] pci 0000:00:1f.2: reg 10 io port: [0xcc00-0xcc07]
[    0.123035] pci 0000:00:1f.2: reg 14 io port: [0xc880-0xc883]
[    0.123040] pci 0000:00:1f.2: reg 18 io port: [0xc800-0xc807]
[    0.123045] pci 0000:00:1f.2: reg 1c io port: [0xc480-0xc483]
[    0.123050] pci 0000:00:1f.2: reg 20 io port: [0xc400-0xc40f]
[    0.123055] pci 0000:00:1f.2: reg 24 io port: [0xc080-0xc08f]
[    0.123096] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe9fb400-0xfe9fb4ff]
[    0.123109] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.123147] pci 0000:00:1f.5: reg 10 io port: [0xbc00-0xbc07]
[    0.123152] pci 0000:00:1f.5: reg 14 io port: [0xb880-0xb883]
[    0.123157] pci 0000:00:1f.5: reg 18 io port: [0xb800-0xb807]
[    0.123163] pci 0000:00:1f.5: reg 1c io port: [0xb480-0xb483]
[    0.123168] pci 0000:00:1f.5: reg 20 io port: [0xb400-0xb40f]
[    0.123173] pci 0000:00:1f.5: reg 24 io port: [0xb080-0xb08f]
[    0.123284] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.123294] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.123321] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.123331] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.123422] pci 0000:00:1c.2: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.123468] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.123487] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
[    0.123500] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.123508] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.123544] pci 0000:03:00.0: supports D1 D2
[    0.123546] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.123621] pci 0000:03:00.0: PME# disabled
[    0.123733] pci 0000:00:1c.5: bridge io port: [0xe000-0xefff]
[    0.123737] pci 0000:00:1c.5: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.123742] pci 0000:00:1c.5: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.123785] pci 0000:00:1e.0: transparent bridge
[    0.123873] pci_bus 0000:00: on NUMA node 0
[    0.123879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.124058] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.124122] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.124172] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.124219] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.140086] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.140441] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.141004] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.141386] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.141767] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.142152] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.142533] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.142914] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.143234] SCSI subsystem initialized
[    0.143234] libata version 3.00 loaded.
[    0.143234] usbcore: registered new interface driver usbfs
[    0.143234] usbcore: registered new interface driver hub
[    0.143234] usbcore: registered new device driver usb
[    0.143996] PCI: Using ACPI for IRQ routing
[    0.145987] NetLabel: Initializing
[    0.146059] NetLabel:  domain hash size = 128
[    0.146135] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.146211] NetLabel:  unlabeled traffic allowed by default
[    0.146288] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.146288] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.153987] pnp: PnP ACPI init
[    0.154066] ACPI: bus type pnp registered
[    0.156084] pnp: PnP ACPI: found 12 devices
[    0.156150] ACPI: ACPI bus type pnp unregistered
[    0.156224] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.156298] system 00:01: iomem range 0xfed90000-0xfed93fff has been reserved
[    0.156375] system 00:06: ioport range 0xa00-0xadf has been reserved
[    0.156449] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.156521] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.156593] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.156665] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.156740] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.156813] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.156889] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.156963] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.157043] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.157120] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.157193] system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
[    0.157267] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[    0.157340] system 00:0b: iomem range 0x100000-0xc7dfffff could not be reserved
[    0.157451] system 00:0b: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.192489] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.192560] pci 0000:00:1c.0:   IO window: disabled
[    0.192631] pci 0000:00:1c.0:   MEM window: disabled
[    0.192701] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.192773] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.192843] pci 0000:00:1c.2:   IO window: disabled
[    0.192913] pci 0000:00:1c.2:   MEM window: 0xfea00000-0xfeafffff
[    0.192990] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.193062] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
[    0.193134] pci 0000:00:1c.5:   IO window: 0xe000-0xefff
[    0.193206] pci 0000:00:1c.5:   MEM window: 0xfeb00000-0xfebfffff
[    0.193279] pci 0000:00:1c.5:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.193393] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.193463] pci 0000:00:1e.0:   IO window: disabled
[    0.193533] pci 0000:00:1e.0:   MEM window: disabled
[    0.193602] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.193681]   alloc irq_desc for 17 on cpu 0 node 0
[    0.193682]   alloc kstat_irqs on cpu 0 node 0
[    0.193687] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.193761] pci 0000:00:1c.0: setting latency timer to 64
[    0.193767]   alloc irq_desc for 18 on cpu 0 node 0
[    0.193768]   alloc kstat_irqs on cpu 0 node 0
[    0.193771] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.193845] pci 0000:00:1c.2: setting latency timer to 64
[    0.193850]   alloc irq_desc for 16 on cpu 0 node 0
[    0.193852]   alloc kstat_irqs on cpu 0 node 0
[    0.193854] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.193928] pci 0000:00:1c.5: setting latency timer to 64
[    0.193934] pci 0000:00:1e.0: setting latency timer to 64
[    0.193937] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.193939] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.193941] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.193943] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.193945] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.193947] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.193950] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.193952] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    0.193974] NET: Registered protocol family 2
[    0.203065] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.203352] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.203835] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.204108] TCP: Hash tables configured (established 131072 bind 65536)
[    0.204181] TCP reno registered
[    0.206098] NET: Registered protocol family 1
[    0.206228] Trying to unpack rootfs image as initramfs...
[    0.214448] Freeing initrd memory: 319k freed
[    0.214980] Machine check exception polling timer started.
[    0.215431] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.215543] Scanning for low memory corruption every 60 seconds
[    0.215840] audit: initializing netlink socket (disabled)
[    0.215918] type=2000 audit(1248287743.215:1): initialized
[    0.225165] highmem bounce pool size: 64 pages
[    0.225235] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.227521] VFS: Disk quotas dquot_6.5.2
[    0.227650] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.228542] msgmni has been set to 1709
[    0.228694] SELinux:  Registering netfilter hooks
[    0.228980] alg: No test for stdrng (krng)
[    0.229161] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.229274] io scheduler noop registered
[    0.229340] io scheduler anticipatory registered
[    0.229408] io scheduler deadline registered
[    0.229523] io scheduler cfq registered (default)
[    0.229601] pci 0000:00:02.0: Boot video device
[    0.229607] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.229609] pci 0000:00:1a.0: Performing full reset
[    0.229623] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229625] pci 0000:00:1a.1: Performing full reset
[    0.229639] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229640] pci 0000:00:1a.2: Performing full reset
[    0.229672] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.229674] pci 0000:00:1d.0: Performing full reset
[    0.229688] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229689] pci 0000:00:1d.1: Performing full reset
[    0.229703] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.229704] pci 0000:00:1d.2: Performing full reset
[    0.229845]   alloc irq_desc for 24 on cpu 0 node 0
[    0.229847]   alloc kstat_irqs on cpu 0 node 0
[    0.229855] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.229867] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.230060]   alloc irq_desc for 25 on cpu 0 node 0
[    0.230062]   alloc kstat_irqs on cpu 0 node 0
[    0.230068] pcieport-driver 0000:00:1c.2: irq 25 for MSI/MSI-X
[    0.230080] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.230236]   alloc irq_desc for 26 on cpu 0 node 0
[    0.230238]   alloc kstat_irqs on cpu 0 node 0
[    0.230244] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.230255] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.230424] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.230699] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.230810] ACPI: Power Button [PWRF]
[    0.230942] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.231064] ACPI: Power Button [PWRB]
[    0.231506] ACPI: SSDT c7da00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.231901] ACPI: SSDT c7da05f0 004B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.232307] Monitor-Mwait will be used to enter C-1 state
[    0.232327] Monitor-Mwait will be used to enter C-2 state
[    0.232334] Marking TSC unstable due to TSC halts in idle
[    0.232419] Switched to high resolution mode on CPU 0
[    0.232449] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    0.232610] processor ACPI_CPU:00: registered as cooling_device0
[    0.232957] ACPI: SSDT c7da0370 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)<7>Switched to high resolution mode on CPU 1
[    0.233129] 
[    0.233403] ACPI: SSDT c7da0ab0 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    0.233878] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    0.234046] processor ACPI_CPU:01: registered as cooling_device1
[    0.238522] Non-volatile memory driver v1.3
[    0.238667] Linux agpgart interface v0.103
[    0.238793] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    0.239501] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    0.241538] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.241700] [drm] Initialized drm 1.1.0 20060810
[    0.241783] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.241857] i915 0000:00:02.0: setting latency timer to 64
[    0.242988] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    0.243144] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.243231]   alloc irq_desc for 27 on cpu 0 node 0
[    0.243233]   alloc kstat_irqs on cpu 0 node 0
[    0.243241] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.354405] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18040300
[    0.493838] allocated 1152x864 fb: 0x08020000, bo f68069c0
[    0.555280] [drm] DAC-6: set mode 1152x864 19
[    0.578525] Console: switching to colour frame buffer device 144x54
[    0.581425] fb0: inteldrmfb frame buffer device
[    0.581450] registered panic notifier
[    0.581481] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.581566] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.583405] brd: module loaded
[    0.584110] loop: module loaded
[    0.584219] Driver 'sd' needs updating - please use bus_type methods
[    0.584283] Driver 'sr' needs updating - please use bus_type methods
[    0.584439] ata_piix 0000:00:1f.2: version 2.13
[    0.584453]   alloc irq_desc for 19 on cpu 0 node 0
[    0.584455]   alloc kstat_irqs on cpu 0 node 0
[    0.584460] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.584501] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.584582] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.584629] scsi0 : ata_piix
[    0.584774] scsi1 : ata_piix
[    0.585964] ata1: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    0.586037] ata2: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    0.586090] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.586131] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    0.586201] ata_piix 0000:00:1f.5: setting latency timer to 64
[    0.586253] scsi2 : ata_piix
[    0.586361] scsi3 : ata_piix
[    0.587351] ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    0.587392] ata4: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    0.587608] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    0.587644] Copyright (c) 1999-2006 Intel Corporation.
[    0.587708] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    0.587741] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.587811] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.587844] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.587949] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.587990] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.588773] r8169 0000:03:00.0: setting latency timer to 64
[    0.588837]   alloc irq_desc for 28 on cpu 0 node 0
[    0.588839]   alloc kstat_irqs on cpu 0 node 0
[    0.588849] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    0.589065] eth0: RTL8168c/8111c at 0xf8056000, 00:21:70:4c:c3:ac, XID 3c4000c0 IRQ 28
[    0.592654] console [netcon0] enabled
[    0.593469] netconsole: network logging started
[    0.594433] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.595316] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    0.595331] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.596242] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.596245] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.597211] drivers/usb/core/inode.c: creating file 'devices'
[    0.597214] drivers/usb/core/inode.c: creating file '001'
[    0.597255] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.598214] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.598218] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.598232] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.602110] ehci_hcd 0000:00:1a.7: debug port 1
[    0.603075] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.603077] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.603088] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[    0.604087] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.607962] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.614015] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.615090] usb usb1: default language 0x0409
[    0.615096] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.616135] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.617202] usb usb1: Product: EHCI Host Controller
[    0.618267] usb usb1: Manufacturer: Linux 2.6.30.1 ehci_hcd
[    0.619355] usb usb1: SerialNumber: 0000:00:1a.7
[    0.620484] usb usb1: uevent
[    0.620514] usb usb1: usb_probe_device
[    0.620516] usb usb1: configuration #1 chosen from 1 choice
[    0.621644] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.621657] usb 1-0:1.0: uevent
[    0.621687] hub 1-0:1.0: usb_probe_interface
[    0.621688] hub 1-0:1.0: usb_probe_interface - got id
[    0.621690] hub 1-0:1.0: USB hub found
[    0.622836] hub 1-0:1.0: 6 ports detected
[    0.623984] hub 1-0:1.0: standalone hub
[    0.623985] hub 1-0:1.0: no power switching (usb 1.0)
[    0.623986] hub 1-0:1.0: individual port over-current protection
[    0.623988] hub 1-0:1.0: power on to power good time: 20ms
[    0.623992] hub 1-0:1.0: local power source is good
[    0.623993] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.624080] drivers/usb/core/inode.c: creating file '001'
[    0.624134]   alloc irq_desc for 23 on cpu 0 node 0
[    0.624135]   alloc kstat_irqs on cpu 0 node 0
[    0.624139] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.625321] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.625323] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.626523] drivers/usb/core/inode.c: creating file '002'
[    0.626563] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.627739] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.627743] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.627756] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.631650] ehci_hcd 0000:00:1d.7: debug port 1
[    0.632816] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.632818] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.632827] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[    0.634004] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.637870] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.644012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.645234] usb usb2: default language 0x0409
[    0.645239] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.646384] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.647544] usb usb2: Product: EHCI Host Controller
[    0.648684] usb usb2: Manufacturer: Linux 2.6.30.1 ehci_hcd
[    0.649846] usb usb2: SerialNumber: 0000:00:1d.7
[    0.651022] usb usb2: uevent
[    0.651051] usb usb2: usb_probe_device
[    0.651053] usb usb2: configuration #1 chosen from 1 choice
[    0.652202] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.652213] usb 2-0:1.0: uevent
[    0.652243] hub 2-0:1.0: usb_probe_interface
[    0.652244] hub 2-0:1.0: usb_probe_interface - got id
[    0.652246] hub 2-0:1.0: USB hub found
[    0.653390] hub 2-0:1.0: 6 ports detected
[    0.654537] hub 2-0:1.0: standalone hub
[    0.654539] hub 2-0:1.0: no power switching (usb 1.0)
[    0.654540] hub 2-0:1.0: individual port over-current protection
[    0.654542] hub 2-0:1.0: power on to power good time: 20ms
[    0.654545] hub 2-0:1.0: local power source is good
[    0.654547] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.654602] drivers/usb/core/inode.c: creating file '001'
[    0.654680] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.655848] ohci_hcd: block sizes: ed 64 td 64
[    0.655884] uhci_hcd: USB Universal Host Controller Interface driver
[    0.657084] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.658257] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.658260] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.659457] drivers/usb/core/inode.c: creating file '003'
[    0.659498] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.660674] uhci_hcd 0000:00:1a.0: detected 2 ports
[    0.661855] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.661856] uhci_hcd 0000:00:1a.0: Performing full reset
[    0.661869] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    0.661879] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[    0.663069] usb usb3: default language 0x0409
[    0.663074] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.664264] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.665462] usb usb3: Product: UHCI Host Controller
[    0.666632] usb usb3: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.667798] usb usb3: SerialNumber: 0000:00:1a.0
[    0.668986] usb usb3: uevent
[    0.669015] usb usb3: usb_probe_device
[    0.669017] usb usb3: configuration #1 chosen from 1 choice
[    0.670181] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    0.670193] usb 3-0:1.0: uevent
[    0.670222] hub 3-0:1.0: usb_probe_interface
[    0.670224] hub 3-0:1.0: usb_probe_interface - got id
[    0.670225] hub 3-0:1.0: USB hub found
[    0.671386] hub 3-0:1.0: 2 ports detected
[    0.672529] hub 3-0:1.0: standalone hub
[    0.672530] hub 3-0:1.0: no power switching (usb 1.0)
[    0.672532] hub 3-0:1.0: individual port over-current protection
[    0.672534] hub 3-0:1.0: power on to power good time: 2ms
[    0.672537] hub 3-0:1.0: local power source is good
[    0.672538] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    0.672585] drivers/usb/core/inode.c: creating file '001'
[    0.672641]   alloc irq_desc for 21 on cpu 0 node 0
[    0.672643]   alloc kstat_irqs on cpu 0 node 0
[    0.672646] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.673812] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.673815] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.674993] drivers/usb/core/inode.c: creating file '004'
[    0.675040] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.676188] uhci_hcd 0000:00:1a.1: detected 2 ports
[    0.677323] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.677325] uhci_hcd 0000:00:1a.1: Performing full reset
[    0.677337] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    0.677347] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[    0.678494] usb usb4: default language 0x0409
[    0.678499] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.679632] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.680778] usb usb4: Product: UHCI Host Controller
[    0.681901] usb usb4: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.683021] usb usb4: SerialNumber: 0000:00:1a.1
[    0.684168] usb usb4: uevent
[    0.684199] usb usb4: usb_probe_device
[    0.684201] usb usb4: configuration #1 chosen from 1 choice
[    0.685327] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    0.685338] usb 4-0:1.0: uevent
[    0.685369] hub 4-0:1.0: usb_probe_interface
[    0.685371] hub 4-0:1.0: usb_probe_interface - got id
[    0.685373] hub 4-0:1.0: USB hub found
[    0.686487] hub 4-0:1.0: 2 ports detected
[    0.687585] hub 4-0:1.0: standalone hub
[    0.687586] hub 4-0:1.0: no power switching (usb 1.0)
[    0.687588] hub 4-0:1.0: individual port over-current protection
[    0.687589] hub 4-0:1.0: power on to power good time: 2ms
[    0.687592] hub 4-0:1.0: local power source is good
[    0.687594] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    0.687639] drivers/usb/core/inode.c: creating file '001'
[    0.687696] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    0.688825] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.688827] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.689983] drivers/usb/core/inode.c: creating file '005'
[    0.690027] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.691165] uhci_hcd 0000:00:1a.2: detected 2 ports
[    0.692291] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.692292] uhci_hcd 0000:00:1a.2: Performing full reset
[    0.692305] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    0.692309] uhci_hcd 0000:00:1a.2: irq 21, io base 0x0000d480
[    0.693445] usb usb5: default language 0x0409
[    0.693450] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.694592] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.695723] usb usb5: Product: UHCI Host Controller
[    0.696845] usb usb5: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.697969] usb usb5: SerialNumber: 0000:00:1a.2
[    0.699107] usb usb5: uevent
[    0.699142] usb usb5: usb_probe_device
[    0.699144] usb usb5: configuration #1 chosen from 1 choice
[    0.700268] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    0.700281] usb 5-0:1.0: uevent
[    0.700310] hub 5-0:1.0: usb_probe_interface
[    0.700312] hub 5-0:1.0: usb_probe_interface - got id
[    0.700313] hub 5-0:1.0: USB hub found
[    0.701437] hub 5-0:1.0: 2 ports detected
[    0.702539] hub 5-0:1.0: standalone hub
[    0.702540] hub 5-0:1.0: no power switching (usb 1.0)
[    0.702542] hub 5-0:1.0: individual port over-current protection
[    0.702543] hub 5-0:1.0: power on to power good time: 2ms
[    0.702547] hub 5-0:1.0: local power source is good
[    0.702548] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    0.702593] drivers/usb/core/inode.c: creating file '001'
[    0.702649] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.703784] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.703786] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.704957] drivers/usb/core/inode.c: creating file '006'
[    0.705005] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.706147] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.707278] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.707280] uhci_hcd 0000:00:1d.0: Performing full reset
[    0.707292] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    0.707296] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    0.708442] usb usb6: default language 0x0409
[    0.708447] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.709587] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.710751] usb usb6: Product: UHCI Host Controller
[    0.711887] usb usb6: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.713025] usb usb6: SerialNumber: 0000:00:1d.0
[    0.714180] usb usb6: uevent
[    0.714209] usb usb6: usb_probe_device
[    0.714211] usb usb6: configuration #1 chosen from 1 choice
[    0.715336] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    0.715348] usb 6-0:1.0: uevent
[    0.715377] hub 6-0:1.0: usb_probe_interface
[    0.715379] hub 6-0:1.0: usb_probe_interface - got id
[    0.715380] hub 6-0:1.0: USB hub found
[    0.716499] hub 6-0:1.0: 2 ports detected
[    0.717602] hub 6-0:1.0: standalone hub
[    0.717603] hub 6-0:1.0: no power switching (usb 1.0)
[    0.717605] hub 6-0:1.0: individual port over-current protection
[    0.717606] hub 6-0:1.0: power on to power good time: 2ms
[    0.717609] hub 6-0:1.0: local power source is good
[    0.717611] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    0.717656] drivers/usb/core/inode.c: creating file '001'
[    0.717712]   alloc irq_desc for 20 on cpu 0 node 0
[    0.717714]   alloc kstat_irqs on cpu 0 node 0
[    0.717718] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    0.718861] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.718863] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.720027] drivers/usb/core/inode.c: creating file '007'
[    0.720068] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.721214] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.722343] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.722345] uhci_hcd 0000:00:1d.1: Performing full reset
[    0.722357] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    0.722367] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000d080
[    0.723511] usb usb7: default language 0x0409
[    0.723516] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.724660] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.725806] usb usb7: Product: UHCI Host Controller
[    0.726942] usb usb7: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.728086] usb usb7: SerialNumber: 0000:00:1d.1
[    0.729246] usb usb7: uevent
[    0.729265] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[    0.729268] hub 1-0:1.0: port 5: status 0501 change 0001
[    0.729274] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[    0.729277] hub 1-0:1.0: port 6: status 0501 change 0001
[    0.729285] usb usb7: usb_probe_device
[    0.729287] usb usb7: configuration #1 chosen from 1 choice
[    0.730417] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    0.730429] usb 7-0:1.0: uevent
[    0.730459] hub 7-0:1.0: usb_probe_interface
[    0.730461] hub 7-0:1.0: usb_probe_interface - got id
[    0.730462] hub 7-0:1.0: USB hub found
[    0.731584] hub 7-0:1.0: 2 ports detected
[    0.732692] hub 7-0:1.0: standalone hub
[    0.732693] hub 7-0:1.0: no power switching (usb 1.0)
[    0.732694] hub 7-0:1.0: individual port over-current protection
[    0.732696] hub 7-0:1.0: power on to power good time: 2ms
[    0.732699] hub 7-0:1.0: local power source is good
[    0.732701] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    0.732748] drivers/usb/core/inode.c: creating file '001'
[    0.732804] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.733951] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.733954] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.735117] drivers/usb/core/inode.c: creating file '008'
[    0.735160] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.736306] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.737434] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.737435] uhci_hcd 0000:00:1d.2: Performing full reset
[    0.737448] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    0.737452] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[    0.738596] usb usb8: default language 0x0409
[    0.738601] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.739745] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.740906] usb usb8: Product: UHCI Host Controller
[    0.742043] usb usb8: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.743195] usb usb8: SerialNumber: 0000:00:1d.2
[    0.744350] usb usb8: uevent
[    0.744379] usb usb8: usb_probe_device
[    0.744381] usb usb8: configuration #1 chosen from 1 choice
[    0.745510] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    0.745521] usb 8-0:1.0: uevent
[    0.745550] hub 8-0:1.0: usb_probe_interface
[    0.745552] hub 8-0:1.0: usb_probe_interface - got id
[    0.745553] hub 8-0:1.0: USB hub found
[    0.746678] hub 8-0:1.0: 2 ports detected
[    0.747782] hub 8-0:1.0: standalone hub
[    0.747783] hub 8-0:1.0: no power switching (usb 1.0)
[    0.747785] hub 8-0:1.0: individual port over-current protection
[    0.747786] hub 8-0:1.0: power on to power good time: 2ms
[    0.747790] hub 8-0:1.0: local power source is good
[    0.747791] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    0.747836] drivers/usb/core/inode.c: creating file '001'
[    0.747950] usbcore: registered new interface driver usblp
[    0.749090] Initializing USB Mass Storage driver...
[    0.750254] usbcore: registered new interface driver usb-storage
[    0.751400] USB Mass Storage support registered.
[    0.752581] usbcore: registered new interface driver libusual
[    0.753833] PNP: No PS/2 controller found. Probing ports directly.
[    0.755067] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    0.755070] hub 2-0:1.0: port 3: status 0501 change 0001
[    0.757022] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.758185] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.759369] mice: PS/2 mouse device common for all mice
[    0.760688] rtc_cmos 00:03: RTC can wake from S4
[    0.761864] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.763023] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.764201] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.765628] cpuidle: using governor ladder
[    0.767113] cpuidle: using governor menu
[    0.769190] usbcore: registered new interface driver hiddev
[    0.770370] usbcore: registered new interface driver usbhid
[    0.771490] usbhid: v2.6:USB HID core driver
[    0.772638] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.772662] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.774478]   alloc irq_desc for 22 on cpu 0 node 0
[    0.774480]   alloc kstat_irqs on cpu 0 node 0
[    0.774485] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.775668] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.787053] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.802033] uhci_hcd 0000:00:1a.2: port 1 portsc 008a,00
[    0.802049] uhci_hcd 0000:00:1a.2: port 2 portsc 008a,00
[    0.811149] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    0.817052] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.829042] hub 1-0:1.0: state 7 ports 6 chg 0060 evt 0000
[    0.829052] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    0.829062] ehci_hcd 0000:00:1a.7: port 5 low speed --> companion
[    0.832028] uhci_hcd 0000:00:1d.1: port 1 portsc 0082,00
[    0.838217] ALSA device list:
[    0.839382]   #0: HDA Intel at 0xfe9f4000 irq 22
[    0.840580] Netfilter messages via NETLINK v0.30.
[    0.841749] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.843115] ctnetlink v0.93: registering with nfnetlink.
[    0.844770] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.845957] TCP cubic registered
[    0.847112] Initializing XFRM netlink socket
[    0.848535] NET: Registered protocol family 10
[    0.850486] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.851691] IPv6 over IPv4 tunneling driver
[    0.853348] NET: Registered protocol family 17
[    0.854664] RPC: Registered udp transport module.
[    0.855814] RPC: Registered tcp transport module.
[    0.857489] Using IPI No-Shortcut mode
[    0.858755] PM: Resume from disk failed.
[    0.858765] registered taskstats version 1
[    0.860009]   Magic number: 1:598:595
[    0.861126] sound hwC0D1: hash matches
[    0.880150] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    0.880168] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    0.880173] ehci_hcd 0000:00:1a.7: port 6 low speed --> companion
[    0.908700] ata3: SATA link down (SStatus 0 SControl 300)
[    0.931032] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    0.931051] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    0.931060] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.931065] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    0.931072] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    0.982273] ehci_hcd 0000:00:1d.7: port 3 high speed
[    0.982276] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.033031] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    1.347092] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.348280] ata1.01: SATA link down (SStatus 0 SControl 300)
[    1.379683] ata1.00: ATA-8: ST3320613AS, DE13, max UDMA/133
[    1.380893] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.431674] ata1.00: configured for UDMA/133
[    1.432945] scsi 0:0:0:0: Direct-Access     ATA      ST3320613AS      DE13 PQ: 0 ANSI: 5
[    1.434358] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.435566] sd 0:0:0:0: [sda] Write Protect is off
[    1.436747] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.436764] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.438050]  sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.460743]  sda1 sda2 sda3 sda4
[    1.497023] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.594273] ehci_hcd 0000:00:1d.7: port 3 high speed
[    1.594277] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.704027] usb usb3: suspend_rh (auto-stop)
[    1.704048] usb usb4: suspend_rh (auto-stop)
[    1.719667] usb 2-3: default language 0x0409
[    1.725170] usb 2-3: New USB device found, idVendor=0bda, idProduct=0151
[    1.726499] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.727709] usb 2-3: Product: USB2.0-CRW
[    1.728919] usb 2-3: Manufacturer: Generic
[    1.730119] usb 2-3: SerialNumber: 20060413092100000
[    1.731348] usb 2-3: uevent
[    1.731389] usb 2-3: usb_probe_device
[    1.731391] usb 2-3: configuration #1 chosen from 1 choice
[    1.733166] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[    1.733922] usb 2-3:1.0: uevent
[    1.733991] usb-storage 2-3:1.0: usb_probe_interface
[    1.733999] usb-storage 2-3:1.0: usb_probe_interface - got id
[    1.734055] scsi4 : SCSI emulation for USB Mass Storage devices
[    1.735371] usb-storage: device found at 2
[    1.735372] usb-storage: waiting for device to settle before scanning
[    1.735461] drivers/usb/core/inode.c: creating file '002'
[    1.735517] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    1.735523] uhci_hcd 0000:00:1a.2: port 1 portsc 01a3,00
[    1.735528] hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    1.839027] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    1.941029] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    1.954027] usb usb6: suspend_rh (auto-stop)
[    1.954048] usb usb8: suspend_rh (auto-stop)
[    1.954077] usb usb7: suspend_rh (auto-stop)
[    2.112463] usb 5-1: skipped 1 descriptor after interface
[    2.112468] usb 5-1: skipped 1 descriptor after interface
[    2.118459] usb 5-1: default language 0x0409
[    2.142460] usb 5-1: New USB device found, idVendor=0d62, idProduct=2106
[    2.143708] usb 5-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.144918] usb 5-1: Product: USB Multimedia Keyboard
[    2.146148] usb 5-1: uevent
[    2.146187] usb 5-1: usb_probe_device
[    2.146188] usb 5-1: configuration #1 chosen from 1 choice
[    2.149464] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    2.149490] usb 5-1:1.0: uevent
[    2.149564] usbhid 5-1:1.0: usb_probe_interface
[    2.149568] usbhid 5-1:1.0: usb_probe_interface - got id
[    2.180740] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input2
[    2.181996] uhci_hcd 0000:00:1a.2: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    2.182079] generic-usb 0003:0D62:2106.0001: input,hidraw0: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input0
[    2.183426] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    2.183438] usb 5-1:1.1: uevent
[    2.183481] usbhid 5-1:1.1: usb_probe_interface
[    2.183483] usbhid 5-1:1.1: usb_probe_interface - got id
[    2.199082] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.200417] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.204244] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    2.211251] ata2.00: configured for UDMA/100
[    2.214096] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    2.219244] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.220645] Uniform CD-ROM driver Revision: 3.20
[    2.222006] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/input/input3
[    2.222077] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.222159] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.224695] uhci_hcd 0000:00:1a.2: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    2.224789] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Device [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input1
[    2.226264] drivers/usb/core/inode.c: creating file '002'
[    2.226324] uhci_hcd 0000:00:1a.2: port 2 portsc 01a3,00
[    2.226329] hub 5-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    2.330031] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    2.432024] usb 5-2: new low speed USB device using uhci_hcd and address 3
[    2.439031] async/1 used greatest stack depth: 6948 bytes left
[    2.498030] async/4 used greatest stack depth: 6828 bytes left
[    2.544696] ata4: SATA link down (SStatus 0 SControl 300)
[    2.546141] Freeing unused kernel memory: 344k freed
[    2.547716] Write protecting the kernel text: 3884k
[    2.549184] Write protecting the kernel read-only data: 1708k
[    2.571677] usb usb3: uevent
[    2.571692] usb 3-0:1.0: uevent
[    2.571763] usb usb4: uevent
[    2.571777] usb 4-0:1.0: uevent
[    2.571848] usb usb5: uevent
[    2.571863] usb 5-0:1.0: uevent
[    2.571891] usb 5-1: uevent
[    2.571905] usb 5-1:1.0: uevent
[    2.572003] usb 5-1:1.1: uevent
[    2.572158] usb usb1: uevent
[    2.572172] usb 1-0:1.0: uevent
[    2.572595] usb usb6: uevent
[    2.572609] usb 6-0:1.0: uevent
[    2.572681] usb usb7: uevent
[    2.572695] usb 7-0:1.0: uevent
[    2.572767] usb usb8: uevent
[    2.572781] usb 8-0:1.0: uevent
[    2.572851] usb usb2: uevent
[    2.572865] usb 2-0:1.0: uevent
[    2.572893] usb 2-3: uevent
[    2.572908] usb 2-3:1.0: uevent
[    2.578462] usb 5-2: skipped 1 descriptor after interface
[    2.583458] usb 5-2: default language 0x0409
[    2.598466] usb 5-2: New USB device found, idVendor=413c, idProduct=3012
[    2.600140] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.601823] usb 5-2: Product: Dell USB Optical Mouse
[    2.603509] usb 5-2: Manufacturer: Dell
[    2.605111] usb 5-2: uevent
[    2.605125] usb 5-2: usb_probe_device
[    2.605128] usb 5-2: configuration #1 chosen from 1 choice
[    2.609465] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    2.609494] usb 5-2:1.0: uevent
[    2.609514] usbhid 5-2:1.0: usb_probe_interface
[    2.609516] usbhid 5-2:1.0: usb_probe_interface - got id
[    2.621673] udevd used greatest stack depth: 6516 bytes left
[    2.623416] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input4
[    2.625016] generic-usb 0003:413C:3012.0003: input,hidraw2: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.2-2/input0
[    2.626626] drivers/usb/core/inode.c: creating file '003'
[    2.626661] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.626666] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    2.668227] udevd used greatest stack depth: 6340 bytes left
[    3.292057] kjournald starting.  Commit interval 5 seconds
[    3.292072] EXT3-fs: mounted filesystem with writeback data mode.
[    3.701035] hub 3-0:1.0: hub_suspend
[    3.701045] usb usb3: bus auto-suspend
[    3.701050] usb usb3: suspend_rh
[    3.701069] hub 4-0:1.0: hub_suspend
[    3.701073] usb usb4: bus auto-suspend
[    3.701076] usb usb4: suspend_rh
[    3.701093] hub 6-0:1.0: hub_suspend
[    3.701098] usb usb6: bus auto-suspend
[    3.701101] usb usb6: suspend_rh
[    3.701118] hub 1-0:1.0: hub_suspend
[    3.701122] usb usb1: bus auto-suspend
[    3.701139] ehci_hcd 0000:00:1a.7: suspend root hub
[    3.701160] hub 8-0:1.0: hub_suspend
[    3.701163] usb usb8: bus auto-suspend
[    3.701164] usb usb8: suspend_rh
[    4.537488] udevd used greatest stack depth: 5976 bytes left
[    4.537508] udev: starting version 141
[    4.560904] usb usb3: uevent
[    4.560920] usb 3-0:1.0: uevent
[    4.560997] usb usb4: uevent
[    4.561034] usb 4-0:1.0: uevent
[    4.561107] usb usb5: uevent
[    4.561122] usb 5-0:1.0: uevent
[    4.561157] usb 5-1: uevent
[    4.561172] usb 5-1:1.0: uevent
[    4.561274] usb 5-1:1.1: uevent
[    4.561380] usb 5-2: uevent
[    4.561395] usb 5-2:1.0: uevent
[    4.561556] usb usb1: uevent
[    4.561570] usb 1-0:1.0: uevent
[    4.562014] usb usb6: uevent
[    4.562031] usb 6-0:1.0: uevent
[    4.562104] usb usb7: uevent
[    4.562119] usb 7-0:1.0: uevent
[    4.562192] usb usb8: uevent
[    4.562206] usb 8-0:1.0: uevent
[    4.562281] usb usb2: uevent
[    4.562296] usb 2-0:1.0: uevent
[    4.562324] usb 2-3: uevent
[    4.562339] usb 2-3:1.0: uevent
[    4.701158] hub 7-0:1.0: hub_suspend
[    4.701166] usb usb7: bus auto-suspend
[    4.701169] usb usb7: suspend_rh
[    5.033670] usb 5-1:1.0: uevent
[    5.033751] usb 5-1: uevent
[    5.039411] usb 5-1:1.1: uevent
[    5.039490] usb 5-1: uevent
[    5.043433] usb 5-2:1.0: uevent
[    5.043516] usb 5-2: uevent
[    5.065137] usb 5-2:1.0: uevent
[    5.065212] usb 5-2: uevent
[    5.758074] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    5.780905] EXT3 FS on sda3, internal journal
[    5.889457] EXT4-fs: barriers enabled
[    5.889740] kjournald2 starting: pid 3191, dev sda2:8, commit interval 5 seconds
[    5.889762] EXT4-fs: delayed allocation enabled
[    5.889766] EXT4-fs: file extents enabled
[    5.901815] EXT4-fs: mballoc enabled
[    5.901826] EXT4-fs: mounted filesystem sda2 with ordered data mode
[    5.924064] Adding 8426084k swap on /dev/sda4.  Priority:-1 extents:1 across:8426084k 
[    6.741443] scsi 4:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 CCS
[    6.741560] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    6.742997] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    6.743015] usb-storage: device scan complete
[    6.745579] usb 2-3:1.0: uevent
[    6.745668] usb 2-3: uevent
[   10.705071] usb usb3: uevent
[   10.705120] usb 3-0:1.0: uevent
[   10.705341] usb usb4: uevent
[   10.705388] usb 4-0:1.0: uevent
[   10.705598] usb usb5: uevent
[   10.705644] usb 5-0:1.0: uevent
[   10.705723] usb 5-1: uevent
[   10.705770] usb 5-1:1.0: uevent
[   10.706288] usb 5-1:1.1: uevent
[   10.706596] usb 5-2: uevent
[   10.706643] usb 5-2:1.0: uevent
[   10.707161] usb usb1: uevent
[   10.707207] usb 1-0:1.0: uevent
[   10.708377] usb usb6: uevent
[   10.708424] usb 6-0:1.0: uevent
[   10.708629] usb usb7: uevent
[   10.708675] usb 7-0:1.0: uevent
[   10.708880] usb usb8: uevent
[   10.708930] usb 8-0:1.0: uevent
[   10.709143] usb usb2: uevent
[   10.709189] usb 2-0:1.0: uevent
[   10.709268] usb 2-3: uevent
[   10.709314] usb 2-3:1.0: uevent
[   11.291506] r8169: eth0: link up
[   11.291513] r8169: eth0: link up
[   13.439124] [drm] DAC-6: set mode 1024x768 1b
[   14.020035] uhci_hcd 0000:00:1a.2: reserve dev 3 ep81-INT, period 8, phase 4, 99 us
[   21.815016] eth0: no IPv6 routers present
[  140.709578] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[  272.042544] amarok used greatest stack depth: 5884 bytes left
[  284.399801] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  285.067759] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  285.368666] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  285.462617] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.230845] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.249978] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  286.251807] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.254535] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.261574] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.266741] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.294031] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.296188] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.300531] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.664526] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.770326] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  286.772230] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.782808] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  286.798510] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.866570] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  286.873609] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  287.993717] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  288.003154] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  288.008652] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  289.289276] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  289.475976] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  289.478425] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  289.586616] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  289.938166] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  289.957513] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  290.331749] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  290.656884] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  290.821840] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  290.945607] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.035607] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  291.053373] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.076965] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.082357] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.089272] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.094004] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.135669] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  291.138666] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.147574] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.149261] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  291.766198] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  291.871207] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  291.876537] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  292.040739] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  292.056941] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  292.096916] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  292.328755] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  292.854910] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  293.016562] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  293.045795] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  293.197344] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  293.327902] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  293.751159] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  293.754164] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  293.769722] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  293.778375] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  294.148278] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  294.168508] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  294.180221] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  294.233870] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  294.236022] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  294.924558] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  294.940063] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  295.213407] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  295.698043] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  295.713735] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  295.766050] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  295.798361] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  295.809459] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  296.746468] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  296.751888] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  297.103755] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  297.107149] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  297.111232] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  297.116207] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  297.122216] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  297.144801] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  297.149476] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  297.178440] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  297.432793] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  297.634114] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  298.179609] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  299.868895] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  299.924641] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  299.926773] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  299.929877] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  299.935822] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  299.937976] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.085074] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.220460] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.227183] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.229654] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.231916] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.234093] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.236705] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.238733] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.242162] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.243921] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.246396] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.248948] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.250885] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.258559] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.262148] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.267963] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.272523] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.274565] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.277256] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.282135] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.283886] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.286765] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.289147] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.289486] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.291595] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.296605] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.366428] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.599277] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.602721] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  300.621104] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  300.935565] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.001231] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.003976] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.005992] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.021031] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.036389] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.330901] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.333286] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.335766] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.337618] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.366033] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.625252] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.756032] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.820206] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.952246] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.959257] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.971197] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  301.973641] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  301.981368] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.235110] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.237374] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.270254] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.272438] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.274330] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.276802] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.281734] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.288110] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.292681] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.296168] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.409678] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.411808] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.465326] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.469726] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.471261] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.482104] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.484023] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.486200] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.495393] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.500764] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.650981] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.653273] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.668486] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.670132] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.677347] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.680726] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.688344] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.723723] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.729669] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.739898] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.747020] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.872872] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.907662] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.922523] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.924685] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.927327] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.929992] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.938017] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.968344] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  302.973405] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  302.992002] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.012497] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.049653] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.051803] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.064478] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.131583] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.136258] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.137985] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.139573] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.140781] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.143607] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.156363] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.160737] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.179229] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.187851] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.189951] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.203356] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.206377] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.279705] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.281519] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.283528] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.285582] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.288720] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.432405] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.440000] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.443273] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.445498] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.451834] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.460008] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.462353] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.476693] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.478690] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.480649] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.486859] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.489234] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.492218] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.499040] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.503925] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.505719] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.528310] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.530501] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.534767] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.536376] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.538414] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.541002] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.543478] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.547145] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.559598] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.662568] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.667478] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.669503] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.675842] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.681019] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.725173] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.727987] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.750415] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.768135] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.833946] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.836080] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.836162] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.839786] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  303.856361] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  303.857446] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.377683] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.381343] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.383470] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.385556] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.388382] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.389966] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.394209] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.467652] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.470435] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.472533] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.478232] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  304.550207] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.643235] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  304.717933] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  305.715105] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  306.954337] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  306.972643] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  306.995357] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.003290] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.028711] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  307.042068] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.154863] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  307.539604] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  307.658110] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.868490] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.871430] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.882752] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  307.902906] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  307.964438] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  308.121589] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  308.123846] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  308.604572] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  308.635543] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  308.638515] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  308.699340] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  308.929686] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  308.960716] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  309.345058] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  309.382668] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  309.386151] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  311.147892] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  311.342112] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  311.355779] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  311.388288] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  311.539991] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  311.735617] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  311.739442] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  311.742018] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.363554] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  312.365492] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.444763] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  312.446826] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  312.455410] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.458016] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.459251] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.491629] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  312.494488] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.497018] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  312.499375] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.503834] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.505967] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.511288] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  312.519583] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  313.706631] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  313.711715] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  313.970864] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  313.976018] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  313.979797] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  314.352497] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  314.389727] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  314.541579] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  314.796645] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  315.001055] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  315.692732] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  315.812650] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  315.816301] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  315.817919] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  315.825259] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.352318] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  318.371679] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.379516] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.427351] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.432750] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  318.480015] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  318.489653] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.492728] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.494976] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.496577] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  318.497788] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  319.553737] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  319.639602] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  319.844087] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  320.698094] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  320.730451] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  320.732117] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  320.734626] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  320.996869] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  322.253257] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  322.657822] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  322.660163] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  322.661867] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  322.969751] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  323.017204] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  323.048948] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  323.077910] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  323.142630] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  323.490295] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  323.693481] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  323.824391] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  324.093926] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  324.104214] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  324.542428] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  324.916125] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  325.051325] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  325.058206] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.066687] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.096533] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.099405] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.323745] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.337072] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.342475] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.366211] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  325.396045] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.398251] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.442187] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.473431] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.616331] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  325.885091] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  326.074665] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  326.080509] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  326.084416] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.092444] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.093744] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  326.095366] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.099290] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.112751] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.114786] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.150483] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.365921] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.370924] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.377234] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  326.518698] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  326.544118] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  327.489173] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  327.493647] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  328.462771] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  328.627925] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  328.679196] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  328.915211] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  328.918425] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  329.248097] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  329.276149] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  329.325795] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  329.957856] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  329.959048] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  330.036365] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  330.037546] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  330.308519] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  330.323973] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  330.341719] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  330.560830] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  330.569590] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  330.573329] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  330.866374] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  330.902539] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  330.904402] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  330.932931] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  331.178365] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  331.183193] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  331.185670] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  331.209510] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  331.259666] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  331.261596] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  331.279239] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  331.281985] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  331.294292] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  331.411581] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  331.697541] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  332.337265] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  332.693952] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  332.697169] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  332.703662] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.164318] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.171493] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.252892] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.258501] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.260259] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.261779] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.499551] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.506236] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.509624] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.512312] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.527228] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.534995] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.536624] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.557420] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.559749] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.564411] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.566344] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.718296] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.735556] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.737282] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.762110] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.765391] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.767543] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.773157] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.775539] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.778033] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.855953] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.889809] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.901460] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  333.936457] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.938361] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  333.969577] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  334.035192] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  334.063977] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  334.142325] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  334.150288] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  334.364879] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  335.044439] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300

--Boundary-00=_IO0ZKhDEQBStq76--
