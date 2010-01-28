Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508Ab0A1UGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0A1UGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228Ab0A1UGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:06:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:40889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab0A1UGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:06:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="237965437"
Subject: Re: [BUG] tip tree - No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B6143C5.7060602@cn.fujitsu.com>
References: <4B6143C5.7060602@cn.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 28 Jan 2010 12:05:13 -0800
Message-Id: <1264709113.2849.14.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zefan,

I have posted a fix for this.

http://marc.info/?l=linux-kernel&m=126420641021426&w=2

Can you please check if this indeed fixes your issue?

thanks,
suresh

On Wed, 2010-01-27 at 23:59 -0800, Li Zefan wrote:
> After bootup, I can't use my keyboard and mouse.
> 
> Here's the full syslog:
> 
> Initializing cgroup subsys cpuset
> Initializing cgroup subsys cpu
> Linux version 2.6.33-rc5-tip+ (lizf@localhost.localdomain) (gcc version 4.4.0 20090506 (Red Hat 4.4.0-4) (GCC) ) #30 SMP Thu Jan 28 14:50:38 CST 2010
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003bff0000 (usable)
>  BIOS-e820: 000000003bff0000 - 000000003bff3000 (ACPI NVS)
>  BIOS-e820: 000000003bff3000 - 000000003c000000 (ACPI data)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
> DMI 2.3 present.
> Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> last_pfn = 0x3bff0 max_arch_pfn = 0x1000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-C7FFF write-protect
>   C8000-FFFFF uncachable
> MTRR variable ranges enabled:
>   0 base 000000000 mask FC0000000 write-back
>   1 base 03C000000 mask FFC000000 uncachable
>   2 base 0D0000000 mask FF8000000 write-combining
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> initial memory mapped : 0 - 01600000
> found SMP MP-table at [c00f5ad0] f5ad0
> init_memory_mapping: 0000000000000000-0000000037bfe000
>  0000000000 - 0000200000 page 4k
>  0000200000 - 0037a00000 page 2M
>  0037a00000 - 0037bfe000 page 4k
> kernel direct mapping tables up to 37bfe000 @ 15000-1a000
> RAMDISK: 37d1a000 - 37fef2e1
> Allocated new RAMDISK: 00100000 - 003d52e1
> Move RAMDISK from 0000000037d1a000 - 0000000037fef2e0 to 00100000 - 003d52e0
> ACPI: RSDP 000f7560 00014 (v00 AWARD )
> ACPI: RSDT 3bff3040 0002C (v01 AWARD  AWRDACPI 42302E31 AWRD 00000000)
> ACPI: FACP 3bff30c0 00074 (v01 AWARD  AWRDACPI 42302E31 AWRD 00000000)
> ACPI: DSDT 3bff3180 03ABC (v01 AWARD  AWRDACPI 00001000 MSFT 0100000E)
> ACPI: FACS 3bff0000 00040
> ACPI: APIC 3bff6c80 00084 (v01 AWARD  AWRDACPI 42302E31 AWRD 00000000)
> ACPI: Local APIC address 0xfee00000
> 67MB HIGHMEM available.
> 891MB LOWMEM available.
>   mapped low ram: 0 - 37bfe000
>   low ram: 0 - 37bfe000
>   node 0 low ram: 00000000 - 37bfe000
>   node 0 bootmap 00016000 - 0001cf80
> (14 early reservations) ==> bootmem [0000000000 - 0037bfe000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000400000 - 0001188a1c]    TEXT DATA BSS ==> [0000400000 - 0001188a1c]
>   #3 [0001189000 - 00011940ed]              BRK ==> [0001189000 - 00011940ed]
>   #4 [00000f5ae0 - 0000100000]    BIOS reserved ==> [00000f5ae0 - 0000100000]
>   #5 [00000f5ad0 - 00000f5ae0]     MP-table mpf ==> [00000f5ad0 - 00000f5ae0]
>   #6 [000009f400 - 00000f0c00]    BIOS reserved ==> [000009f400 - 00000f0c00]
>   #7 [00000f0d0c - 00000f5ad0]    BIOS reserved ==> [00000f0d0c - 00000f5ad0]
>   #8 [00000f0c00 - 00000f0d0c]     MP-table mpc ==> [00000f0c00 - 00000f0d0c]
>   #9 [0000010000 - 0000011000]       TRAMPOLINE ==> [0000010000 - 0000011000]
>   #10 [0000011000 - 0000015000]      ACPI WAKEUP ==> [0000011000 - 0000015000]
>   #11 [0000015000 - 0000016000]          PGTABLE ==> [0000015000 - 0000016000]
>   #12 [0000100000 - 00003d52e1]      NEW RAMDISK ==> [0000100000 - 00003d52e1]
>   #13 [0000016000 - 000001d000]          BOOTMAP ==> [0000016000 - 000001d000]
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x00037bfe
>   HighMem  0x00037bfe -> 0x0003bff0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x0003bff0
> On node 0 totalpages: 245631
> free_area_init_node: node 0, pgdat c09ef980, node_mem_map c1196200
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3951 pages, LIFO batch:0
>   Normal zone: 1752 pages used for memmap
>   Normal zone: 222502 pages, LIFO batch:31
>   HighMem zone: 136 pages used for memmap
>   HighMem zone: 17258 pages, LIFO batch:3
> Using APIC driver default
> ACPI: PM-Timer IO Port: 0x1008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Using ACPI (MADT) for SMP configuration information
> SMP: Allowing 4 CPUs, 2 hotplug CPUs
> nr_irqs_gsi: 24
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Allocating PCI resources starting at 3c000000 (gap: 3c000000:c2c00000)
> setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
> PERCPU: Embedded 334 pages/cpu @c1a00000 s1346324 r0 d21740 u2097152
> pcpu-alloc: s1346324 r0 d21740 u2097152 alloc=1*2097152
> pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243711
> Kernel command line: ro root=UUID=355bca51-980f-47e8-93ad-16ed4d633479 rhgb quiet ftrace=nop
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> allocated 4914560 bytes of page_cgroup
> please try 'cgroup_disable=memory' option if you don't want memory cgroups
> Initializing HighMem for node 0 (00037bfe:0003bff0)
> Memory: 946520k/982976k available (4141k kernel code, 35512k reserved, 2043k data, 1832k init, 69576k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff1b000 - 0xfffff000   ( 912 kB)
>     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
>     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
>       .init : 0xc0a0b000 - 0xc0bd5000   (1832 kB)
>       .data : 0xc080b5ff - 0xc0a0a458   (2043 kB)
>       .text : 0xc0400000 - 0xc080b5ff   (4141 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> Hierarchical RCU implementation.
> NR_IRQS:384
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     16384
> ... MAX_LOCKDEP_CHAINS:      32768
> ... CHAINHASH_SIZE:          16384
>  memory used by lock dependency info: 3823 kB
>  per task-struct memory footprint: 1920 bytes
> Fast TSC calibration using PIT
> Detected 2800.014 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.02 BogoMIPS (lpj=2800014)
> Mount-cache hash table entries: 512
> Initializing cgroup subsys debug
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys memory
> Initializing cgroup subsys devices
> Initializing cgroup subsys freezer
> Initializing cgroup subsys net_cls
> Initializing cgroup subsys blkio
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> mce: CPU supports 4 MCE banks
> CPU0: Thermal monitoring enabled (TM1)
> using mwait in idle threads.
> Performance Events: no PMU driver, software events only.
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20091214
> ftrace: converting mcount calls to 0f 1f 44 00 00
> ftrace: allocating 17486 entries in 35 pages
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Pentium(R) D CPU 2.80GHz stepping 04
> Testing tracer nop: PASSED
> Starting tracer 'nop'
> Disabling FTRACE selftests due to running tracer 'nop'
> lockdep: fixing up alternatives.
> Booting Node   0, Processors  #1
> Initializing CPU#1
> do_IRQ: 1.48 No irq handler for vector (irq -1)
> Brought up 2 CPUs
> Total of 2 processors activated (11199.29 BogoMIPS).
> Time:  7:41:58  Date: 01/28/10
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfbda0, last bus=1
> PCI: Using configuration type 1 for base access
> mtrr: your CPUs had inconsistent fixed MTRR settings
> mtrr: probably your BIOS does not setup all CPUs.
> mtrr: corrected configuration.
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: No dock devices found.
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
> pci_root PNP0A03:00: host bridge window [io  0x0000-0x047f] (ignored)
> pci_root PNP0A03:00: host bridge window [io  0x0490-0x0cf7] (ignored)
> pci_root PNP0A03:00: host bridge window [io  0x0d00-0x0fff] (ignored)
> pci_root PNP0A03:00: host bridge window [io  0x1100-0xffff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x3c000000-0xfebfffff] (ignored)
> pci 0000:00:00.0: reg 10: [mem 0xd0000000-0xd7ffffff]
> pci 0000:00:02.5: reg 10: [io  0x01f0-0x01f7]
> pci 0000:00:02.5: reg 14: [io  0x03f4-0x03f7]
> pci 0000:00:02.5: reg 18: [io  0x0170-0x0177]
> pci 0000:00:02.5: reg 1c: [io  0x0374-0x0377]
> pci 0000:00:02.5: reg 20: [io  0x4000-0x400f]
> pci 0000:00:02.5: PME# supported from D3cold
> pci 0000:00:02.5: PME# disabled
> pci 0000:00:02.7: reg 10: [io  0xd000-0xd0ff]
> pci 0000:00:02.7: reg 14: [io  0xd400-0xd47f]
> pci 0000:00:02.7: supports D1 D2
> pci 0000:00:02.7: PME# supported from D3hot D3cold
> pci 0000:00:02.7: PME# disabled
> pci 0000:00:03.0: reg 10: [mem 0xe1104000-0xe1104fff]
> pci 0000:00:03.1: reg 10: [mem 0xe1100000-0xe1100fff]
> pci 0000:00:03.2: reg 10: [mem 0xe1101000-0xe1101fff]
> pci 0000:00:03.3: reg 10: [mem 0xe1102000-0xe1102fff]
> pci 0000:00:03.3: PME# supported from D0 D3hot D3cold
> pci 0000:00:03.3: PME# disabled
> pci 0000:00:05.0: reg 10: [io  0xd800-0xd807]
> pci 0000:00:05.0: reg 14: [io  0xdc00-0xdc03]
> pci 0000:00:05.0: reg 18: [io  0xe000-0xe007]
> pci 0000:00:05.0: reg 1c: [io  0xe400-0xe403]
> pci 0000:00:05.0: reg 20: [io  0xe800-0xe80f]
> pci 0000:00:05.0: PME# supported from D3cold
> pci 0000:00:05.0: PME# disabled
> pci 0000:00:0e.0: reg 10: [io  0xec00-0xecff]
> pci 0000:00:0e.0: reg 14: [mem 0xe1103000-0xe11030ff]
> pci 0000:00:0e.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> pci 0000:00:0e.0: supports D1 D2
> pci 0000:00:0e.0: PME# supported from D1 D2 D3hot D3cold
> pci 0000:00:0e.0: PME# disabled
> pci 0000:01:00.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
> pci 0000:01:00.0: reg 14: [mem 0xe1000000-0xe101ffff]
> pci 0000:01:00.0: reg 18: [io  0xc000-0xc07f]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:01.0:   bridge window [mem 0xe1000000-0xe10fffff]
> pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
> do_IRQ: 1.58 No irq handler for vector (irq -1)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 14 15)
> do_IRQ: 1.59 No irq handler for vector (irq -1)
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 *6 7 9 10 11 14 15)
> do_IRQ: 1.54 No irq handler for vector (irq -1)
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 14 15)
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 14 15)
> do_IRQ: 1.53 No irq handler for vector (irq -1)
> vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 64 bytes
> Switching to clocksource tsc
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 12 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> system 00:00: [mem 0x000f0000-0x000f7fff] could not be reserved
> system 00:00: [mem 0x000f8000-0x000fbfff] could not be reserved
> system 00:00: [mem 0x000fc000-0x000fffff] could not be reserved
> system 00:00: [mem 0x3bff0000-0x3bffffff] could not be reserved
> system 00:00: [mem 0xffff0000-0xffffffff] has been reserved
> system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> system 00:00: [mem 0x00100000-0x3bfeffff] could not be reserved
> system 00:00: [mem 0xffee0000-0xffefffff] has been reserved
> system 00:00: [mem 0xfffe0000-0xfffeffff] has been reserved
> system 00:00: [mem 0xfec00000-0xfecfffff] could not be reserved
> system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
> system 00:02: [io  0x04d0-0x04d1] has been reserved
> system 00:02: [io  0x0800-0x0805] has been reserved
> system 00:02: [io  0x0290-0x0297] has been reserved
> system 00:02: [io  0x0880-0x088f] has been reserved
> pci 0000:00:0e.0: BAR 6: assigned [mem 0x3c000000-0x3c01ffff pref]
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:01.0:   bridge window [mem 0xe1000000-0xe10fffff]
> pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
> pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
> pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
> pci_bus 0000:01: resource 1 [mem 0xe1000000-0xe10fffff]
> pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> UDP hash table entries: 512 (order: 3, 49152 bytes)
> UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
> NET: Registered protocol family 1
> pci 0000:01:00.0: Boot video device
> PCI: CLS 32 bytes, default 64
> Trying to unpack rootfs image as initramfs...
> Freeing initrd memory: 2900k freed
> apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
> apm: disabled - APM is not SMP safe.
> highmem bounce pool size: 64 pages
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> msgmni has been set to 1719
> alg: No test for stdrng (krng)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> pci-stub: invalid id string ""
> input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> ACPI: Power Button [PWRB]
> input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
> ACPI: Sleep Button [FUTS]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> ACPI: Power Button [PWRF]
> ACPI: Fan [FAN] (on)
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> agpgart-sis 0000:00:00.0: SiS chipset [1039/0661]
> agpgart-sis 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> do_IRQ: 1.52 No irq handler for vector (irq -1)
> do_IRQ: 1.52 No irq handler for vector (irq -1)
> serial8250: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A
> do_IRQ: 1.51 No irq handler for vector (irq -1)
> do_IRQ: 1.51 No irq handler for vector (irq -1)
> serial8250: ttyS1 at I/O 0x2f8 (irq = 0) is a 16550A
> 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> brd: module loaded
> loop: module loaded
> Fixed MDIO Bus: probed
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci_hcd 0000:00:03.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> ehci_hcd 0000:00:03.3: EHCI Host Controller
> ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:03.3: irq 23, io mem 0xe1102000
> ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.33-rc5-tip+ ehci_hcd
> usb usb1: SerialNumber: 0000:00:03.3
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 8 ports detected
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci_hcd 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> ohci_hcd 0000:00:03.0: OHCI Host Controller
> ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:03.0: irq 20, io mem 0xe1104000
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: OHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.33-rc5-tip+ ohci_hcd
> usb usb2: SerialNumber: 0000:00:03.0
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 3 ports detected
> ohci_hcd 0000:00:03.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> ohci_hcd 0000:00:03.1: OHCI Host Controller
> ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
> ohci_hcd 0000:00:03.1: irq 21, io mem 0xe1100000
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: OHCI Host Controller
> usb usb3: Manufacturer: Linux 2.6.33-rc5-tip+ ohci_hcd
> usb usb3: SerialNumber: 0000:00:03.1
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 3 ports detected
> ohci_hcd 0000:00:03.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> ohci_hcd 0000:00:03.2: OHCI Host Controller
> ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
> ohci_hcd 0000:00:03.2: irq 22, io mem 0xe1101000
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: OHCI Host Controller
> usb usb4: Manufacturer: Linux 2.6.33-rc5-tip+ ohci_hcd
> usb usb4: SerialNumber: 0000:00:03.2
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> uhci_hcd: USB Universal Host Controller Interface driver
> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> do_IRQ: 1.60 No irq handler for vector (irq -1)
> serio: i8042 KBD port at 0x60,0x64 irq 1
> mice: PS/2 mouse device common for all mice
> rtc_cmos 00:04: RTC can wake from S4
> rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one year, 242 bytes nvram
> device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
> cpuidle: using governor ladder
> cpuidle: using governor menu
> nf_conntrack version 0.5.0 (14842 buckets, 59368 max)
> CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
> sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> Using IPI No-Shortcut mode
> PM: Resume from disk failed.
> registered taskstats version 1
> Testing kprobe tracing: OK
> kmemleak: Kernel memory leak detector initialized
> kmemleak: Automatic memory scanning thread started
>   Magic number: 10:944:673
> Initalizing network drop monitor service
> Freeing unused kernel memory: 1832k freed
> Write protecting the kernel text: 4144k
> Write protecting the kernel read-only data: 1572k
> pata_sis 0000:00:02.5: version 0.5.2
> pata_sis 0000:00:02.5: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> scsi0 : pata_sis
> scsi1 : pata_sis
> ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x4000 irq 14
> ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x4008 irq 15
> sata_sis 0000:00:05.0: version 1.0
> sata_sis 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> sata_sis 0000:00:05.0: Detected SiS 180/181/964 chipset in SATA mode
> scsi2 : sata_sis
> scsi3 : sata_sis
> ata3: SATA max UDMA/133 cmd 0xd800 ctl 0xdc00 bmdma 0xe800 irq 17
> ata4: SATA max UDMA/133 cmd 0xe000 ctl 0xe400 bmdma 0xe808 irq 17
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3.00: ATA-7: ST3808110AS, 3.AAE, max UDMA/133
> ata3.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata3.00: configured for UDMA/133
> scsi 2:0:0:0: Direct-Access     ATA      ST3808110AS      3.AA PQ: 0 ANSI: 5
> sd 2:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
> sd 2:0:0:0: [sda] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg0 type 0
> ata4: SATA link down (SStatus 0 SControl 300)
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (sda5): mounted filesystem with writeback data mode
> udev: starting version 141
> parport_pc 00:09: reported by Plug and Play ACPI
> parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
> input: PC Speaker as /devices/platform/pcspkr/input/input3
> r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> r8169 0000:00:0e.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> r8169 0000:00:0e.0: no PCI Express capability
> eth0: RTL8110s at 0xf862a000, 00:16:ec:2e:b7:e0, XID 04000000 IRQ 18
> do_IRQ: 3 callbacks suppressed
> do_IRQ: 1.56 No irq handler for vector (irq -1)
> ppdev: user-space parallel port driver
> md: md0 stopped.
> md: bind<sda6>
> md: linear personality registered for level -1
> md0: detected capacity change from 0 to 15726608384
>  md0: unknown partition table
> device-mapper: multipath: version 1.1.1 loaded
> EXT3-fs (sda5): using internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (sda7): using internal journal
> EXT3-fs (sda7): mounted filesystem with writeback data mode
> Adding 1048564k swap on /dev/sda8.  Priority:-1 extents:1 across:1048564k
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ip6_tables: (C) 2000-2006 Netfilter Core Team
> r8169: eth0: link up
> r8169: eth0: link up
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> do_IRQ: 1.52 No irq handler for vector (irq -1)
> do_IRQ: 1.52 No irq handler for vector (irq -1)
> do_IRQ: 1.51 No irq handler for vector (irq -1)
> do_IRQ: 1.51 No irq handler for vector (irq -1)
> eth0: no IPv6 routers present
> 

