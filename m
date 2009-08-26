Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZHZL6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZHZL6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbZHZL6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:58:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZHZL6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:58:24 -0400
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
From: Eric Paris <eparis@redhat.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
In-Reply-To: <1251248426.3623.47.camel@localhost.localdomain>
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
	 <4A8EFFB2.4040100@suse.de>
	 <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
	 <4A8F1081.3020803@suse.de>
	 <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
	 <1251248426.3623.47.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-MUD/dW/s68FIv3icQ/5n"
Date: Wed, 26 Aug 2009 07:58:14 -0400
Message-Id: <1251287895.2270.25.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MUD/dW/s68FIv3icQ/5n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Wed, 2009-08-26 at 09:00 +0800, ykzhao wrote:
> On Mon, 2009-08-24 at 22:36 +0800, Eric Paris wrote:
> > On Sat, 2009-08-22 at 01:24 +0400, Alexey Starikovskiy wrote:
> > > Eric Paris пишет:

> > It does stop my slew of warnings.  Not sure it completely fixes my
> > problems though....
> Will you please add the boot option of initcall_debug and attach the
> output of dmesg?
> It will be helpful if you can attach the output of acpidump.
> Thanks.

Here is booting a kernel without the change.  I don't see acpidump
packaged in fedora.  Do you have a pointer to the source or maybe a
static binary?  I'll look myself later in the afternoon.

-Eric

