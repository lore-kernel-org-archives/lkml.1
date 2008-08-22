Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYHVBA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYHVBA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbYHVBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:00:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYHVBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:00:18 -0400
Date: Thu, 21 Aug 2008 15:00:14 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822010014.GH23377@hoblitt.com>
References: <bug-11388-27@http.bugzilla.kernel.org/> <20080820180405.7f164450.akpm@linux-foundation.org> <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com> <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com> <20080821205558.GC23377@hoblitt.com> <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com> <20080821233317.GE23377@hoblitt.com> <20080822001047.GF23377@hoblitt.com> <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com> <20080822002952.GG23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <20080822002952.GG23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have applied your patch to the tip tree and rebuilt.  Still no msr
dump.

-J

--
On Thu, Aug 21, 2008 at 02:29:52PM -1000, Joshua Hoblitt wrote:
> Lol.  No - I thought you implied it was in the tip tree.  Sigh.  I'll
> try again.
> 
> -J
> 
> --
> On Thu, Aug 21, 2008 at 05:28:51PM -0700, Yinghai Lu wrote:
> > On Thu, Aug 21, 2008 at 5:10 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
> > > The dmesg from the tip kernel is attached and it's at least larger than
> > > the last builds dmesg.
> > 
> > did you apply my debug patch?
> > you should get msr print out...
> > 
> > YH

