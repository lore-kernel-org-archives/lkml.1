Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYHYVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYHYVnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYHYVn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:43:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYHYVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:43:24 -0400
Date: Mon, 25 Aug 2008 11:43:19 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080825214319.GC12156@hoblitt.com>
References: <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com> <20080822002952.GG23377@hoblitt.com> <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20080822035609.GD30284@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I repulled/rebuilding the tip tree this morning.  I can confirm that the
show_msr patch is working and mtrr masking patch is now only printing a
single warning in the dmesg.  The dmesg is attached.

As per usual, the kernel folks provide the best support of any software
in history.  Thanks guys!

-J

--
On Fri, Aug 22, 2008 at 05:56:09AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i've tidied up your patch (see the commit below) and have queued it up 
> > in x86/urgent. It seems fairly safe and i guess we can push it to 
> > v2.6.27 if Joshua reports test success. Joshua, could you give it a go 
> > please?
> 
> or just try the latest tip/master - please check whether you are getting 
> the right amount of RAM out of box plus this warning message:
> 
> > WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
> 
> 	Ingo

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.27-rc4-tip-00345-g8c8b7ed.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-rc4-tip-00345-g8c8b7ed (root@ipp000) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #1 SMP Mon Aug 25 10:36:23 HST 2008
[    0.000000] Command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc show_msr=1 console=tty0 console=ttyS0,115200n8 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff00000 (usable)
[    0.000000]  BIOS-e820: 00000000cff00000 - 00000000cff0a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff0a000 - 00000000cff0b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff0b000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000430000000 (usable)
[    0.000000] last_pfn = 0x430000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] last_pfn = 0xcff00 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff00000 page 4k
[    0.000000] kernel direct mapping tables up to cff00000 @ 8000-e000
[    0.000000] last_map_addr: cff00000 end: cff00000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 0430000000 page 2M
[    0.000000] kernel direct mapping tables up to 430000000 @ c000-1e000
[    0.000000] last_map_addr: 430000000 end: 430000000
[    0.000000] RAMDISK: 37e10000 - 37fef782
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F7020, 0024 (r2 PTLTD )
[    0.000000] ACPI: XSDT CFF0395D, 005C (r1 PTLTD  	 XSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP CFF09D60, 00F4 (r3 INTEL  TUMWATER  6040000 PTL         3)
[    0.000000] ACPI: DSDT CFF0599D, 434F (r1  Intel SEABURG   6040000 MSFT  3000000)
[    0.000000] ACPI: FACS CFF0AFC0, 0040
[    0.000000] ACPI: _MAR CFF09E54, 0030 (r1 Intel  OEMDMAR   6040000 LOHR        1)
[    0.000000] ACPI: APIC CFF09E84, 00C8 (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: MCFG CFF09F4C, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
[    0.000000] ACPI: BOOT CFF09F88, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: SPCR CFF09FB0, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
[    0.000000] ACPI: SSDT CFF039B9, 1405 (r1  PmRef    CpuPm     3000 INTL 20050228)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000430000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000430000000
[    0.000000]   NODE_DATA [0000000000019000 - 0000000000023fff]
[    0.000000]   bootmap [0000000000100000 -  0000000000185fff] pages 86
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0430000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00009bfef0]    TEXT DATA BSS ==> [0000200000 - 00009bfef0]
[    0.000000]   #3 [0037e10000 - 0037fef782]          RAMDISK ==> [0037e10000 - 0037fef782]
[    0.000000]   #4 [000009e400 - 0000100000]    BIOS reserved ==> [000009e400 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #6 [000000c000 - 0000019000]          PGTABLE ==> [000000c000 - 0000019000]
[    0.000000] found SMP MP-table at [ffff8800000f7050] 000f7050
[    0.000000]  [ffffe20000000000-ffffe200107fffff] PMD -> [ffff880028200000-ffff880037dfffff] on node 0
[    0.000000]  [ffffe20010800000-ffffe20010bfffff] PMD -> [ffff880038000000-ffff8800383fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00430000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff00
[    0.000000]     0: 0x00100000 -> 0x00430000
[    0.000000] On node 0 totalpages: 4193950
[    0.000000]   DMA zone: 1832 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 831296 pages, LIFO batch:31
[    0.000000]   Normal zone: 3290112 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xfec88000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ca000
[    0.000000] PM: Registered nosave memory: 00000000000ca000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000cff0a000
[    0.000000] PM: Registered nosave memory: 00000000cff0a000 - 00000000cff0b000
[    0.000000] PM: Registered nosave memory: 00000000cff0b000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] dyn_array irq_2_pin_head+0x0/0x418 size:0x10 nr:256 align:0x1000
[    0.000000] dyn_array irq_cfgx+0x0/0x8 size:0x30 nr:32 align:0x1000
[    0.000000] dyn_array sparse_irqs+0x0/0x8 size:0x100 nr:32 align:0x1000
[    0.000000] dyn_array total_size: 0x4000
[    0.000000] dyn_array irq_2_pin_head+0x0/0x418  ==> [0x28034000 - 0x28035000]
[    0.000000] dyn_array irq_cfgx+0x0/0x8  ==> [0x28035000 - 0x28035600]
[    0.000000] dyn_array sparse_irqs+0x0/0x8  ==> [0x28036000 - 0x28038000]
[    0.000000] kstat_irqs ==> [0x28038000 - 0x28038400]
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] per cpu data for cpu0 on node0 at 0000000028039000
[    0.000000] per cpu data for cpu1 on node0 at 0000000028045000
[    0.000000] per cpu data for cpu2 on node0 at 0000000028051000
[    0.000000] per cpu data for cpu3 on node0 at 000000002805d000
[    0.000000] per cpu data for cpu4 on node0 at 0000000028069000
[    0.000000] per cpu data for cpu5 on node0 at 0000000028075000
[    0.000000] per cpu data for cpu6 on node0 at 0000000028081000
[    0.000000] per cpu data for cpu7 on node0 at 000000002808d000
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 8, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4123240
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc show_msr=1 console=tty0 console=ttyS0,115200n8 
[    0.000000] Initializing CPU#0
[    0.000000] found new irq_desc for irq 0
[    0.000000] found new irq_desc for irq 1
[    0.000000] found new irq_desc for irq 2
[    0.000000] found new irq_desc for irq 3
[    0.000000] found new irq_desc for irq 4
[    0.000000] found new irq_desc for irq 5
[    0.000000] found new irq_desc for irq 6
[    0.000000] found new irq_desc for irq 7
[    0.000000] found new irq_desc for irq 8
[    0.000000] found new irq_desc for irq 9
[    0.000000] found new irq_desc for irq 10
[    0.000000] found new irq_desc for irq 11
[    0.000000] found new irq_desc for irq 12
[    0.000000] found new irq_desc for irq 13
[    0.000000] found new irq_desc for irq 14
[    0.000000] found new irq_desc for irq 15
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 3192.010 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.003333] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.003333] Memory: 16436776k/17563648k available (3831k kernel code, 339024k reserved, 2175k data, 676k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.003341] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.02 BogoMIPS (lpj=10640033)
[    0.010017] Security Framework initialized
[    0.016879] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.027256] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.034238] Mount-cache hash table entries: 256
[    0.036819] Initializing cgroup subsys ns
[    0.040003] Initializing cgroup subsys cpuacct
[    0.043333] Initializing cgroup subsys memory
[    0.046668] Initializing cgroup subsys devices
[    0.050006] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.055184] CPU: L2 cache: 6144K
[    0.056665] CPU 0/0 -> Node 0
[    0.059998] CPU: Physical Processor ID: 0
[    0.063330] CPU: Processor Core ID: 0
[    0.066667] CPU0: Thermal monitoring enabled (TM2)
[    0.069997] using mwait in idle threads.
[    0.073345] ACPI: Core revision 20080609
[    0.083380] Setting APIC routing to flat
[    0.090076]  0 add_pin_to_irq: irq 1 --> apic 0 pin 1
[    0.090081]  0 add_pin_to_irq: irq 0 --> apic 0 pin 2
[    0.090083]  0 add_pin_to_irq: irq 3 --> apic 0 pin 3
[    0.090086]  0 add_pin_to_irq: irq 4 --> apic 0 pin 4
[    0.090089]  0 add_pin_to_irq: irq 5 --> apic 0 pin 5
[    0.090091]  0 add_pin_to_irq: irq 6 --> apic 0 pin 6
[    0.090093]  0 add_pin_to_irq: irq 7 --> apic 0 pin 7
[    0.090096]  0 add_pin_to_irq: irq 8 --> apic 0 pin 8
[    0.090098]  0 add_pin_to_irq: irq 9 --> apic 0 pin 9
[    0.090101]  0 add_pin_to_irq: irq 10 --> apic 0 pin 10
[    0.090104]  0 add_pin_to_irq: irq 11 --> apic 0 pin 11
[    0.090106]  0 add_pin_to_irq: irq 12 --> apic 0 pin 12
[    0.090109]  0 add_pin_to_irq: irq 13 --> apic 0 pin 13
[    0.090111]  0 add_pin_to_irq: irq 14 --> apic 0 pin 14
[    0.090114]  0 add_pin_to_irq: irq 15 --> apic 0 pin 15
[    0.090247] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.129455] CPU0: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.136658]  MSR00000000: 00000000cff69380
[    0.139991]  MSR00000001: 0000000000000000
[    0.143327]  MSR00000006: 0000000000000040
[    0.146661]  MSR00000010: 00000041ff91fb10
[    0.149993]  MSR00000017: 0018000088e40822
[    0.153325]  MSR0000001b: 00000000fee00900
[    0.156659]  MSR00000021: 0000000000000001
[    0.159993]  MSR0000002a: 00000000c208149e
[    0.163326]  MSR00000032: 0000000000000000
[    0.166656]  MSR00000033: 0000000000000000
[    0.169991]  MSR00000039: 0000000000000000
[    0.173322]  MSR0000003a: 000000000000000d
[    0.176657]  MSR0000003f: 0000000000000000
[    0.179989]  MSR00000040: ffffffff805af2f3
[    0.183322]  MSR00000041: ffffffff8020c348
[    0.186655]  MSR00000042: ffffffff802380fc
[    0.189988]  MSR00000043: ffffffff8020c348
[    0.193332]  MSR00000060: ffffffff805af2cc
[    0.196654]  MSR00000061: ffffffff802380eb
[    0.199987]  MSR00000062: ffffffff805af2c1
[    0.203320]  MSR00000063: ffffffff802380eb
[    0.206668]  MSR0000008b: 0000060600000000
[    0.209992]  MSR0000009b: 0000000000000000
[    0.213321]  MSR000000a0: 00000000cff80000
[    0.216653]  MSR000000a1: 00000000fff80800
[    0.219989]  MSR000000a8: 000000000000061a
[    0.223319]  MSR000000a9: 000000000000061a
[    0.226652]  MSR000000aa: 000000000000061a
[    0.229985]  MSR000000ab: 000000000000061a
[    0.233318]  MSR000000ac: 000000000000061a
[    0.236652]  MSR000000ad: 000000000000061a
[    0.239992]  MSR000000c1: 0000000000000000
[    0.243318]  MSR000000c2: 0000000000000000
[    0.246653]  MSR000000c7: 130000004c000000
[    0.249986]  MSR000000cd: 0000000000000806
[    0.253317]  MSR000000ce: 001a08227f7f071a
[    0.256650]  MSR000000cf: 0000000000000000
[    0.259990]  MSR000000e0: 00000000018bc0f0
[    0.263316]  MSR000000e1: 00000000f0f00000
[    0.266650]  MSR000000e2: 0000000002262201
[    0.269983]  MSR000000e3: 0000000000000000
[    0.273316]  MSR000000e4: 0000000000000000
[    0.276649]  MSR000000e5: 00000000d00208c8
[    0.279982]  MSR000000e7: 000000421f188350
[    0.283315]  MSR000000e8: 000000421fe966d0
[    0.286650]  MSR000000ee: 04000000877d4b01
[    0.289987]  MSR000000fe: 0000000000000d07
[    0.293323]  MSR00000116: 0000000000003fc0
[    0.296648]  MSR00000118: 00000000000bfffd
[    0.299982]  MSR0000011b: 0000000000000000
[    0.303314]  MSR0000011c: 00000000e000000c
[    0.306647]  MSR0000011e: 00000000be702111
[    0.309998]  MSR0000014e: 000000006fe76e2f
[    0.313313]  MSR0000014f: 00000000f7bef7ff
[    0.316647]  MSR00000151: 00000000ad123a00
[    0.319984]  MSR0000015e: 0000000000000006
[    0.323313]  MSR0000015f: 00000000001c0822
[    0.326653]  MSR00000174: 0000000000000010
[    0.329979]  MSR00000175: 0000000000000000
[    0.333312]  MSR00000176: ffffffff80228960
[    0.336646]  MSR00000179: 0000000000000806
[    0.339978]  MSR0000017a: 0000000000000000
[    0.343315]  MSR00000186: 0000000000000000
[    0.346644]  MSR00000187: 0000000000000000
[    0.349982]  MSR00000193: 0000000000000000
[    0.353311]  MSR00000194: 0000000000000522
[    0.356645]  MSR00000198: 0822082206000822
[    0.359977]  MSR00000199: 0000000000000822
[    0.363310]  MSR0000019a: 0000000000000002
[    0.366643]  MSR0000019b: 0000000000000003
[    0.369976]  MSR0000019c: 00000000882a0000
[    0.373309]  MSR0000019d: 000000000000061a
[    0.376642]  MSR0000019e: 0000000006010000
[    0.379976]  MSR0000019f: 0000000000000000
[    0.383309]  MSR000001a0: 00000060669d2489
[    0.386642]  MSR000001a1: 0000000000000000
[    0.389975]  MSR000001a2: 0000000000001000
[    0.393311]  MSR000001aa: 00000000fe7f042f
[    0.396649]  MSR000001bf: 0000000000000404
[    0.399978]  MSR000001c9: 0000000000000002
[    0.403311]  MSR000001d3: 0000000000008000
[    0.406642]  MSR000001d9: 0000000000000001
[    0.409974]  MSR000001db: ffffffff805af2f3
[    0.413307]  MSR000001dc: ffffffff805af2c1
[    0.416640]  MSR000001dd: ffffffff802380ca
[    0.419973]  MSR000001de: ffffffff802380e6
[    0.423306]  MSR000001e0: 0000000000000ff0
[    0.426648]  MSR000001f8: 0000000000000001
[    0.429972]  MSR000001f9: 0000000000000001
[    0.433305]  MSR000001fa: 0000000000008c89
[    0.436640]  MSR00000200: 00000000d0000000
[    0.439972]  MSR00000201: 0000000ff0000800
[    0.443305]  MSR00000202: 00000000e0000000
[    0.446638]  MSR00000203: 0000000fe0000800
[    0.449971]  MSR00000204: 0000000000000006
[    0.453304]  MSR00000205: 0000000c00000800
[    0.456637]  MSR00000206: 0000000400000006
[    0.459970]  MSR00000207: 0000000fe0000800
[    0.463303]  MSR00000208: 0000000420000006
[    0.466637]  MSR00000209: 0000000ff0000800
[    0.469970]  MSR0000020a: 0000000000000000
[    0.473303]  MSR0000020b: 0000000000000000
[    0.476636]  MSR0000020c: 0000000000000000
[    0.479969]  MSR0000020d: 0000000000000000
[    0.483328]  MSR00000250: 0606060606060606
[    0.486638]  MSR00000258: 0606060606060606
[    0.489968]  MSR00000259: 0000000000000000
[    0.493307]  MSR00000268: 0505050505050505
[    0.496635]  MSR00000269: 0505050505050505
[    0.499968]  MSR0000026a: 0000000000000000
[    0.503301]  MSR0000026b: 0000000000000000
[    0.506634]  MSR0000026c: 0505050505050505
[    0.509968]  MSR0000026d: 0505050505050505
[    0.513301]  MSR0000026e: 0505050505050505
[    0.516634]  MSR0000026f: 0505050505050505
[    0.519970]  MSR00000277: 0007010600070106
[    0.523353]  MSR000002ff: 0000000000000c00
[    0.526638]  MSR00000309: 0000000000000000
[    0.529968]  MSR0000030a: 0000000000000000
[    0.533301]  MSR0000030b: 0000000000000000
[    0.536656]  MSR00000345: 00000000000010c2
[    0.539995]  MSR0000038d: 0000000000000000
[    0.543301]  MSR0000038e: 0000000000000000
[    0.546634]  MSR0000038f: ffffffffffffffff
[    0.549968]  MSR00000390: ffffffffffffffff
[    0.553338]  MSR000003f1: 0000000000000000
[    0.556640]  MSR00000400: 00000000c208149e
[    0.559968]  MSR00000401: 1000000000000000
[    0.563301]  MSR00000402: 0000000000000000
[    0.566635]  MSR00000404: 0000000000000001
[    0.569968]  MSR00000405: 0000000000000000
[    0.573301]  MSR00000406: 000002a9000002a9
[    0.576635]  MSR00000408: 0000000000000001
[    0.579968]  MSR00000409: 0000000000000000
[    0.583301]  MSR0000040a: 000002a9000002a9
[    0.586635]  MSR0000040c: 0000000000000001
[    0.589968]  MSR0000040d: 0020000000000000
[    0.593301]  MSR0000040e: 00000080608ad188
[    0.596635]  MSR00000410: 0000000000000008
[    0.599968]  MSR00000411: 0000000000000011
[    0.603302]  MSR00000414: 0000000000000001
[    0.606634]  MSR00000415: 1000001004000e0f
[    0.610018]  MSRc0000080: 0000000000000d01
[    0.613301]  MSRc0000081: 0023001000000000
[    0.616634]  MSRc0000082: ffffffff8020bce0
[    0.619968]  MSRc0000083: ffffffff80228b70
[    0.623301]  MSRc0000084: 0000000000003700
[    0.626681]  MSRc0000100: 0000000000000000
[    0.629968]  MSRc0000101: ffffffff807e6c00
[    0.633301]  MSRc0000102: 0000000000000000
[    0.643300] Booting processor 1/4 ip 6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6386.64 BogoMIPS (lpj=10639430)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 1/4 -> Node 0
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] CPU1: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.738103] CPU1: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.744732] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.746689] Booting processor 2/1 ip 6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 6386.61 BogoMIPS (lpj=10639385)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 2/1 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] CPU2: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.844800] CPU2: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.851400] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.853400] Booting processor 3/5 ip 6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 6386.62 BogoMIPS (lpj=10639401)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 3/5 -> Node 0
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] CPU3: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.951441] CPU3: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.958064] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.960026] Booting processor 4/2 ip 6000
[    0.003333] Initializing CPU#4
[    0.003333] Calibrating delay using timer specific routine.. 6386.60 BogoMIPS (lpj=10639363)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 4/2 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] CPU4: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    1.058128] CPU4: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    1.064733] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    1.066687] Booting processor 5/6 ip 6000
[    0.003333] Initializing CPU#5
[    0.003333] Calibrating delay using timer specific routine.. 6386.60 BogoMIPS (lpj=10639368)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 5/6 -> Node 0
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] CPU5: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    1.164844] CPU5: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    1.171401] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    1.173351] Booting processor 6/3 ip 6000
[    0.003333] Initializing CPU#6
[    0.003333] Calibrating delay using timer specific routine.. 6386.61 BogoMIPS (lpj=10639379)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 6/3 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] CPU6: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    1.271472] CPU6: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    1.279979] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    1.286686] Booting processor 7/7 ip 6000
[    0.003333] Initializing CPU#7
[    0.003333] Calibrating delay using timer specific routine.. 6386.62 BogoMIPS (lpj=10639406)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 6144K
[    0.003333] CPU 7/7 -> Node 0
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] CPU7: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    1.384776] CPU7: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    1.391399] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    1.393308] Brought up 8 CPUs
[    1.396635] Total of 8 processors activated (51089.35 BogoMIPS).
[    1.400602] net_namespace: 864 bytes
[    1.403457] xor: automatically using best checksumming function: generic_sse
[    1.423301]    generic_sse: 11871.600 MB/sec
[    1.426634] xor: using function: generic_sse (11871.600 MB/sec)
[    1.429997] NET: Registered protocol family 16
[    1.433531] No dock devices found.
[    1.436849] ACPI: bus type pci registered
[    1.440110] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 8
[    1.443302] PCI: MCFG area at e0000000 reserved in E820
[    1.446821] PCI: Using MMCONFIG at e0000000 - e08fffff
[    1.449968] PCI: Using configuration type 1 for base access
[    1.458449] ACPI: EC: Look up EC in DSDT
[    1.460268] ACPI: Interpreter enabled
[    1.463302] ACPI: (supports S0 S3 S4 S5)
[    1.468074] ACPI: Using IOAPIC for interrupt routing
[    1.475012] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.476744] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.479969] pci 0000:00:00.0: PME# disabled
[    1.483323] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.486635] pci 0000:00:01.0: PME# disabled
[    1.489991] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.493302] pci 0000:00:05.0: PME# disabled
[    1.496658] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.499969] pci 0000:00:09.0: PME# disabled
[    1.503525] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.506636] pci 0000:00:1b.0: PME# disabled
[    1.510005] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.513303] pci 0000:00:1c.0: PME# disabled
[    1.516837] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.519970] pci 0000:00:1d.7: PME# disabled
[    1.523376] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.523526] pci 0000:01:00.0: supports D1
[    1.523550] PCI: bridge 0000:00:01.0 32bit mmio: [dc100000, dc1fffff]
[    1.526695] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.529969] pci 0000:03:00.0: PME# disabled
[    1.533335] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    1.536636] pci 0000:03:00.3: PME# disabled
[    1.539993] PCI: bridge 0000:00:09.0 io port: [2000, 2fff]
[    1.543302] PCI: bridge 0000:00:09.0 32bit mmio: [dc200000, dc3fffff]
[    1.546674] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.549969] pci 0000:04:00.0: PME# disabled
[    1.553333] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
[    1.556636] pci 0000:04:02.0: PME# disabled
[    1.559987] PCI: bridge 0000:03:00.0 io port: [2000, 2fff]
[    1.563302] PCI: bridge 0000:03:00.0 32bit mmio: [dc200000, dc2fffff]
[    1.566736] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.569970] pci 0000:06:00.0: PME# disabled
[    1.573370] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    1.576636] pci 0000:06:00.1: PME# disabled
[    1.579995] PCI: bridge 0000:04:02.0 io port: [2000, 2fff]
[    1.583302] PCI: bridge 0000:04:02.0 32bit mmio: [dc200000, dc2fffff]
[    1.586779] pci 0000:09:05.0: supports D1
[    1.586780] pci 0000:09:05.0: supports D2
[    1.586839] pci 0000:09:06.0: supports D2
[    1.586840] pci 0000:09:06.0: PME# supported from D2 D3hot D3cold
[    1.589970] pci 0000:09:06.0: PME# disabled
[    1.593327] pci 0000:00:1e.0: transparent bridge
[    1.596644] PCI: bridge 0000:00:1e.0 io port: [3000, 3fff]
[    1.599969] PCI: bridge 0000:00:1e.0 32bit mmio: [dc000000, dc0fffff]
[    1.603304] PCI: bridge 0000:00:1e.0 64bit mmio pref: [d8000000, dbffffff]
[    1.606649] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.607085] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.607173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    1.607254] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.609973] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0._PRT]
[    1.610147] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD0._PRT]
[    1.610229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD2._PRT]
[    1.610311] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMF3._PRT]
[    1.610438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.610530] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.619795] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.623888] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.631510] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.639519] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.643883] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15)
[    1.651512] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15)
[    1.659053] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
[    1.663358] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *9
[    1.671379] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.673363] pnp: PnP ACPI init
[    1.676638] ACPI: bus type pnp registered
[    1.684675] pnp: PnP ACPI: found 11 devices
[    1.686635] ACPI: ACPI bus type pnp unregistered
[    1.690226] SCSI subsystem initialized
[    1.693560] libata version 3.00 loaded.
[    1.693878] usbcore: registered new interface driver usbfs
[    1.696702] usbcore: registered new interface driver hub
[    1.700059] usbcore: registered new device driver usb
[    1.703709] PCI: Using ACPI for IRQ routing
[    1.723323] PCI-GART: No AMD northbridge found.
[    1.726732] hpet clockevent registered
[    1.726735] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.733301] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.739991] ACPI: RTC can wake from S4
[    1.752137] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    1.758702] system 00:01: ioport range 0x800-0x80f has been reserved
[    1.765260] system 00:01: ioport range 0x1000-0x107f has been reserved
[    1.771994] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    1.778731] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    1.785460] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    1.793294] system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    1.801126] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.808961] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.816288] system 00:01: iomem range 0xfec88000-0xfec88fff has been reserved
[    1.823621] system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
[    1.830953] system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
[    1.839316] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.845445] pci 0000:00:01.0:   IO window: disabled
[    1.850520] pci 0000:00:01.0:   MEM window: 0xdc100000-0xdc1fffff
[    1.856816] pci 0000:00:01.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    1.864732] pci 0000:00:05.0: PCI bridge, secondary bus 0000:02
[    1.870855] pci 0000:00:05.0:   IO window: disabled
[    1.875931] pci 0000:00:05.0:   MEM window: disabled
[    1.881096] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.886696] pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
[    1.892815] pci 0000:04:00.0:   IO window: disabled
[    1.897892] pci 0000:04:00.0:   MEM window: disabled
[    1.903058] pci 0000:04:00.0:   PREFETCH window: disabled
[    1.908667] pci 0000:04:02.0: PCI bridge, secondary bus 0000:06
[    1.914787] pci 0000:04:02.0:   IO window: 0x2000-0x2fff
[    1.920296] pci 0000:04:02.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.926590] pci 0000:04:02.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.934508] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    1.941128] pci 0000:03:00.0:   IO window: 0x2000-0x2fff
[    1.946634] pci 0000:03:00.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.952928] pci 0000:03:00.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.960845] pci 0000:03:00.3: PCI bridge, secondary bus 0000:07
[    1.966966] pci 0000:03:00.3:   IO window: disabled
[    1.972055] pci 0000:03:00.3:   MEM window: disabled
[    1.977218] pci 0000:03:00.3:   PREFETCH window: disabled
[    1.982814] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    1.988938] pci 0000:00:09.0:   IO window: 0x2000-0x2fff
[    1.994447] pci 0000:00:09.0:   MEM window: 0xdc200000-0xdc3fffff
[    2.000745] pci 0000:00:09.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    2.008670] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    2.014789] pci 0000:00:1c.0:   IO window: disabled
[    2.019866] pci 0000:00:1c.0:   MEM window: disabled
[    2.025029] pci 0000:00:1c.0:   PREFETCH window: disabled
[    2.030622] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    2.036743] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
[    2.042263] pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
[    2.048555] pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
[    2.056478] found new irq_cfg for irq 16
[    2.056479]  0 add_pin_to_irq: irq 16 --> apic 0 pin 16
[    2.056482] found new irq_desc for irq 16
[    2.056484] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.063384] pci 0000:00:01.0: setting latency timer to 64
[    2.063387] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.070283] pci 0000:00:05.0: setting latency timer to 64
[    2.070286] pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.077180] pci 0000:00:09.0: setting latency timer to 64
[    2.077185] vendor=8086 device=4029
[    2.080865] pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.087764] pci 0000:03:00.0: setting latency timer to 64
[    2.087768] vendor=8086 device=3500
[    2.091456] vendor=8086 device=4029
[    2.095138] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.102047] pci 0000:04:00.0: setting latency timer to 64
[    2.102051] vendor=8086 device=3500
[    2.105749] vendor=8086 device=4029
[    2.109430] found new irq_cfg for irq 18
[    2.109431]  0 add_pin_to_irq: irq 18 --> apic 0 pin 18
[    2.109434] found new irq_desc for irq 18
[    2.109436] pci 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.116340] pci 0000:04:02.0: setting latency timer to 64
[    2.116345] pci 0000:03:00.3: setting latency timer to 64
[    2.116349] found new irq_cfg for irq 21
[    2.116350]  0 add_pin_to_irq: irq 21 --> apic 0 pin 21
[    2.116352] found new irq_desc for irq 21
[    2.116353] pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.123255] pci 0000:00:1c.0: setting latency timer to 64
[    2.123259] pci 0000:00:1e.0: setting latency timer to 64
[    2.123261] bus: 00 index 0 io port: [0, ffff]
[    2.127903] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    2.133331] bus: 01 index 0 mmio: [0, 0]
[    2.137454] bus: 01 index 1 mmio: [dc100000, dc1fffff]
[    2.142784] bus: 01 index 2 mmio: [d1000000, d10fffff]
[    2.148123] bus: 01 index 3 mmio: [0, 0]
[    2.152256] bus: 02 index 0 mmio: [0, 0]
[    2.156372] bus: 02 index 1 mmio: [0, 0]
[    2.160487] bus: 02 index 2 mmio: [0, 0]
[    2.164604] bus: 02 index 3 mmio: [0, 0]
[    2.168727] bus: 03 index 0 io port: [2000, 2fff]
[    2.173628] bus: 03 index 1 mmio: [dc200000, dc3fffff]
[    2.178968] bus: 03 index 2 mmio: [d1100000, d11fffff]
[    2.184307] bus: 03 index 3 mmio: [0, 0]
[    2.188429] bus: 04 index 0 io port: [2000, 2fff]
[    2.193329] bus: 04 index 1 mmio: [dc200000, dc2fffff]
[    2.199107] bus: 04 index 2 mmio: [d1100000, d11fffff]
[    2.204438] bus: 04 index 3 mmio: [0, 0]
[    2.208552] bus: 05 index 0 mmio: [0, 0]
[    2.216825] bus: 05 index 1 mmio: [0, 0]
[    2.220945] bus: 05 index 2 mmio: [0, 0]
[    2.225060] bus: 05 index 3 mmio: [0, 0]
[    2.229180] bus: 06 index 0 io port: [2000, 2fff]
[    2.234078] bus: 06 index 1 mmio: [dc200000, dc2fffff]
[    2.239404] bus: 06 index 2 mmio: [d1100000, d11fffff]
[    2.244739] bus: 06 index 3 mmio: [0, 0]
[    2.248859] bus: 07 index 0 mmio: [0, 0]
[    2.252977] bus: 07 index 1 mmio: [0, 0]
[    2.257092] bus: 07 index 2 mmio: [0, 0]
[    2.261210] bus: 07 index 3 mmio: [0, 0]
[    2.265335] bus: 08 index 0 mmio: [0, 0]
[    2.269451] bus: 08 index 1 mmio: [0, 0]
[    2.273570] bus: 08 index 2 mmio: [0, 0]
[    2.277688] bus: 08 index 3 mmio: [0, 0]
[    2.281803] bus: 09 index 0 io port: [3000, 3fff]
[    2.286702] bus: 09 index 1 mmio: [dc000000, dc0fffff]
[    2.292040] bus: 09 index 2 mmio: [d8000000, dbffffff]
[    2.297368] bus: 09 index 3 io port: [0, ffff]
[    2.302015] bus: 09 index 4 mmio: [0, ffffffffffffffff]
[    2.307441] NET: Registered protocol family 2
[    2.342447] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    2.351747] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.362318] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.369559] TCP: Hash tables configured (established 524288 bind 65536)
[    2.376372] TCP reno registered
[    2.388889] NET: Registered protocol family 1
[    2.393533] checking if image is initramfs... it is
[    2.447462] Freeing initrd memory: 1917k freed
[    2.452418] pci 0000:09:05.0: Boot video device
[    2.452642] input: Power Button (FF) as /class/input/input0
[    2.458415] ACPI: Power Button (FF) [PWRF]
[    2.462809] input: Power Button (CM) as /class/input/input1
[    2.468578] ACPI: Power Button (CM) [PWRB]
[    2.473058] found new irq_cfg for irq 20
[    2.473059]  0 add_pin_to_irq: irq 20 --> apic 0 pin 20
[    2.473065] found new irq_desc for irq 20
[    2.473069] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.474634] Switched to high resolution mode on CPU 2
[    2.474651] Switched to high resolution mode on CPU 7
[    2.474734] Switched to high resolution mode on CPU 5
[    2.474746] Switched to high resolution mode on CPU 3
[    2.475210] Switched to high resolution mode on CPU 1
[    2.475274] Switched to high resolution mode on CPU 4
[    2.475559] Switched to high resolution mode on CPU 6
[    2.480410] Switched to high resolution mode on CPU 0
[    2.480417] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.480420] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.485941] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.497588] ehci_hcd 0000:00:1d.7: debug port 1
[    2.502323] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.502334] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc608000
[    2.520008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.527959] usb usb1: configuration #1 chosen from 1 choice
[    2.533803] hub 1-0:1.0: USB hub found
[    2.537753] hub 1-0:1.0: 8 ports detected
[    2.643637] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.643697] USB Universal Host Controller Interface driver v3.0
[    2.649833] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.657167] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.657169] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.662661] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.670423] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[    2.676470] usb usb2: configuration #1 chosen from 1 choice
[    2.682306] hub 2-0:1.0: USB hub found
[    2.686256] hub 2-0:1.0: 2 ports detected
[    2.793526] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.800868] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.800870] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.806365] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.814138] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[    2.820190] usb usb3: configuration #1 chosen from 1 choice
[    2.826029] hub 3-0:1.0: USB hub found
[    2.829983] hub 3-0:1.0: 2 ports detected
[    2.936857] found new irq_cfg for irq 22
[    2.936858]  0 add_pin_to_irq: irq 22 --> apic 0 pin 22
[    2.936860] found new irq_desc for irq 22
[    2.936862] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.944205] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.944207] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.949699] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.957472] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[    2.963516] usb usb4: configuration #1 chosen from 1 choice
[    2.969356] hub 4-0:1.0: USB hub found
[    2.973310] hub 4-0:1.0: 2 ports detected
[    3.080191] found new irq_cfg for irq 23
[    3.080192]  0 add_pin_to_irq: irq 23 --> apic 0 pin 23
[    3.080195] found new irq_desc for irq 23
[    3.080197] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.087542] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.087544] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.093035] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.100820] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
[    3.106869] usb usb5: configuration #1 chosen from 1 choice
[    3.112703] hub 5-0:1.0: USB hub found
[    3.116656] hub 5-0:1.0: 2 ports detected
[    3.223686] Simple Boot Flag at 0x40 set to 0x80
[    3.232748] audit: initializing netlink socket (disabled)
[    3.238371] type=2000 audit(1219700065.236:1): initialized
[    3.249049] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.258941] VFS: Disk quotas dquot_6.5.1
[    3.263163] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.271065] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.277919] msgmni has been set to 32106
[    3.282179] async_tx: api initialized (async)
[    3.286738] io scheduler noop registered
[    3.290862] io scheduler anticipatory registered
[    3.295673] io scheduler deadline registered
[    3.300297] io scheduler cfq registered (default)
[    3.305352] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    3.305374] pcieport-driver 0000:00:01.0: found MSI capability
[    3.311410] found new irq_cfg for irq 33024
[    3.311415] found new irq_desc for irq 33024
[    3.311423] pci_express 0000:00:01.0:pcie00: allocate port service
[    3.311505] pci_express 0000:00:01.0:pcie01: allocate port service
[    3.311585] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    3.311606] pcieport-driver 0000:00:05.0: found MSI capability
[    3.317646] found new irq_cfg for irq 164096
[    3.317648] found new irq_desc for irq 164096
[    3.317655] pci_express 0000:00:05.0:pcie00: allocate port service
[    3.317727] pci_express 0000:00:05.0:pcie01: allocate port service
[    3.317806] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    3.317828] pcieport-driver 0000:00:09.0: found MSI capability
[    3.323867] found new irq_cfg for irq 295168
[    3.323868] found new irq_desc for irq 295168
[    3.323875] pci_express 0000:00:09.0:pcie00: allocate port service
[    3.323945] pci_express 0000:00:09.0:pcie01: allocate port service
[    3.324032] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    3.324057] pcieport-driver 0000:00:1c.0: found MSI capability
[    3.330104] found new irq_cfg for irq 917760
[    3.330105] found new irq_desc for irq 917760
[    3.330115] pci_express 0000:00:1c.0:pcie00: allocate port service
[    3.330188] pci_express 0000:00:1c.0:pcie02: allocate port service
[    3.330236] pci_express 0000:00:1c.0:pcie03: allocate port service
[    3.330335] pcieport-driver 0000:03:00.0: setting latency timer to 64
[    3.330361] pci_express 0000:03:00.0:pcie11: allocate port service
[    3.330458] pcieport-driver 0000:04:00.0: setting latency timer to 64
[    3.330480] pcieport-driver 0000:04:00.0: found MSI capability
[    3.336530] found new irq_cfg for irq 4194560
[    3.336532] found new irq_desc for irq 4194560
[    3.336543] pci_express 0000:04:00.0:pcie21: allocate port service
[    3.336651] pcieport-driver 0000:04:02.0: setting latency timer to 64
[    3.336675] pcieport-driver 0000:04:02.0: found MSI capability
[    3.342722] found new irq_cfg for irq 4260096
[    3.342724] found new irq_desc for irq 4260096
[    3.342735] pci_express 0000:04:02.0:pcie21: allocate port service
[    3.343580] aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC support
[    3.344172] aer 0000:00:05.0:pcie01: AER service couldn't init device: no _OSC support
[    3.344758] aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
[    3.345543] ACPI: SSDT CFF04DBE, 01DD (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
[    3.353334] processor ACPI0007:00: registered as cooling_device0
[    3.360253] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.367102] ACPI: SSDT CFF04F9B, 016E (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
[    3.266881] processor ACPI0007:01: registered as cooling_device1
[    3.381854] ACPI: Processor [CPU1] (supports 8 throttling states)
[    3.388729] ACPI: SSDT CFF05109, 016E (r1  PmRef  Cpu2Ist     3000 INTL 20050228)
[    3.397234] processor ACPI0007:02: registered as cooling_device2
[    3.403440] ACPI: Processor [CPU2] (supports 8 throttling states)
[    3.410261] ACPI: SSDT CFF05277, 016E (r1  PmRef  Cpu3Ist     3000 INTL 20050228)
[    3.418748] processor ACPI0007:03: registered as cooling_device3
[    3.424960] ACPI: Processor [CPU3] (supports 8 throttling states)
[    3.431805] ACPI: SSDT CFF053E5, 016E (r1  PmRef  CPU4Ist     3000 INTL 20050228)
[    3.270834] processor ACPI0007:04: registered as cooling_device4
[    3.446507] ACPI: Processor [CPU4] (supports 8 throttling states)
[    3.453414] ACPI: SSDT CFF05553, 016E (r1  PmRef  CPU5Ist     3000 INTL 20050228)
[    3.271042] processor ACPI0007:05: registered as cooling_device5
[    3.468167] ACPI: Processor [CPU5] (supports 8 throttling states)
[    3.475014] ACPI: SSDT CFF056C1, 016E (r1  PmRef  Cpu6Ist     3000 INTL 20050228)
[    3.467918] processor ACPI0007:06: registered as cooling_device6
[    3.489708] ACPI: Processor [CPU6] (supports 8 throttling states)
[    3.496547] ACPI: SSDT CFF0582F, 016E (r1  PmRef  Cpu7Ist     3000 INTL 20050228)
[    3.505058] processor ACPI0007:07: registered as cooling_device7
[    3.511266] ACPI: Processor [CPU7] (supports 8 throttling states)
[    3.577486] Non-volatile memory driver v1.2
[    3.582244] intel_rng: FWH not detected
[    3.586374] Linux agpgart interface v0.103
[    3.590746] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    3.597254] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.603650] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.610425] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.616418] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.637353] FDC 0 is a post-1991 82077
[    3.643999] brd: module loaded
[    3.648125] loop: module loaded
[    3.651483] tun: Universal TUN/TAP device driver, 1.6
[    3.656733] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.663226] console [netcon0] enabled
[    3.667087] netconsole: network logging started
[    3.671813] Uniform Multi-Platform E-IDE driver
[    3.676626] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.686719] Probing IDE interface ide0...
[    4.386871] hda: Optiarc DVD RW AD-7590A, ATAPI CD/DVD-ROM drive
[    5.030061] Probing IDE interface ide1...
[    5.563407] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.568224] ide1 at 0x170-0x177,0x376 on irq 15
[    5.066667] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 974kB Cache
[    5.584052] Uniform CD-ROM driver Revision: 3.20
[    7.726667] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    8.179669] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    8.186885] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    8.193019] Driver 'sd' needs updating - please use bus_type methods
[    8.199622] Driver 'sr' needs updating - please use bus_type methods
[    8.206389] ata_piix 0000:00:1f.1: version 2.12
[    8.206400] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    8.213746] ata_piix 0000:00:1f.1: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
[    8.221489] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 0 (errno=-16)
[    8.229757] ata_piix 0000:00:1f.1: BAR 2: can't reserve I/O region [0x170-0x177]
[    8.237502] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 1 (errno=-16)
[    8.245763] ata_piix 0000:00:1f.1: no available native port
[    8.252009] Fusion MPT base driver 3.04.07
[    8.256298] Copyright (c) 1999-2008 LSI Corporation
[    8.261376] Fusion MPT SPI Host driver 3.04.07
[    8.266077] Fusion MPT SAS Host driver 3.04.07
[    8.271077] vendor=8086 device=244e
[    8.274770] found new irq_cfg for irq 17
[    8.274771]  0 add_pin_to_irq: irq 17 --> apic 0 pin 17
[    8.274775] found new irq_desc for irq 17
[    8.274778] ohci1394 0000:09:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.335284] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[dc040000-dc0407ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    8.352396] ieee1394: raw1394: /dev/raw1394 device initialized
[    8.358974] usbcore: registered new interface driver usblp
[    8.364664] Initializing USB Mass Storage driver...
[    8.373899] usbcore: registered new interface driver usb-storage
[    8.380108] USB Mass Storage support registered.
[    8.385027] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    8.394944] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.400119] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.405573] mice: PS/2 mouse device common for all mice
[    8.613333] md: linear personality registered for level -1
[    8.772496] md: raid0 personality registered for level 0
[    8.778017] md: raid1 personality registered for level 1
[    8.783526] md: raid10 personality registered for level 10
[    8.843752] raid6: int64x1   2858 MB/s
[    8.903766] raid6: int64x2   3533 MB/s
[    8.963751] raid6: int64x4   3433 MB/s
[    9.023764] raid6: int64x8   2296 MB/s
[    9.083752] raid6: sse2x1    3645 MB/s
[    9.143749] raid6: sse2x2    7359 MB/s
[    9.203750] raid6: sse2x4    8798 MB/s
[    9.207697] raid6: using algorithm sse2x4 (8798 MB/s)
[    9.212940] md: raid6 personality registered for level 6
[    9.218446] md: raid5 personality registered for level 5
[    9.223959] md: raid4 personality registered for level 4
[    9.229468] md: multipath personality registered for level -4
[    9.235625] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    9.244414] cpuidle: using governor ladder
[    9.248708] cpuidle: using governor menu
[    9.252892] usbcore: registered new interface driver usbhid
[    9.258660] usbhid: v2.6:USB HID core driver
[    9.263234] oprofile: using NMI interrupt.
[    9.267730] TCP cubic registered
[    9.271247] NET: Registered protocol family 10
[    9.276347] IPv6 over IPv4 tunneling driver
[    9.281180] NET: Registered protocol family 17
[    9.286175] RPC: Registered udp transport module.
[    9.291082] RPC: Registered tcp transport module.
[    9.298064] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    9.304600] Freeing unused kernel memory: 676k freed
[    9.309964] Write protecting the kernel read-only data: 5576k
[    9.541223] vendor=8086 device=4021
[    9.541227] arcmsr 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.541232] arcmsr 0000:01:00.0: setting latency timer to 64
[    9.553980] ARECA RAID ADAPTER0: FIRMWARE VERSION V1.45 2008-3-14  
[    9.566674] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    9.566675]  Driver Version 1.20.00.15 2008/02/27
[    9.557083] scsi 0:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
[    9.556875] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    9.557708] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    9.557708] sd 0:0:0:0: [sda] Write Protect is off
[    9.557708] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    9.556666] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.557083] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    9.554583] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    9.556875] sd 0:0:0:0: [sda] Write Protect is off
[    9.556875] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    9.557708] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.557708]  sda:<7>ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e08100002824f8]
[    9.577500]  sda1 sda2 sda3 sda4
[    9.954660] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.954889] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.955753] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    9.956200] scsi 0:0:16:0: Attached scsi generic sg1 type 3
[   10.023565] 3ware Storage Controller device driver for Linux v1.26.02.002.
[   10.033876] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[   10.049059] Adaptec aacraid driver 1.1-5[2456]-ms
[   10.154668] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[   10.156139] SGI XFS Quota Management subsystem
[   10.169930] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[   10.169932] Copyright (c) 1999-2006 Intel Corporation.
[   14.230000] kjournald starting.  Commit interval 5 seconds
[   14.236667] EXT3-fs: mounted filesystem with ordered data mode.
[   22.764869] found new irq_cfg for irq 19
[   22.764871]  0 add_pin_to_irq: irq 19 --> apic 0 pin 19
[   22.764876] found new irq_desc for irq 19
[   22.764879] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.775780] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   22.775863] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[   22.775952] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   22.782406] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[   22.782408] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   22.782479] vendor=8086 device=3518
[   22.782480] vendor=8086 device=3500
[   22.782482] vendor=8086 device=4029
[   22.782484] e1000e 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   22.782492] e1000e 0000:06:00.0: setting latency timer to 64
[   22.855404] 0000:06:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:14
[   22.855406] 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   22.855484] 0000:06:00.0: eth0: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   22.855506] vendor=8086 device=3518
[   22.855507] vendor=8086 device=3500
[   22.855508] vendor=8086 device=4029
[   22.855510] e1000e 0000:06:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.855515] e1000e 0000:06:00.1: setting latency timer to 64
[   22.932857] 0000:06:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:15
[   22.932859] 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   22.932937] 0000:06:00.1: eth1: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   23.605493] EXT3 FS on sda3, internal journal
[   24.137915] XFS mounting filesystem sda4
[   24.234165] Ending clean XFS mount for filesystem: sda4
[   24.370791] Adding 31999992k swap on /dev/sda2.  Priority:-1 extents:1 across:31999992k
[   28.090792] found new irq_cfg for irq 6291712
[   28.090798] found new irq_desc for irq 6291712
[   28.145496] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.766056] 0000:06:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   30.768604] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   40.941246] eth0: no IPv6 routers present
[   61.380619] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   61.406663] NFSD: starting 90-second grace period

--a8Wt8u1KmwUX3Y2C--