--=-MUD/dW/s68FIv3icQ/5n
Content-Disposition: attachment; filename="serial0.txt"
Content-Type: text/plain; name="serial0.txt"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc7-next-20090825 (paris@paris.rdu.redhat.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-44)) #50 SMP PREEMPT Tue Aug 25 17:12:01 EDT 2009
[    0.000000] Command line: ro root=/dev/VolGroup00/LogVol00 audit=1 console=tty0 console=ttyS0,9600 enforcing=0 initcall_debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fef0000 (usable)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feff000 - 000000007ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x80000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 00000000000e0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fef0000 (usable)
[    0.000000]  modified: 000000007fef0000 - 000000007feff000 (ACPI data)
[    0.000000]  modified: 000000007feff000 - 000000007ff00000 (ACPI NVS)
[    0.000000]  modified: 000000007ff00000 - 0000000080000000 (usable)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-0000000080000000
[    0.000000] RAMDISK: 37c11000 - 37fef062
[    0.000000] ACPI: RSDP 00000000000f6a30 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 000000007fefa138 0003C (v01 INTEL  440BX    06040000 VMW  01324272)
[    0.000000] ACPI: FACP 000000007fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  000F4240)
[    0.000000] ACPI: DSDT 000000007fefa22a 04C6E (v01 PTLTD  Custom   06040000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000007fefffc0 00040
[    0.000000] ACPI: BOOT 000000007fefa202 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: APIC 000000007fefa1a4 0005E (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000080000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [0000000000010000 - 0000000000027fff]
[    0.000000]   bootmap [0000000000028000 -  0000000000037fff] pages 10
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0080000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0002643830]    TEXT DATA BSS ==> [0001000000 - 0002643830]
[    0.000000]   #3 [0037c11000 - 0037fef062]          RAMDISK ==> [0037c11000 - 0037fef062]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [0002644000 - 00026441e8]              BRK ==> [0002644000 - 00026441e8]
[    0.000000]   #6 [0000100000 - 0000501000]          PGTABLE ==> [0000100000 - 0000501000]
[    0.000000] found SMP MP-table at [ffff8800000f6aa0] f6aa0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fef0
[    0.000000]     0: 0x0007ff00 -> 0x00080000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff880006400000 s1927008 r8192 d22688 u2097152
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 508699
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/VolGroup00/LogVol00 audit=1 console=tty0 console=ttyS0,9600 enforcing=0 initcall_debug
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 2004256k/2097152k available (5332k kernel code, 516k absent, 92380k reserved, 2789k data, 3304k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Frequency read from the hypervisor
[    0.000000] Detected 2666.725 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191
[    0.000999] ... CLASSHASH_SIZE:          4096
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000999] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000999] ... CHAINHASH_SIZE:          16384
[    0.000999]  memory used by lock dependency info: 6367 kB
[    0.000999]  per task-struct memory footprint: 2688 bytes
[    0.001084] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.45 BogoMIPS (lpj=2666725)
[    0.003531] Security Framework initialized
[    0.004098] SELinux:  Initializing.
[    0.006088] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009618] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.011232] Mount-cache hash table entries: 256
[    0.017461] Initializing cgroup subsys ns
[    0.018056] Initializing cgroup subsys cpuacct
[    0.019032] Initializing cgroup subsys devices
[    0.020067] Initializing cgroup subsys freezer
[    0.021220] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.023008] CPU: L2 cache: 4096K
[    0.024032] CPU 0/0x0 -> Node 0
[    0.025048] mce: CPU supports 0 MCE banks
[    0.026066] Performance Counters: Core2 events, Intel PMU driver.
[    0.028037] ... version:                 2
[    0.029007] ... bit width:               40
[    0.030008] ... generic counters:        2
[    0.031006] ... value mask:              000000ffffffffff
[    0.032015] ... max period:              000000007fffffff
[    0.033006] ... fixed-purpose counters:  3
[    0.034006] ... counter mask:            0000000700000003
[    0.040889] ACPI: Core revision 20090625
[    0.042363] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.043100] no locks held by swapper/0.
[    0.044004] Modules linked in:
[    0.045384] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.046004] Call Trace:
[    0.047055]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.048031]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.049027]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.050007]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.051016]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.052007]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.053014]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.054006]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.055019]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.056005]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.057009]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.058005]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.059039]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.060004]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.061006]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.062004]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.063017]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.064004]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.065004]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.066004]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.071009] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.072070] no locks held by swapper/0.
[    0.072999] Modules linked in:
[    0.075000] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.076008] Call Trace:
[    0.077003]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.078002]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.079017]  [<ffffffff812d184c>] ? acpi_os_release_object+0x1e/0x34
[    0.080010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.081001]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.082001]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.083001]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.084009]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.085001]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.086001]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.087000]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.088008]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.089001]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.090000]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.091000]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.092007]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.092999]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.094000]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.094999]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.096007]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.100015] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.101150] no locks held by swapper/0.
[    0.102116] Modules linked in:
[    0.103368] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.103994] Call Trace:
[    0.105007]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.105998]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.106997]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.108011]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.109005]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.109997]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.110997]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.111997]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.113004]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.113997]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.114996]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.115995]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.117004]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.117996]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.118995]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.119996]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.121004]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.121995]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.122995]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.123995]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.125003]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.129042] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.130154] no locks held by swapper/0.
[    0.131100] Modules linked in:
[    0.132538] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.132990] Call Trace:
[    0.134004]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.134994]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.135994]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.136993]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.138000]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.138993]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.139993]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.140992]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.142000]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.143006]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.143992]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.144991]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.146000]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.146992]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.147991]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.148992]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.149999]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.150991]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.151991]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.152991]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.153998]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.158069] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.159139] no locks held by swapper/0.
[    0.160068] Modules linked in:
[    0.161359] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.161986] Call Trace:
[    0.162998]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.163989]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.164989]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.165988]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.166996]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.167988]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.168988]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.169988]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.170995]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.171988]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.172988]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.173987]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.174995]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.175987]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.176986]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.177987]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.178994]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.179986]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.181984]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.182994]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.183985]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.187043] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.188138] no locks held by swapper/0.
[    0.188991] Modules linked in:
[    0.191384] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.191990] Call Trace:
[    0.192986]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.193992]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.194984]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.195992]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.196984]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.197983]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.198983]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.199991]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.200983]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.201983]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.202983]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.203990]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.204983]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.205983]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.206982]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.207991]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.208982]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.209982]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.211991]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.212981]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.213981]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.216058] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.217098] no locks held by swapper/0.
[    0.217977] Modules linked in:
[    0.219978] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.220985] Call Trace:
[    0.221981]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.222980]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.223980]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.224987]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.225979]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.226979]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.227979]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.228986]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.229978]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.230979]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.231978]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.232986]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.233978]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.234978]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.235977]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.236986]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.237978]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.238977]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.239977]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.240985]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.241977]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.245100] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.247013] no locks held by swapper/0.
[    0.247972] Modules linked in:
[    0.249345] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.249981] Call Trace:
[    0.250976]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.251976]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.252975]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.253999]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.254975]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.255975]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.256975]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.257982]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.258974]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.259974]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.260974]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.261981]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.262974]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.263976]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.264975]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.266016]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.266976]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.267971]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.268971]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.269976]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.270969]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.274050] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.275099] no locks held by swapper/0.
[    0.275966] Modules linked in:
[    0.276967] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.277966] Call Trace:
[    0.278977]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.279970]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.280978]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.281967]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.282973]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.283967]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.284967]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.285966]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.286972]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.287967]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.288966]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.289966]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.290972]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.291966]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.292965]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.293966]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.294971]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.295965]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.296965]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.297965]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.298970]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.303341] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.304090] no locks held by swapper/0.
[    0.305004] Modules linked in:
[    0.306241] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.306961] Call Trace:
[    0.307972]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.308964]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.309963]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.310962]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.311969]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.312963]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.313962]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.314962]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.315968]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.316982]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.318002]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.319007]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.320016]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.321011]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.322010]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.323011]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.324016]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.325011]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.326010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.327010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.328017]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.332064] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.333135] no locks held by swapper/0.
[    0.334135] Modules linked in:
[    0.335297] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.336008] Call Trace:
[    0.337018]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.338011]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.339010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.340010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.341016]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.342010]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.343010]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.344010]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.345016]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.346011]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.347010]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.348010]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.349017]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.350011]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.351020]  [<ffffffff812f3a57>] acpi_ns_parse_table+0x2f/0x60
[    0.352011]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.353017]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.354010]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.355010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.356010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.357016]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.361100] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.362134] no locks held by swapper/0.
[    0.363116] Modules linked in:
[    0.364009] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.365008] Call Trace:
[    0.366018]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.367011]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.368011]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.369010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.370016]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.371010]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.372010]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.373010]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.374017]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.375011]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.376010]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.377010]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.378017]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.379011]  [<ffffffff812f3a6b>] acpi_ns_parse_table+0x43/0x60
[    0.380011]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.381011]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.382016]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.383010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.384010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.385010]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.390023] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.391266] no locks held by swapper/0.
[    0.392118] Modules linked in:
[    0.393305] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.394008] Call Trace:
[    0.395017]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.396011]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.397010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.398010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.399016]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.400010]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.401011]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.402010]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.403016]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.404011]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.405010]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.406010]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.407016]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.408011]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.409010]  [<ffffffff812f3a6b>] acpi_ns_parse_table+0x43/0x60
[    0.410011]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.411016]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.412010]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.413010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.414010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.415016]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.419061] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.420130] no locks held by swapper/0.
[    0.421116] Modules linked in:
[    0.422063] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.423008] Call Trace:
[    0.424018]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.425012]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.426011]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.427010]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.428016]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.429011]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.430010]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.431013]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.432017]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.433011]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.434011]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.435010]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.436017]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.437011]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.438010]  [<ffffffff812f3a6b>] acpi_ns_parse_table+0x43/0x60
[    0.439011]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.440016]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.441010]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.442010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.443010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.444016]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.448022] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.449145] no locks held by swapper/0.
[    0.450117] Modules linked in:
[    0.451299] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.452008] Call Trace:
[    0.453018]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.454011]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.455010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.456010]  [<ffffffff812f641b>] ? acpi_ps_free_op+0x35/0x4b
[    0.457017]  [<ffffffff812f5f65>] ? acpi_ps_delete_parse_tree+0x51/0x84
[    0.458011]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.459010]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.460010]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.461016]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.462011]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.463010]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.464010]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.465016]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.466011]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.467010]  [<ffffffff812f3a6b>] acpi_ns_parse_table+0x43/0x60
[    0.468010]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.469016]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.470010]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.471010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.472010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.473016]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.477582] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.478130] no locks held by swapper/0.
[    0.479120] Modules linked in:
[    0.480294] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.481008] Call Trace:
[    0.482018]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.483011]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.484010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.485010]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.486017]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.487011]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.488010]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.489011]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.490017]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.491011]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.492010]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.493010]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.494016]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.495011]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.496010]  [<ffffffff812f3a6b>] acpi_ns_parse_table+0x43/0x60
[    0.497011]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.498016]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.499010]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.500010]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.501010]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.502016]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150
[    0.510434] Setting APIC routing to flat
[    0.513000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.524182] CPU0: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.528000] calling  kmemcheck_init+0x0/0x90 @ 1
[    0.528013] kmemcheck: Limiting number of CPUs to 1.
[    0.530014] kmemcheck: Initialized
[    0.531017] initcall kmemcheck_init+0x0/0x90 returned 0 after 2929 usecs
[    0.532000] calling  migration_init+0x0/0x80 @ 1
[    0.534486] initcall migration_init+0x0/0x80 returned 0 after 0 usecs
[    0.535000] calling  spawn_ksoftirqd+0x0/0x80 @ 1
[    0.537134] initcall spawn_ksoftirqd+0x0/0x80 returned 0 after 976 usecs
[    0.539028] calling  init_call_single_data+0x0/0x110 @ 1
[    0.541021] initcall init_call_single_data+0x0/0x110 returned 0 after 0 usecs
[    0.542000] calling  spawn_softlockup_task+0x0/0xa0 @ 1
[    0.544166] initcall spawn_softlockup_task+0x0/0xa0 returned 0 after 0 usecs
[    0.545000] calling  relay_init+0x0/0x40 @ 1
[    0.546000] initcall relay_init+0x0/0x40 returned 0 after 0 usecs
[    0.547453] calling  tracer_alloc_buffers+0x0/0x230 @ 1
[    0.549197] initcall tracer_alloc_buffers+0x0/0x230 returned 0 after 976 usecs
[    0.551016] calling  init_trace_printk+0x0/0x40 @ 1
[    0.552000] initcall init_trace_printk+0x0/0x40 returned 0 after 0 usecs
[    0.553000] Brought up 1 CPUs
[    0.555011] Total of 1 processors activated (5333.45 BogoMIPS).
[    0.571095] khelper used greatest stack depth: 4528 bytes left
[    0.576472] calling  init_mmap_min_addr+0x0/0x40 @ 1
[    0.577000] initcall init_mmap_min_addr+0x0/0x40 returned 0 after 0 usecs
[    0.578000] calling  net_ns_init+0x0/0x120 @ 1
[    0.580612] initcall net_ns_init+0x0/0x120 returned 0 after 0 usecs
[    0.582154] calling  pci_reboot_init+0x0/0x40 @ 1
[    0.583000] initcall pci_reboot_init+0x0/0x40 returned 0 after 0 usecs
[    0.584000] calling  init_lapic_sysfs+0x0/0x60 @ 1
[    0.587699] initcall init_lapic_sysfs+0x0/0x60 returned 0 after 1953 usecs
[    0.589157] calling  print_banner+0x0/0x10 @ 1
[    0.590000] Booting paravirtualized kernel on bare hardware
[    0.591000] initcall print_banner+0x0/0x10 returned 0 after 976 usecs
[    0.592000] calling  init_smp_flush+0x0/0x70 @ 1
[    0.593000] initcall init_smp_flush+0x0/0x70 returned 0 after 0 usecs
[    0.595028] calling  alloc_frozen_cpus+0x0/0x30 @ 1
[    0.596000] initcall alloc_frozen_cpus+0x0/0x30 returned 0 after 0 usecs
[    0.597000] calling  sysctl_init+0x0/0x60 @ 1
[    0.599365] initcall sysctl_init+0x0/0x60 returned 0 after 0 usecs
[    0.600000] calling  ksysfs_init+0x0/0xf0 @ 1
[    0.602133] initcall ksysfs_init+0x0/0xf0 returned 0 after 976 usecs
[    0.603000] calling  async_init+0x0/0x90 @ 1
[    0.605731] initcall async_init+0x0/0x90 returned 0 after 976 usecs
[    0.607141] calling  init_jiffies_clocksource+0x0/0x40 @ 1
[    0.608000] initcall init_jiffies_clocksource+0x0/0x40 returned 0 after 0 usecs
[    0.609010] calling  pm_init+0x0/0xa0 @ 1
[    0.611311] initcall pm_init+0x0/0xa0 returned 0 after 0 usecs
[    0.613079] calling  init_hw_breakpoint+0x0/0x40 @ 1
[    0.615021] initcall init_hw_breakpoint+0x0/0x40 returned 0 after 0 usecs
[    0.616000] calling  filelock_init+0x0/0x60 @ 1
[    0.618081] initcall filelock_init+0x0/0x60 returned 0 after 0 usecs
[    0.619000] calling  init_misc_binfmt+0x0/0x70 @ 1
[    0.620000] initcall init_misc_binfmt+0x0/0x70 returned 0 after 0 usecs
[    0.621000] calling  init_script_binfmt+0x0/0x40 @ 1
[    0.623012] initcall init_script_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.624000] calling  init_elf_binfmt+0x0/0x40 @ 1
[    0.625000] initcall init_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.626000] calling  init_compat_elf_binfmt+0x0/0x40 @ 1
[    0.627000] initcall init_compat_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.628000] calling  debugfs_init+0x0/0x90 @ 1
[    0.630072] initcall debugfs_init+0x0/0x90 returned 0 after 976 usecs
[    0.632011] calling  securityfs_init+0x0/0x80 @ 1
[    0.634036] initcall securityfs_init+0x0/0x80 returned 0 after 976 usecs
[    0.635000] calling  random32_init+0x0/0x150 @ 1
[    0.636000] initcall random32_init+0x0/0x150 returned 0 after 0 usecs
[    0.637000] calling  gnttab_init+0x0/0x1f0 @ 1
[    0.638000] initcall gnttab_init+0x0/0x1f0 returned -19 after 0 usecs
[    0.639000] calling  early_resume_init+0x0/0x1e0 @ 1
[    0.641106] Time:  7:49:32  Date: 08/26/09
[    0.643012] initcall early_resume_init+0x0/0x1e0 returned 0 after 1953 usecs
[    0.645010] calling  cpuidle_init+0x0/0x70 @ 1
[    0.647089] initcall cpuidle_init+0x0/0x70 returned 0 after 0 usecs
[    0.648000] calling  sock_init+0x0/0x90 @ 1
[    0.651307] initcall sock_init+0x0/0x90 returned 0 after 1953 usecs
[    0.652401] calling  net_inuse_init+0x0/0x50 @ 1
[    0.654024] initcall net_inuse_init+0x0/0x50 returned 0 after 976 usecs
[    0.655000] calling  netpoll_init+0x0/0x70 @ 1
[    0.656000] initcall netpoll_init+0x0/0x70 returned 0 after 0 usecs
[    0.658017] calling  netlink_proto_init+0x0/0x220 @ 1
[    0.660403] NET: Registered protocol family 16
[    0.662296] initcall netlink_proto_init+0x0/0x220 returned 0 after 1953 usecs
[    0.664011] calling  bdi_class_init+0x0/0x70 @ 1
[    0.667767] initcall bdi_class_init+0x0/0x70 returned 0 after 976 usecs
[    0.668000] calling  kobject_uevent_init+0x0/0x80 @ 1
[    0.670084] initcall kobject_uevent_init+0x0/0x80 returned 0 after 0 usecs
[    0.672011] calling  pcibus_class_init+0x0/0x50 @ 1
[    0.675501] initcall pcibus_class_init+0x0/0x50 returned 0 after 1953 usecs
[    0.677029] calling  pci_driver_init+0x0/0x40 @ 1
[    0.682073] initcall pci_driver_init+0x0/0x40 returned 0 after 2929 usecs
[    0.683000] calling  xenbus_probe_init+0x0/0x140 @ 1
[    0.684000] initcall xenbus_probe_init+0x0/0x140 returned -19 after 0 usecs
[    0.685000] calling  tty_class_init+0x0/0x60 @ 1
[    0.688279] initcall tty_class_init+0x0/0x60 returned 0 after 1953 usecs
[    0.690076] calling  vtconsole_class_init+0x0/0x110 @ 1
[    0.694197] initcall vtconsole_class_init+0x0/0x110 returned 0 after 2929 usecs
[    0.695011] calling  register_node_type+0x0/0xa0 @ 1
[    0.697618] initcall register_node_type+0x0/0xa0 returned 0 after 0 usecs
[    0.699152] calling  amd_postcore_init+0x0/0x9d0 @ 1
[    0.700000] initcall amd_postcore_init+0x0/0x9d0 returned 0 after 0 usecs
[    0.702018] calling  arch_kdebugfs_init+0x0/0x2e0 @ 1
[    0.704329] initcall arch_kdebugfs_init+0x0/0x2e0 returned 0 after 0 usecs
[    0.705000] calling  mtrr_if_init+0x0/0x90 @ 1
[    0.707061] initcall mtrr_if_init+0x0/0x90 returned 0 after 0 usecs
[    0.708000] calling  ffh_cstate_init+0x0/0x60 @ 1
[    0.710022] initcall ffh_cstate_init+0x0/0x60 returned 0 after 0 usecs
[    0.711000] calling  acpi_pci_init+0x0/0xa0 @ 1
[    0.713082] ACPI: bus type pci registered
[    0.714000] initcall acpi_pci_init+0x0/0xa0 returned 0 after 976 usecs
[    0.715514] calling  setup_vcpu_hotplug_event+0x0/0x50 @ 1
[    0.716000] initcall setup_vcpu_hotplug_event+0x0/0x50 returned -19 after 0 usecs
[    0.717010] calling  dmi_id_init+0x0/0x3d0 @ 1
[    0.721569] initcall dmi_id_init+0x0/0x3d0 returned 0 after 2929 usecs
[    0.723082] calling  dma_bus_init+0x0/0x70 @ 1
[    0.726244] initcall dma_bus_init+0x0/0x70 returned 0 after 1953 usecs
[    0.728094] calling  dma_channel_table_init+0x0/0x150 @ 1
[    0.730015] initcall dma_channel_table_init+0x0/0x150 returned 0 after 976 usecs
[    0.732020] calling  pci_arch_init+0x0/0x90 @ 1
[    0.734172] PCI: Using configuration type 1 for base access
[    0.735000] initcall pci_arch_init+0x0/0x90 returned 0 after 976 usecs
[    0.736000] calling  topology_init+0x0/0x100 @ 1
[    0.740608] initcall topology_init+0x0/0x100 returned 0 after 2929 usecs
[    0.742116] calling  mtrr_init_finialize+0x0/0x70 @ 1
[    0.743000] initcall mtrr_init_finialize+0x0/0x70 returned 0 after 0 usecs
[    0.744000] calling  param_sysfs_init+0x0/0x2c0 @ 1
[    0.840433] initcall param_sysfs_init+0x0/0x2c0 returned 0 after 92773 usecs
[    0.842182] calling  pm_sysrq_init+0x0/0x50 @ 1
[    0.843000] initcall pm_sysrq_init+0x0/0x50 returned 0 after 0 usecs
[    0.845020] calling  init_slow_work+0x0/0x60 @ 1
[    0.847012] initcall init_slow_work+0x0/0x60 returned 0 after 0 usecs
[    0.848000] calling  default_bdi_init+0x0/0x60 @ 1
[    0.851849] initcall default_bdi_init+0x0/0x60 returned 0 after 1953 usecs
[    0.853154] calling  init_bio+0x0/0x1b0 @ 1
[    0.855544] bio: create slab <bio-0> at 0
[    0.857387] initcall init_bio+0x0/0x1b0 returned 0 after 2929 usecs
[    0.858000] calling  fsnotify_init+0x0/0x40 @ 1
[    0.859000] initcall fsnotify_init+0x0/0x40 returned 0 after 0 usecs
[    0.861020] calling  fsnotify_notification_init+0x0/0xb0 @ 1
[    0.862000] initcall fsnotify_notification_init+0x0/0xb0 returned 0 after 0 usecs
[    0.863000] calling  cryptomgr_init+0x0/0x40 @ 1
[    0.865035] initcall cryptomgr_init+0x0/0x40 returned 0 after 0 usecs
[    0.866000] calling  blk_settings_init+0x0/0x60 @ 1
[    0.867000] initcall blk_settings_init+0x0/0x60 returned 0 after 0 usecs
[    0.868000] calling  blk_ioc_init+0x0/0x60 @ 1
[    0.869000] initcall blk_ioc_init+0x0/0x60 returned 0 after 0 usecs
[    0.870000] calling  blk_softirq_init+0x0/0xe0 @ 1
[    0.872015] initcall blk_softirq_init+0x0/0xe0 returned 0 after 0 usecs
[    0.874011] calling  blk_iopoll_setup+0x0/0xe0 @ 1
[    0.875000] initcall blk_iopoll_setup+0x0/0xe0 returned 0 after 0 usecs
[    0.876000] calling  genhd_device_init+0x0/0xb0 @ 1
[    0.879790] initcall genhd_device_init+0x0/0xb0 returned 0 after 1953 usecs
[    0.881069] calling  blk_dev_integrity_init+0x0/0x60 @ 1
[    0.883039] initcall blk_dev_integrity_init+0x0/0x60 returned 0 after 0 usecs
[    0.885039] calling  pci_slot_init+0x0/0x70 @ 1
[    0.887034] initcall pci_slot_init+0x0/0x70 returned 0 after 976 usecs
[    0.889019] calling  fbmem_init+0x0/0xd0 @ 1
[    0.892401] initcall fbmem_init+0x0/0xd0 returned 0 after 1953 usecs
[    0.894035] calling  acpi_init+0x0/0x283 @ 1
[    1.019398] ACPI: BIOS _OSI(Linux) query ignored
[    1.039253] ACPI: Interpreter enabled
[    1.041032] ACPI: (supports S0 S1 S5)
[    1.044060] ACPI: Using IOAPIC for interrupt routing
[    1.198752] initcall acpi_init+0x0/0x283 returned 0 after 295898 usecs
[    1.199000] calling  dock_init+0x0/0xb4 @ 1
[    1.202919] ACPI: No dock devices found.
[    1.203000] initcall dock_init+0x0/0xb4 returned 0 after 2929 usecs
[    1.205012] calling  acpi_pci_root_init+0x0/0x4f @ 1
[    1.245341] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.254333] pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
[    1.256010] pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
[    1.270391] pci 0000:00:11.0: transparent bridge
[    1.381990] initcall acpi_pci_root_init+0x0/0x4f returned 0 after 170898 usecs
[    1.383129] calling  acpi_pci_link_init+0x0/0x6a @ 1
[    1.387659] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
[    1.395530] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 14 15)
[    1.401910] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)
[    1.407894] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
[    1.414000] initcall acpi_pci_link_init+0x0/0x6a returned 0 after 28320 usecs
[    1.415168] calling  pnp_init+0x0/0x40 @ 1
[    1.418358] initcall pnp_init+0x0/0x40 returned 0 after 976 usecs
[    1.419001] calling  setup_shutdown_event+0x0/0x40 @ 1
[    1.420001] initcall setup_shutdown_event+0x0/0x40 returned 0 after 0 usecs
[    1.422021] calling  balloon_init+0x0/0x240 @ 1
[    1.423001] initcall balloon_init+0x0/0x240 returned -19 after 0 usecs
[    1.424001] calling  misc_init+0x0/0xe0 @ 1
[    1.426669] initcall misc_init+0x0/0xe0 returned 0 after 976 usecs
[    1.428086] calling  vga_arb_device_init+0x0/0xb0 @ 1
[    1.432527] vgaarb: device added: PCI:0000:00:0f.0,decodes=io+mem,owns=io+mem,locks=none
[    1.434076] vgaarb: loaded
[    1.435011] initcall vga_arb_device_init+0x0/0xb0 returned 0 after 5859 usecs
[    1.436001] calling  cn_init+0x0/0x120 @ 1
[    1.438277] initcall cn_init+0x0/0x120 returned 0 after 976 usecs
[    1.439001] calling  init_scsi+0x0/0xd0 @ 1
[    1.445580] SCSI subsystem initialized
[    1.447108] initcall init_scsi+0x0/0xd0 returned 0 after 5859 usecs
[    1.448001] calling  ata_init+0x0/0x3d0 @ 1
[    1.450443] initcall ata_init+0x0/0x3d0 returned 0 after 976 usecs
[    1.452152] calling  init_pcmcia_cs+0x0/0x70 @ 1
[    1.454552] initcall init_pcmcia_cs+0x0/0x70 returned 0 after 976 usecs
[    1.456076] calling  usb_init+0x0/0x1d0 @ 1
[    1.460768] usbcore: registered new interface driver usbfs
[    1.463469] usbcore: registered new interface driver hub
[    1.466848] usbcore: registered new device driver usb
[    1.468069] initcall usb_init+0x0/0x1d0 returned 0 after 10742 usecs
[    1.470012] calling  serio_init+0x0/0xd0 @ 1
[    1.473486] initcall serio_init+0x0/0xd0 returned 0 after 1953 usecs
[    1.475082] calling  input_init+0x0/0x180 @ 1
[    1.478259] initcall input_init+0x0/0x180 returned 0 after 1953 usecs
[    1.479001] calling  rtc_init+0x0/0xa0 @ 1
[    1.482235] initcall rtc_init+0x0/0xa0 returned 0 after 1953 usecs
[    1.484126] calling  power_supply_class_init+0x0/0x60 @ 1
[    1.487103] initcall power_supply_class_init+0x0/0x60 returned 0 after 1953 usecs
[    1.488001] calling  thermal_init+0x0/0x80 @ 1
[    1.491463] initcall thermal_init+0x0/0x80 returned 0 after 1953 usecs
[    1.493165] calling  md_init+0x0/0x110 @ 1
[    1.495133] initcall md_init+0x0/0x110 returned 0 after 0 usecs
[    1.496001] calling  pci_subsys_init+0x0/0x170 @ 1
[    1.497001] PCI: Using ACPI for IRQ routing
[    1.500503] initcall pci_subsys_init+0x0/0x170 returned 0 after 2929 usecs
[    1.501001] calling  proto_init+0x0/0x40 @ 1
[    1.502001] initcall proto_init+0x0/0x40 returned 0 after 0 usecs
[    1.503001] calling  net_dev_init+0x0/0x230 @ 1
[    1.509798] initcall net_dev_init+0x0/0x230 returned 0 after 4882 usecs
[    1.511066] calling  neigh_init+0x0/0xa0 @ 1
[    1.513011] initcall neigh_init+0x0/0xa0 returned 0 after 0 usecs
[    1.514001] calling  fib_rules_init+0x0/0xd0 @ 1
[    1.516030] initcall fib_rules_init+0x0/0xd0 returned 0 after 0 usecs
[    1.517001] calling  pktsched_init+0x0/0xf0 @ 1
[    1.519057] initcall pktsched_init+0x0/0xf0 returned 0 after 976 usecs
[    1.521012] calling  tc_filter_init+0x0/0x80 @ 1
[    1.522001] initcall tc_filter_init+0x0/0x80 returned 0 after 0 usecs
[    1.523001] calling  tc_action_init+0x0/0x80 @ 1
[    1.524001] initcall tc_action_init+0x0/0x80 returned 0 after 0 usecs
[    1.525001] calling  genl_init+0x0/0xc0 @ 1
[    1.527242] initcall genl_init+0x0/0xc0 returned 0 after 976 usecs
[    1.528001] calling  cipso_v4_init+0x0/0xb0 @ 1
[    1.530073] initcall cipso_v4_init+0x0/0xb0 returned 0 after 976 usecs
[    1.531001] calling  netlbl_init+0x0/0xc0 @ 1
[    1.532001] NetLabel: Initializing
[    1.533001] NetLabel:  domain hash size = 128
[    1.534001] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.536352] NetLabel:  unlabeled traffic allowed by default
[    1.538012] initcall netlbl_init+0x0/0xc0 returned 0 after 5859 usecs
[    1.539001] calling  sysctl_init+0x0/0x70 @ 1
[    1.541015] initcall sysctl_init+0x0/0x70 returned 0 after 0 usecs
[    1.542001] calling  pci_iommu_init+0x0/0x50 @ 1
[    1.544265] initcall pci_iommu_init+0x0/0x50 returned 0 after 976 usecs
[    1.546012] calling  print_all_ICs+0x0/0x5c0 @ 1
[    1.548029] initcall print_all_ICs+0x0/0x5c0 returned 0 after 0 usecs
[    1.549001] calling  hpet_late_init+0x0/0x270 @ 1
[    1.551017] initcall hpet_late_init+0x0/0x270 returned -19 after 0 usecs
[    1.552001] calling  clocksource_done_booting+0x0/0x50 @ 1
[    1.554022] Switching to clocksource tsc
[    1.557676] initcall clocksource_done_booting+0x0/0x50 returned 0 after 3245 usecs
[    1.565392] calling  rb_init_debugfs+0x0/0x60 @ 1
[    1.567857] initcall rb_init_debugfs+0x0/0x60 returned 0 after 129 usecs
[    1.571075] calling  tracer_init_debugfs+0x0/0x380 @ 1
[    1.576649] initcall tracer_init_debugfs+0x0/0x380 returned 0 after 3049 usecs
[    1.580314] calling  init_trace_printk_function_export+0x0/0x60 @ 1
[    1.583254] initcall init_trace_printk_function_export+0x0/0x60 returned 0 after 54 usecs
[    1.587116] calling  event_trace_init+0x0/0x260 @ 1
[    1.657886] initcall event_trace_init+0x0/0x260 returned 0 after 66808 usecs
[    1.661177] calling  init_pipe_fs+0x0/0x80 @ 1
[    1.663836] initcall init_pipe_fs+0x0/0x80 returned 0 after 508 usecs
[    1.666811] calling  eventpoll_init+0x0/0xe0 @ 1
[    1.669149] initcall eventpoll_init+0x0/0xe0 returned 0 after 76 usecs
[    1.672306] calling  anon_inode_init+0x0/0x170 @ 1
[    1.675025] initcall anon_inode_init+0x0/0x170 returned 0 after 415 usecs
[    1.678140] calling  tomoyo_initerface_init+0x0/0x150 @ 1
[    1.680689] initcall tomoyo_initerface_init+0x0/0x150 returned 0 after 4 usecs
[    1.684368] calling  blk_scsi_ioctl_init+0x0/0x2b0 @ 1
[    1.686788] initcall blk_scsi_ioctl_init+0x0/0x2b0 returned 0 after 5 usecs
[    1.690362] calling  acpi_event_init+0x0/0xa7 @ 1
[    1.693108] initcall acpi_event_init+0x0/0xa7 returned 0 after 286 usecs
[    1.696150] calling  pnpacpi_init+0x0/0xc0 @ 1
[    1.698301] pnp: PnP ACPI init
[    1.700097] ACPI: bus type pnp registered
[    1.895252] pnp: PnP ACPI: found 12 devices
[    1.897445] ACPI: ACPI bus type pnp unregistered
[    1.899742] initcall pnpacpi_init+0x0/0xc0 returned 0 after 196680 usecs
[    1.902832] calling  pnp_system_init+0x0/0x40 @ 1
[    1.905463] system 00:01: ioport range 0x1000-0x103f has been reserved
[    1.908491] system 00:01: ioport range 0x1040-0x104f has been reserved
[    1.912124] initcall pnp_system_init+0x0/0x40 returned 0 after 6730 usecs
[    1.915592] calling  chr_dev_init+0x0/0xf0 @ 1
[    1.928380] initcall chr_dev_init+0x0/0xf0 returned 0 after 10340 usecs
[    1.931547] calling  firmware_class_init+0x0/0xb0 @ 1
[    1.934674] initcall firmware_class_init+0x0/0xb0 returned 0 after 699 usecs
[    1.937989] calling  init_acpi_pm_clocksource+0x0/0x130 @ 1
[    1.945217] initcall init_acpi_pm_clocksource+0x0/0x130 returned 0 after 4538 usecs
[    1.948907] calling  pcibios_assign_resources+0x0/0xb0 @ 1
[    1.951967] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.954850] pci 0000:00:01.0:   IO window: disabled
[    1.957425] pci 0000:00:01.0:   MEM window: disabled
[    1.959833] pci 0000:00:01.0:   PREFETCH window: disabled
[    1.962426] pci 0000:00:11.0: PCI bridge, secondary bus 0000:02
[    1.965173] pci 0000:00:11.0:   IO window: 0x2000-0x2fff
[    1.967939] pci 0000:00:11.0:   MEM window: 0xe8900000-0xe89fffff
[    1.970784] pci 0000:00:11.0:   PREFETCH window: 0x80000000-0x800fffff
[    1.974012] initcall pcibios_assign_resources+0x0/0xb0 returned 0 after 22018 usecs
[    1.977873] calling  sysctl_core_init+0x0/0x70 @ 1
[    1.980416] initcall sysctl_core_init+0x0/0x70 returned 0 after 249 usecs
[    1.983492] calling  inet_init+0x0/0x2a0 @ 1
[    1.986032] NET: Registered protocol family 2
[    1.989683] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    1.999080] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.011145] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    2.030717] TCP: Hash tables configured (established 262144 bind 65536)
[    2.033895] TCP reno registered
[    2.036823] initcall inet_init+0x0/0x2a0 returned 0 after 49877 usecs
[    2.039946] calling  af_unix_init+0x0/0x80 @ 1
[    2.059577] NET: Registered protocol family 1
[    2.062001] initcall af_unix_init+0x0/0x80 returned 0 after 19434 usecs
[    2.065062] calling  populate_rootfs+0x0/0x340 @ 1
[    2.068889] Trying to unpack rootfs image as initramfs...
[    2.422995] Freeing initrd memory: 3960k freed
[    2.429020] initcall populate_rootfs+0x0/0x340 returned 0 after 353177 usecs
[    2.432296] calling  calgary_fixup_tce_spaces+0x0/0x140 @ 1
[    2.434961] initcall calgary_fixup_tce_spaces+0x0/0x140 returned -19 after 5 usecs
[    2.438766] calling  i8259A_init_sysfs+0x0/0x50 @ 1
[    2.442709] initcall i8259A_init_sysfs+0x0/0x50 returned 0 after 1594 usecs
[    2.446146] calling  vsyscall_init+0x0/0x70 @ 1
[    2.448808] initcall vsyscall_init+0x0/0x70 returned 0 after 111 usecs
[    2.451793] calling  sbf_init+0x0/0x120 @ 1
[    2.453866] Simple Boot Flag at 0x36 set to 0x1
[    2.456112] initcall sbf_init+0x0/0x120 returned 0 after 2204 usecs
[    2.459163] calling  i8237A_init_sysfs+0x0/0x50 @ 1
[    2.462796] initcall i8237A_init_sysfs+0x0/0x50 returned 0 after 1292 usecs
[    2.466160] calling  add_rtc_cmos+0x0/0xf0 @ 1
[    2.468388] initcall add_rtc_cmos+0x0/0xf0 returned 0 after 11 usecs
[    2.471300] calling  cache_sysfs_init+0x0/0xd0 @ 1
[    2.477415] initcall cache_sysfs_init+0x0/0xd0 returned 0 after 3507 usecs
[    2.480760] calling  mce_init_device+0x0/0x200 @ 1
[    2.485756] initcall mce_init_device+0x0/0x200 returned 0 after 2563 usecs
[    2.489226] calling  threshold_init_device+0x0/0xc0 @ 1
[    2.491715] initcall threshold_init_device+0x0/0xc0 returned 0 after 0 usecs
[    2.494904] calling  thermal_throttle_init_device+0x0/0x110 @ 1
[    2.497828] initcall thermal_throttle_init_device+0x0/0x110 returned 0 after 0 usecs
[    2.501509] calling  msr_init+0x0/0x1e0 @ 1
[    2.505603] initcall msr_init+0x0/0x1e0 returned 0 after 1990 usecs
[    2.508830] calling  cpuid_init+0x0/0x1e0 @ 1
[    2.512751] initcall cpuid_init+0x0/0x1e0 returned 0 after 1763 usecs
[    2.515870] calling  ioapic_init_sysfs+0x0/0x110 @ 1
[    2.519763] initcall ioapic_init_sysfs+0x0/0x110 returned 0 after 1306 usecs
[    2.523105] calling  add_pcspkr+0x0/0x60 @ 1
[    2.525929] initcall add_pcspkr+0x0/0x60 returned 0 after 732 usecs
[    2.529210] calling  start_periodic_check_for_corruption+0x0/0x70 @ 1
[    2.532142] Scanning for low memory corruption every 60 seconds
[    2.534923] initcall start_periodic_check_for_corruption+0x0/0x70 returned 0 after 2721 usecs
[    2.539125] calling  audit_classes_init+0x0/0xe0 @ 1
[    2.541597] initcall audit_classes_init+0x0/0xe0 returned 0 after 92 usecs
[    2.544776] calling  init_vdso_vars+0x0/0x240 @ 1
[    2.547142] initcall init_vdso_vars+0x0/0x240 returned 0 after 87 usecs
[    2.550367] calling  ia32_binfmt_init+0x0/0x40 @ 1
[    2.552709] initcall ia32_binfmt_init+0x0/0x40 returned 0 after 53 usecs
[    2.555745] calling  sysenter_setup+0x0/0x370 @ 1
[    2.558023] initcall sysenter_setup+0x0/0x370 returned 0 after 17 usecs
[    2.561202] calling  init_sched_debug_procfs+0x0/0x60 @ 1
[    2.563808] initcall init_sched_debug_procfs+0x0/0x60 returned 0 after 46 usecs
[    2.567336] calling  proc_schedstat_init+0x0/0x50 @ 1
[    2.569970] initcall proc_schedstat_init+0x0/0x50 returned 0 after 38 usecs
[    2.573127] calling  proc_execdomains_init+0x0/0x50 @ 1
[    2.575649] initcall proc_execdomains_init+0x0/0x50 returned 0 after 67 usecs
[    2.578906] calling  ioresources_init+0x0/0x70 @ 1
[    2.581386] initcall ioresources_init+0x0/0x70 returned 0 after 67 usecs
[    2.584430] calling  uid_cache_init+0x0/0xa0 @ 1
[    2.586703] initcall uid_cache_init+0x0/0xa0 returned 0 after 40 usecs
[    2.589723] calling  init_posix_timers+0x0/0x210 @ 1
[    2.592336] initcall init_posix_timers+0x0/0x210 returned 0 after 66 usecs
[    2.595419] calling  init_posix_cpu_timers+0x0/0x130 @ 1
[    2.597949] initcall init_posix_cpu_timers+0x0/0x130 returned 0 after 0 usecs
[    2.601319] calling  nsproxy_cache_init+0x0/0x60 @ 1
[    2.603704] initcall nsproxy_cache_init+0x0/0x60 returned 0 after 20 usecs
[    2.606799] calling  create_proc_profile+0x0/0x350 @ 1
[    2.609233] initcall create_proc_profile+0x0/0x350 returned 0 after 0 usecs
[    2.612522] calling  timekeeping_init_device+0x0/0x50 @ 1
[    2.616586] initcall timekeeping_init_device+0x0/0x50 returned 0 after 1469 usecs
[    2.620566] calling  init_clocksource_sysfs+0x0/0x80 @ 1
[    2.624408] initcall init_clocksource_sysfs+0x0/0x80 returned 0 after 1294 usecs
[    2.628163] calling  init_timer_list_procfs+0x0/0x60 @ 1
[    2.631472] initcall init_timer_list_procfs+0x0/0x60 returned 0 after 34 usecs
[    2.634983] calling  init_tstats_procfs+0x0/0x60 @ 1
[    2.637376] initcall init_tstats_procfs+0x0/0x60 returned 0 after 35 usecs
[    2.641264] calling  lockdep_proc_init+0x0/0xb0 @ 1
[    2.643746] initcall lockdep_proc_init+0x0/0xb0 returned 0 after 161 usecs
[    2.646855] calling  futex_init+0x0/0xd0 @ 1
[    2.649066] initcall futex_init+0x0/0xd0 returned 0 after 100 usecs
[    2.652146] calling  proc_dma_init+0x0/0x50 @ 1
[    2.654383] initcall proc_dma_init+0x0/0x50 returned 0 after 33 usecs
[    2.657312] calling  proc_modules_init+0x0/0x50 @ 1
[    2.659695] initcall proc_modules_init+0x0/0x50 returned 0 after 32 usecs
[    2.662950] calling  kallsyms_init+0x0/0x50 @ 1
[    2.665196] initcall kallsyms_init+0x0/0x50 returned 0 after 33 usecs
[    2.668125] calling  crash_save_vmcoreinfo_init+0x0/0x4a0 @ 1
[    2.670854] initcall crash_save_vmcoreinfo_init+0x0/0x4a0 returned 0 after 29 usecs
[    2.674693] calling  crash_notes_memory_init+0x0/0x60 @ 1
[    2.677231] initcall crash_notes_memory_init+0x0/0x60 returned 0 after 9 usecs
[    2.680731] calling  pid_namespaces_init+0x0/0x60 @ 1
[    2.683333] initcall pid_namespaces_init+0x0/0x60 returned 0 after 54 usecs
[    2.686465] calling  audit_init+0x0/0x190 @ 1
[    2.688636] audit: initializing netlink socket (enabled)
[    2.691360] type=2000 audit(1251272972.691:1): initialized
[    2.694137] initcall audit_init+0x0/0x190 returned 0 after 5376 usecs
[    2.697069] calling  init_kprobes+0x0/0x1d0 @ 1
[    2.702981] initcall init_kprobes+0x0/0x1d0 returned 0 after 3636 usecs
[    2.705998] calling  hung_task_init+0x0/0x80 @ 1
[    2.708492] initcall hung_task_init+0x0/0x80 returned 0 after 223 usecs
[    2.711815] calling  utsname_sysctl_init+0x0/0x40 @ 1
[    2.714395] initcall utsname_sysctl_init+0x0/0x40 returned 0 after 119 usecs
[    2.717562] calling  init_markers+0x0/0x40 @ 1
[    2.719769] initcall init_markers+0x0/0x40 returned 0 after 0 usecs
[    2.722841] calling  init_tracepoints+0x0/0x40 @ 1
[    2.725143] initcall init_tracepoints+0x0/0x40 returned 0 after 4 usecs
[    2.728168] calling  init_lstats_procfs+0x0/0x50 @ 1
[    2.730573] initcall init_lstats_procfs+0x0/0x50 returned 0 after 39 usecs
[    2.733870] calling  init_events+0x0/0xb0 @ 1
[    2.736024] initcall init_events+0x0/0xb0 returned 0 after 28 usecs
[    2.738934] calling  init_sched_switch_trace+0x0/0x40 @ 1
[    2.741497] initcall init_sched_switch_trace+0x0/0x40 returned 0 after 32 usecs
[    2.745302] calling  perf_counter_sysfs_init+0x0/0x50 @ 1
[    2.747922] initcall perf_counter_sysfs_init+0x0/0x50 returned 0 after 76 usecs
[    2.751454] calling  init_per_zone_wmark_min+0x0/0xa0 @ 1
[    2.759073] initcall init_per_zone_wmark_min+0x0/0xa0 returned 0 after 4133 usecs
[    2.762721] calling  pdflush_init+0x0/0x50 @ 1
[    2.765466] initcall pdflush_init+0x0/0x50 returned 0 after 433 usecs
[    2.768485] calling  kswapd_init+0x0/0xb0 @ 1
[    2.770842] initcall kswapd_init+0x0/0xb0 returned 0 after 265 usecs
[    2.774000] calling  setup_vmstat+0x0/0x140 @ 1
[    2.776343] initcall setup_vmstat+0x0/0x140 returned 0 after 164 usecs
[    2.779346] calling  mm_sysfs_init+0x0/0x50 @ 1
[    2.781568] initcall mm_sysfs_init+0x0/0x50 returned 0 after 65 usecs
[    2.784731] calling  proc_vmalloc_init+0x0/0x50 @ 1
[    2.787094] initcall proc_vmalloc_init+0x0/0x50 returned 0 after 37 usecs
[    2.790189] calling  procswaps_init+0x0/0x50 @ 1
[    2.792439] initcall procswaps_init+0x0/0x50 returned 0 after 35 usecs
[    2.795688] calling  hugetlb_init+0x0/0x460 @ 1
[    2.797926] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.800996] initcall hugetlb_init+0x0/0x460 returned 0 after 3024 usecs
[    2.804225] calling  slab_proc_init+0x0/0x50 @ 1
[    2.806469] initcall slab_proc_init+0x0/0x50 returned 0 after 41 usecs
[    2.809452] calling  slab_sysfs_init+0x0/0x130 @ 1
[    2.889135] initcall slab_sysfs_init+0x0/0x130 returned 0 after 75581 usecs
[    2.892317] calling  fasync_init+0x0/0x60 @ 1
[    2.894709] initcall fasync_init+0x0/0x60 returned 0 after 71 usecs
[    2.897593] calling  proc_filesystems_init+0x0/0x50 @ 1
[    2.900110] initcall proc_filesystems_init+0x0/0x50 returned 0 after 44 usecs
[    2.903329] calling  dnotify_init+0x0/0xb0 @ 1
[    2.906973] initcall dnotify_init+0x0/0xb0 returned 0 after 1292 usecs
[    2.910205] calling  inotify_setup+0x0/0x40 @ 1
[    2.912394] initcall inotify_setup+0x0/0x40 returned 0 after 0 usecs
[    2.915460] calling  inotify_user_setup+0x0/0xf0 @ 1
[    2.918383] initcall inotify_user_setup+0x0/0xf0 returned 0 after 536 usecs
[    2.921524] calling  fanotify_init+0x0/0x80 @ 1
[    2.923794] NET: Registered protocol family 37
[    2.926118] initcall fanotify_init+0x0/0x80 returned 0 after 2313 usecs
[    2.929127] calling  aio_setup+0x0/0xd0 @ 1
[    2.932929] initcall aio_setup+0x0/0xd0 returned 0 after 1706 usecs
[    2.936091] calling  proc_locks_init+0x0/0x50 @ 1
[    2.938393] initcall proc_locks_init+0x0/0x50 returned 0 after 36 usecs
[    2.941392] calling  init_sys32_ioctl+0x0/0xc0 @ 1
[    2.943716] initcall init_sys32_ioctl+0x0/0xc0 returned 0 after 26 usecs
[    2.946926] calling  init_mbcache+0x0/0x40 @ 1
[    2.949125] initcall init_mbcache+0x0/0x40 returned 0 after 12 usecs
[    2.952032] calling  dquot_init+0x0/0x140 @ 1
[    2.954154] VFS: Disk quotas dquot_6.5.2
[    2.957660] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.960748] initcall dquot_init+0x0/0x140 returned 0 after 6438 usecs
[    2.963705] calling  init_v2_quota_format+0x0/0x40 @ 1
[    2.966296] initcall init_v2_quota_format+0x0/0x40 returned 0 after 6 usecs
[    2.969434] calling  proc_cmdline_init+0x0/0x50 @ 1
[    2.971780] initcall proc_cmdline_init+0x0/0x50 returned 0 after 36 usecs
[    2.974903] calling  proc_cpuinfo_init+0x0/0x50 @ 1
[    2.977420] initcall proc_cpuinfo_init+0x0/0x50 returned 0 after 33 usecs
[    2.980557] calling  proc_devices_init+0x0/0x50 @ 1
[    2.982968] initcall proc_devices_init+0x0/0x50 returned 0 after 32 usecs
[    2.986224] calling  proc_interrupts_init+0x0/0x50 @ 1
[    2.988685] initcall proc_interrupts_init+0x0/0x50 returned 0 after 33 usecs
[    2.991854] calling  proc_loadavg_init+0x0/0x50 @ 1
[    2.994237] initcall proc_loadavg_init+0x0/0x50 returned 0 after 32 usecs
[    2.997480] calling  proc_meminfo_init+0x0/0x50 @ 1
[    2.999889] initcall proc_meminfo_init+0x0/0x50 returned 0 after 32 usecs
[    3.002991] calling  proc_stat_init+0x0/0x50 @ 1
[    3.005291] initcall proc_stat_init+0x0/0x50 returned 0 after 35 usecs
[    3.008429] calling  proc_uptime_init+0x0/0x50 @ 1
[    3.010751] initcall proc_uptime_init+0x0/0x50 returned 0 after 33 usecs
[    3.013800] calling  proc_version_init+0x0/0x50 @ 1
[    3.016357] initcall proc_version_init+0x0/0x50 returned 0 after 46 usecs
[    3.019428] calling  proc_softirqs_init+0x0/0x50 @ 1
[    3.021844] initcall proc_softirqs_init+0x0/0x50 returned 0 after 36 usecs
[    3.024978] calling  proc_kcore_init+0x0/0x70 @ 1
[    3.027415] initcall proc_kcore_init+0x0/0x70 returned 0 after 33 usecs
[    3.030464] calling  vmcore_init+0x0/0xa70 @ 1
[    3.032613] initcall vmcore_init+0x0/0xa70 returned 0 after 0 usecs
[    3.035494] calling  proc_kmsg_init+0x0/0x50 @ 1
[    3.037934] initcall proc_kmsg_init+0x0/0x50 returned 0 after 40 usecs
[    3.040930] calling  proc_page_init+0x0/0x70 @ 1
[    3.043224] initcall proc_page_init+0x0/0x70 returned 0 after 63 usecs
[    3.046360] calling  init_devpts_fs+0x0/0x80 @ 1
[    3.049317] initcall init_devpts_fs+0x0/0x80 returned 0 after 738 usecs
[    3.052336] calling  init_ext3_fs+0x0/0xa0 @ 1
[    3.057307] initcall init_ext3_fs+0x0/0xa0 returned 0 after 2749 usecs
[    3.060426] calling  journal_init+0x0/0xe0 @ 1
[    3.067816] initcall journal_init+0x0/0xe0 returned 0 after 5118 usecs
[    3.070945] calling  init_ramfs_fs+0x0/0x40 @ 1
[    3.073159] initcall init_ramfs_fs+0x0/0x40 returned 0 after 2 usecs
[    3.076078] calling  init_hugetlbfs_fs+0x0/0xd0 @ 1
[    3.080402] initcall init_hugetlbfs_fs+0x0/0xd0 returned 0 after 1793 usecs
[    3.083551] calling  init_iso9660_fs+0x0/0xa0 @ 1
[    3.087307] initcall init_iso9660_fs+0x0/0xa0 returned 0 after 1443 usecs
[    3.090554] calling  init_nls_cp437+0x0/0x40 @ 1
[    3.092827] initcall init_nls_cp437+0x0/0x40 returned 0 after 32 usecs
[    3.095786] calling  init_nls_ascii+0x0/0x40 @ 1
[    3.098190] initcall init_nls_ascii+0x0/0x40 returned 0 after 1 usecs
[    3.101117] calling  ipc_init+0x0/0x50 @ 1
[    3.103221] msgmni has been set to 3922
[    3.105236] initcall ipc_init+0x0/0x50 returned 0 after 2047 usecs
[    3.108221] calling  ipc_sysctl_init+0x0/0x40 @ 1
[    3.110675] initcall ipc_sysctl_init+0x0/0x40 returned 0 after 201 usecs
[    3.113734] calling  init_mqueue_fs+0x0/0x100 @ 1
[    3.118454] initcall init_mqueue_fs+0x0/0x100 returned 0 after 2408 usecs
[    3.121492] calling  key_proc_init+0x0/0x90 @ 1
[    3.123782] initcall key_proc_init+0x0/0x90 returned 0 after 70 usecs
[    3.126712] calling  selinux_nf_ip_init+0x0/0x90 @ 1
[    3.129316] initcall selinux_nf_ip_init+0x0/0x90 returned 0 after 48 usecs
[    3.132427] calling  init_sel_fs+0x0/0xa0 @ 1
[    3.138221] initcall init_sel_fs+0x0/0xa0 returned 0 after 3588 usecs
[    3.141170] calling  selnl_init+0x0/0x80 @ 1
[    3.143407] initcall selnl_init+0x0/0x80 returned 0 after 122 usecs
[    3.146306] calling  sel_netif_init+0x0/0x90 @ 1
[    3.148751] initcall sel_netif_init+0x0/0x90 returned 0 after 22 usecs
[    3.151725] calling  sel_netnode_init+0x0/0xa0 @ 1
[    3.154060] initcall sel_netnode_init+0x0/0xa0 returned 0 after 21 usecs
[    3.157082] calling  sel_netport_init+0x0/0xa0 @ 1
[    3.159564] initcall sel_netport_init+0x0/0xa0 returned 0 after 13 usecs
[    3.162665] calling  aurule_init+0x0/0x60 @ 1
[    3.164797] initcall aurule_init+0x0/0x60 returned 0 after 11 usecs
[    3.167691] calling  init_smk_fs+0x0/0xb0 @ 1
[    3.170038] initcall init_smk_fs+0x0/0xb0 returned 0 after 8 usecs
[    3.172894] calling  crypto_wq_init+0x0/0x60 @ 1
[    3.185772] initcall crypto_wq_init+0x0/0x60 returned 0 after 10353 usecs
[    3.188962] calling  crypto_algapi_init+0x0/0x40 @ 1
[    3.191424] initcall crypto_algapi_init+0x0/0x40 returned 0 after 100 usecs
[    3.194608] calling  skcipher_module_init+0x0/0x60 @ 1
[    3.197023] initcall skcipher_module_init+0x0/0x60 returned 0 after 0 usecs
[    3.200335] calling  chainiv_module_init+0x0/0x40 @ 1
[    3.202936] initcall chainiv_module_init+0x0/0x40 returned 0 after 190 usecs
[    3.206116] calling  eseqiv_module_init+0x0/0x40 @ 1
[    3.208512] initcall eseqiv_module_init+0x0/0x40 returned 0 after 6 usecs
[    3.211779] calling  hmac_module_init+0x0/0x40 @ 1
[    3.214096] initcall hmac_module_init+0x0/0x40 returned 0 after 10 usecs
[    3.217112] calling  md5_mod_init+0x0/0x40 @ 1
[    3.220031] initcall md5_mod_init+0x0/0x40 returned 0 after 759 usecs
[    3.223063] calling  sha1_generic_mod_init+0x0/0x40 @ 1
[    3.225946] initcall sha1_generic_mod_init+0x0/0x40 returned 0 after 410 usecs
[    3.230136] calling  crypto_ecb_module_init+0x0/0x40 @ 1
[    3.232660] initcall crypto_ecb_module_init+0x0/0x40 returned 0 after 6 usecs
[    3.235876] calling  aes_init+0x0/0x40 @ 1
[    3.238476] initcall aes_init+0x0/0x40 returned 0 after 561 usecs
[    3.241442] calling  arc4_init+0x0/0x40 @ 1
[    3.243941] initcall arc4_init+0x0/0x40 returned 0 after 420 usecs
[    3.246830] calling  krng_mod_init+0x0/0x40 @ 1
[    3.249270] alg: No test for stdrng (krng)
[    3.251609] initcall krng_mod_init+0x0/0x40 returned 0 after 2501 usecs
[    3.254689] calling  prng_mod_init+0x0/0x60 @ 1
[    3.272657] initcall prng_mod_init+0x0/0x60 returned 0 after 15440 usecs
[    3.275748] calling  proc_genhd_init+0x0/0x70 @ 1
[    3.278095] initcall proc_genhd_init+0x0/0x70 returned 0 after 71 usecs
[    3.281243] calling  bsg_init+0x0/0x160 @ 1
[    3.285375] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.289100] initcall bsg_init+0x0/0x160 returned 0 after 5666 usecs
[    3.292408] calling  noop_init+0x0/0x40 @ 1
[    3.295392] io scheduler noop registered
[    3.297345] initcall noop_init+0x0/0x40 returned 0 after 1949 usecs
[    3.300228] calling  as_init+0x0/0x40 @ 1
[    3.302366] io scheduler anticipatory registered
[    3.304612] initcall as_init+0x0/0x40 returned 0 after 2191 usecs
[    3.307410] calling  deadline_init+0x0/0x40 @ 1
[    3.309652] io scheduler deadline registered
[    3.311906] initcall deadline_init+0x0/0x40 returned 0 after 2200 usecs
[    3.314930] calling  cfq_init+0x0/0xd0 @ 1
[    3.317079] io scheduler cfq registered (default)
[    3.319345] initcall cfq_init+0x0/0xd0 returned 0 after 2338 usecs
[    3.322331] calling  debug_objects_init_debugfs+0x0/0x90 @ 1
[    3.325170] initcall debug_objects_init_debugfs+0x0/0x90 returned 0 after 174 usecs
[    3.328834] calling  percpu_counter_startup+0x0/0x50 @ 1
[    3.331494] initcall percpu_counter_startup+0x0/0x50 returned 0 after 4 usecs
[    3.334740] calling  dynamic_debug_init+0x0/0x190 @ 1
[    3.338863] initcall dynamic_debug_init+0x0/0x190 returned 0 after 1678 usecs
[    3.342246] calling  pci_init+0x0/0x70 @ 1
[    3.344306] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.347262] initcall pci_init+0x0/0x70 returned 0 after 2933 usecs
[    3.350091] calling  pci_proc_init+0x0/0xa0 @ 1
[    3.353150] initcall pci_proc_init+0x0/0xa0 returned 0 after 694 usecs
[    3.356143] calling  pcie_portdrv_init+0x0/0x80 @ 1
[    3.360634] initcall pcie_portdrv_init+0x0/0x80 returned 0 after 2094 usecs
[    3.364087] calling  aer_service_init+0x0/0x50 @ 1
[    3.367029] initcall aer_service_init+0x0/0x50 returned 0 after 630 usecs
[    3.370229] calling  fb_console_init+0x0/0x180 @ 1
[    3.373882] initcall fb_console_init+0x0/0x180 returned 0 after 1164 usecs
[    3.377017] calling  vesafb_init+0x0/0x280 @ 1
[    3.381005] initcall vesafb_init+0x0/0x280 returned 0 after 1740 usecs
[    3.384285] calling  efifb_init+0x0/0x205 @ 1
[    3.386431] initcall efifb_init+0x0/0x205 returned -19 after 30 usecs
[    3.389383] calling  acpi_reserve_resources+0x0/0x112 @ 1
[    3.392192] initcall acpi_reserve_resources+0x0/0x112 returned 0 after 86 usecs
[    3.395726] calling  irqrouter_init_sysfs+0x0/0x5f @ 1
[    3.399702] initcall irqrouter_init_sysfs+0x0/0x5f returned 0 after 1405 usecs
[    3.403558] calling  acpi_button_init+0x0/0x7d @ 1
[    3.407738] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.411552] ACPI: Power Button [PWRF]
[    3.414796] initcall acpi_button_init+0x0/0x7d returned 0 after 8727 usecs
[    3.417989] calling  acpi_fan_init+0x0/0x7d @ 1
[    3.420908] initcall acpi_fan_init+0x0/0x7d returned 0 after 697 usecs
[    3.424273] calling  acpi_pci_slot_init+0x0/0x47 @ 1
[    3.428214] initcall acpi_pci_slot_init+0x0/0x47 returned 0 after 1559 usecs
[    3.431380] calling  acpi_processor_init+0x0/0x116 @ 1
[    3.436858] processor LNXCPU:00: registered as cooling_device0
[    3.439869] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.445061] processor LNXCPU:01: registered as cooling_device1
[    3.449666] initcall acpi_processor_init+0x0/0x116 returned 0 after 15313 usecs
[    3.453474] calling  acpi_container_init+0x0/0x65 @ 1
[    3.542418] initcall acpi_container_init+0x0/0x65 returned 0 after 84475 usecs
[    3.546049] calling  acpi_thermal_init+0x0/0xa6 @ 1
[    3.551982] initcall acpi_thermal_init+0x0/0xa6 returned 0 after 3520 usecs
[    3.555366] calling  evtchn_init+0x0/0xb0 @ 1
[    3.557481] initcall evtchn_init+0x0/0xb0 returned -19 after 13 usecs
[    3.560419] calling  hypervisor_subsys_init+0x0/0x50 @ 1
[    3.562911] initcall hypervisor_subsys_init+0x0/0x50 returned -19 after 0 usecs
[    3.566636] calling  hyper_sysfs_init+0x0/0xf0 @ 1
[    3.568923] initcall hyper_sysfs_init+0x0/0xf0 returned -19 after 0 usecs
[    3.572034] calling  rand_initialize+0x0/0x60 @ 1
[    3.574509] initcall rand_initialize+0x0/0x60 returned 0 after 195 usecs
[    3.577558] calling  tty_init+0x0/0x130 @ 1
[    3.654836] initcall tty_init+0x0/0x130 returned 0 after 73473 usecs
[    3.657806] calling  pty_init+0x0/0x320 @ 1
[    3.675645] initcall pty_init+0x0/0x320 returned 0 after 15391 usecs
[    3.678664] calling  sysrq_init+0x0/0x50 @ 1
[    3.680828] initcall sysrq_init+0x0/0x50 returned 0 after 67 usecs
[    3.683727] calling  xen_init+0x0/0xc0 @ 1
[    3.685912] initcall xen_init+0x0/0xc0 returned -19 after 0 usecs
[    3.688754] calling  hpet_init+0x0/0xa0 @ 1
[    3.692682] initcall hpet_init+0x0/0xa0 returned 0 after 1858 usecs
[    3.695736] calling  nvram_init+0x0/0xb0 @ 1
[    3.698923] Non-volatile memory driver v1.3
[    3.701107] initcall nvram_init+0x0/0xb0 returned 0 after 3050 usecs
[    3.704163] calling  mod_init+0x0/0x80 @ 1
[    3.706196] initcall mod_init+0x0/0x80 returned -19 after 0 usecs
[    3.709197] calling  agp_init+0x0/0x50 @ 1
[    3.711211] Linux agpgart interface v0.103
[    3.713247] initcall agp_init+0x0/0x50 returned 0 after 1991 usecs
[    3.716058] calling  agp_intel_init+0x0/0x60 @ 1
[    3.718716] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
[    3.724900] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
[    3.729300] initcall agp_intel_init+0x0/0x60 returned 0 after 10573 usecs
[    3.732381] calling  agp_sis_init+0x0/0x60 @ 1
[    3.735454] initcall agp_sis_init+0x0/0x60 returned 0 after 897 usecs
[    3.738737] calling  agp_via_init+0x0/0x60 @ 1
[    3.741559] initcall agp_via_init+0x0/0x60 returned 0 after 683 usecs
[    3.744575] calling  init_tis+0x0/0xc0 @ 1
[    3.747456] initcall init_tis+0x0/0xc0 returned 0 after 880 usecs
[    3.750308] calling  cn_proc_init+0x0/0x70 @ 1
[    3.752468] initcall cn_proc_init+0x0/0x70 returned 0 after 26 usecs
[    3.755391] calling  serial8250_init+0x0/0x1a0 @ 1
[    3.757871] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.763418] async_waiting @ 1
[    3.765043] async_continuing @ 1 after 45 usec
[    3.889970] async_waiting @ 1
[    3.891556] async_continuing @ 1 after 1 usec
�[    4.017173] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.022427] async_waiting @ 1
[    4.024007] async_continuing @ 1 after 1 usec
[    4.148947] async_waiting @ 1
[    4.150518] async_continuing @ 1 after 1 usec
[    4.275154] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.282012] initcall serial8250_init+0x0/0x1a0 returned 0 after 511858 usecs
[    4.285407] calling  serial8250_pnp_init+0x0/0x40 @ 1
[    4.292076] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.298318] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.302917] initcall serial8250_pnp_init+0x0/0x40 returned 0 after 14745 usecs
[    4.306535] calling  serial8250_pci_init+0x0/0x50 @ 1
[    4.309709] initcall serial8250_pci_init+0x0/0x50 returned 0 after 733 usecs
[    4.313169] calling  init_kgdboc+0x0/0x40 @ 1
[    4.315284] initcall init_kgdboc+0x0/0x40 returned 0 after 5 usecs
[    4.318144] calling  topology_sysfs_init+0x0/0xc0 @ 1
[    4.320706] initcall topology_sysfs_init+0x0/0xc0 returned 0 after 188 usecs
[    4.324090] calling  brd_init+0x0/0x1d0 @ 1
[    4.373468] brd: module loaded
[    4.375111] initcall brd_init+0x0/0x1d0 returned 0 after 47828 usecs
[    4.378064] calling  loop_init+0x0/0x200 @ 1
[    4.402825] loop: module loaded
[    4.404662] initcall loop_init+0x0/0x200 returned 0 after 23935 usecs
[    4.407568] calling  init_kgdbts+0x0/0x40 @ 1
[    4.409745] initcall init_kgdbts+0x0/0x40 returned 0 after 12 usecs
[    4.412810] calling  mac_hid_init+0x0/0x100 @ 1
[    4.416576] input: Macintosh mouse button emulation as /devices/virtual/input/input1
[    4.420519] initcall mac_hid_init+0x0/0x100 returned 0 after 5253 usecs
[    4.423699] calling  init_sd+0x0/0x100 @ 1
[    4.427432] initcall init_sd+0x0/0x100 returned 0 after 1667 usecs
[    4.430466] calling  init_sr+0x0/0x80 @ 1
[    4.433242] initcall init_sr+0x0/0x80 returned 0 after 775 usecs
[    4.436156] calling  init_sg+0x0/0x1a0 @ 1
[    4.439309] initcall init_sg+0x0/0x1a0 returned 0 after 1109 usecs
[    4.442142] calling  ahci_init+0x0/0x50 @ 1
[    4.445431] initcall ahci_init+0x0/0x50 returned 0 after 1032 usecs
[    4.448384] calling  net_olddevs_init+0x0/0xe0 @ 1
[    4.450693] initcall net_olddevs_init+0x0/0xe0 returned 0 after 21 usecs
[    4.453906] calling  cdrom_init+0x0/0x40 @ 1
[    4.456200] initcall cdrom_init+0x0/0x40 returned 0 after 201 usecs
[    4.459086] calling  mon_init+0x0/0x150 @ 1
[    4.463380] initcall mon_init+0x0/0x150 returned 0 after 2185 usecs
[    4.466229] calling  ehci_hcd_init+0x0/0x100 @ 1
[    4.468461] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.472505] initcall ehci_hcd_init+0x0/0x100 returned 0 after 3959 usecs
[    4.475826] calling  ohci_hcd_mod_init+0x0/0xc0 @ 1
[    4.478179] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.481716] initcall ohci_hcd_mod_init+0x0/0xc0 returned 0 after 3459 usecs
[    4.485233] calling  uhci_hcd_init+0x0/0xf0 @ 1
[    4.487398] uhci_hcd: USB Universal Host Controller Interface driver
[    4.492932] initcall uhci_hcd_init+0x0/0xf0 returned 0 after 5403 usecs
[    4.496315] calling  i8042_init+0x0/0x460 @ 1
[    4.500150] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
[    5.034779] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.037927] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.040534] initcall i8042_init+0x0/0x460 returned 0 after 529388 usecs
[    5.043545] calling  serport_init+0x0/0x60 @ 1
[    5.045803] initcall serport_init+0x0/0x60 returned 0 after 7 usecs
[    5.049119] calling  mousedev_init+0x0/0x90 @ 1
[    5.057088] mice: PS/2 mouse device common for all mice
[    5.059972] initcall mousedev_init+0x0/0x90 returned 0 after 8461 usecs
[    5.062996] calling  evdev_init+0x0/0x40 @ 1
[    5.067110] initcall evdev_init+0x0/0x40 returned 0 after 1967 usecs
[    5.070433] calling  atkbd_init+0x0/0x60 @ 1
[    5.073464] initcall atkbd_init+0x0/0x60 returned 0 after 947 usecs
[    5.076602] calling  psmouse_init+0x0/0xa0 @ 1
[    5.081730] initcall psmouse_init+0x0/0xa0 returned 0 after 2744 usecs
[    5.084853] calling  cmos_init+0x0/0xa0 @ 1
[    5.091789] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    5.097047] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    5.100326] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    5.113586] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    5.118619] initcall cmos_init+0x0/0xa0 returned 0 after 30955 usecs
[    5.121821] calling  dm_init+0x0/0x80 @ 1
[    5.137013] device-mapper: uevent: version 1.0.3
[    5.142484] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    5.146592] initcall dm_init+0x0/0x80 returned 0 after 22249 usecs
[    5.149438] calling  dm_snapshot_init+0x0/0x300 @ 1
[    5.152474] initcall dm_snapshot_init+0x0/0x300 returned 0 after 513 usecs
[    5.155681] calling  dm_mirror_init+0x0/0xb0 @ 1
[    5.172843] initcall dm_mirror_init+0x0/0xb0 returned 0 after 14593 usecs
[    5.176029] calling  dm_dirty_log_init+0x0/0x90 @ 1
[    5.178418] initcall dm_dirty_log_init+0x0/0x90 returned 0 after 43 usecs
[    5.181489] calling  dm_zero_init+0x0/0x60 @ 1
[    5.183675] initcall dm_zero_init+0x0/0x60 returned 0 after 3 usecs
[    5.186516] calling  init_ladder+0x0/0x40 @ 1
[    5.188724] cpuidle: using governor ladder
[    5.190747] initcall init_ladder+0x0/0x40 returned 0 after 2021 usecs
[    5.193880] calling  init_menu+0x0/0x40 @ 1
[    5.195931] cpuidle: using governor menu
[    5.197900] initcall init_menu+0x0/0x40 returned 0 after 1921 usecs
[    5.200790] calling  efivars_init+0x0/0x2c0 @ 1
[    5.203111] initcall efivars_init+0x0/0x2c0 returned -19 after 5 usecs
[    5.206098] calling  hid_init+0x0/0xa0 @ 1
[    5.209856] initcall hid_init+0x0/0xa0 returned 0 after 1707 usecs
[    5.213012] calling  flow_cache_init+0x0/0x230 @ 1
[    5.215722] initcall flow_cache_init+0x0/0x230 returned 0 after 426 usecs
[    5.218823] calling  blackhole_module_init+0x0/0x40 @ 1
[    5.221262] initcall blackhole_module_init+0x0/0x40 returned 0 after 17 usecs
[    5.224662] calling  nf_conntrack_standalone_init+0x0/0x40 @ 1
[    5.227377] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.233927] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    5.237555] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    5.241331] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    5.244812] initcall nf_conntrack_standalone_init+0x0/0x40 returned 0 after 17051 usecs
[    5.248615] calling  xt_init+0x0/0x250 @ 1
[    5.250688] initcall xt_init+0x0/0x250 returned 0 after 65 usecs
[    5.253633] calling  tcpudp_mt_init+0x0/0x50 @ 1
[    5.255913] initcall tcpudp_mt_init+0x0/0x50 returned 0 after 53 usecs
[    5.258902] calling  conntrack_mt_init+0x0/0x50 @ 1
[    5.261219] initcall conntrack_mt_init+0x0/0x50 returned 0 after 4 usecs
[    5.264452] calling  state_mt_init+0x0/0x50 @ 1
[    5.266631] initcall state_mt_init+0x0/0x50 returned 0 after 8 usecs
[    5.269531] calling  sysctl_ipv4_init+0x0/0x80 @ 1
[    5.274250] initcall sysctl_ipv4_init+0x0/0x80 returned 0 after 2390 usecs
[    5.277357] calling  init_syncookies+0x0/0x50 @ 1
[    5.279680] initcall init_syncookies+0x0/0x50 returned 0 after 64 usecs
[    5.282707] calling  ipv4_netfilter_init+0x0/0x40 @ 1
[    5.285316] initcall ipv4_netfilter_init+0x0/0x40 returned 0 after 44 usecs
[    5.288485] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x170 @ 1
[    5.293149] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x170 returned 0 after 834 usecs
[    5.297147] calling  nf_defrag_init+0x0/0x50 @ 1
[    5.299375] initcall nf_defrag_init+0x0/0x50 returned 0 after 3 usecs
[    5.302305] calling  ip_tables_init+0x0/0xe0 @ 1
[    5.304875] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.307407] initcall ip_tables_init+0x0/0xe0 returned 0 after 2633 usecs
[    5.310437] calling  iptable_filter_init+0x0/0xa0 @ 1
[    5.312955] initcall iptable_filter_init+0x0/0xa0 returned 0 after 107 usecs
[    5.316313] calling  reject_tg_init+0x0/0x40 @ 1
[    5.318545] initcall reject_tg_init+0x0/0x40 returned 0 after 2 usecs
[    5.321462] calling  cubictcp_register+0x0/0xa0 @ 1
[    5.323809] TCP cubic registered
[    5.325669] initcall cubictcp_register+0x0/0xa0 returned 0 after 1828 usecs
[    5.328829] calling  xfrm_user_init+0x0/0x80 @ 1
[    5.331054] Initializing XFRM netlink socket
[    5.333381] initcall xfrm_user_init+0x0/0x80 returned 0 after 2270 usecs
[    5.336598] calling  packet_init+0x0/0x70 @ 1
[    5.338767] NET: Registered protocol family 17
[    5.341015] initcall packet_init+0x0/0x70 returned 0 after 2202 usecs
[    5.343986] calling  severities_debugfs_init+0x0/0x90 @ 1
[    5.346816] initcall severities_debugfs_init+0x0/0x90 returned 0 after 133 usecs
[    5.350397] calling  hpet_insert_resource+0x0/0x50 @ 1
[    5.352833] initcall hpet_insert_resource+0x0/0x50 returned 1 after 4 usecs
[    5.356159] initcall hpet_insert_resource+0x0/0x50 returned with error code 1 
[    5.359638] calling  update_mp_table+0x0/0x530 @ 1
[    5.361963] initcall update_mp_table+0x0/0x530 returned 0 after 8 usecs
[    5.364966] calling  lapic_insert_resource+0x0/0x70 @ 1
[    5.367614] initcall lapic_insert_resource+0x0/0x70 returned 0 after 13 usecs
[    5.370834] calling  init_lapic_nmi_sysfs+0x0/0x60 @ 1
[    5.373285] initcall init_lapic_nmi_sysfs+0x0/0x60 returned 0 after 4 usecs
[    5.376593] calling  io_apic_bug_finalize+0x0/0x50 @ 1
[    5.379039] initcall io_apic_bug_finalize+0x0/0x50 returned 0 after 0 usecs
[    5.382184] calling  check_early_ioremap_leak+0x0/0x90 @ 1
[    5.384775] initcall check_early_ioremap_leak+0x0/0x90 returned 0 after 7 usecs
[    5.388472] calling  pat_memtype_list_init+0x0/0x60 @ 1
[    5.391010] initcall pat_memtype_list_init+0x0/0x60 returned 0 after 80 usecs
[    5.394245] calling  sched_init_debug+0x0/0x50 @ 1
[    5.396750] initcall sched_init_debug+0x0/0x50 returned 0 after 68 usecs
[    5.399814] calling  init_oops_id+0x0/0x60 @ 1
[    5.401980] initcall init_oops_id+0x0/0x60 returned 0 after 8 usecs
[    5.404860] calling  disable_boot_consoles+0x0/0x80 @ 1
[    5.407460] initcall disable_boot_consoles+0x0/0x80 returned 0 after 4 usecs
[    5.410669] calling  pm_qos_power_init+0x0/0xa0 @ 1
[    5.416572] initcall pm_qos_power_init+0x0/0xa0 returned 0 after 3464 usecs
[    5.419902] calling  test_suspend+0x0/0x210 @ 1
[    5.422160] initcall test_suspend+0x0/0x210 returned 0 after 8 usecs
[    5.425050] calling  debugfs_kprobe_init+0x0/0xb0 @ 1
[    5.427777] initcall debugfs_kprobe_init+0x0/0xb0 returned 0 after 166 usecs
[    5.430975] calling  taskstats_init+0x0/0xd0 @ 1
[    5.433305] registered taskstats version 1
[    5.435330] initcall taskstats_init+0x0/0xd0 returned 0 after 2080 usecs
[    5.438578] calling  clear_boot_tracer+0x0/0x60 @ 1
[    5.440928] initcall clear_boot_tracer+0x0/0x60 returned 0 after 4 usecs
[    5.443970] calling  fail_page_alloc_debugfs+0x0/0x120 @ 1
[    5.447391] initcall fail_page_alloc_debugfs+0x0/0x120 returned 0 after 663 usecs
[    5.450997] calling  max_swapfiles_check+0x0/0x30 @ 1
[    5.453401] initcall max_swapfiles_check+0x0/0x30 returned 0 after 11 usecs
[    5.456570] calling  kmemleak_late_init+0x0/0xb0 @ 1
[    5.459482] kmemleak: Kernel memory leak detector initialized
[    5.462334] initcall kmemleak_late_init+0x0/0xb0 returned 0 after 3155 usecs
[    5.465500] calling  init_ima+0x0/0x50 @ 1
[    5.468637] kmemleak: Automatic memory scanning thread started
[    5.471693] No TPM chip found, activating TPM-bypass!
[    5.475425] initcall init_ima+0x0/0x50 returned 0 after 7517 usecs
[    5.478439] calling  fail_make_request_debugfs+0x0/0x50 @ 1
[    5.481842] initcall fail_make_request_debugfs+0x0/0x50 returned 0 after 759 usecs
[    5.485489] calling  fail_io_timeout_debugfs+0x0/0x50 @ 1
[    5.488883] initcall fail_io_timeout_debugfs+0x0/0x50 returned 0 after 662 usecs
[    5.492452] calling  random32_reseed+0x0/0x110 @ 1
[    5.494783] initcall random32_reseed+0x0/0x110 returned 0 after 24 usecs
[    5.498011] calling  pci_resource_alignment_sysfs_init+0x0/0x50 @ 1
[    5.500904] initcall pci_resource_alignment_sysfs_init+0x0/0x50 returned 0 after 24 usecs
[    5.504747] calling  pci_sysfs_init+0x0/0x80 @ 1
[    5.508619] initcall pci_sysfs_init+0x0/0x80 returned 0 after 1603 usecs
[    5.511687] calling  boot_wait_for_devices+0x0/0x50 @ 1
[    5.514155] initcall boot_wait_for_devices+0x0/0x50 returned 0 after 9 usecs
[    5.517343] calling  seqgen_init+0x0/0x40 @ 1
[    5.519493] initcall seqgen_init+0x0/0x40 returned 0 after 28 usecs
[    5.522375] calling  late_resume_init+0x0/0x170 @ 1
[    5.524705]   Magic number: 5:494:825
[    5.526635] initcall late_resume_init+0x0/0x170 returned 0 after 1882 usecs
[    5.529959] calling  scsi_complete_async_scans+0x0/0x1c0 @ 1
[    5.532593] initcall scsi_complete_async_scans+0x0/0x1c0 returned 0 after 4 usecs
[    5.536187] calling  rtc_hctosys+0x0/0x1b0 @ 1
[    5.558671] rtc_cmos 00:04: setting system clock to 2009-08-26 07:49:38 UTC (1251272978)
[    5.562488] initcall rtc_hctosys+0x0/0x1b0 returned 0 after 23445 usecs
[    5.565504] calling  memmap_init+0x0/0xe0 @ 1
[    5.568919] initcall memmap_init+0x0/0xe0 returned 0 after 1213 usecs
[    5.571899] calling  pci_mmcfg_late_insert_resources+0x0/0x1b0 @ 1
[    5.574728] initcall pci_mmcfg_late_insert_resources+0x0/0x1b0 returned 1 after 5 usecs
[    5.578725] initcall pci_mmcfg_late_insert_resources+0x0/0x1b0 returned with error code 1 
[    5.582657] calling  tcp_congestion_default+0x0/0x40 @ 1
[    5.585116] initcall tcp_congestion_default+0x0/0x40 returned 0 after 2 usecs
[    5.588385] calling  initialize_hashrnd+0x0/0x50 @ 1
[    5.590942] initcall initialize_hashrnd+0x0/0x50 returned 0 after 7 usecs
[    5.594102] async_waiting @ 1
[    5.596278] async_continuing @ 1 after 1 usec
[    5.599318] Freeing unused kernel memory: 3304k freed
[    5.609261] Write protecting the kernel read-only data: 7268k
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
%G[    6.152042] calling  journal_init+0x0/0x12d [jbd2] @ 565
[    6.155139] initcall journal_init+0x0/0x12d [jbd2] returned 0 after 384 usecs
[    6.209136] calling  init_ext4_fs+0x0/0x140 [ext4] @ 565
[    6.215845] initcall init_ext4_fs+0x0/0x140 [ext4] returned 0 after 4017 usecs
[    6.235896] calling  spi_transport_init+0x0/0xb5 [scsi_transport_spi] @ 566
[    6.239594] initcall spi_transport_init+0x0/0xb5 [scsi_transport_spi] returned 0 after 430 usecs
[    6.262471] calling  fusion_init+0x0/0x115 [mptbase] @ 567
[    6.265098] Fusion MPT base driver 3.04.11
[    6.267127] Copyright (c) 1999-2008 LSI Corporation
[    6.269560] initcall fusion_init+0x0/0x115 [mptbase] returned 0 after 4353 usecs
[    6.309133] calling  mptspi_init+0x0/0x109 [mptspi] @ 569
[    6.312260] Fusion MPT SPI Host driver 3.04.11
[    6.315114] mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.318947] mptbase: ioc0: Initiating bringup
[    6.340602] ioc0: LSI53C1030 B0: Capabilities={Initiator}
[    6.396332] scsi0 : ioc0: LSI53C1030 B0, FwRev=00000000h, Ports=1, MaxQ=128, IRQ=17
[    6.434329] scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[    6.438348] scsi target0:0:0: Beginning Domain Validation
[    6.444324] scsi target0:0:0: Domain Validation skipping write tests
[    6.447400] scsi target0:0:0: Ending Domain Validation
[    6.449905] scsi target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
[    6.453903] initcall mptspi_init+0x0/0x109 [mptspi] returned 0 after 138319 usecs
[    6.479292] sd 0:0:0:0: [sda] 33554432 512-byte logical blocks: (17.1 GB/16.0 GiB)
[    6.483218] sd 0:0:0:0: [sda] Write Protect is off
[    6.485866] sd 0:0:0:0: [sda] Cache data unavailable
[    6.488474] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    6.493570] sd 0:0:0:0: [sda] Cache data unavailable
[    6.495976] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    6.498974]  sda:
[    6.502925] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.507478] scsi_scan_0 used greatest stack depth: 2960 bytes left
[    6.510596]  sda1 sda2
[    6.516778] sd 0:0:0:0: [sda] Cache data unavailable
[    6.519297] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    6.522131] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.539950] calling  wait_scan_init+0x0/0x39 [scsi_wait_scan] @ 575
[    6.542953] initcall wait_scan_init+0x0/0x39 [scsi_wait_scan] returned 0 after 2 usecs
[    7.011545] EXT4-fs (/dev/root): Update your userspace programs to mount using ext4
[    7.015244] EXT4-fs (/dev/root): ext4dev backwards compatibility will go away by 2.6.31
[    7.028500] EXT4-fs (dm-0): barriers enabled
[    7.031672] kjournald2 starting: pid 582, dev dm-0:8, commit interval 5 seconds
[    7.035793] EXT4-fs (dm-0): delayed allocation enabled
[    7.038546] EXT4-fs: file extents enabled
[    7.053987] EXT4-fs: mballoc enabled
[    7.056305] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[   14.828056] SELinux:  permission module_request in class system not defined in policy
[   14.831051] SELinux: the above unknown classes and permissions will be allowed
[   14.938910] type=1403 audit(1251272987.879:2): policy loaded auid=4294967295 ses=4294967295
[   15.158515] type=1129 audit(1251272988.099:3): user pid=585 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0 msg='old-level=6 new-level=S: exe="/sbin/runlevel" (hostname=?, addr=?, terminal=console res=success)'
[   15.335202] awk used greatest stack depth: 2168 bytes left
		Welcome to Fedora 
		Press 'I' to enter interactive startup.

--=-MUD/dW/s68FIv3icQ/5n--