--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.27-rc4-tip-dirty.dmesg"

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
[    0.000000] Detected 3192.003 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Memory: 3342444k/3406848k available (3830k kernel code, 64012k reserved, 2175k data, 672k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.006666] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.00 BogoMIPS (lpj=10640010)
[    0.013090] Security Framework initialized
[    0.016665] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.021482] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.026664] Mount-cache hash table entries: 256
[    0.029998] Initializing cgroup subsys ns
[    0.033331] Initializing cgroup subsys cpuacct
[    0.036664] Initializing cgroup subsys memory
[    0.039997] Initializing cgroup subsys devices
[    0.043330] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.048295] CPU: L2 cache: 6144K
[    0.051718] CPU 0/0 -> Node 0
[    0.054884] CPU: Physical Processor ID: 0
[    0.059078] CPU: Processor Core ID: 0
[    0.062932] CPU0: Thermal monitoring enabled (TM2)
[    0.066662] using mwait in idle threads.
[    0.069995] ACPI: Core revision 20080609
[    0.082433] Setting APIC routing to flat
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
[    0.133324] APIC timer calibration result 24937581
[    0.133324] Detected 24.937 MHz APIC timer.
[    0.136657] Booting processor 1/4 ip 6000
[    0.149990] Initializing CPU#1
[    0.149990] Calibrating delay using timer specific routine.. 6386.12 BogoMIPS (lpj=10640193)
[    0.149990] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.149990] CPU: L2 cache: 6144K
[    0.149990] CPU 1/4 -> Node 0
[    0.149990] CPU: Physical Processor ID: 1
[    0.149990] CPU: Processor Core ID: 0
[    0.149990] CPU1: Thermal monitoring enabled (TM2)
[    0.149990] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.233318] CPU1: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.243317] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.246829] Booting processor 2/1 ip 6000
[    0.263316] Initializing CPU#2
[    0.263316] Calibrating delay using timer specific routine.. 6386.09 BogoMIPS (lpj=10640154)
[    0.263316] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.263316] CPU: L2 cache: 6144K
[    0.263316] CPU 2/1 -> Node 0
[    0.263316] CPU: Physical Processor ID: 0
[    0.263316] CPU: Processor Core ID: 1
[    0.263316] CPU2: Thermal monitoring enabled (TM2)
[    0.263316] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.344816] CPU2: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.353310] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.356643] Booting processor 3/5 ip 6000
[    0.369975] Initializing CPU#3
[    0.369975] Calibrating delay using timer specific routine.. 6386.10 BogoMIPS (lpj=10640161)
[    0.369975] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.369975] CPU: L2 cache: 6144K
[    0.369975] CPU 3/5 -> Node 0
[    0.369975] CPU: Physical Processor ID: 1
[    0.369975] CPU: Processor Core ID: 1
[    0.369975] CPU3: Thermal monitoring enabled (TM2)
[    0.369975] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.453303] CPU3: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.459970] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.463303] Booting processor 4/2 ip 6000
[    0.476635] Initializing CPU#4
[    0.476635] Calibrating delay using timer specific routine.. 6386.09 BogoMIPS (lpj=10640144)
[    0.476635] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.476635] CPU: L2 cache: 6144K
[    0.476635] CPU 4/2 -> Node 0
[    0.476635] CPU: Physical Processor ID: 0
[    0.476635] CPU: Processor Core ID: 2
[    0.476635] CPU4: Thermal monitoring enabled (TM2)
[    0.476635] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.559967] CPU4: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.566633] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.569967] Booting processor 5/6 ip 6000
[    0.583295] Initializing CPU#5
[    0.583295] Calibrating delay using timer specific routine.. 6386.07 BogoMIPS (lpj=10640124)
[    0.583295] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.583295] CPU: L2 cache: 6144K
[    0.583295] CPU 5/6 -> Node 0
[    0.583295] CPU: Physical Processor ID: 1
[    0.583295] CPU: Processor Core ID: 2
[    0.583295] CPU5: Thermal monitoring enabled (TM2)
[    0.583295] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.666633] CPU5: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.673300] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.676633] Booting processor 6/3 ip 6000
[    0.689955] Initializing CPU#6
[    0.689955] Calibrating delay using timer specific routine.. 6386.07 BogoMIPS (lpj=10640124)
[    0.689955] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.689955] CPU: L2 cache: 6144K
[    0.689955] CPU 6/3 -> Node 0
[    0.689955] CPU: Physical Processor ID: 0
[    0.689955] CPU: Processor Core ID: 3
[    0.689955] CPU6: Thermal monitoring enabled (TM2)
[    0.689955] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.773300] CPU6: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.779967] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    0.783300] Booting processor 7/7 ip 6000
[    0.796614] Initializing CPU#7
[    0.796614] Calibrating delay using timer specific routine.. 6386.11 BogoMIPS (lpj=10640182)
[    0.796614] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.796614] CPU: L2 cache: 6144K
[    0.796614] CPU 7/7 -> Node 0
[    0.796614] CPU: Physical Processor ID: 1
[    0.796614] CPU: Processor Core ID: 3
[    0.796614] CPU7: Thermal monitoring enabled (TM2)
[    0.796614] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.879967] CPU7: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.886633] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    0.889967] Brought up 8 CPUs
[    0.893127] Total of 8 processors activated (51093.68 BogoMIPS).
[    0.896634] net_namespace: 864 bytes
[    0.899967] xor: automatically using best checksumming function: generic_sse
[    0.919003]    generic_sse: 11872.800 MB/sec
[    0.923300] xor: using function: generic_sse (11872.800 MB/sec)
[    0.926633] NET: Registered protocol family 16
[    0.929967] No dock devices found.
[    0.933300] ACPI: bus type pci registered
[    0.936633] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 8
[    0.939967] PCI: MCFG area at e0000000 reserved in E820
[    0.943300] PCI: Using MMCONFIG at e0000000 - e08fffff
[    0.946633] PCI: Using configuration type 1 for base access
[    0.953300] ACPI: EC: Look up EC in DSDT
[    0.956633] ACPI: Interpreter enabled
[    0.959967] ACPI: (supports S0 S3 S4 S5)
[    0.963300] ACPI: Using IOAPIC for interrupt routing
[    0.969967] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.973300] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.976633] pci 0000:00:00.0: PME# disabled
[    0.979967] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.983300] pci 0000:00:01.0: PME# disabled
[    0.986633] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.989967] pci 0000:00:05.0: PME# disabled
[    0.993300] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.996633] pci 0000:00:09.0: PME# disabled
[    0.999967] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.003300] pci 0000:00:1b.0: PME# disabled
[    1.006633] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.009967] pci 0000:00:1c.0: PME# disabled
[    1.013300] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.016633] pci 0000:00:1d.7: PME# disabled
[    1.019967] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.019967] pci 0000:01:00.0: supports D1
[    1.019967] PCI: bridge 0000:00:01.0 32bit mmio: [dc100000, dc1fffff]
[    1.023300] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.026633] pci 0000:03:00.0: PME# disabled
[    1.029967] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    1.033300] pci 0000:03:00.3: PME# disabled
[    1.036633] PCI: bridge 0000:00:09.0 io port: [2000, 2fff]
[    1.039967] PCI: bridge 0000:00:09.0 32bit mmio: [dc200000, dc3fffff]
[    1.043300] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.046633] pci 0000:04:00.0: PME# disabled
[    1.049967] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
[    1.053300] pci 0000:04:02.0: PME# disabled
[    1.056633] PCI: bridge 0000:03:00.0 io port: [2000, 2fff]
[    1.059967] PCI: bridge 0000:03:00.0 32bit mmio: [dc200000, dc2fffff]
[    1.063300] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.066633] pci 0000:06:00.0: PME# disabled
[    1.069967] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    1.073300] pci 0000:06:00.1: PME# disabled
[    1.076633] PCI: bridge 0000:04:02.0 io port: [2000, 2fff]
[    1.079967] PCI: bridge 0000:04:02.0 32bit mmio: [dc200000, dc2fffff]
[    1.083300] pci 0000:09:05.0: supports D1
[    1.083300] pci 0000:09:05.0: supports D2
[    1.083300] pci 0000:09:06.0: supports D2
[    1.083300] pci 0000:09:06.0: PME# supported from D2 D3hot D3cold
[    1.086633] pci 0000:09:06.0: PME# disabled
[    1.089967] pci 0000:00:1e.0: transparent bridge
[    1.093300] PCI: bridge 0000:00:1e.0 io port: [3000, 3fff]
[    1.096633] PCI: bridge 0000:00:1e.0 32bit mmio: [dc000000, dc0fffff]
[    1.099967] PCI: bridge 0000:00:1e.0 64bit mmio pref: [d8000000, dbffffff]
[    1.103300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.103300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.103300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    1.103300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.104010] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0._PRT]
[    1.104195] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD0._PRT]
[    1.104463] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD2._PRT]
[    1.104813] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMF3._PRT]
[    1.105290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.105857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.113300] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.119752] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.126417] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.133099] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.139759] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15)
[    1.146424] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15)
[    1.152859] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
[    1.159752] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *9
[    1.166633] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.169967] pnp: PnP ACPI init
[    1.173279] ACPI: bus type pnp registered
[    1.179967] pnp: PnP ACPI: found 11 devices
[    1.183300] ACPI: ACPI bus type pnp unregistered
[    1.186633] SCSI subsystem initialized
[    1.189967] libata version 3.00 loaded.
[    1.189967] usbcore: registered new interface driver usbfs
[    1.193300] usbcore: registered new interface driver hub
[    1.196633] usbcore: registered new device driver usb
[    1.199967] PCI: Using ACPI for IRQ routing
[    1.218715] PCI-GART: No AMD northbridge found.
[    1.223300] hpet clockevent registered
[    1.223300] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.228475] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.233300] ACPI: RTC can wake from S4
[    1.244882] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    1.248222] system 00:01: ioport range 0x800-0x80f has been reserved
[    1.254771] system 00:01: ioport range 0x1000-0x107f has been reserved
[    1.261422] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    1.268151] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    1.274872] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    1.282705] system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    1.290524] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.298349] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.305674] system 00:01: iomem range 0xfec88000-0xfec88fff has been reserved
[    1.313012] system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
[    1.320342] system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
[    1.332484] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.334892] pci 0000:00:01.0:   IO window: disabled
[    1.339968] pci 0000:00:01.0:   MEM window: 0xdc100000-0xdc1fffff
[    1.346259] pci 0000:00:01.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    1.354179] pci 0000:00:05.0: PCI bridge, secondary bus 0000:02
[    1.360300] pci 0000:00:05.0:   IO window: disabled
[    1.365379] pci 0000:00:05.0:   MEM window: disabled
[    1.374717] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.380313] pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
[    1.386432] pci 0000:04:00.0:   IO window: disabled
[    1.391510] pci 0000:04:00.0:   MEM window: disabled
[    1.396674] pci 0000:04:00.0:   PREFETCH window: disabled
[    1.402276] pci 0000:04:02.0: PCI bridge, secondary bus 0000:06
[    1.408392] pci 0000:04:02.0:   IO window: 0x2000-0x2fff
[    1.413904] pci 0000:04:02.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.420197] pci 0000:04:02.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.428122] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    1.434245] pci 0000:03:00.0:   IO window: 0x2000-0x2fff
[    1.439763] pci 0000:03:00.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.446053] pci 0000:03:00.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.453970] pci 0000:03:00.3: PCI bridge, secondary bus 0000:07
[    1.460088] pci 0000:03:00.3:   IO window: disabled
[    1.465168] pci 0000:03:00.3:   MEM window: disabled
[    1.470332] pci 0000:03:00.3:   PREFETCH window: disabled
[    1.475931] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    1.482571] pci 0000:00:09.0:   IO window: 0x2000-0x2fff
[    1.488091] pci 0000:00:09.0:   MEM window: 0xdc200000-0xdc3fffff
[    1.494393] pci 0000:00:09.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.502310] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    1.508425] pci 0000:00:1c.0:   IO window: disabled
[    1.513500] pci 0000:00:1c.0:   MEM window: disabled
[    1.518654] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.524259] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    1.530377] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
[    1.535887] pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
[    1.542182] pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
[    1.550105] found new irq_cfg for irq 16
[    1.550114]  0 add_pin_to_irq: irq 16 --> apic 0 pin 16
[    1.550127] found new irq_desc for irq 16
[    1.550142] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.557012] pci 0000:00:01.0: setting latency timer to 64
[    1.557019] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.563917] pci 0000:00:05.0: setting latency timer to 64
[    1.563922] pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.570818] pci 0000:00:09.0: setting latency timer to 64
[    1.570824] vendor=8086 device=4029
[    1.574510] pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.581417] pci 0000:03:00.0: setting latency timer to 64
[    1.581424] vendor=8086 device=3500
[    1.585108] vendor=8086 device=4029
[    1.588793] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.595689] pci 0000:04:00.0: setting latency timer to 64
[    1.595696] vendor=8086 device=3500
[    1.599376] vendor=8086 device=4029
[    1.603056] found new irq_cfg for irq 18
[    1.603058]  0 add_pin_to_irq: irq 18 --> apic 0 pin 18
[    1.603063] found new irq_desc for irq 18
[    1.603069] pci 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.609965] pci 0000:04:02.0: setting latency timer to 64
[    1.609974] pci 0000:03:00.3: setting latency timer to 64
[    1.609986] found new irq_cfg for irq 21
[    1.610000]  0 add_pin_to_irq: irq 21 --> apic 0 pin 21
[    1.610015] found new irq_desc for irq 21
[    1.610032] pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.616882] pci 0000:00:1c.0: setting latency timer to 64
[    1.616889] pci 0000:00:1e.0: setting latency timer to 64
[    1.616897] bus: 00 index 0 io port: [0, ffff]
[    1.621539] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    1.626955] bus: 01 index 0 mmio: [0, 0]
[    1.631078] bus: 01 index 1 mmio: [dc100000, dc1fffff]
[    1.636412] bus: 01 index 2 mmio: [d1000000, d10fffff]
[    1.641750] bus: 01 index 3 mmio: [0, 0]
[    1.645873] bus: 02 index 0 mmio: [0, 0]
[    1.649990] bus: 02 index 1 mmio: [0, 0]
[    1.654109] bus: 02 index 2 mmio: [0, 0]
[    1.658230] bus: 02 index 3 mmio: [0, 0]
[    1.662348] bus: 03 index 0 io port: [2000, 2fff]
[    1.667245] bus: 03 index 1 mmio: [dc200000, dc3fffff]
[    1.672577] bus: 03 index 2 mmio: [d1100000, d11fffff]
[    1.677915] bus: 03 index 3 mmio: [0, 0]
[    1.682029] bus: 04 index 0 io port: [2000, 2fff]
[    1.686928] bus: 04 index 1 mmio: [dc200000, dc2fffff]
[    1.692258] bus: 04 index 2 mmio: [d1100000, d11fffff]
[    1.697600] bus: 04 index 3 mmio: [0, 0]
[    1.701721] bus: 05 index 0 mmio: [0, 0]
[    1.705839] bus: 05 index 1 mmio: [0, 0]
[    1.709955] bus: 05 index 2 mmio: [0, 0]
[    1.714070] bus: 05 index 3 mmio: [0, 0]
[    1.718186] bus: 06 index 0 io port: [2000, 2fff]
[    1.723086] bus: 06 index 1 mmio: [dc200000, dc2fffff]
[    1.728425] bus: 06 index 2 mmio: [d1100000, d11fffff]
[    1.733763] bus: 06 index 3 mmio: [0, 0]
[    1.738390] bus: 07 index 0 mmio: [0, 0]
[    1.742506] bus: 07 index 1 mmio: [0, 0]
[    1.746618] bus: 07 index 2 mmio: [0, 0]
[    1.750740] bus: 07 index 3 mmio: [0, 0]
[    1.754860] bus: 08 index 0 mmio: [0, 0]
[    1.758982] bus: 08 index 1 mmio: [0, 0]
[    1.763097] bus: 08 index 2 mmio: [0, 0]
[    1.767214] bus: 08 index 3 mmio: [0, 0]
[    1.771340] bus: 09 index 0 io port: [3000, 3fff]
[    1.776235] bus: 09 index 1 mmio: [dc000000, dc0fffff]
[    1.781569] bus: 09 index 2 mmio: [d8000000, dbffffff]
[    1.786908] bus: 09 index 3 io port: [0, ffff]
[    1.791553] bus: 09 index 4 mmio: [0, ffffffffffffffff]
[    1.796987] NET: Registered protocol family 2
[    1.838223] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.843532] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.854890] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.861233] TCP: Hash tables configured (established 524288 bind 65536)
[    1.868057] TCP reno registered
[    1.881545] NET: Registered protocol family 1
[    1.884977] checking if image is initramfs... it is
[    1.938223] Freeing initrd memory: 1917k freed
[    1.941956] pci 0000:09:05.0: Boot video device
[    1.945345] input: Power Button (FF) as /class/input/input0
[    1.948325] ACPI: Power Button (FF) [PWRF]
[    1.955648] input: Power Button (CM) as /class/input/input1
[    1.958933] ACPI: Power Button (CM) [PWRB]
[    1.966437] found new irq_cfg for irq 20
[    1.966437]  0 add_pin_to_irq: irq 20 --> apic 0 pin 20
[    1.966437] found new irq_desc for irq 20
[    1.966437] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.964114] Switched to high resolution mode on CPU 2
[    1.966445] Switched to high resolution mode on CPU 3
[    1.966443] Switched to high resolution mode on CPU 6
[    1.964258] Switched to high resolution mode on CPU 5
[    1.964674] Switched to high resolution mode on CPU 4
[    1.964749] Switched to high resolution mode on CPU 7
[    1.964966] Switched to high resolution mode on CPU 1
[    1.969989] Switched to high resolution mode on CPU 0
[    1.969998] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.970011] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.228142] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.228142] ehci_hcd 0000:00:1d.7: debug port 1
[    2.228142] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.228142] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc608000
[    2.228142] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.228142] usb usb1: configuration #1 chosen from 1 choice
[    2.228142] hub 1-0:1.0: USB hub found
[    2.228142] hub 1-0:1.0: 8 ports detected
[    2.228142] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.228142] USB Universal Host Controller Interface driver v3.0
[    2.228142] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.228142] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.228142] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.228142] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.228142] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[    2.228142] usb usb2: configuration #1 chosen from 1 choice
[    2.228142] hub 2-0:1.0: USB hub found
[    2.228142] hub 2-0:1.0: 2 ports detected
[    2.289994] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.293342] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.293348] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.298045] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.306325] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[    2.311447] usb usb3: configuration #1 chosen from 1 choice
[    2.318062] hub 3-0:1.0: USB hub found
[    2.322075] hub 3-0:1.0: 2 ports detected
[    2.431244] found new irq_cfg for irq 22
[    2.431244]  0 add_pin_to_irq: irq 22 --> apic 0 pin 22
[    2.431244] found new irq_desc for irq 22
[    2.431244] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.436673] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.436680] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.441397] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.449669] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[    2.454791] usb usb4: configuration #1 chosen from 1 choice
[    2.461395] hub 4-0:1.0: USB hub found
[    2.465407] hub 4-0:1.0: 2 ports detected
[    2.574578] found new irq_cfg for irq 23
[    2.574578]  0 add_pin_to_irq: irq 23 --> apic 0 pin 23
[    2.574578] found new irq_desc for irq 23
[    2.574578] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.580007] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.580013] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.584712] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.593003] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
[    2.598150] usb usb5: configuration #1 chosen from 1 choice
[    2.604718] hub 5-0:1.0: USB hub found
[    2.608733] hub 5-0:1.0: 2 ports detected
[    2.717911] Simple Boot Flag at 0x40 set to 0x80
[    2.724792] audit: initializing netlink socket (disabled)
[    2.731484] type=2000 audit(1219366433.726:1): initialized
[    2.743333] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.753334] VFS: Disk quotas dquot_6.5.1
[    2.755221] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.766667] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.770319] msgmni has been set to 6531
[    2.774691] async_tx: api initialized (async)
[    2.778128] io scheduler noop registered
[    2.782240] io scheduler anticipatory registered
[    2.787039] io scheduler deadline registered
[    2.792639] io scheduler cfq registered (default)
[    2.797918] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    2.797918] pcieport-driver 0000:00:01.0: found MSI capability
[    2.804128] found new irq_cfg for irq 33024
[    2.804128] found new irq_desc for irq 33024
[    2.804128] pci_express 0000:00:01.0:pcie00: allocate port service
[    2.804584] pci_express 0000:00:01.0:pcie01: allocate port service
[    2.804584] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    2.804584] pcieport-driver 0000:00:05.0: found MSI capability
[    2.807391] found new irq_cfg for irq 164096
[    2.807405] found new irq_desc for irq 164096
[    2.807426] pci_express 0000:00:05.0:pcie00: allocate port service
[    2.808096] pci_express 0000:00:05.0:pcie01: allocate port service
[    2.808923] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    2.809117] pcieport-driver 0000:00:09.0: found MSI capability
[    2.815332] found new irq_cfg for irq 295168
[    2.815343] found new irq_desc for irq 295168
[    2.815361] pci_express 0000:00:09.0:pcie00: allocate port service
[    2.815698] pci_express 0000:00:09.0:pcie01: allocate port service
[    2.816495] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.816495] pcieport-driver 0000:00:1c.0: found MSI capability
[    2.822721] found new irq_cfg for irq 917760
[    2.822722] found new irq_desc for irq 917760
[    2.822722] pci_express 0000:00:1c.0:pcie00: allocate port service
[    2.822722] pci_express 0000:00:1c.0:pcie02: allocate port service
[    2.822722] pci_express 0000:00:1c.0:pcie03: allocate port service
[    2.822722] pcieport-driver 0000:03:00.0: setting latency timer to 64
[    2.822722] pci_express 0000:03:00.0:pcie11: allocate port service
[    2.822722] pcieport-driver 0000:04:00.0: setting latency timer to 64
[    2.822722] pcieport-driver 0000:04:00.0: found MSI capability
[    2.829140] found new irq_cfg for irq 4194560
[    2.829140] found new irq_desc for irq 4194560
[    2.829140] pci_express 0000:04:00.0:pcie21: allocate port service
[    2.829140] pcieport-driver 0000:04:02.0: setting latency timer to 64
[    2.829140] pcieport-driver 0000:04:02.0: found MSI capability
[    2.835337] found new irq_cfg for irq 4260096
[    2.835337] found new irq_desc for irq 4260096
[    2.835337] pci_express 0000:04:02.0:pcie21: allocate port service
[    2.835337] aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC support
[    2.835337] aer 0000:00:05.0:pcie01: AER service couldn't init device: no _OSC support
[    2.837364] aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
[    2.837924] ACPI: SSDT CFF04DBE, 01DD (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
[    2.846662] processor ACPI0007:00: registered as cooling_device0
[    2.849521] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.856998] ACPI: SSDT CFF04F9B, 016E (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
[    2.870207] processor ACPI0007:01: registered as cooling_device1
[    2.871125] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.880402] ACPI: SSDT CFF05109, 016E (r1  PmRef  Cpu2Ist     3000 INTL 20050228)
[    2.890408] processor ACPI0007:02: registered as cooling_device2
[    2.892720] ACPI: Processor [CPU2] (supports 8 throttling states)
[    2.901088] ACPI: SSDT CFF05277, 016E (r1  PmRef  Cpu3Ist     3000 INTL 20050228)
[    2.911304] processor ACPI0007:03: registered as cooling_device3
[    2.917297] ACPI: Processor [CPU3] (supports 8 throttling states)
[    2.923619] ACPI: SSDT CFF053E5, 016E (r1  PmRef  CPU4Ist     3000 INTL 20050228)
[    2.937917] processor ACPI0007:04: registered as cooling_device4
[    2.939955] ACPI: Processor [CPU4] (supports 8 throttling states)
[    2.948396] ACPI: SSDT CFF05553, 016E (r1  PmRef  CPU5Ist     3000 INTL 20050228)
[    2.958119] processor ACPI0007:05: registered as cooling_device5
[    2.961626] ACPI: Processor [CPU5] (supports 8 throttling states)
[    2.971364] ACPI: SSDT CFF056C1, 016E (r1  PmRef  Cpu6Ist     3000 INTL 20050228)
[    2.983963] processor ACPI0007:06: registered as cooling_device6
[    2.983967] ACPI: Processor [CPU6] (supports 8 throttling states)
[    2.992445] ACPI: SSDT CFF0582F, 016E (r1  PmRef  Cpu7Ist     3000 INTL 20050228)
[    3.003745] processor ACPI0007:07: registered as cooling_device7
[    3.008459] ACPI: Processor [CPU7] (supports 8 throttling states)
[    3.070637] Non-volatile memory driver v1.2
[    3.075359] intel_rng: FWH not detected
[    3.078812] Linux agpgart interface v0.103
[    3.084583] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    3.091250] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.097917] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.103398] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.109592] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.127501] FDC 0 is a post-1991 82077
[    3.136839] brd: module loaded
[    3.141461] loop: module loaded
[    3.143964] tun: Universal TUN/TAP device driver, 1.6
[    3.147985] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.156178] console [netcon0] enabled
[    3.159608] netconsole: network logging started
[    3.164325] Uniform Multi-Platform E-IDE driver
[    3.169522] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.179678] Probing IDE interface ide0...
[    3.879494] hda: Optiarc DVD RW AD-7590A, ATAPI CD/DVD-ROM drive
[    4.524564] Probing IDE interface ide1...
[    5.056668] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.060420] ide1 at 0x170-0x177,0x376 on irq 15
[    5.066634] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 974kB Cache
[    5.074600] Uniform CD-ROM driver Revision: 3.20
[    7.728124] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    7.734949] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    7.742659] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    7.749038] Driver 'sd' needs updating - please use bus_type methods
[    7.755696] Driver 'sr' needs updating - please use bus_type methods
[    7.762300] ata_piix 0000:00:1f.1: version 2.12
[    7.762300] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.768982] ata_piix 0000:00:1f.1: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
[    7.776518] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 0 (errno=-16)
[    7.784758] ata_piix 0000:00:1f.1: BAR 2: can't reserve I/O region [0x170-0x177]
[    7.792481] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 1 (errno=-16)
[    7.800724] ata_piix 0000:00:1f.1: no available native port
[    7.807931] Fusion MPT base driver 3.04.07
[    7.810977] Copyright (c) 1999-2008 LSI Corporation
[    7.815751] Fusion MPT SPI Host driver 3.04.07
[    7.821617] Fusion MPT SAS Host driver 3.04.07
[    7.826829] vendor=8086 device=244e
[    7.830165] found new irq_cfg for irq 17
[    7.830169]  0 add_pin_to_irq: irq 17 --> apic 0 pin 17
[    7.830177] found new irq_desc for irq 17
[    7.830187] ohci1394 0000:09:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.890637] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[dc040000-dc0407ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    7.909020] ieee1394: raw1394: /dev/raw1394 device initialized
[    7.914584] usbcore: registered new interface driver usblp
[    7.917907] Initializing USB Mass Storage driver...
[    7.924887] usbcore: registered new interface driver usb-storage
[    7.931126] USB Mass Storage support registered.
[    7.936947] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    7.946731] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.950619] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.957923] mice: PS/2 mouse device common for all mice
[    8.316658] md: linear personality registered for level -1
[    8.319171] md: raid0 personality registered for level 0
[    8.325837] md: raid1 personality registered for level 1
[    8.331336] md: raid10 personality registered for level 10
[    8.393333] raid6: int64x1   2954 MB/s
[    8.453333] raid6: int64x2   3541 MB/s
[    8.513333] raid6: int64x4   3431 MB/s
[    8.573333] raid6: int64x8   2300 MB/s
[    8.633333] raid6: sse2x1    3625 MB/s
[    8.693333] raid6: sse2x2    7342 MB/s
[    8.753534] raid6: sse2x4    8725 MB/s
[    8.756874] raid6: using algorithm sse2x4 (8725 MB/s)
[    8.760823] md: raid6 personality registered for level 6
[    8.769041] md: raid5 personality registered for level 5
[    8.774538] md: raid4 personality registered for level 4
[    8.777091] md: multipath personality registered for level -4
[    8.785215] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    8.794213] cpuidle: using governor ladder
[    8.797563] cpuidle: using governor menu
[    8.801923] usbcore: registered new interface driver usbhid
[    8.807756] usbhid: v2.6:USB HID core driver
[    8.812469] oprofile: using NMI interrupt.
[    8.817063] TCP cubic registered
[    8.821255] NET: Registered protocol family 10
[    8.824775] IPv6 over IPv4 tunneling driver
[    8.831255] NET: Registered protocol family 17
[    8.835637] RPC: Registered udp transport module.
[    8.840903] RPC: Registered tcp transport module.
[    8.847922] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    8.854088] Freeing unused kernel memory: 672k freed
[    8.857881] Write protecting the kernel read-only data: 5576k
[    9.091458] vendor=8086 device=4021
[    9.091458] arcmsr 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.091458] arcmsr 0000:01:00.0: setting latency timer to 64
[    9.104583] ARECA RAID ADAPTER0: FIRMWARE VERSION V1.44 2008-1-31  
[    9.116650] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    9.116657]  Driver Version 1.20.00.15 2008/02/27
[    9.117082] scsi 0:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
[    9.116874] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    9.117707] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    9.118124] sd 0:0:0:0: [sda] Write Protect is off
[    9.118124] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    9.116668] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.118124] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    9.118124] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    9.116874] sd 0:0:0:0: [sda] Write Protect is off
[    9.116874] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    9.118124] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.118124]  sda:<7>ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e08100002824f8]
[    9.500831]  sda1 sda2 sda3 sda4
[    9.503517] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.503517] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.504167] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    9.504583] scsi 0:0:16:0: Attached scsi generic sg1 type 3
[    9.572084] 3ware Storage Controller device driver for Linux v1.26.02.002.
[    9.583333] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[    9.598220] Adaptec aacraid driver 1.1-5[2456]-ms
[    9.703333] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    9.706666] SGI XFS Quota Management subsystem
[    9.719602] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    9.719602] Copyright (c) 1999-2006 Intel Corporation.
[   13.929972] kjournald starting.  Commit interval 5 seconds
[   13.929972] EXT3-fs: mounted filesystem with ordered data mode.
[   22.301270] found new irq_cfg for irq 19
[   22.301270]  0 add_pin_to_irq: irq 19 --> apic 0 pin 19
[   22.301270] found new irq_desc for irq 19
[   22.301270] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.309893] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   22.309893] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[   22.309893] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   22.314574] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[   22.314574] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   22.314574] vendor=8086 device=3518
[   22.314574] vendor=8086 device=3500
[   22.314574] vendor=8086 device=4029
[   22.314574] e1000e 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   22.314574] e1000e 0000:06:00.0: setting latency timer to 64
[   22.391040] 0000:06:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:14
[   22.391040] 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   22.391040] 0000:06:00.0: eth0: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   22.391040] vendor=8086 device=3518
[   22.391040] vendor=8086 device=3500
[   22.391040] vendor=8086 device=4029
[   22.391040] e1000e 0000:06:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.391040] e1000e 0000:06:00.1: setting latency timer to 64
[   22.464373] 0000:06:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:15
[   22.464373] 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   22.464373] 0000:06:00.1: eth1: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   23.297291] EXT3 FS on sda3, internal journal
[   23.463957] SMsC 37B787 watchdog component driver 1.1 initialising...
[   23.463957] smsc37b787_wdt: Unable to register miscdev on minor 130
[   23.840414] XFS mounting filesystem sda4
[   23.974769] Ending clean XFS mount for filesystem: sda4
[   24.050423] Adding 31999992k swap on /dev/sda2.  Priority:-1 extents:1 across:31999992k
[   27.870000] found new irq_cfg for irq 6291712
[   27.870000] found new irq_desc for irq 6291712
[   27.923748] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.684580] 0000:06:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   30.689997] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   41.540007] eth0: no IPv6 routers present
[   63.181453] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   63.196662] NFSD: starting 90-second grace period
[  157.601435] kjournald starting.  Commit interval 5 seconds
[  157.599978] EXT3 FS on sda1, internal journal
[  157.599978] EXT3-fs: mounted filesystem with ordered data mode.

--O3RTKUHj+75w1tg5--
