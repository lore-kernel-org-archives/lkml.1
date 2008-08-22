Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYHVALH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYHVALH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYHVAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:10:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYHVAKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:10:51 -0400
Date: Thu, 21 Aug 2008 14:10:47 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822001047.GF23377@hoblitt.com>
References: <bug-11388-27@http.bugzilla.kernel.org/> <20080820180405.7f164450.akpm@linux-foundation.org> <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com> <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com> <20080821205558.GC23377@hoblitt.com> <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com> <20080821233317.GE23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <20080821233317.GE23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The dmesg from the tip kernel is attached and it's at least larger than
the last builds dmesg.

 $ wc -l *.dmesg
  683 2.6.27-r3.dmesg
  829 2.6.27-rc4-tip.dmesg

-J

--
On Thu, Aug 21, 2008 at 01:33:17PM -1000, Joshua Hoblitt wrote:
> On Thu, Aug 21, 2008 at 02:51:43PM -0700, Yinghai Lu wrote:
> > can you check that with tip/master?
> > 
> > http://people.redhat.com/mingo/tip.git/readme.txt
> 
> I'm doing that now.  Note that I was pulling from netdev-2.6 before.
> 
> -J
> 
> --

--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.27-rc4-tip.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-rc4-tip-00862-gcc150c8 (root@ipp000) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #1 SMP Thu Aug 21 13:52:09 HST 2008
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
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 13056MB of RAM.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1558 mtrr_trim_uncached_memory+0x522/0x54b()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc4-tip-00862-gcc150c8 #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80237573>] warn_on_slowpath+0x51/0x77
[    0.000000]  [<ffffffff8023808b>] printk+0x4e/0x56
[    0.000000]  [<ffffffff803b1942>] sort+0xfa/0x18c
[    0.000000]  [<ffffffff80802a5b>] cmp_range+0x0/0x6
[    0.000000]  [<ffffffff808030e9>] mtrr_trim_uncached_memory+0x522/0x54b
[    0.000000]  [<ffffffff802194d9>] post_set+0x20/0x3d
[    0.000000]  [<ffffffff807ff4df>] setup_arch+0x39d/0x6d7
[    0.000000]  [<ffffffff8024702e>] kernel_text_address+0x9/0x26
[    0.000000]  [<ffffffff8024c4de>] notifier_chain_register+0x14/0x55
[    0.000000]  [<ffffffff807f8a1d>] start_kernel+0x74/0x346
[    0.000000]  [<ffffffff807f8394>] x86_64_start_kernel+0xe3/0xe7
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] update e820 for mtrr
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  modified: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff00000 (usable)
[    0.000000]  modified: 00000000cff00000 - 00000000cff0a000 (ACPI data)
[    0.000000]  modified: 00000000cff0a000 - 00000000cff0b000 (ACPI NVS)
[    0.000000]  modified: 00000000cff0b000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000430000000 (reserved)
[    0.000000] last_pfn = 0xcff00 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff00000 page 4k
[    0.000000] kernel direct mapping tables up to cff00000 @ 8000-e000
[    0.000000] last_map_addr: cff00000 end: cff00000
[    0.000000] RAMDISK: 37e10000 - 37fef7d5
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
[    0.000000] Faking a node at 0000000000000000-00000000cff00000
[    0.000000] Bootmem setup node 0 0000000000000000-00000000cff00000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000016fff]
[    0.000000]   bootmap [0000000000017000 -  0000000000030fdf] pages 1a
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00cff00000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00009beef0]    TEXT DATA BSS ==> [0000200000 - 00009beef0]
[    0.000000]   #3 [0037e10000 - 0037fef7d5]          RAMDISK ==> [0037e10000 - 0037fef7d5]
[    0.000000]   #4 [000009e400 - 0000100000]    BIOS reserved ==> [000009e400 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000] found SMP MP-table at [ffff8800000f7050] 000f7050
[    0.000000]  [ffffe20000000000-ffffe200033fffff] PMD -> [ffff880001200000-ffff8800045fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff00
[    0.000000] On node 0 totalpages: 851614
[    0.000000]   DMA zone: 1846 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 834372 pages, LIFO batch:31
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
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] dyn_array irq_2_pin_head+0x0/0x418 size:0x10 nr:256 align:0x1000
[    0.000000] dyn_array irq_cfgx+0x0/0x8 size:0x30 nr:32 align:0x1000
[    0.000000] dyn_array sparse_irqs+0x0/0x8 size:0x100 nr:32 align:0x1000
[    0.000000] dyn_array total_size: 0x4000
[    0.000000] dyn_array irq_2_pin_head+0x0/0x418  ==> [0x101c000 - 0x101d000]
[    0.000000] dyn_array irq_cfgx+0x0/0x8  ==> [0x101d000 - 0x101d600]
[    0.000000] dyn_array sparse_irqs+0x0/0x8  ==> [0x101e000 - 0x1020000]
[    0.000000] kstat_irqs ==> [0x1020000 - 0x1020400]
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] per cpu data for cpu0 on node0 at 0000000001021000
[    0.000000] per cpu data for cpu1 on node0 at 000000000102d000
[    0.000000] per cpu data for cpu2 on node0 at 0000000001039000
[    0.000000] per cpu data for cpu3 on node0 at 0000000001045000
[    0.000000] per cpu data for cpu4 on node0 at 0000000001051000
[    0.000000] per cpu data for cpu5 on node0 at 000000000105d000
[    0.000000] per cpu data for cpu6 on node0 at 0000000001069000
[    0.000000] per cpu data for cpu7 on node0 at 0000000001075000
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 8, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 836218
[    0.000000] Policy zone: DMA32
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
[    0.000000] Detected 3191.983 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Memory: 3342444k/3406848k available (3830k kernel code, 64012k reserved, 2175k data, 672k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.006666] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.96 BogoMIPS (lpj=10639943)
[    0.013081] Security Framework initialized
[    0.016665] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.021461] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.026664] Mount-cache hash table entries: 256
[    0.029998] Initializing cgroup subsys ns
[    0.033331] Initializing cgroup subsys cpuacct
[    0.036664] Initializing cgroup subsys memory
[    0.039997] Initializing cgroup subsys devices
[    0.043330] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.048291] CPU: L2 cache: 6144K
[    0.051710] CPU 0/0 -> Node 0
[    0.054865] CPU: Physical Processor ID: 0
[    0.059063] CPU: Processor Core ID: 0
[    0.063329] CPU0: Thermal monitoring enabled (TM2)
[    0.066662] using mwait in idle threads.
[    0.069995] ACPI: Core revision 20080609
[    0.082425] Setting APIC routing to flat
[    0.086661]  0 add_pin_to_irq: irq 1 --> apic 0 pin 1
[    0.086661]  0 add_pin_to_irq: irq 0 --> apic 0 pin 2
[    0.086661]  0 add_pin_to_irq: irq 3 --> apic 0 pin 3
[    0.086661]  0 add_pin_to_irq: irq 4 --> apic 0 pin 4
[    0.086661]  0 add_pin_to_irq: irq 5 --> apic 0 pin 5
[    0.086661]  0 add_pin_to_irq: irq 6 --> apic 0 pin 6
[    0.086661]  0 add_pin_to_irq: irq 7 --> apic 0 pin 7
[    0.086661]  0 add_pin_to_irq: irq 8 --> apic 0 pin 8
[    0.086661]  0 add_pin_to_irq: irq 9 --> apic 0 pin 9
[    0.086661]  0 add_pin_to_irq: irq 10 --> apic 0 pin 10
[    0.086661]  0 add_pin_to_irq: irq 11 --> apic 0 pin 11
[    0.086661]  0 add_pin_to_irq: irq 12 --> apic 0 pin 12
[    0.086661]  0 add_pin_to_irq: irq 13 --> apic 0 pin 13
[    0.086661]  0 add_pin_to_irq: irq 14 --> apic 0 pin 14
[    0.086661]  0 add_pin_to_irq: irq 15 --> apic 0 pin 15
[    0.086661] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.122915] CPU0: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.133324] APIC timer calibration result 24937431
[    0.133324] Detected 24.937 MHz APIC timer.
[    0.136657] Booting processor 1/4 ip 6000
[    0.149990] Initializing CPU#1
[    0.149990] Calibrating delay using timer specific routine.. 6386.03 BogoMIPS (lpj=10640061)
[    0.149990] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.149990] CPU: L2 cache: 6144K
[    0.149990] CPU 1/4 -> Node 0
[    0.149990] CPU: Physical Processor ID: 1
[    0.149990] CPU: Processor Core ID: 0
[    0.149990] CPU1: Thermal monitoring enabled (TM2)
[    0.149990] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.233318] CPU1: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.243317] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.246650] Booting processor 2/1 ip 6000
[    0.259983] Initializing CPU#2
[    0.259983] Calibrating delay using timer specific routine.. 6386.02 BogoMIPS (lpj=10640043)
[    0.259983] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.259983] CPU: L2 cache: 6144K
[    0.259983] CPU 2/1 -> Node 0
[    0.259983] CPU: Physical Processor ID: 0
[    0.259983] CPU: Processor Core ID: 1
[    0.259983] CPU2: Thermal monitoring enabled (TM2)
[    0.259983] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.343097] CPU2: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.349977] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.353310] Booting processor 3/5 ip 6000
[    0.366642] Initializing CPU#3
[    0.366642] Calibrating delay using timer specific routine.. 6453.47 BogoMIPS (lpj=10751153)
[    0.366642] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.366642] CPU: L2 cache: 6144K
[    0.366642] CPU 3/5 -> Node 0
[    0.366642] CPU: Physical Processor ID: 1
[    0.366642] CPU: Processor Core ID: 1
[    0.366642] CPU3: Thermal monitoring enabled (TM2)
[    0.366642] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.449970] CPU3: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.456636] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.459970] Booting processor 4/2 ip 6000
[    0.473302] Initializing CPU#4
[    0.473302] Calibrating delay using timer specific routine.. 6386.99 BogoMIPS (lpj=10639998)
[    0.473302] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.473302] CPU: L2 cache: 6144K
[    0.473302] CPU 4/2 -> Node 0
[    0.473302] CPU: Physical Processor ID: 0
[    0.473302] CPU: Processor Core ID: 2
[    0.473302] CPU4: Thermal monitoring enabled (TM2)
[    0.473302] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.556633] CPU4: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.563300] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.566633] Booting processor 5/6 ip 6000
[    0.579962] Initializing CPU#5
[    0.579962] Calibrating delay using timer specific routine.. 6386.01 BogoMIPS (lpj=10640030)
[    0.579962] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.579962] CPU: L2 cache: 6144K
[    0.579962] CPU 5/6 -> Node 0
[    0.579962] CPU: Physical Processor ID: 1
[    0.579962] CPU: Processor Core ID: 2
[    0.579962] CPU5: Thermal monitoring enabled (TM2)
[    0.579962] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.663300] CPU5: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.669967] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.673300] Booting processor 6/3 ip 6000
[    0.686621] Initializing CPU#6
[    0.686621] Calibrating delay using timer specific routine.. 6386.99 BogoMIPS (lpj=10639999)
[    0.686621] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.686621] CPU: L2 cache: 6144K
[    0.686621] CPU 6/3 -> Node 0
[    0.686621] CPU: Physical Processor ID: 0
[    0.686621] CPU: Processor Core ID: 3
[    0.686621] CPU6: Thermal monitoring enabled (TM2)
[    0.686621] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.769967] CPU6: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.776633] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    0.779967] Booting processor 7/7 ip 6000
[    0.793281] Initializing CPU#7
[    0.793281] Calibrating delay using timer specific routine.. 6386.01 BogoMIPS (lpj=10640024)
[    0.793281] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.793281] CPU: L2 cache: 6144K
[    0.793281] CPU 7/7 -> Node 0
[    0.793281] CPU: Physical Processor ID: 1
[    0.793281] CPU: Processor Core ID: 3
[    0.793281] CPU7: Thermal monitoring enabled (TM2)
[    0.793281] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.876633] CPU7: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.883300] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    0.886633] Brought up 8 CPUs
[    0.889792] Total of 8 processors activated (51159.53 BogoMIPS).
[    0.893300] net_namespace: 864 bytes
[    0.896633] xor: automatically using best checksumming function: generic_sse
[    0.915667]    generic_sse: 11872.800 MB/sec
[    0.919967] xor: using function: generic_sse (11872.800 MB/sec)
[    0.923300] NET: Registered protocol family 16
[    0.926633] No dock devices found.
[    0.929967] ACPI: bus type pci registered
[    0.933300] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 8
[    0.936633] PCI: MCFG area at e0000000 reserved in E820
[    0.939967] PCI: Using MMCONFIG at e0000000 - e08fffff
[    0.943300] PCI: Using configuration type 1 for base access
[    0.949967] ACPI: EC: Look up EC in DSDT
[    0.953300] ACPI: Interpreter enabled
[    0.956633] ACPI: (supports S0 S3 S4 S5)
[    0.959967] ACPI: Using IOAPIC for interrupt routing
[    0.966633] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.969967] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.973300] pci 0000:00:00.0: PME# disabled
[    0.976633] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.979967] pci 0000:00:01.0: PME# disabled
[    0.983300] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.986633] pci 0000:00:05.0: PME# disabled
[    0.989967] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.993300] pci 0000:00:09.0: PME# disabled
[    0.996633] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.999967] pci 0000:00:1b.0: PME# disabled
[    1.003300] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.006633] pci 0000:00:1c.0: PME# disabled
[    1.009967] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.013300] pci 0000:00:1d.7: PME# disabled
[    1.016633] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.016633] pci 0000:01:00.0: supports D1
[    1.016633] PCI: bridge 0000:00:01.0 32bit mmio: [dc100000, dc1fffff]
[    1.019967] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.023300] pci 0000:03:00.0: PME# disabled
[    1.026633] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    1.029967] pci 0000:03:00.3: PME# disabled
[    1.033300] PCI: bridge 0000:00:09.0 io port: [2000, 2fff]
[    1.036633] PCI: bridge 0000:00:09.0 32bit mmio: [dc200000, dc3fffff]
[    1.039967] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.043300] pci 0000:04:00.0: PME# disabled
[    1.046633] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
[    1.049967] pci 0000:04:02.0: PME# disabled
[    1.053300] PCI: bridge 0000:03:00.0 io port: [2000, 2fff]
[    1.056633] PCI: bridge 0000:03:00.0 32bit mmio: [dc200000, dc2fffff]
[    1.059967] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.063300] pci 0000:06:00.0: PME# disabled
[    1.066633] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    1.069967] pci 0000:06:00.1: PME# disabled
[    1.073300] PCI: bridge 0000:04:02.0 io port: [2000, 2fff]
[    1.076633] PCI: bridge 0000:04:02.0 32bit mmio: [dc200000, dc2fffff]
[    1.079967] pci 0000:09:05.0: supports D1
[    1.079967] pci 0000:09:05.0: supports D2
[    1.079967] pci 0000:09:06.0: supports D2
[    1.079967] pci 0000:09:06.0: PME# supported from D2 D3hot D3cold
[    1.083300] pci 0000:09:06.0: PME# disabled
[    1.086633] pci 0000:00:1e.0: transparent bridge
[    1.089967] PCI: bridge 0000:00:1e.0 io port: [3000, 3fff]
[    1.093300] PCI: bridge 0000:00:1e.0 32bit mmio: [dc000000, dc0fffff]
[    1.096633] PCI: bridge 0000:00:1e.0 64bit mmio pref: [d8000000, dbffffff]
[    1.099967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.099967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.099967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    1.099967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.099967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0._PRT]
[    1.100861] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD0._PRT]
[    1.101087] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD2._PRT]
[    1.101394] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMF3._PRT]
[    1.101828] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.102351] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.109967] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.116426] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.123087] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.129762] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.136417] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15)
[    1.143082] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15)
[    1.149515] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
[    1.153300] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *9
[    1.159967] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.163300] pnp: PnP ACPI init
[    1.166609] ACPI: bus type pnp registered
[    1.173300] pnp: PnP ACPI: found 11 devices
[    1.176633] ACPI: ACPI bus type pnp unregistered
[    1.179967] SCSI subsystem initialized
[    1.183300] libata version 3.00 loaded.
[    1.183300] usbcore: registered new interface driver usbfs
[    1.186633] usbcore: registered new interface driver hub
[    1.189967] usbcore: registered new device driver usb
[    1.193300] PCI: Using ACPI for IRQ routing
[    1.212875] PCI-GART: No AMD northbridge found.
[    1.216633] hpet clockevent registered
[    1.216633] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.221231] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.227657] ACPI: RTC can wake from S4
[    1.240451] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    1.245465] system 00:01: ioport range 0x800-0x80f has been reserved
[    1.252012] system 00:01: ioport range 0x1000-0x107f has been reserved
[    1.258660] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    1.265389] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    1.272112] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    1.279932] system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    1.287758] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.295583] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.302914] system 00:01: iomem range 0xfec88000-0xfec88fff has been reserved
[    1.310247] system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
[    1.317577] system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
[    1.330161] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.332154] pci 0000:00:01.0:   IO window: disabled
[    1.337231] pci 0000:00:01.0:   MEM window: 0xdc100000-0xdc1fffff
[    1.343525] pci 0000:00:01.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    1.351436] pci 0000:00:05.0: PCI bridge, secondary bus 0000:02
[    1.357553] pci 0000:00:05.0:   IO window: disabled
[    1.362623] pci 0000:00:05.0:   MEM window: disabled
[    1.371932] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.377532] pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
[    1.383650] pci 0000:04:00.0:   IO window: disabled
[    1.388737] pci 0000:04:00.0:   MEM window: disabled
[    1.393900] pci 0000:04:00.0:   PREFETCH window: disabled
[    1.399496] pci 0000:04:02.0: PCI bridge, secondary bus 0000:06
[    1.405614] pci 0000:04:02.0:   IO window: 0x2000-0x2fff
[    1.411124] pci 0000:04:02.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.417417] pci 0000:04:02.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.425343] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    1.431455] pci 0000:03:00.0:   IO window: 0x2000-0x2fff
[    1.436972] pci 0000:03:00.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.443261] pci 0000:03:00.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.451646] pci 0000:03:00.3: PCI bridge, secondary bus 0000:07
[    1.457758] pci 0000:03:00.3:   IO window: disabled
[    1.462837] pci 0000:03:00.3:   MEM window: disabled
[    1.468002] pci 0000:03:00.3:   PREFETCH window: disabled
[    1.473602] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    1.479718] pci 0000:00:09.0:   IO window: 0x2000-0x2fff
[    1.485228] pci 0000:00:09.0:   MEM window: 0xdc200000-0xdc3fffff
[    1.491534] pci 0000:00:09.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.499450] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    1.505566] pci 0000:00:1c.0:   IO window: disabled
[    1.510643] pci 0000:00:1c.0:   MEM window: disabled
[    1.515808] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.521406] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    1.527518] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
[    1.533029] pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
[    1.539325] pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
[    1.547245] found new irq_cfg for irq 16
[    1.547254]  0 add_pin_to_irq: irq 16 --> apic 0 pin 16
[    1.547267] found new irq_desc for irq 16
[    1.547282] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.554155] pci 0000:00:01.0: setting latency timer to 64
[    1.554162] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.561061] pci 0000:00:05.0: setting latency timer to 64
[    1.561066] pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.567959] pci 0000:00:09.0: setting latency timer to 64
[    1.567965] vendor=8086 device=4029
[    1.571652] pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.578548] pci 0000:03:00.0: setting latency timer to 64
[    1.578556] vendor=8086 device=3500
[    1.582236] vendor=8086 device=4029
[    1.585919] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.592811] pci 0000:04:00.0: setting latency timer to 64
[    1.592818] vendor=8086 device=3500
[    1.596501] vendor=8086 device=4029
[    1.600182] found new irq_cfg for irq 18
[    1.600183]  0 add_pin_to_irq: irq 18 --> apic 0 pin 18
[    1.600188] found new irq_desc for irq 18
[    1.600194] pci 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.607088] pci 0000:04:02.0: setting latency timer to 64
[    1.607096] pci 0000:03:00.3: setting latency timer to 64
[    1.607109] found new irq_cfg for irq 21
[    1.607123]  0 add_pin_to_irq: irq 21 --> apic 0 pin 21
[    1.607138] found new irq_desc for irq 21
[    1.607155] pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.613997] pci 0000:00:1c.0: setting latency timer to 64
[    1.614003] pci 0000:00:1e.0: setting latency timer to 64
[    1.614012] bus: 00 index 0 io port: [0, ffff]
[    1.618660] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    1.624071] bus: 01 index 0 mmio: [0, 0]
[    1.628193] bus: 01 index 1 mmio: [dc100000, dc1fffff]
[    1.633529] bus: 01 index 2 mmio: [d1000000, d10fffff]
[    1.638865] bus: 01 index 3 mmio: [0, 0]
[    1.642980] bus: 02 index 0 mmio: [0, 0]
[    1.647099] bus: 02 index 1 mmio: [0, 0]
[    1.651210] bus: 02 index 2 mmio: [0, 0]
[    1.655340] bus: 02 index 3 mmio: [0, 0]
[    1.659457] bus: 03 index 0 io port: [2000, 2fff]
[    1.664351] bus: 03 index 1 mmio: [dc200000, dc3fffff]
[    1.669686] bus: 03 index 2 mmio: [d1100000, d11fffff]
[    1.675035] bus: 03 index 3 mmio: [0, 0]
[    1.679152] bus: 04 index 0 io port: [2000, 2fff]
[    1.684055] bus: 04 index 1 mmio: [dc200000, dc2fffff]
[    1.689392] bus: 04 index 2 mmio: [d1100000, d11fffff]
[    1.694721] bus: 04 index 3 mmio: [0, 0]
[    1.698837] bus: 05 index 0 mmio: [0, 0]
[    1.702954] bus: 05 index 1 mmio: [0, 0]
[    1.707501] bus: 05 index 2 mmio: [0, 0]
[    1.711630] bus: 05 index 3 mmio: [0, 0]
[    1.715746] bus: 06 index 0 io port: [2000, 2fff]
[    1.720644] bus: 06 index 1 mmio: [dc200000, dc2fffff]
[    1.725975] bus: 06 index 2 mmio: [d1100000, d11fffff]
[    1.731306] bus: 06 index 3 mmio: [0, 0]
[    1.735435] bus: 07 index 0 mmio: [0, 0]
[    1.739553] bus: 07 index 1 mmio: [0, 0]
[    1.743672] bus: 07 index 2 mmio: [0, 0]
[    1.747788] bus: 07 index 3 mmio: [0, 0]
[    1.751902] bus: 08 index 0 mmio: [0, 0]
[    1.756020] bus: 08 index 1 mmio: [0, 0]
[    1.760137] bus: 08 index 2 mmio: [0, 0]
[    1.764252] bus: 08 index 3 mmio: [0, 0]
[    1.768379] bus: 09 index 0 io port: [3000, 3fff]
[    1.773278] bus: 09 index 1 mmio: [dc000000, dc0fffff]
[    1.778614] bus: 09 index 2 mmio: [d8000000, dbffffff]
[    1.783947] bus: 09 index 3 io port: [0, ffff]
[    1.788581] bus: 09 index 4 mmio: [0, ffffffffffffffff]
[    1.794014] NET: Registered protocol family 2
[    1.832044] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.837428] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.848795] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.855117] TCP: Hash tables configured (established 524288 bind 65536)
[    1.861926] TCP reno registered
[    1.875410] NET: Registered protocol family 1
[    1.878880] checking if image is initramfs... it is
[    1.932129] Freeing initrd memory: 1917k freed
[    1.935787] pci 0000:09:05.0: Boot video device
[    1.939163] input: Power Button (FF) as /class/input/input0
[    1.942159] ACPI: Power Button (FF) [PWRF]
[    1.949470] input: Power Button (CM) as /class/input/input1
[    1.952768] ACPI: Power Button (CM) [PWRB]
[    1.960068] found new irq_cfg for irq 20
[    1.960068]  0 add_pin_to_irq: irq 20 --> apic 0 pin 20
[    1.960068] found new irq_desc for irq 20
[    1.960068] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.957967] Switched to high resolution mode on CPU 2
[    1.958119] Switched to high resolution mode on CPU 5
[    1.960075] Switched to high resolution mode on CPU 3
[    1.960073] Switched to high resolution mode on CPU 6
[    1.958611] Switched to high resolution mode on CPU 4
[    1.958615] Switched to high resolution mode on CPU 7
[    1.959458] Switched to high resolution mode on CPU 1
[    1.963822] Switched to high resolution mode on CPU 0
[    1.963832] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.963845] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.221976] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.221976] ehci_hcd 0000:00:1d.7: debug port 1
[    2.221976] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.221976] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc608000
[    2.221976] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.221976] usb usb1: configuration #1 chosen from 1 choice
[    2.221976] hub 1-0:1.0: USB hub found
[    2.221976] hub 1-0:1.0: 8 ports detected
[    2.221977] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.221977] USB Universal Host Controller Interface driver v3.0
[    2.221977] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.221977] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.221977] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.221977] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.221977] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[    2.221977] usb usb2: configuration #1 chosen from 1 choice
[    2.221977] hub 2-0:1.0: USB hub found
[    2.221977] hub 2-0:1.0: 2 ports detected
[    2.283328] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.286675] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.286682] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.291388] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.299653] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[    2.304781] usb usb3: configuration #1 chosen from 1 choice
[    2.311396] hub 3-0:1.0: USB hub found
[    2.315409] hub 3-0:1.0: 2 ports detected
[    2.424783] found new irq_cfg for irq 22
[    2.424783]  0 add_pin_to_irq: irq 22 --> apic 0 pin 22
[    2.424783] found new irq_desc for irq 22
[    2.424783] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.430006] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.430012] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.434719] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.443011] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[    2.448122] usb usb4: configuration #1 chosen from 1 choice
[    2.454726] hub 4-0:1.0: USB hub found
[    2.458737] hub 4-0:1.0: 2 ports detected
[    2.568116] found new irq_cfg for irq 23
[    2.568116]  0 add_pin_to_irq: irq 23 --> apic 0 pin 23
[    2.568116] found new irq_desc for irq 23
[    2.568116] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.573340] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.573347] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.578044] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.586329] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
[    2.591448] usb usb5: configuration #1 chosen from 1 choice
[    2.598085] hub 5-0:1.0: USB hub found
[    2.602111] hub 5-0:1.0: 2 ports detected
[    2.711450] Simple Boot Flag at 0x40 set to 0x80
[    2.718126] audit: initializing netlink socket (disabled)
[    2.723993] type=2000 audit(1219363544.720:1): initialized
[    2.734797] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.744797] VFS: Disk quotas dquot_6.5.1
[    2.748463] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.755197] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.762850] msgmni has been set to 6531
[    2.767165] async_tx: api initialized (async)
[    2.771716] io scheduler noop registered
[    2.775187] io scheduler anticipatory registered
[    2.779310] io scheduler deadline registered
[    2.785250] io scheduler cfq registered (default)
[    2.789827] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    2.789988] pcieport-driver 0000:00:01.0: found MSI capability
[    2.796171] found new irq_cfg for irq 33024
[    2.796188] found new irq_desc for irq 33024
[    2.796212] pci_express 0000:00:01.0:pcie00: allocate port service
[    2.796466] pci_express 0000:00:01.0:pcie01: allocate port service
[    2.796466] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    2.796466] pcieport-driver 0000:00:05.0: found MSI capability
[    2.802674] found new irq_cfg for irq 164096
[    2.802674] found new irq_desc for irq 164096
[    2.802674] pci_express 0000:00:05.0:pcie00: allocate port service
[    2.802674] pci_express 0000:00:05.0:pcie01: allocate port service
[    2.802674] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    2.802674] pcieport-driver 0000:00:09.0: found MSI capability
[    2.808872] found new irq_cfg for irq 295168
[    2.808878] found new irq_desc for irq 295168
[    2.808878] pci_express 0000:00:09.0:pcie00: allocate port service
[    2.808878] pci_express 0000:00:09.0:pcie01: allocate port service
[    2.808878] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.808878] pcieport-driver 0000:00:1c.0: found MSI capability
[    2.815092] found new irq_cfg for irq 917760
[    2.815092] found new irq_desc for irq 917760
[    2.815092] pci_express 0000:00:1c.0:pcie00: allocate port service
[    2.815092] pci_express 0000:00:1c.0:pcie02: allocate port service
[    2.815092] pci_express 0000:00:1c.0:pcie03: allocate port service
[    2.815092] pcieport-driver 0000:03:00.0: setting latency timer to 64
[    2.815092] pci_express 0000:03:00.0:pcie11: allocate port service
[    2.815092] pcieport-driver 0000:04:00.0: setting latency timer to 64
[    2.815092] pcieport-driver 0000:04:00.0: found MSI capability
[    2.821470] found new irq_cfg for irq 4194560
[    2.821470] found new irq_desc for irq 4194560
[    2.821470] pci_express 0000:04:00.0:pcie21: allocate port service
[    2.821470] pcieport-driver 0000:04:02.0: setting latency timer to 64
[    2.821470] pcieport-driver 0000:04:02.0: found MSI capability
[    2.824818] found new irq_cfg for irq 4260096
[    2.824835] found new irq_desc for irq 4260096
[    2.824863] pci_express 0000:04:02.0:pcie21: allocate port service
[    2.827930] aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC support
[    2.827930] aer 0000:00:05.0:pcie01: AER service couldn't init device: no _OSC support
[    2.827930] aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
[    2.827930] ACPI: SSDT CFF04DBE, 01DD (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
[    2.839743] processor ACPI0007:00: registered as cooling_device0
[    2.843338] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.851067] ACPI: SSDT CFF04F9B, 016E (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
[    2.863958] processor ACPI0007:01: registered as cooling_device1
[    2.863961] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.870848] ACPI: SSDT CFF05109, 016E (r1  PmRef  Cpu2Ist     3000 INTL 20050228)
[    2.882423] processor ACPI0007:02: registered as cooling_device2
[    2.884887] ACPI: Processor [CPU2] (supports 8 throttling states)
[    2.894156] ACPI: SSDT CFF05277, 016E (r1  PmRef  Cpu3Ist     3000 INTL 20050228)
[    2.903959] processor ACPI0007:03: registered as cooling_device3
[    2.907296] ACPI: Processor [CPU3] (supports 8 throttling states)
[    2.914783] ACPI: SSDT CFF053E5, 016E (r1  PmRef  CPU4Ist     3000 INTL 20050228)
[    2.928625] processor ACPI0007:04: registered as cooling_device4
[    2.932042] ACPI: Processor [CPU4] (supports 8 throttling states)
[    2.940460] ACPI: SSDT CFF05553, 016E (r1  PmRef  CPU5Ist     3000 INTL 20050228)
[    2.953958] processor ACPI0007:05: registered as cooling_device5
[    2.953963] ACPI: Processor [CPU5] (supports 8 throttling states)
[    2.961174] ACPI: SSDT CFF056C1, 016E (r1  PmRef  Cpu6Ist     3000 INTL 20050228)
[    2.973963] processor ACPI0007:06: registered as cooling_device6
[    2.975295] ACPI: Processor [CPU6] (supports 8 throttling states)
[    2.983217] ACPI: SSDT CFF0582F, 016E (r1  PmRef  Cpu7Ist     3000 INTL 20050228)
[    2.994791] processor ACPI0007:07: registered as cooling_device7
[    2.996869] ACPI: Processor [CPU7] (supports 8 throttling states)
[    3.068127] Non-volatile memory driver v1.2
[    3.071952] intel_rng: FWH not detected
[    3.075411] Linux agpgart interface v0.103
[    3.081251] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    3.087917] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.094583] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.101250] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.105852] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.128126] FDC 0 is a post-1991 82077
[    3.134794] brd: module loaded
[    3.139901] loop: module loaded
[    3.142122] tun: Universal TUN/TAP device driver, 1.6
[    3.147366] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.154791] console [netcon0] enabled
[    3.158127] netconsole: network logging started
[    3.162841] Uniform Multi-Platform E-IDE driver
[    3.168245] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.178252] Probing IDE interface ide0...
[    3.875104] hda: Optiarc DVD RW AD-7590A, ATAPI CD/DVD-ROM drive
[    4.521230] Probing IDE interface ide1...
[    5.053945] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.057472] ide1 at 0x170-0x177,0x376 on irq 15
[    5.063300] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 974kB Cache
[    5.072020] Uniform CD-ROM driver Revision: 3.20
[    7.671081] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    7.680523] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    7.688269] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    7.694910] Driver 'sd' needs updating - please use bus_type methods
[    7.701566] Driver 'sr' needs updating - please use bus_type methods
[    7.708162] ata_piix 0000:00:1f.1: version 2.12
[    7.708162] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.714844] ata_piix 0000:00:1f.1: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
[    7.722590] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 0 (errno=-16)
[    7.730141] ata_piix 0000:00:1f.1: BAR 2: can't reserve I/O region [0x170-0x177]
[    7.737861] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 1 (errno=-16)
[    7.746104] ata_piix 0000:00:1f.1: no available native port
[    7.753958] Fusion MPT base driver 3.04.07
[    7.757293] Copyright (c) 1999-2008 LSI Corporation
[    7.761619] Fusion MPT SPI Host driver 3.04.07
[    7.767994] Fusion MPT SAS Host driver 3.04.07
[    7.772700] vendor=8086 device=244e
[    7.776036] found new irq_cfg for irq 17
[    7.776040]  0 add_pin_to_irq: irq 17 --> apic 0 pin 17
[    7.776047] found new irq_desc for irq 17
[    7.776056] ohci1394 0000:09:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.837304] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[dc040000-dc0407ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    7.854831] ieee1394: raw1394: /dev/raw1394 device initialized
[    7.861257] usbcore: registered new interface driver usblp
[    7.864371] Initializing USB Mass Storage driver...
[    7.871561] usbcore: registered new interface driver usb-storage
[    7.877802] USB Mass Storage support registered.
[    7.883427] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    7.893355] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.896706] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.904589] mice: PS/2 mouse device common for all mice
[    8.264580] md: linear personality registered for level -1
[    8.265864] md: raid0 personality registered for level 0
[    8.272529] md: raid1 personality registered for level 1
[    8.278027] md: raid10 personality registered for level 10
[    8.339999] raid6: int64x1   2954 MB/s
[    8.399999] raid6: int64x2   3542 MB/s
[    8.459999] raid6: int64x4   3432 MB/s
[    8.519999] raid6: int64x8   2319 MB/s
[    8.579999] raid6: sse2x1    3637 MB/s
[    8.639999] raid6: sse2x2    7362 MB/s
[    8.700418] raid6: sse2x4    8743 MB/s
[    8.703333] raid6: using algorithm sse2x4 (8743 MB/s)
[    8.707697] md: raid6 personality registered for level 6
[    8.716276] md: raid5 personality registered for level 5
[    8.721774] md: raid4 personality registered for level 4
[    8.723967] md: multipath personality registered for level -4
[    8.732811] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    8.741824] cpuidle: using governor ladder
[    8.744461] cpuidle: using governor menu
[    8.748811] usbcore: registered new interface driver usbhid
[    8.754641] usbhid: v2.6:USB HID core driver
[    8.759372] oprofile: using NMI interrupt.
[    8.763967] TCP cubic registered
[    8.767922] NET: Registered protocol family 10
[    8.771676] IPv6 over IPv4 tunneling driver
[    8.777922] NET: Registered protocol family 17
[    8.782537] RPC: Registered udp transport module.
[    8.787891] RPC: Registered tcp transport module.
[    8.794588] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    8.801365] Freeing unused kernel memory: 672k freed
[    8.804896] Write protecting the kernel read-only data: 5576k
[    9.035910] vendor=8086 device=4021
[    9.035910] arcmsr 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.035910] arcmsr 0000:01:00.0: setting latency timer to 64
[    9.047290] ARECA RAID ADAPTER0: FIRMWARE VERSION V1.44 2008-1-31  
[    9.059982] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    9.059989]  Driver Version 1.20.00.15 2008/02/27
[    9.060416] scsi 0:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
[    9.060207] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    9.061041] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    9.061457] sd 0:0:0:0: [sda] Write Protect is off
[    9.061457] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    9.060000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.061457] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    9.061457] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    9.060207] sd 0:0:0:0: [sda] Write Protect is off
[    9.060207] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    9.061457] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.061457]  sda:<7>ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e08100002824f8]
[    9.450808]  sda1 sda2 sda3 sda4
[    9.454374] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.456849] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.456849] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    9.456849] scsi 0:0:16:0: Attached scsi generic sg1 type 3
[    9.521250] 3ware Storage Controller device driver for Linux v1.26.02.002.
[    9.532143] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[    9.548653] Adaptec aacraid driver 1.1-5[2456]-ms
[    9.653333] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    9.656275] SGI XFS Quota Management subsystem
[    9.669306] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    9.669306] Copyright (c) 1999-2006 Intel Corporation.
[   13.883324] kjournald starting.  Commit interval 5 seconds
[   13.883324] EXT3-fs: mounted filesystem with ordered data mode.
[   22.158124] found new irq_cfg for irq 19
[   22.158124]  0 add_pin_to_irq: irq 19 --> apic 0 pin 19
[   22.158124] found new irq_desc for irq 19
[   22.158124] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.163542] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   22.163542] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[   22.163542] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   22.171457] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[   22.171457] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   22.171457] vendor=8086 device=3518
[   22.171457] vendor=8086 device=3500
[   22.171457] vendor=8086 device=4029
[   22.171457] e1000e 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   22.171457] e1000e 0000:06:00.0: setting latency timer to 64
[   22.247915] 0000:06:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:14
[   22.247915] 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   22.247915] 0000:06:00.0: eth0: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   22.247915] vendor=8086 device=3518
[   22.247915] vendor=8086 device=3500
[   22.247915] vendor=8086 device=4029
[   22.247915] e1000e 0000:06:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.247915] e1000e 0000:06:00.1: setting latency timer to 64
[   22.321248] 0000:06:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:15
[   22.321248] 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   22.321248] 0000:06:00.1: eth1: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   23.093333] EXT3 FS on sda3, internal journal
[   23.244790] SMsC 37B787 watchdog component driver 1.1 initialising...
[   23.244790] smsc37b787_wdt: Unable to register miscdev on minor 130
[   23.634789] XFS mounting filesystem sda4
[   23.763214] Ending clean XFS mount for filesystem: sda4
[   23.846924] Adding 31999992k swap on /dev/sda2.  Priority:-1 extents:1 across:31999992k
[   27.620000] found new irq_cfg for irq 6291712
[   27.620000] found new irq_desc for irq 6291712
[   27.673651] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.790417] 0000:06:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   30.793544] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   40.923341] eth0: no IPv6 routers present
[   62.888260] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   62.894694] NFSD: starting 90-second grace period

--WYTEVAkct0FjGQmd--
