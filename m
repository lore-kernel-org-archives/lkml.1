Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYK2K1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYK2K1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYK2K1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:27:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYK2K1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:27:06 -0500
Date: Sat, 29 Nov 2008 11:26:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: sparseirq enabling v4
Message-ID: <20081129102619.GA3901@elte.hu>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org> <20081128163456.GB10487@elte.hu> <4930EB7F.1080307@kernel.org> <20081129100253.GD26691@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129100253.GD26691@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_00,URI_HEX autolearn=no SpamAssassin version=3.2.3
	0.4 URI_HEX                URI: URI hostname has long hexadecimal sequence
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI:

irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802cbd18>] ? check_bytes_and_report+0x38/0xe0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff80278148>] ? debug_mutex_init+0x38/0x60
 [<ffffffff802ef6d9>] ? seq_open+0x89/0xb0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352

	Ingo

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc6-tip-01066-gb8cb0e0-dirty (mingo@titan) (gcc version 4.2.3) #1 SMP Sat Nov 29 11:15:16 CET 2008
Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi nosmp nmi_watchdog=0 noapic nolapic_timer lapic hpet=disable idle=poll nopat pci=nomsi
KERNEL supported cpus:
  Centaur CentaurHauls
CPU: vendor_id 'GenuineIntel' unknown, using generic init.
CPU: Your system may be unstable.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)
 BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
 BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)
 BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
 BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
 BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
console [earlyser0] enabled
debug: ignoring loglevel setting.
using polling idle threads.
DMI 2.3 present.
last_pfn = 0x3ff00 max_arch_pfn = 0x3ffffffff
Scanning 2 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000001000 (usable)
 modified: 0000000000001000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 0000000000008000 (usable)
 modified: 0000000000008000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 0000000000092c00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000003ed94000 (usable)
 modified: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
 modified: 000000003ee4e000 - 000000003fea2000 (usable)
 modified: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
 modified: 000000003fee9000 - 000000003feed000 (usable)
 modified: 000000003feed000 - 000000003feff000 (ACPI data)
 modified: 000000003feff000 - 000000003ff00000 (usable)
init_memory_mapping: 0000000000000000-000000003ff00000
 0000000000 - 003ff00000 page 4k
kernel direct mapping tables up to 3ff00000 @ 20a3000-22a5000
last_map_addr: 3ff00000 end: 3ff00000
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 3FEFDE48, 0050 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACP 3FEFCF10, 0074 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: DSDT 3FEF8010, 3E70 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACS 3FEDFC40, 0040
ACPI: APIC 3FEFCE10, 0078 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: WDDT 3FEF7F90, 0040 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: MCFG 3FEF7F10, 003C (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: ASF! 3FEFCD10, 00A6 (r32 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: HPET 3FEF7E90, 0038 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: SSDT 3FEFDC10, 01BC (r1 INTEL     CpuPm      4B9 MSFT  1000013)
ACPI: SSDT 3FEFDA10, 01B7 (r1 INTEL   Cpu0Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD810, 01B7 (r1 INTEL   Cpu1Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD610, 01B7 (r1 INTEL   Cpu2Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD410, 01B7 (r1 INTEL   Cpu3Ist      4B9 MSFT  1000013)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000003ff00000
Bootmem setup node 0 0000000000000000-000000003ff00000
  NODE_DATA [0000000000010000 - 0000000000014fff]
  bootmap [0000000000015000 -  000000000001cfdf] pages 8
(5 early reservations) ==> bootmem [0000000000 - 003ff00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00020a2c58]    TEXT DATA BSS ==> [0000200000 - 00020a2c58]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [00020a3000 - 00022a3000]          PGTABLE ==> [00020a3000 - 00022a3000]
 [ffffe20000000000-ffffe200019fffff] PMD -> [ffff880002400000-ffff880003dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x00000001
    0: 0x00000006 -> 0x00000008
    0: 0x00000010 -> 0x00000092
    0: 0x00000100 -> 0x0003ed94
    0: 0x0003ee4e -> 0x0003fea2
    0: 0x0003fee9 -> 0x0003feed
    0: 0x0003feff -> 0x0003ff00
On node 0 totalpages: 261490
  DMA zone: 104 pages used for memmap
  DMA zone: 99 pages reserved
  DMA zone: 3770 pages, LIFO batch:0
  DMA32 zone: 6546 pages used for memmap
  DMA32 zone: 250971 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: Skipping IOAPIC probe due to 'noapic' option.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
mapped APIC to ffffffffff5fc000 (fee00000)
Allocating PCI resources starting at 40000000 (gap: 3ff00000:c0100000)
PERCPU: Allocating 1904640 bytes of per cpu data
per cpu data for cpu0 on node0 at 0000000003e00000
per cpu data for cpu1 on node0 at 0000000003fd1000
per cpu data for cpu2 on node0 at 00000000041a2000
per cpu data for cpu3 on node0 at 0000000004373000
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 254741
Policy zone: DMA32
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi nosmp nmi_watchdog=0 noapic nolapic_timer lapic hpet=disable idle=poll nopat pci=nomsi
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
Initializing CPU#0
RCU-based detection of stalled CPUs is enabled.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2933.424 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [earlyser0] -> real [tty0]
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4351 kB
 per task-struct memory footprint: 2688 bytes
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 928060k/1047552k available (12575k kernel code, 1592k absent, 117900k reserved, 6209k data, 2784k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
ODEBUG: selftest passed
Calibrating delay loop (skipped), value calculated using timer frequency.. 5866.84 BogoMIPS (lpj=11733696)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in enforcing mode
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 0K (0 bytes/line), D cache 0K (0 bytes/line)
CPU: L2 Cache: 4096K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
WARNING: polling idle and HT enabled, performance may degrade.
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
ACPI: Core revision 20080926
ACPI: setting ELCR to 0200 (from 0e00)
Setting APIC routing to flat
SMP mode deactivated.
enabled ExtINT on CPU#0
SMP disabled
calling  migration_init+0x0/0x60 @ 1
initcall migration_init+0x0/0x60 returned 1 after 0 usecs
initcall migration_init+0x0/0x60 returned with error code 1 
calling  spawn_ksoftirqd+0x0/0x60 @ 1
initcall spawn_ksoftirqd+0x0/0x60 returned 0 after 0 usecs
calling  init_call_single_data+0x0/0x80 @ 1
initcall init_call_single_data+0x0/0x80 returned 0 after 0 usecs
calling  spawn_softlockup_task+0x0/0x90 @ 1
initcall spawn_softlockup_task+0x0/0x90 returned 0 after 3906 usecs
calling  relay_init+0x0/0x20 @ 1
initcall relay_init+0x0/0x20 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x1e0 @ 1
Testing tracer nop: PASSED
initcall tracer_alloc_buffers+0x0/0x1e0 returned 0 after 3906 usecs
Brought up 1 CPUs
Total of 1 processors activated (5866.84 BogoMIPS).
CPU0 attaching NULL sched-domain.
khelper used greatest stack depth: 6080 bytes left
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 1, comm: swapper Not tainted 2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff8021aa20>] ? native_sched_clock+0x20/0x80
 [<ffffffff8021a7d9>] ? sched_clock+0x9/0x10
 [<ffffffff803209a4>] ? proc_register+0x124/0x1f0
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80320b89>] ? create_proc_entry+0x59/0xa0
 [<ffffffff802947ec>] ? register_irq_proc+0xbc/0xe0
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff8029487c>] init_irq_proc+0x6c/0x80
 [<ffffffff814a1f65>] kernel_init+0x115/0x190
 [<ffffffff80e43aad>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff802149aa>] child_rip+0xa/0x20
 [<ffffffff802142be>] ? restore_args+0x0/0x30
 [<ffffffff814a1e50>] ? kernel_init+0x0/0x190
 [<ffffffff802149a0>] ? child_rip+0x0/0x20
---[ end trace 4eaa2a86a8e2da22 ]---
calling  init_cpufreq_transition_notifier_list+0x0/0x20 @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 usecs
calling  net_ns_init+0x0/0x180 @ 1
net_namespace: 1096 bytes
initcall net_ns_init+0x0/0x180 returned 0 after 3906 usecs
calling  cpufreq_tsc+0x0/0x40 @ 1
initcall cpufreq_tsc+0x0/0x40 returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x60 @ 1
initcall init_smp_flush+0x0/0x60 returned 0 after 0 usecs
calling  print_banner+0x0/0x10 @ 1
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0x10 returned 0 after 3906 usecs
calling  sysctl_init+0x0/0x40 @ 1
initcall sysctl_init+0x0/0x40 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0xc0 @ 1
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x20 @ 1
initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
calling  pm_init+0x0/0x40 @ 1
initcall pm_init+0x0/0x40 returned 0 after 0 usecs
calling  stop_machine_init+0x0/0x50 @ 1
initcall stop_machine_init+0x0/0x50 returned 0 after 0 usecs
calling  filelock_init+0x0/0x30 @ 1
initcall filelock_init+0x0/0x30 returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x50 @ 1
initcall init_misc_binfmt+0x0/0x50 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x20 @ 1
initcall init_script_binfmt+0x0/0x20 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x20 @ 1
initcall init_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x20 @ 1
initcall init_compat_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x60 @ 1
initcall debugfs_init+0x0/0x60 returned 0 after 0 usecs
calling  securityfs_init+0x0/0x60 @ 1
initcall securityfs_init+0x0/0x60 returned 0 after 0 usecs
calling  random32_init+0x0/0x100 @ 1
initcall random32_init+0x0/0x100 returned 0 after 0 usecs
calling  gnttab_init+0x0/0x1c0 @ 1
initcall gnttab_init+0x0/0x1c0 returned -19 after 0 usecs
calling  cpufreq_core_init+0x0/0x90 @ 1
initcall cpufreq_core_init+0x0/0x90 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x50 @ 1
initcall cpuidle_init+0x0/0x50 returned 0 after 0 usecs
calling  sock_init+0x0/0x60 @ 1
initcall sock_init+0x0/0x60 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x50 @ 1
initcall netpoll_init+0x0/0x50 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x180 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x180 returned 0 after 3906 usecs
calling  bdi_class_init+0x0/0x50 @ 1
initcall bdi_class_init+0x0/0x50 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x50 @ 1
initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x20 @ 1
initcall pcibus_class_init+0x0/0x20 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x20 @ 1
initcall pci_driver_init+0x0/0x20 returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x50 @ 1
initcall backlight_class_init+0x0/0x50 returned 0 after 0 usecs
calling  video_output_class_init+0x0/0x19 @ 1
initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
calling  xenbus_probe_init+0x0/0x170 @ 1
initcall xenbus_probe_init+0x0/0x170 returned -19 after 0 usecs
calling  tty_class_init+0x0/0x40 @ 1
initcall tty_class_init+0x0/0x40 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xf0 @ 1
initcall vtconsole_class_init+0x0/0xf0 returned 0 after 0 usecs
calling  register_node_type+0x0/0x70 @ 1
initcall register_node_type+0x0/0x70 returned 0 after 0 usecs
calling  i2c_init+0x0/0x80 @ 1
initcall i2c_init+0x0/0x80 returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x8d0 @ 1
initcall amd_postcore_init+0x0/0x8d0 returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x30 @ 1
initcall arch_kdebugfs_init+0x0/0x30 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x80 @ 1
initcall mtrr_if_init+0x0/0x80 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x40 @ 1
initcall ffh_cstate_init+0x0/0x40 returned -1 after 0 usecs
initcall ffh_cstate_init+0x0/0x40 returned with error code -1 
calling  acpi_pci_init+0x0/0x70 @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x70 returned 0 after 0 usecs
calling  init_acpi_device_notify+0x0/0x4b @ 1
initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 usecs
calling  setup_vcpu_hotplug_event+0x0/0x30 @ 1
initcall setup_vcpu_hotplug_event+0x0/0x30 returned -19 after 0 usecs
calling  dmi_id_init+0x0/0x310 @ 1
initcall dmi_id_init+0x0/0x310 returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x50 @ 1
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x50 returned 0 after 3906 usecs
calling  topology_init+0x0/0x80 @ 1
initcall topology_init+0x0/0x80 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x50 @ 1
initcall mtrr_init_finialize+0x0/0x50 returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x390 @ 1
khelper used greatest stack depth: 5704 bytes left
initcall param_sysfs_init+0x0/0x390 returned 0 after 70312 usecs
calling  pm_sysrq_init+0x0/0x20 @ 1
initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
calling  readahead_init+0x0/0x40 @ 1
initcall readahead_init+0x0/0x40 returned 0 after 0 usecs
calling  init_bio+0x0/0x100 @ 1
initcall init_bio+0x0/0x100 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x40 @ 1
initcall cryptomgr_init+0x0/0x40 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x30 @ 1
initcall blk_settings_init+0x0/0x30 returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x30 @ 1
initcall blk_ioc_init+0x0/0x30 returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x70 @ 1
initcall blk_softirq_init+0x0/0x70 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x70 @ 1
initcall genhd_device_init+0x0/0x70 returned 0 after 3906 usecs
calling  gpiolib_debugfs_init+0x0/0x30 @ 1
initcall gpiolib_debugfs_init+0x0/0x30 returned 0 after 0 usecs
calling  max732x_init+0x0/0x20 @ 1
initcall max732x_init+0x0/0x20 returned 0 after 0 usecs
calling  pca953x_init+0x0/0x20 @ 1
initcall pca953x_init+0x0/0x20 returned 0 after 0 usecs
calling  pcf857x_init+0x0/0x20 @ 1
initcall pcf857x_init+0x0/0x20 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x50 @ 1
initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
calling  fbmem_init+0x0/0xa0 @ 1
initcall fbmem_init+0x0/0xa0 returned 0 after 0 usecs
calling  acpi_init+0x0/0x234 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
initcall acpi_init+0x0/0x234 returned 0 after 23437 usecs
calling  acpi_scan_init+0x0/0x110 @ 1
initcall acpi_scan_init+0x0/0x110 returned 0 after 11718 usecs
calling  acpi_ec_init+0x0/0x61 @ 1
initcall acpi_ec_init+0x0/0x61 returned 0 after 0 usecs
calling  dock_init+0x0/0x8d @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0x8d returned 0 after 3906 usecs
calling  acpi_pci_root_init+0x0/0x28 @ 1
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0x50404400-0x504047ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
pci 0000:00:1f.2: reg 24 32bit mmio: [0x50404000-0x504043ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x4000-0x401f]
pci 0000:01:00.0: reg 10 64bit mmio: [0x40000000-0x4fffffff]
pci 0000:01:00.0: reg 18 64bit mmio: [0x50300000-0x5030ffff]
pci 0000:01:00.0: reg 20 io port: [0x3000-0x30ff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 64bit mmio: [0x50310000-0x5031ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x4fffffff]
pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x502fffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0x50100000-0x5011ffff]
pci 0000:04:00.0: reg 18 io port: [0x2000-0x201f]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.5: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.5: bridge 32bit mmio: [0x50100000-0x501fffff]
pci 0000:05:02.0: reg 10 32bit mmio: [0x50000000-0x50007fff]
pci 0000:05:04.0: reg 10 32bit mmio: [0x5000c000-0x5000c7ff]
pci 0000:05:04.0: reg 14 32bit mmio: [0x50008000-0x5000bfff]
pci 0000:05:04.0: supports D1 D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:05:05.0: reg 10 io port: [0x1018-0x101f]
pci 0000:05:05.0: reg 14 io port: [0x1024-0x1027]
pci 0000:05:05.0: reg 18 io port: [0x1010-0x1017]
pci 0000:05:05.0: reg 1c io port: [0x1020-0x1023]
pci 0000:05:05.0: reg 20 io port: [0x1000-0x100f]
pci 0000:05:05.0: reg 24 32bit mmio: [0x5000c800-0x5000cbff]
pci 0000:05:05.0: reg 30 32bit mmio: [0xfff80000-0xffffffff]
pci 0000:05:05.0: supports D1 D2
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0x50000000-0x500fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 304688 usecs
calling  acpi_pci_link_init+0x0/0x63 @ 1
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
initcall acpi_pci_link_init+0x0/0x63 returned 0 after 46875 usecs
calling  acpi_power_init+0x0/0x77 @ 1
initcall acpi_power_init+0x0/0x77 returned 0 after 0 usecs
calling  acpi_system_init+0x0/0x265 @ 1
initcall acpi_system_init+0x0/0x265 returned 0 after 0 usecs
calling  acpi_wmi_init+0x0/0x4f @ 1
ACPI: WMI: Mapper loaded
initcall acpi_wmi_init+0x0/0x4f returned 0 after 3906 usecs
calling  pnp_init+0x0/0x20 @ 1
initcall pnp_init+0x0/0x20 returned 0 after 0 usecs
calling  setup_shutdown_event+0x0/0x20 @ 1
initcall setup_shutdown_event+0x0/0x20 returned 0 after 0 usecs
calling  misc_init+0x0/0xb0 @ 1
initcall misc_init+0x0/0xb0 returned 0 after 0 usecs
calling  cn_init+0x0/0xf0 @ 1
initcall cn_init+0x0/0xf0 returned 0 after 0 usecs
calling  tifm_init+0x0/0x90 @ 1
initcall tifm_init+0x0/0x90 returned 0 after 0 usecs
calling  phy_init+0x0/0x40 @ 1
initcall phy_init+0x0/0x40 returned 0 after 0 usecs
Clocksource tsc unstable (delta = 82414432 ns)
calling  init_scsi+0x0/0xb0 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0xb0 returned 0 after 3906 usecs
calling  ata_init+0x0/0x3c0 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x3c0 returned 0 after 3906 usecs
calling  init_pcmcia_cs+0x0/0x30 @ 1
initcall init_pcmcia_cs+0x0/0x30 returned 0 after 0 usecs
calling  usb_init+0x0/0x120 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x120 returned 0 after 11718 usecs
calling  serio_init+0x0/0xb0 @ 1
initcall serio_init+0x0/0xb0 returned 0 after 0 usecs
calling  gameport_init+0x0/0xb0 @ 1
initcall gameport_init+0x0/0xb0 returned 0 after 0 usecs
calling  input_init+0x0/0x130 @ 1
initcall input_init+0x0/0x130 returned 0 after 0 usecs
calling  rtc_init+0x0/0x70 @ 1
initcall rtc_init+0x0/0x70 returned 0 after 0 usecs
calling  tps_init+0x0/0xe0 @ 1
tps65010: version 2 May 2005
tps65010: no chip?
initcall tps_init+0x0/0xe0 returned -19 after 35156 usecs
calling  hwmon_init+0x0/0x50 @ 1
initcall hwmon_init+0x0/0x50 returned 0 after 0 usecs
calling  thermal_init+0x0/0x60 @ 1
initcall thermal_init+0x0/0x60 returned 0 after 0 usecs
calling  md_init+0x0/0xe0 @ 1
initcall md_init+0x0/0xe0 returned 0 after 0 usecs
calling  mmc_init+0x0/0x90 @ 1
initcall mmc_init+0x0/0x90 returned 0 after 0 usecs
calling  leds_init+0x0/0x40 @ 1
initcall leds_init+0x0/0x40 returned 0 after 0 usecs
calling  dma_bus_init+0x0/0x40 @ 1
initcall dma_bus_init+0x0/0x40 returned 0 after 0 usecs
calling  dca_init+0x0/0x20 @ 1
dca service started, version 1.4
initcall dca_init+0x0/0x20 returned 0 after 3906 usecs
calling  pci_subsys_init+0x0/0x130 @ 1
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x130 returned 0 after 0 usecs
calling  proto_init+0x0/0x30 @ 1
initcall proto_init+0x0/0x30 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x180 @ 1
initcall net_dev_init+0x0/0x180 returned 0 after 0 usecs
calling  neigh_init+0x0/0x80 @ 1
initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xb0 @ 1
initcall fib_rules_init+0x0/0xb0 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xd0 @ 1
initcall pktsched_init+0x0/0xd0 returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x50 @ 1
initcall tc_filter_init+0x0/0x50 returned 0 after 0 usecs
calling  tc_action_init+0x0/0x50 @ 1
initcall tc_action_init+0x0/0x50 returned 0 after 0 usecs
calling  genl_init+0x0/0xe0 @ 1
initcall genl_init+0x0/0xe0 returned 0 after 15625 usecs
calling  irda_init+0x0/0xb0 @ 1
NET: Registered protocol family 23
initcall irda_init+0x0/0xb0 returned 0 after 0 usecs
calling  atm_init+0x0/0xd0 @ 1
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall atm_init+0x0/0xd0 returned 0 after 7812 usecs
calling  wireless_nlevent_init+0x0/0x50 @ 1
initcall wireless_nlevent_init+0x0/0x50 returned 0 after 0 usecs
calling  rfkill_init+0x0/0x90 @ 1
initcall rfkill_init+0x0/0x90 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x50 @ 1
initcall sysctl_init+0x0/0x50 returned 0 after 0 usecs
calling  xen_mc_debugfs+0x0/0x120 @ 1
initcall xen_mc_debugfs+0x0/0x120 returned 0 after 0 usecs
calling  xen_mmu_debugfs+0x0/0x2c0 @ 1
initcall xen_mmu_debugfs+0x0/0x2c0 returned 0 after 0 usecs
calling  xen_spinlock_debugfs+0x0/0x250 @ 1
initcall xen_spinlock_debugfs+0x0/0x250 returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x20 @ 1
initcall pci_iommu_init+0x0/0x20 returned 0 after 0 usecs
calling  print_all_ICs+0x0/0x500 @ 1

printing PIC contents
... PIC  IMR: fdfa
... PIC  IRR: 0c00
... PIC  ISR: 0000
... PIC ELCR: 0200

printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00050014
... APIC TASKPRI: 00000000 (00)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC ESR: 00000000
... APIC ICR: 00000200
... APIC ICR2: 01000000
... APIC LVTT: 00010000
... APIC LVTPC: 00010000
... APIC LVT0: 00001700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000000

number of MP IRQ sources: 0.
testing the IO APIC.......................
IRQ to pin mappings:
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 1, comm: swapper Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff814af540>] ? print_local_APIC+0x0/0x3b0
 [<ffffffff80e43aad>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff80e4460f>] ? _spin_unlock_irqrestore+0x5f/0x70
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff814af1ed>] print_all_ICs+0x41d/0x500
 [<ffffffff8027334a>] ? getnstimeofday+0x3a/0xc0
 [<ffffffff8026f12a>] ? ktime_get_ts+0x4a/0x60
 [<ffffffff814aedd0>] ? print_all_ICs+0x0/0x500
 [<ffffffff8020a03c>] do_one_initcall+0x3c/0x180
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80291da2>] ? irq_to_desc+0x42/0x50
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff814a1f83>] kernel_init+0x133/0x190
 [<ffffffff80e43aad>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff802149aa>] child_rip+0xa/0x20
 [<ffffffff802142be>] ? restore_args+0x0/0x30
 [<ffffffff814a1e50>] ? kernel_init+0x0/0x190
 [<ffffffff802149a0>] ? child_rip+0x0/0x20
---[ end trace 4eaa2a86a8e2da22 ]---
.................................... done.
initcall print_all_ICs+0x0/0x500 returned 0 after 136719 usecs
calling  hpet_late_init+0x0/0x1c0 @ 1
initcall hpet_late_init+0x0/0x1c0 returned -19 after 0 usecs
calling  clocksource_done_booting+0x0/0x20 @ 1
initcall clocksource_done_booting+0x0/0x20 returned 0 after 0 usecs
calling  rb_init_debugfs+0x0/0x50 @ 1
initcall rb_init_debugfs+0x0/0x50 returned 0 after 0 usecs
calling  tracer_init_debugfs+0x0/0x310 @ 1
initcall tracer_init_debugfs+0x0/0x310 returned 0 after 0 usecs
calling  init_pipe_fs+0x0/0x60 @ 1
initcall init_pipe_fs+0x0/0x60 returned 0 after 0 usecs
calling  init_mnt_writers+0x0/0x90 @ 1
initcall init_mnt_writers+0x0/0x90 returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xa0 @ 1
initcall eventpoll_init+0x0/0xa0 returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x130 @ 1
initcall anon_inode_init+0x0/0x130 returned 0 after 0 usecs
calling  pcie_aspm_init+0x0/0x30 @ 1
initcall pcie_aspm_init+0x0/0x30 returned 0 after 3906 usecs
calling  acpi_event_init+0x0/0x80 @ 1
initcall acpi_event_init+0x0/0x80 returned 0 after 15625 usecs
calling  pnp_system_init+0x0/0x20 @ 1
initcall pnp_system_init+0x0/0x20 returned 0 after 0 usecs
calling  pnpacpi_init+0x0/0xa0 @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff has been reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0xa0 returned 0 after 66406 usecs
calling  chr_dev_init+0x0/0xe0 @ 1
initcall chr_dev_init+0x0/0xe0 returned 0 after 3906 usecs
calling  firmware_class_init+0x0/0x90 @ 1
initcall firmware_class_init+0x0/0x90 returned 0 after 0 usecs
calling  loopback_init+0x0/0x20 @ 1
initcall loopback_init+0x0/0x20 returned 0 after 0 usecs
calling  cpufreq_gov_performance_init+0x0/0x20 @ 1
initcall cpufreq_gov_performance_init+0x0/0x20 returned 0 after 0 usecs
calling  init_acpi_pm_clocksource+0x0/0x100 @ 1
initcall init_acpi_pm_clocksource+0x0/0x100 returned 0 after 3906 usecs
Switched to NOHz mode on CPU #0
calling  ssb_modinit+0x0/0x70 @ 1
initcall ssb_modinit+0x0/0x70 returned 0 after 95 usecs
calling  pcibios_assign_resources+0x0/0x90 @ 1
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x3000-0x3fff
pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x0000004fffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: disabled
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
pci 0000:00:1c.5:   MEM window: 0x50100000-0x501fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0x50000000-0x500fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:00:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:01.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:00:1c.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 io port: [0x3000-0x3fff]
bus: 01 index 1 mmio: [0x50300000-0x503fffff]
bus: 01 index 2 mmio: [0x40000000-0x4fffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 mmio: [0x0-0x0]
bus: 02 index 1 mmio: [0x50200000-0x502fffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 mmio: [0x0-0x0]
bus: 03 index 1 mmio: [0x0-0x0]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 04 index 0 io port: [0x2000-0x2fff]
bus: 04 index 1 mmio: [0x50100000-0x501fffff]
bus: 04 index 2 mmio: [0x0-0x0]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0x1000-0x1fff]
bus: 05 index 1 mmio: [0x50000000-0x500fffff]
bus: 05 index 2 mmio: [0x0-0x0]
bus: 05 index 3 io port: [0x00-0xffff]
bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
initcall pcibios_assign_resources+0x0/0x90 returned 0 after 229924 usecs
calling  inet_init+0x0/0x250 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x250 returned 0 after 78074 usecs
calling  af_unix_init+0x0/0x70 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x70 returned 0 after 3036 usecs
calling  default_rootfs+0x0/0x80 @ 1
initcall default_rootfs+0x0/0x80 returned 0 after 68 usecs
calling  calgary_fixup_tce_spaces+0x0/0x110 @ 1
initcall calgary_fixup_tce_spaces+0x0/0x110 returned -19 after 1 usecs
calling  i8259A_init_sysfs+0x0/0x30 @ 1
initcall i8259A_init_sysfs+0x0/0x30 returned 0 after 250 usecs
calling  vsyscall_init+0x0/0x70 @ 1
initcall vsyscall_init+0x0/0x70 returned 0 after 15 usecs
calling  sbf_init+0x0/0xe0 @ 1
initcall sbf_init+0x0/0xe0 returned 0 after 1 usecs
calling  i8237A_init_sysfs+0x0/0x30 @ 1
initcall i8237A_init_sysfs+0x0/0x30 returned 0 after 156 usecs
calling  add_rtc_cmos+0x0/0xb0 @ 1
initcall add_rtc_cmos+0x0/0xb0 returned 0 after 3 usecs
calling  cache_sysfs_init+0x0/0x60 @ 1
initcall cache_sysfs_init+0x0/0x60 returned 0 after 1 usecs
calling  cpuid_init+0x0/0x100 @ 1
initcall cpuid_init+0x0/0x100 returned 0 after 201 usecs
calling  init_lapic_sysfs+0x0/0x30 @ 1
initcall init_lapic_sysfs+0x0/0x30 returned 0 after 148 usecs
calling  ioapic_init_sysfs+0x0/0xe0 @ 1
initcall ioapic_init_sysfs+0x0/0xe0 returned 0 after 75 usecs
calling  add_pcspkr+0x0/0x30 @ 1
initcall add_pcspkr+0x0/0x30 returned 0 after 113 usecs
calling  start_periodic_check_for_corruption+0x0/0x40 @ 1
Scanning for low memory corruption every 60 seconds
initcall start_periodic_check_for_corruption+0x0/0x40 returned 0 after 4549 usecs
calling  uv_ptc_init+0x0/0x60 @ 1
initcall uv_ptc_init+0x0/0x60 returned 0 after 1 usecs
calling  uv_bau_init+0x0/0x660 @ 1
initcall uv_bau_init+0x0/0x660 returned 0 after 0 usecs
calling  sgi_uv_sysfs_init+0x0/0xb0 @ 1
initcall sgi_uv_sysfs_init+0x0/0xb0 returned 0 after 7 usecs
calling  audit_classes_init+0x0/0xb0 @ 1
initcall audit_classes_init+0x0/0xb0 returned 0 after 9 usecs
calling  start_pageattr_test+0x0/0x50 @ 1
initcall start_pageattr_test+0x0/0x50 returned 0 after 72 usecs
calling  pt_dump_init+0x0/0x30 @ 1
initcall pt_dump_init+0x0/0x30 returned 0 after 9 usecs
calling  aes_init+0x0/0x20 @ 1
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
initcall aes_init+0x0/0x20 returned 0 after 9831 usecs
calling  init+0x0/0x20 @ 1
initcall init+0x0/0x20 returned 0 after 42 usecs
calling  init_vdso_vars+0x0/0x220 @ 1
initcall init_vdso_vars+0x0/0x220 returned 0 after 16 usecs
calling  ia32_binfmt_init+0x0/0x20 @ 1
initcall ia32_binfmt_init+0x0/0x20 returned 0 after 8 usecs
calling  sysenter_setup+0x0/0x380 @ 1
initcall sysenter_setup+0x0/0x380 returned 0 after 4 usecs
calling  init_aout_binfmt+0x0/0x20 @ 1
initcall init_aout_binfmt+0x0/0x20 returned 0 after 1 usecs
calling  init_sched_debug_procfs+0x0/0x30 @ 1
initcall init_sched_debug_procfs+0x0/0x30 returned 0 after 7 usecs
calling  proc_schedstat_init+0x0/0x30 @ 1
initcall proc_schedstat_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_execdomains_init+0x0/0x30 @ 1
initcall proc_execdomains_init+0x0/0x30 returned 0 after 4 usecs
calling  ioresources_init+0x0/0x40 @ 1
initcall ioresources_init+0x0/0x40 returned 0 after 11 usecs
calling  uid_cache_init+0x0/0x80 @ 1
initcall uid_cache_init+0x0/0x80 returned 0 after 7 usecs
calling  init_posix_timers+0x0/0x110 @ 1
initcall init_posix_timers+0x0/0x110 returned 0 after 4 usecs
calling  init_posix_cpu_timers+0x0/0xe0 @ 1
initcall init_posix_cpu_timers+0x0/0xe0 returned 0 after 1 usecs
calling  nsproxy_cache_init+0x0/0x30 @ 1
initcall nsproxy_cache_init+0x0/0x30 returned 0 after 4 usecs
calling  create_proc_profile+0x0/0x310 @ 1
initcall create_proc_profile+0x0/0x310 returned 0 after 11 usecs
calling  timekeeping_init_device+0x0/0x30 @ 1
initcall timekeeping_init_device+0x0/0x30 returned 0 after 157 usecs
calling  init_clocksource_sysfs+0x0/0x60 @ 1
initcall init_clocksource_sysfs+0x0/0x60 returned 0 after 175 usecs
calling  init_timer_list_procfs+0x0/0x30 @ 1
initcall init_timer_list_procfs+0x0/0x30 returned 0 after 4 usecs
calling  lockdep_proc_init+0x0/0x60 @ 1
initcall lockdep_proc_init+0x0/0x60 returned 0 after 9 usecs
calling  futex_init+0x0/0xf0 @ 1
initcall futex_init+0x0/0xf0 returned 0 after 18 usecs
calling  proc_dma_init+0x0/0x30 @ 1
initcall proc_dma_init+0x0/0x30 returned 0 after 4 usecs
calling  kallsyms_init+0x0/0x30 @ 1
initcall kallsyms_init+0x0/0x30 returned 0 after 3 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x470 @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x470 returned 0 after 11 usecs
calling  crash_notes_memory_init+0x0/0x40 @ 1
initcall crash_notes_memory_init+0x0/0x40 returned 0 after 2 usecs
calling  backtrace_regression_test+0x0/0x100 @ 1
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
Pid: 1, comm: swapper Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80285160>] ? backtrace_regression_test+0x0/0x100
 [<ffffffff80285198>] backtrace_regression_test+0x38/0x100
 [<ffffffff8027334a>] ? getnstimeofday+0x3a/0xc0
 [<ffffffff8026f12a>] ? ktime_get_ts+0x4a/0x60
 [<ffffffff80285160>] ? backtrace_regression_test+0x0/0x100
 [<ffffffff8026f151>] ? ktime_get+0x11/0x50
 [<ffffffff8020a03c>] do_one_initcall+0x3c/0x180
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80291da2>] ? irq_to_desc+0x42/0x50
 [<ffffffff814a1140>] ? early_idt_handler+0x0/0x73
 [<ffffffff814a1f83>] kernel_init+0x133/0x190
 [<ffffffff80e43aad>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff802149aa>] child_rip+0xa/0x20
 [<ffffffff802142be>] ? restore_args+0x0/0x30
 [<ffffffff814a1e50>] ? kernel_init+0x0/0x190
 [<ffffffff802149a0>] ? child_rip+0x0/0x20
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
Pid: 4, comm: ksoftirqd/0 Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 <IRQ>  [<ffffffff80285149>] backtrace_test_irq_callback+0x9/0x20
 [<ffffffff8025a8e9>] tasklet_action+0x79/0x100
 [<ffffffff8025a58d>] __do_softirq+0x9d/0x190
 [<ffffffff8025a680>] ? ksoftirqd+0x0/0xf0
 [<ffffffff80214aac>] call_softirq+0x1c/0x30
 <EOI>  [<ffffffff80216715>] do_softirq+0x85/0xd0
 [<ffffffff8025a6f5>] ksoftirqd+0x75/0xf0
 [<ffffffff8026bc2d>] kthread+0x4d/0x80
 [<ffffffff802149aa>] child_rip+0xa/0x20
 [<ffffffff802142be>] ? restore_args+0x0/0x30
 [<ffffffff8026bbe0>] ? kthread+0x0/0x80
 [<ffffffff802149a0>] ? child_rip+0x0/0x20
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<ffffffff802201aa>] save_stack_trace+0x2a/0x50
 [<ffffffff80285236>] backtrace_regression_test+0xd6/0x100
 [<ffffffff8020a03c>] do_one_initcall+0x3c/0x180
 [<ffffffff814a1f83>] kernel_init+0x133/0x190
 [<ffffffff802149aa>] child_rip+0xa/0x20
 [<ffffffffffffffff>] 0xffffffffffffffff
====[ end of backtrace testing ]====
initcall backtrace_regression_test+0x0/0x100 returned 0 after 191082 usecs
calling  ikconfig_init+0x0/0x40 @ 1
initcall ikconfig_init+0x0/0x40 returned 0 after 4 usecs
calling  audit_init+0x0/0x170 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1227953790.187:1): initialized
audit: cannot initialize inotify handle
initcall audit_init+0x0/0x170 returned 0 after 11710 usecs
calling  utsname_sysctl_init+0x0/0x20 @ 1
initcall utsname_sysctl_init+0x0/0x20 returned 0 after 21 usecs
calling  init_lstats_procfs+0x0/0x30 @ 1
initcall init_lstats_procfs+0x0/0x30 returned 0 after 4 usecs
calling  init_stack_trace+0x0/0x20 @ 1
Testing tracer sysprof: PASSED
initcall init_stack_trace+0x0/0x20 returned 0 after 103900 usecs
calling  init_irqsoff_tracer+0x0/0x20 @ 1
Testing tracer irqsoff: PASSED
initcall init_irqsoff_tracer+0x0/0x20 returned 0 after 2908 usecs
calling  init_bts_trace+0x0/0x20 @ 1
initcall init_bts_trace+0x0/0x20 returned 0 after 1 usecs
calling  init_power_trace+0x0/0x20 @ 1
initcall init_power_trace+0x0/0x20 returned 0 after 1 usecs
calling  init_per_zone_pages_min+0x0/0x60 @ 1
initcall init_per_zone_pages_min+0x0/0x60 returned 0 after 32 usecs
calling  pdflush_init+0x0/0x20 @ 1
initcall pdflush_init+0x0/0x20 returned 0 after 62 usecs
calling  kswapd_init+0x0/0x70 @ 1
initcall kswapd_init+0x0/0x70 returned 0 after 33 usecs
calling  setup_vmstat+0x0/0xc0 @ 1
initcall setup_vmstat+0x0/0xc0 returned 0 after 15 usecs
calling  mm_sysfs_init+0x0/0x30 @ 1
initcall mm_sysfs_init+0x0/0x30 returned 0 after 6 usecs
calling  proc_vmalloc_init+0x0/0x30 @ 1
initcall proc_vmalloc_init+0x0/0x30 returned 0 after 4 usecs
calling  init_tmpfs+0x0/0xf0 @ 1
initcall init_tmpfs+0x0/0xf0 returned 0 after 55 usecs
calling  slab_proc_init+0x0/0x30 @ 1
initcall slab_proc_init+0x0/0x30 returned 0 after 4 usecs
calling  slab_sysfs_init+0x0/0x100 @ 1
initcall slab_sysfs_init+0x0/0x100 returned 0 after 13731 usecs
calling  fasync_init+0x0/0x30 @ 1
initcall fasync_init+0x0/0x30 returned 0 after 1218 usecs
calling  proc_filesystems_init+0x0/0x30 @ 1
initcall proc_filesystems_init+0x0/0x30 returned 0 after 8 usecs
calling  proc_locks_init+0x0/0x30 @ 1
initcall proc_locks_init+0x0/0x30 returned 0 after 4 usecs
calling  init_sys32_ioctl+0x0/0x90 @ 1
initcall init_sys32_ioctl+0x0/0x90 returned 0 after 13 usecs
calling  init_mbcache+0x0/0x20 @ 1
initcall init_mbcache+0x0/0x20 returned 0 after 1 usecs
calling  dquot_init+0x0/0x120 @ 1
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x120 returned 0 after 7858 usecs
calling  init_v1_quota_format+0x0/0x20 @ 1
initcall init_v1_quota_format+0x0/0x20 returned 0 after 1 usecs
calling  dnotify_init+0x0/0x30 @ 1
initcall dnotify_init+0x0/0x30 returned 0 after 145 usecs
calling  proc_cmdline_init+0x0/0x30 @ 1
initcall proc_cmdline_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_cpuinfo_init+0x0/0x30 @ 1
initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_devices_init+0x0/0x30 @ 1
initcall proc_devices_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_interrupts_init+0x0/0x30 @ 1
initcall proc_interrupts_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_loadavg_init+0x0/0x30 @ 1
initcall proc_loadavg_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_meminfo_init+0x0/0x30 @ 1
initcall proc_meminfo_init+0x0/0x30 returned 0 after 8 usecs
calling  proc_stat_init+0x0/0x30 @ 1
initcall proc_stat_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_uptime_init+0x0/0x30 @ 1
initcall proc_uptime_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_version_init+0x0/0x30 @ 1
initcall proc_version_init+0x0/0x30 returned 0 after 4 usecs
calling  proc_kcore_init+0x0/0x50 @ 1
initcall proc_kcore_init+0x0/0x50 returned 0 after 3 usecs
calling  proc_kmsg_init+0x0/0x30 @ 1
initcall proc_kmsg_init+0x0/0x30 returned 0 after 3 usecs
calling  configfs_init+0x0/0xf0 @ 1
initcall configfs_init+0x0/0xf0 returned 0 after 159 usecs
calling  init_devpts_fs+0x0/0x50 @ 1
initcall init_devpts_fs+0x0/0x50 returned 0 after 30 usecs
calling  init_dlm+0x0/0xa0 @ 1
DLM (built Nov 29 2008 11:12:21) installed
initcall init_dlm+0x0/0xa0 returned 0 after 4279 usecs
calling  init_ext3_fs+0x0/0x80 @ 1
initcall init_ext3_fs+0x0/0x80 returned 0 after 304 usecs
calling  init_ext4_fs+0x0/0xa0 @ 1
initcall init_ext4_fs+0x0/0xa0 returned 0 after 729 usecs
calling  journal_init+0x0/0xb0 @ 1
initcall journal_init+0x0/0xb0 returned 0 after 578 usecs
calling  journal_init+0x0/0x110 @ 1
initcall journal_init+0x0/0x110 returned 0 after 619 usecs
calling  init_ext2_fs+0x0/0x80 @ 1
initcall init_ext2_fs+0x0/0x80 returned 0 after 296 usecs
calling  init_cramfs_fs+0x0/0x40 @ 1
initcall init_cramfs_fs+0x0/0x40 returned 0 after 19 usecs
calling  init_ramfs_fs+0x0/0x20 @ 1
initcall init_ramfs_fs+0x0/0x20 returned 0 after 1 usecs
calling  init_minix_fs+0x0/0x70 @ 1
initcall init_minix_fs+0x0/0x70 returned 0 after 145 usecs
calling  init_fat_fs+0x0/0x60 @ 1
initcall init_fat_fs+0x0/0x60 returned 0 after 288 usecs
calling  init_vfat_fs+0x0/0x20 @ 1
initcall init_vfat_fs+0x0/0x20 returned 0 after 1 usecs
calling  init_msdos_fs+0x0/0x20 @ 1
initcall init_msdos_fs+0x0/0x20 returned 0 after 1 usecs
calling  init_bfs_fs+0x0/0x70 @ 1
initcall init_bfs_fs+0x0/0x70 returned 0 after 144 usecs
calling  init_iso9660_fs+0x0/0x90 @ 1
initcall init_iso9660_fs+0x0/0x90 returned 0 after 156 usecs
calling  init_hfsplus_fs+0x0/0x70 @ 1
initcall init_hfsplus_fs+0x0/0x70 returned 0 after 144 usecs
calling  init_hfs_fs+0x0/0x70 @ 1
initcall init_hfs_fs+0x0/0x70 returned 0 after 145 usecs
calling  vxfs_init+0x0/0x70 @ 1
initcall vxfs_init+0x0/0x70 returned 0 after 145 usecs
calling  init_nfs_fs+0x0/0x130 @ 1
initcall init_nfs_fs+0x0/0x130 returned 0 after 919 usecs
calling  init_nfsd+0x0/0x100 @ 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0x100 returned 0 after 6195 usecs
calling  init_nlm+0x0/0x30 @ 1
initcall init_nlm+0x0/0x30 returned 0 after 26 usecs
calling  init_nls_cp437+0x0/0x20 @ 1
initcall init_nls_cp437+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp737+0x0/0x20 @ 1
initcall init_nls_cp737+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp775+0x0/0x20 @ 1
initcall init_nls_cp775+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp852+0x0/0x20 @ 1
initcall init_nls_cp852+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp855+0x0/0x20 @ 1
initcall init_nls_cp855+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp860+0x0/0x20 @ 1
initcall init_nls_cp860+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp864+0x0/0x20 @ 1
initcall init_nls_cp864+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp865+0x0/0x20 @ 1
initcall init_nls_cp865+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp866+0x0/0x20 @ 1
initcall init_nls_cp866+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp874+0x0/0x20 @ 1
initcall init_nls_cp874+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp932+0x0/0x20 @ 1
initcall init_nls_cp932+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_euc_jp+0x0/0x50 @ 1
initcall init_nls_euc_jp+0x0/0x50 returned 0 after 1 usecs
calling  init_nls_cp936+0x0/0x20 @ 1
initcall init_nls_cp936+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp949+0x0/0x20 @ 1
initcall init_nls_cp949+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp950+0x0/0x20 @ 1
initcall init_nls_cp950+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp1251+0x0/0x20 @ 1
initcall init_nls_cp1251+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_ascii+0x0/0x20 @ 1
initcall init_nls_ascii+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_iso8859_3+0x0/0x20 @ 1
initcall init_nls_iso8859_3+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_iso8859_4+0x0/0x20 @ 1
initcall init_nls_iso8859_4+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_iso8859_7+0x0/0x20 @ 1
initcall init_nls_iso8859_7+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_cp1255+0x0/0x20 @ 1
initcall init_nls_cp1255+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_iso8859_13+0x0/0x20 @ 1
initcall init_nls_iso8859_13+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_iso8859_14+0x0/0x20 @ 1
initcall init_nls_iso8859_14+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_iso8859_15+0x0/0x20 @ 1
initcall init_nls_iso8859_15+0x0/0x20 returned 0 after 1 usecs
calling  init_nls_utf8+0x0/0x30 @ 1
initcall init_nls_utf8+0x0/0x30 returned 0 after 1 usecs
calling  init_hpfs_fs+0x0/0x70 @ 1
initcall init_hpfs_fs+0x0/0x70 returned 0 after 168 usecs
calling  init_ntfs_fs+0x0/0x270 @ 1
NTFS driver 2.1.29 [Flags: R/O DEBUG].
initcall init_ntfs_fs+0x0/0x270 returned 0 after 4178 usecs
calling  init_efs_fs+0x0/0x70 @ 1
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x70 returned 0 after 3773 usecs
calling  init_affs_fs+0x0/0x70 @ 1
initcall init_affs_fs+0x0/0x70 returned 0 after 145 usecs
calling  init_romfs_fs+0x0/0x70 @ 1
initcall init_romfs_fs+0x0/0x70 returned 0 after 144 usecs
calling  init_qnx4_fs+0x0/0x80 @ 1
QNX4 filesystem 0.2.3 registered.
initcall init_qnx4_fs+0x0/0x80 returned 0 after 3169 usecs
calling  init_autofs4_fs+0x0/0x30 @ 1
initcall init_autofs4_fs+0x0/0x30 returned 0 after 95 usecs
calling  fuse_init+0x0/0x140 @ 1
fuse init (API version 7.10)
initcall fuse_init+0x0/0x140 returned 0 after 3288 usecs
calling  init_omfs_fs+0x0/0x20 @ 1
initcall init_omfs_fs+0x0/0x20 returned 0 after 2 usecs
calling  init_jfs_fs+0x0/0x290 @ 1
JFS: nTxBlock = 7250, nTxLock = 58003
initcall init_jfs_fs+0x0/0x290 returned 0 after 8323 usecs
calling  init_xfs_fs+0x0/0xc0 @ 1
SGI XFS with security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
initcall init_xfs_fs+0x0/0xc0 returned 0 after 13819 usecs
calling  init_befs_fs+0x0/0x90 @ 1
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0x90 returned 0 after 1977 usecs
calling  ocfs2_init+0x0/0x210 @ 1
OCFS2 1.5.0
initcall ocfs2_init+0x0/0x210 returned 0 after 1629 usecs
calling  ocfs2_stack_glue_init+0x0/0xa0 @ 1
initcall ocfs2_stack_glue_init+0x0/0xa0 returned 0 after 25 usecs
calling  o2cb_stack_init+0x0/0x20 @ 1
ocfs2: Registered cluster interface o2cb
initcall o2cb_stack_init+0x0/0x20 returned 0 after 3616 usecs
calling  init_o2nm+0x0/0xb0 @ 1
OCFS2 Node Manager 1.5.0
initcall init_o2nm+0x0/0xb0 returned 0 after 3092 usecs
calling  dlm_init+0x0/0x290 @ 1
OCFS2 DLM 1.5.0
initcall dlm_init+0x0/0x290 returned 0 after 2137 usecs
calling  init_dlmfs_fs+0x0/0xf0 @ 1
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
initcall init_dlmfs_fs+0x0/0xf0 returned 0 after 5282 usecs
calling  ipc_init+0x0/0x30 @ 1
msgmni has been set to 1812
initcall ipc_init+0x0/0x30 returned 0 after 2532 usecs
calling  ipc_sysctl_init+0x0/0x20 @ 1
initcall ipc_sysctl_init+0x0/0x20 returned 0 after 45 usecs
calling  init_mqueue_fs+0x0/0xe0 @ 1
initcall init_mqueue_fs+0x0/0xe0 returned 0 after 203 usecs
calling  key_proc_init+0x0/0x40 @ 1
initcall key_proc_init+0x0/0x40 returned 0 after 6 usecs
calling  init_sel_fs+0x0/0x70 @ 1
initcall init_sel_fs+0x0/0x70 returned 0 after 235 usecs
calling  selnl_init+0x0/0x50 @ 1
initcall selnl_init+0x0/0x50 returned 0 after 18 usecs
calling  sel_netif_init+0x0/0x70 @ 1
initcall sel_netif_init+0x0/0x70 returned 0 after 4 usecs
calling  sel_netnode_init+0x0/0xb0 @ 1
initcall sel_netnode_init+0x0/0xb0 returned 0 after 4 usecs
calling  sel_netport_init+0x0/0xb0 @ 1
initcall sel_netport_init+0x0/0xb0 returned 0 after 4 usecs
calling  aurule_init+0x0/0x40 @ 1
initcall aurule_init+0x0/0x40 returned 0 after 1 usecs
calling  crypto_algapi_init+0x0/0x10 @ 1
initcall crypto_algapi_init+0x0/0x10 returned 0 after 14 usecs
calling  chainiv_module_init+0x0/0x20 @ 1
initcall chainiv_module_init+0x0/0x20 returned 0 after 2 usecs
calling  eseqiv_module_init+0x0/0x20 @ 1
initcall eseqiv_module_init+0x0/0x20 returned 0 after 1 usecs
calling  seqiv_module_init+0x0/0x20 @ 1
initcall seqiv_module_init+0x0/0x20 returned 0 after 1 usecs
calling  hmac_module_init+0x0/0x20 @ 1
initcall hmac_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_null_mod_init+0x0/0x90 @ 1
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
initcall crypto_null_mod_init+0x0/0x90 returned 0 after 13915 usecs
calling  md4_mod_init+0x0/0x20 @ 1
initcall md4_mod_init+0x0/0x20 returned 0 after 53 usecs
calling  md5_mod_init+0x0/0x20 @ 1
initcall md5_mod_init+0x0/0x20 returned 0 after 50 usecs
calling  rmd128_mod_init+0x0/0x20 @ 1
initcall rmd128_mod_init+0x0/0x20 returned 0 after 54 usecs
calling  rmd160_mod_init+0x0/0x20 @ 1
initcall rmd160_mod_init+0x0/0x20 returned 0 after 57 usecs
calling  rmd320_mod_init+0x0/0x20 @ 1
initcall rmd320_mod_init+0x0/0x20 returned 0 after 55 usecs
calling  sha1_generic_mod_init+0x0/0x20 @ 1
initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 49 usecs
calling  sha256_generic_mod_init+0x0/0x50 @ 1
initcall sha256_generic_mod_init+0x0/0x50 returned 0 after 99 usecs
calling  wp512_mod_init+0x0/0x90 @ 1
initcall wp512_mod_init+0x0/0x90 returned 0 after 193 usecs
calling  crypto_ecb_module_init+0x0/0x20 @ 1
initcall crypto_ecb_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_cbc_module_init+0x0/0x20 @ 1
initcall crypto_cbc_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_pcbc_module_init+0x0/0x20 @ 1
initcall crypto_pcbc_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_cts_module_init+0x0/0x20 @ 1
initcall crypto_cts_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_module_init+0x0/0x20 @ 1
initcall crypto_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_module_init+0x0/0x20 @ 1
initcall crypto_module_init+0x0/0x20 returned 0 after 1 usecs
calling  crypto_ctr_module_init+0x0/0x50 @ 1
initcall crypto_ctr_module_init+0x0/0x50 returned 0 after 2 usecs
calling  crypto_gcm_module_init+0x0/0x70 @ 1
initcall crypto_gcm_module_init+0x0/0x70 returned 0 after 3 usecs
calling  cryptd_init+0x0/0xc0 @ 1
initcall cryptd_init+0x0/0xc0 returned 0 after 31 usecs
calling  des_generic_mod_init+0x0/0x50 @ 1
initcall des_generic_mod_init+0x0/0x50 returned 0 after 122 usecs
calling  fcrypt_mod_init+0x0/0x20 @ 1
alg: No test for fcrypt (fcrypt-generic)
initcall fcrypt_mod_init+0x0/0x20 returned 0 after 3663 usecs
calling  blowfish_mod_init+0x0/0x20 @ 1
initcall blowfish_mod_init+0x0/0x20 returned 0 after 494 usecs
calling  twofish_mod_init+0x0/0x20 @ 1
initcall twofish_mod_init+0x0/0x20 returned 0 after 73 usecs
calling  serpent_mod_init+0x0/0x50 @ 1
initcall serpent_mod_init+0x0/0x50 returned 0 after 116 usecs
calling  aes_init+0x0/0x360 @ 1
initcall aes_init+0x0/0x360 returned 0 after 75 usecs
calling  camellia_init+0x0/0x20 @ 1
initcall camellia_init+0x0/0x20 returned 0 after 58 usecs
calling  cast5_mod_init+0x0/0x20 @ 1
initcall cast5_mod_init+0x0/0x20 returned 0 after 55 usecs
calling  cast6_mod_init+0x0/0x20 @ 1
initcall cast6_mod_init+0x0/0x20 returned 0 after 59 usecs
calling  arc4_init+0x0/0x20 @ 1
initcall arc4_init+0x0/0x20 returned 0 after 61 usecs
calling  tea_mod_init+0x0/0x90 @ 1
initcall tea_mod_init+0x0/0x90 returned 0 after 154 usecs
calling  anubis_mod_init+0x0/0x20 @ 1
initcall anubis_mod_init+0x0/0x20 returned 0 after 75 usecs
calling  salsa20_generic_mod_init+0x0/0x20 @ 1
initcall salsa20_generic_mod_init+0x0/0x20 returned 0 after 43 usecs
calling  deflate_mod_init+0x0/0x20 @ 1
initcall deflate_mod_init+0x0/0x20 returned 0 after 362 usecs
calling  michael_mic_init+0x0/0x20 @ 1
initcall michael_mic_init+0x0/0x20 returned 0 after 49 usecs
calling  crc32c_mod_init+0x0/0x50 @ 1
initcall crc32c_mod_init+0x0/0x50 returned 0 after 120 usecs
calling  crypto_authenc_module_init+0x0/0x20 @ 1
initcall crypto_authenc_module_init+0x0/0x20 returned 0 after 2 usecs
calling  krng_mod_init+0x0/0x20 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x20 returned 0 after 2813 usecs
calling  proc_genhd_init+0x0/0x40 @ 1
initcall proc_genhd_init+0x0/0x40 returned 0 after 9 usecs
calling  bsg_init+0x0/0x150 @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall bsg_init+0x0/0x150 returned 0 after 6259 usecs
calling  noop_init+0x0/0x20 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x20 returned 0 after 2600 usecs
calling  as_init+0x0/0x20 @ 1
io scheduler anticipatory registered
initcall as_init+0x0/0x20 returned 0 after 3260 usecs
calling  deadline_init+0x0/0x20 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x20 returned 0 after 2938 usecs
calling  cfq_init+0x0/0xa0 @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0xa0 returned 0 after 3654 usecs
calling  debug_objects_init_debugfs+0x0/0x70 @ 1
initcall debug_objects_init_debugfs+0x0/0x70 returned 0 after 11 usecs
calling  init_kmp+0x0/0x20 @ 1
initcall init_kmp+0x0/0x20 returned 0 after 1 usecs
calling  init_bm+0x0/0x20 @ 1
initcall init_bm+0x0/0x20 returned 0 after 1 usecs
calling  init_fsm+0x0/0x20 @ 1
initcall init_fsm+0x0/0x20 returned 0 after 1 usecs
calling  percpu_counter_startup+0x0/0x20 @ 1
initcall percpu_counter_startup+0x0/0x20 returned 0 after 2 usecs
calling  dynamic_printk_init+0x0/0xc0 @ 1
initcall dynamic_printk_init+0x0/0xc0 returned 0 after 1986 usecs
calling  pci_init+0x0/0x50 @ 1
pci 0000:01:00.0: Boot video device
initcall pci_init+0x0/0x50 returned 0 after 3410 usecs
calling  pci_proc_init+0x0/0x70 @ 1
initcall pci_proc_init+0x0/0x70 returned 0 after 121 usecs
calling  pcie_portdrv_init+0x0/0x60 @ 1
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
initcall pcie_portdrv_init+0x0/0x60 returned 0 after 73188 usecs
calling  pci_hotplug_init+0x0/0x60 @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x60 returned 0 after 4208 usecs
calling  zt5550_init+0x0/0x90 @ 1
cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
initcall zt5550_init+0x0/0x90 returned 0 after 5483 usecs
calling  cpcihp_generic_init+0x0/0x520 @ 1
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
cpcihp_generic: not configured, disabling.
initcall cpcihp_generic_init+0x0/0x520 returned -22 after 10107 usecs
initcall cpcihp_generic_init+0x0/0x520 returned with error code -22 
calling  pcied_init+0x0/0x90 @ 1
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
initcall pcied_init+0x0/0x90 returned 0 after 5595 usecs
calling  shpcd_init+0x0/0x70 @ 1
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x70 returned 0 after 5399 usecs
calling  corgibl_init+0x0/0x20 @ 1
initcall corgibl_init+0x0/0x20 returned 0 after 82 usecs
calling  progearbl_init+0x0/0x70 @ 1
ALI M7101 PMU not found.
initcall progearbl_init+0x0/0x70 returned 0 after 2452 usecs
calling  mbp_init+0x0/0xf0 @ 1
initcall mbp_init+0x0/0xf0 returned -19 after 2 usecs
calling  kb3886_init+0x0/0x40 @ 1
initcall kb3886_init+0x0/0x40 returned -19 after 1 usecs
calling  display_class_init+0x0/0x80 @ 1
initcall display_class_init+0x0/0x80 returned 0 after 78 usecs
calling  arcfb_init+0x0/0x80 @ 1
initcall arcfb_init+0x0/0x80 returned -6 after 1 usecs
initcall arcfb_init+0x0/0x80 returned with error code -6 
calling  cyber2000fb_init+0x0/0xe0 @ 1
initcall cyber2000fb_init+0x0/0xe0 returned 0 after 89 usecs
calling  pm2fb_init+0x0/0x180 @ 1
initcall pm2fb_init+0x0/0x180 returned 0 after 87 usecs
calling  pm3fb_init+0x0/0x130 @ 1
initcall pm3fb_init+0x0/0x130 returned 0 after 87 usecs
calling  nvidiafb_init+0x0/0x2e0 @ 1
nvidiafb_setup START
initcall nvidiafb_init+0x0/0x2e0 returned 0 after 1995 usecs
calling  atyfb_init+0x0/0x210 @ 1
initcall atyfb_init+0x0/0x210 returned 0 after 92 usecs
calling  sisfb_init+0x0/0x830 @ 1
initcall sisfb_init+0x0/0x830 returned 0 after 87 usecs
calling  kyrofb_init+0x0/0x120 @ 1
initcall kyrofb_init+0x0/0x120 returned 0 after 115 usecs
calling  savagefb_init+0x0/0x80 @ 1
initcall savagefb_init+0x0/0x80 returned 0 after 94 usecs
calling  gxfb_init+0x0/0x90 @ 1
initcall gxfb_init+0x0/0x90 returned 0 after 88 usecs
calling  lxfb_init+0x0/0x120 @ 1
initcall lxfb_init+0x0/0x120 returned 0 after 91 usecs
calling  neofb_init+0x0/0x170 @ 1
initcall neofb_init+0x0/0x170 returned 0 after 88 usecs
calling  imsttfb_init+0x0/0x120 @ 1
initcall imsttfb_init+0x0/0x120 returned 0 after 88 usecs
calling  vt8623fb_init+0x0/0xa0 @ 1
initcall vt8623fb_init+0x0/0xa0 returned 0 after 88 usecs
calling  tridentfb_init+0x0/0x230 @ 1
initcall tridentfb_init+0x0/0x230 returned 0 after 89 usecs
calling  vmlfb_init+0x0/0xa0 @ 1
vmlfb: initializing
initcall vmlfb_init+0x0/0xa0 returned 0 after 1931 usecs
calling  cr_pll_init+0x0/0x110 @ 1
Could not find Carillo Ranch MCH device.
initcall cr_pll_init+0x0/0x110 returned -19 after 3621 usecs
calling  arkfb_init+0x0/0xa0 @ 1
initcall arkfb_init+0x0/0xa0 returned 0 after 88 usecs
calling  hecubafb_init+0x0/0x20 @ 1
initcall hecubafb_init+0x0/0x20 returned 0 after 80 usecs
calling  metronomefb_init+0x0/0x20 @ 1
initcall metronomefb_init+0x0/0x20 returned 0 after 81 usecs
calling  s1d13xxxfb_init+0x0/0x30 @ 1
initcall s1d13xxxfb_init+0x0/0x30 returned 0 after 81 usecs
calling  mb862xxfb_init+0x0/0x20 @ 1
initcall mb862xxfb_init+0x0/0x20 returned 0 after 88 usecs
calling  uvesafb_init+0x0/0x400 @ 1
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
initcall uvesafb_init+0x0/0x400 returned 0 after 22356 usecs
calling  efifb_init+0x0/0x200 @ 1
initcall efifb_init+0x0/0x200 returned -19 after 1 usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 4 usecs
calling  acpi_ac_init+0x0/0x28 @ 1
initcall acpi_ac_init+0x0/0x28 returned 0 after 107 usecs
calling  acpi_button_init+0x0/0x5e @ 1
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
initcall acpi_button_init+0x0/0x5e returned 0 after 14390 usecs
calling  acpi_video_init+0x0/0x5e @ 1
initcall acpi_video_init+0x0/0x5e returned 0 after 100 usecs
calling  irqrouter_init_sysfs+0x0/0x38 @ 1
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 154 usecs
calling  acpi_processor_init+0x0/0x107 @ 1
processor ACPI_CPU:00: registered as cooling_device0
initcall acpi_processor_init+0x0/0x107 returned 0 after 5017 usecs
calling  acpi_container_init+0x0/0x42 @ 1
initcall acpi_container_init+0x0/0x42 returned 0 after 2873 usecs
calling  acpi_thermal_init+0x0/0x83 @ 1
initcall acpi_thermal_init+0x0/0x83 returned 0 after 117 usecs
calling  toshiba_acpi_init+0x0/0x461 @ 1
initcall toshiba_acpi_init+0x0/0x461 returned -19 after 4 usecs
calling  rand_initialize+0x0/0x30 @ 1
initcall rand_initialize+0x0/0x30 returned 0 after 13 usecs
calling  tty_init+0x0/0x110 @ 1
initcall tty_init+0x0/0x110 returned 0 after 26682 usecs
calling  pty_init+0x0/0x5c0 @ 1
initcall pty_init+0x0/0x5c0 returned 0 after 62442 usecs
calling  sysrq_init+0x0/0x30 @ 1
initcall sysrq_init+0x0/0x30 returned 0 after 15 usecs
calling  nozomi_init+0x0/0x170 @ 1
Initializing Nozomi driver 2.1d (build date: Nov 29 2008 11:10:19)
initcall nozomi_init+0x0/0x170 returned 0 after 5937 usecs
calling  xen_init+0x0/0xb0 @ 1
initcall xen_init+0x0/0xb0 returned -19 after 1 usecs
calling  raw_init+0x0/0xf0 @ 1
initcall raw_init+0x0/0xf0 returned 0 after 310 usecs
calling  r3964_init+0x0/0x50 @ 1
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall r3964_init+0x0/0x50 returned 0 after 4049 usecs
calling  applicom_init+0x0/0x550 @ 1
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall applicom_init+0x0/0x550 returned -6 after 13894 usecs
initcall applicom_init+0x0/0x550 returned with error code -6 
calling  hpet_init+0x0/0x80 @ 1
initcall hpet_init+0x0/0x80 returned 0 after 225 usecs
calling  nvram_init+0x0/0xa0 @ 1
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0xa0 returned 0 after 2940 usecs
calling  i8k_init+0x0/0x270 @ 1
initcall i8k_init+0x0/0x270 returned -19 after 3 usecs
calling  mod_init+0x0/0x230 @ 1
initcall mod_init+0x0/0x230 returned -19 after 147 usecs
calling  mod_init+0x0/0xd0 @ 1
initcall mod_init+0x0/0xd0 returned -19 after 42 usecs
calling  pc8736x_gpio_init+0x0/0x4a0 @ 1
platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
platform pc8736x_gpio.0: no device found
initcall pc8736x_gpio_init+0x0/0x4a0 returned -19 after 9564 usecs
calling  nsc_gpio_init+0x0/0x20 @ 1
nsc_gpio initializing
initcall nsc_gpio_init+0x0/0x20 returned 0 after 2009 usecs
calling  tlclk_init+0x0/0x1e0 @ 1
telclk_interrup = 0xf non-mcpbl0010 hw.
initcall tlclk_init+0x0/0x1e0 returned -6 after 3544 usecs
initcall tlclk_init+0x0/0x1e0 returned with error code -6 
calling  hangcheck_init+0x0/0x90 @ 1
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
initcall hangcheck_init+0x0/0x90 returned 0 after 10289 usecs
calling  init_tis+0x0/0xb0 @ 1
initcall init_tis+0x0/0xb0 returned 0 after 95 usecs
calling  init_inf+0x0/0x20 @ 1
initcall init_inf+0x0/0x20 returned 0 after 84 usecs
calling  cn_proc_init+0x0/0x40 @ 1
initcall cn_proc_init+0x0/0x40 returned 0 after 3 usecs
calling  serial8250_init+0x0/0x150 @ 1
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_init+0x0/0x150 returned 0 after 10145 usecs
calling  serial8250_pci_init+0x0/0x20 @ 1
initcall serial8250_pci_init+0x0/0x20 returned 0 after 98 usecs
calling  jsm_init_module+0x0/0x60 @ 1
initcall jsm_init_module+0x0/0x60 returned 0 after 100 usecs
calling  topology_sysfs_init+0x0/0x50 @ 1
initcall topology_sysfs_init+0x0/0x50 returned 0 after 13 usecs
calling  floppy_init+0x0/0x1180 @ 1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
initcall floppy_init+0x0/0x1180 returned 0 after 24818 usecs
calling  loop_init+0x0/0x1e0 @ 1
loop: module loaded
initcall loop_init+0x0/0x1e0 returned 0 after 3723 usecs
calling  cpqarray_init+0x0/0x2d0 @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x2d0 returned -19 after 2943 usecs
calling  cciss_init+0x0/0x30 @ 1
HP CISS Driver (v 3.6.20)
initcall cciss_init+0x0/0x30 returned 0 after 2446 usecs
calling  DAC960_init_module+0x0/0x60 @ 1
initcall DAC960_init_module+0x0/0x60 returned 0 after 197 usecs
calling  mm_init+0x0/0x1d0 @ 1
MM: desc_per_page = 128
initcall mm_init+0x0/0x1d0 returned 0 after 2285 usecs
calling  init_cryptoloop+0x0/0x40 @ 1
initcall init_cryptoloop+0x0/0x40 returned 0 after 1 usecs
calling  carm_init+0x0/0x20 @ 1
initcall carm_init+0x0/0x20 returned 0 after 89 usecs
calling  xlblk_init+0x0/0x90 @ 1
initcall xlblk_init+0x0/0x90 returned -19 after 1 usecs
calling  asus_laptop_init+0x0/0x330 @ 1
initcall asus_laptop_init+0x0/0x330 returned -19 after 174 usecs
calling  eeepc_laptop_init+0x0/0x240 @ 1
initcall eeepc_laptop_init+0x0/0x240 returned -19 after 170 usecs
calling  msi_init+0x0/0x180 @ 1
initcall msi_init+0x0/0x180 returned -19 after 1 usecs
calling  acer_wmi_init+0x0/0x630 @ 1
acer-wmi: Acer Laptop ACPI-WMI Extras
acer-wmi: No or unsupported WMI interface, unable to load
initcall acer_wmi_init+0x0/0x630 returned -19 after 8418 usecs
calling  hp_wmi_init+0x0/0x160 @ 1
initcall hp_wmi_init+0x0/0x160 returned 0 after 1 usecs
calling  ioc4_init+0x0/0x20 @ 1
initcall ioc4_init+0x0/0x20 returned 0 after 89 usecs
calling  sony_laptop_init+0x0/0xa0 @ 1
initcall sony_laptop_init+0x0/0xa0 returned 0 after 94 usecs
calling  acpi_pcc_init+0x0/0x30 @ 1
initcall acpi_pcc_init+0x0/0x30 returned 0 after 90 usecs
calling  intel_menlow_module_init+0x0/0x80 @ 1
initcall intel_menlow_module_init+0x0/0x80 returned -19 after 9 usecs
calling  enclosure_init+0x0/0x20 @ 1
initcall enclosure_init+0x0/0x20 returned 0 after 96 usecs
calling  gru_init+0x0/0x540 @ 1
initcall gru_init+0x0/0x540 returned 0 after 1 usecs
calling  ilo_init+0x0/0xa0 @ 1
initcall ilo_init+0x0/0xa0 returned 0 after 166 usecs
calling  c2port_init+0x0/0x60 @ 1
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
initcall c2port_init+0x0/0x60 returned 0 after 5903 usecs
calling  duramar2150_c2port_init+0x0/0x70 @ 1
c2port c2port0: C2 port uc added
c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
initcall duramar2150_c2port_init+0x0/0x70 returned 0 after 9219 usecs
calling  sm501_base_init+0x0/0x30 @ 1
initcall sm501_base_init+0x0/0x30 returned 0 after 168 usecs
calling  wm8400_module_init+0x0/0x40 @ 1
initcall wm8400_module_init+0x0/0x40 returned 0 after 84 usecs
calling  da903x_init+0x0/0x20 @ 1
initcall da903x_init+0x0/0x20 returned 0 after 81 usecs
calling  e1000_init_module+0x0/0xa0 @ 1
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
initcall e1000_init_module+0x0/0xa0 returned 0 after 8925 usecs
calling  e1000_init_module+0x0/0x70 @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:04:00.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
e1000e 0000:04:00.0: setting latency timer to 64
0000:04:00.0: 0000:04:00.0: Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
0000:04:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:ab:6e:84
0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
0000:04:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
initcall e1000_init_module+0x0/0x70 returned 0 after 156059 usecs
calling  igb_init_module+0x0/0x60 @ 1
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
initcall igb_init_module+0x0/0x60 returned 0 after 8756 usecs
calling  bonding_init+0x0/0x9b0 @ 1
Ethernet Channel Bonding Driver: v3.3.0 (June 10, 2008)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
initcall bonding_init+0x0/0x9b0 returned 0 after 20844 usecs
calling  atl2_init_module+0x0/0x50 @ 1
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
initcall atl2_init_module+0x0/0x50 returned 0 after 7672 usecs
calling  atl1e_init_module+0x0/0x20 @ 1
initcall atl1e_init_module+0x0/0x20 returned 0 after 88 usecs
calling  jme_init_module+0x0/0x30 @ 1
jme: JMicron JMC250 gigabit ethernet driver version 1.0.3
initcall jme_init_module+0x0/0x30 returned 0 after 5142 usecs
calling  rr_init_module+0x0/0x20 @ 1
initcall rr_init_module+0x0/0x20 returned 0 after 88 usecs
calling  gem_init+0x0/0x20 @ 1
initcall gem_init+0x0/0x20 returned 0 after 91 usecs
calling  vortex_init+0x0/0xd0 @ 1
initcall vortex_init+0x0/0xd0 returned 0 after 90 usecs
calling  typhoon_init+0x0/0x20 @ 1
initcall typhoon_init+0x0/0x20 returned 0 after 92 usecs
calling  ne2k_pci_init+0x0/0x20 @ 1
initcall ne2k_pci_init+0x0/0x20 returned 0 after 88 usecs
calling  pcnet32_init_module+0x0/0x150 @ 1
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
initcall pcnet32_init_module+0x0/0x150 returned 0 after 4804 usecs
calling  eepro100_init_module+0x0/0x20 @ 1
initcall eepro100_init_module+0x0/0x20 returned 0 after 90 usecs
calling  e100_init_module+0x0/0x60 @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x60 returned 0 after 8928 usecs
calling  tlan_probe+0x0/0x120 @ 1
ThunderLAN driver v1.15
TLAN: 0 devices installed, PCI: 0  EISA: 0
initcall tlan_probe+0x0/0x120 returned -19 after 6124 usecs
calling  epic_init+0x0/0x20 @ 1
initcall epic_init+0x0/0x20 returned 0 after 88 usecs
calling  sis900_init_module+0x0/0x20 @ 1
initcall sis900_init_module+0x0/0x20 returned 0 after 88 usecs
calling  r6040_init+0x0/0x20 @ 1
initcall r6040_init+0x0/0x20 returned 0 after 94 usecs
calling  yellowfin_init+0x0/0x20 @ 1
initcall yellowfin_init+0x0/0x20 returned 0 after 88 usecs
calling  ns83820_init+0x0/0x30 @ 1
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
initcall ns83820_init+0x0/0x30 returned 0 after 5479 usecs
calling  tg3_init+0x0/0x20 @ 1
initcall tg3_init+0x0/0x20 returned 0 after 96 usecs
calling  skge_init_module+0x0/0x20 @ 1
initcall skge_init_module+0x0/0x20 returned 0 after 88 usecs
calling  sky2_init_module+0x0/0x60 @ 1
sky2 driver version 1.22
initcall sky2_init_module+0x0/0x60 returned 0 after 2342 usecs
calling  velocity_init_module+0x0/0x50 @ 1
initcall velocity_init_module+0x0/0x50 returned 0 after 89 usecs
calling  starfire_init+0x0/0x20 @ 1
initcall starfire_init+0x0/0x20 returned 0 after 88 usecs
calling  marvell_init+0x0/0x90 @ 1
initcall marvell_init+0x0/0x90 returned 0 after 489 usecs
calling  lxt_init+0x0/0x50 @ 1
initcall lxt_init+0x0/0x50 returned 0 after 170 usecs
calling  smsc_init+0x0/0x70 @ 1
initcall smsc_init+0x0/0x70 returned 0 after 250 usecs
calling  vsc8244_init+0x0/0x20 @ 1
initcall vsc8244_init+0x0/0x20 returned 0 after 81 usecs
calling  broadcom_init+0x0/0xd0 @ 1
initcall broadcom_init+0x0/0xd0 returned 0 after 489 usecs
calling  ip175c_init+0x0/0x20 @ 1
initcall ip175c_init+0x0/0x20 returned 0 after 80 usecs
calling  realtek_init+0x0/0x20 @ 1
initcall realtek_init+0x0/0x20 returned 0 after 80 usecs
calling  fixed_mdio_bus_init+0x0/0x110 @ 1
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0x110 returned 0 after 5513 usecs
calling  sundance_init+0x0/0x20 @ 1
initcall sundance_init+0x0/0x20 returned 0 after 101 usecs
calling  hamachi_init+0x0/0x20 @ 1
initcall hamachi_init+0x0/0x20 returned 0 after 90 usecs
calling  net_olddevs_init+0x0/0xb0 @ 1
initcall net_olddevs_init+0x0/0xb0 returned 0 after 3 usecs
calling  sb1000_init+0x0/0x20 @ 1
initcall sb1000_init+0x0/0x20 returned 0 after 90 usecs
calling  init_nic+0x0/0x20 @ 1
initcall init_nic+0x0/0x20 returned 0 after 90 usecs
calling  ql3xxx_init_module+0x0/0x20 @ 1
initcall ql3xxx_init_module+0x0/0x20 returned 0 after 88 usecs
calling  ppp_init+0x0/0xb0 @ 1
PPP generic driver version 2.4.2
initcall ppp_init+0x0/0xb0 returned 0 after 3126 usecs
calling  ppp_async_init+0x0/0x40 @ 1
initcall ppp_async_init+0x0/0x40 returned 0 after 1 usecs
calling  ppp_sync_init+0x0/0x40 @ 1
initcall ppp_sync_init+0x0/0x40 returned 0 after 1 usecs
calling  bsdcomp_init+0x0/0x40 @ 1
PPP BSD Compression module registered
initcall bsdcomp_init+0x0/0x40 returned 0 after 3362 usecs
calling  ppp_mppe_init+0x0/0x120 @ 1
PPP MPPE Compression module registered
initcall ppp_mppe_init+0x0/0x120 returned 0 after 3550 usecs
calling  pppox_init+0x0/0x20 @ 1
NET: Registered protocol family 24
initcall pppox_init+0x0/0x20 returned 0 after 3107 usecs
calling  pppoe_init+0x0/0xb0 @ 1
initcall pppoe_init+0x0/0xb0 returned 0 after 9 usecs
calling  netif_init+0x0/0x80 @ 1
initcall netif_init+0x0/0x80 returned -19 after 0 usecs
calling  ifb_init_module+0x0/0xf0 @ 1
initcall ifb_init_module+0x0/0xf0 returned 0 after 864 usecs
calling  macvlan_init_module+0x0/0x60 @ 1
initcall macvlan_init_module+0x0/0x60 returned 0 after 2 usecs
calling  cp_init+0x0/0x20 @ 1
initcall cp_init+0x0/0x20 returned 0 after 93 usecs
calling  rtl8139_init_module+0x0/0x20 @ 1
initcall rtl8139_init_module+0x0/0x20 returned 0 after 96 usecs
calling  tun_init+0x0/0xb0 @ 1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0xb0 returned 0 after 8611 usecs
calling  veth_init+0x0/0x20 @ 1
initcall veth_init+0x0/0x20 returned 0 after 2 usecs
calling  rio_init+0x0/0x20 @ 1
initcall rio_init+0x0/0x20 returned 0 after 93 usecs
calling  rtl8169_init_module+0x0/0x20 @ 1
initcall rtl8169_init_module+0x0/0x20 returned 0 after 89 usecs
calling  xl_pci_init+0x0/0x20 @ 1
initcall xl_pci_init+0x0/0x20 returned 0 after 88 usecs
calling  hdlc_module_init+0x0/0x50 @ 1
HDLC support module revision 1.22
initcall hdlc_module_init+0x0/0x50 returned 0 after 3025 usecs
calling  mod_init+0x0/0x20 @ 1
initcall mod_init+0x0/0x20 returned 0 after 1 usecs
calling  sync_ppp_init+0x0/0x70 @ 1
Cronyx Ltd, Synchronous PPP and CISCO HDLC (c) 1994
Linux port (c) 1998 Building Number Three Ltd & Jan "Yenya" Kasprzak.
initcall sync_ppp_init+0x0/0x70 returned 0 after 10598 usecs
calling  init_lmc+0x0/0x20 @ 1
initcall init_lmc+0x0/0x20 returned 0 after 88 usecs
calling  wanxl_init_module+0x0/0x20 @ 1
initcall wanxl_init_module+0x0/0x20 returned 0 after 88 usecs
calling  pci200_init_module+0x0/0x50 @ 1
initcall pci200_init_module+0x0/0x50 returned 0 after 92 usecs
calling  catc_init+0x0/0x40 @ 1
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x40 returned 0 after 8710 usecs
calling  kaweth_init+0x0/0x20 @ 1
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x20 returned 0 after 4289 usecs
calling  pegasus_init+0x0/0x1f0 @ 1
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
initcall pegasus_init+0x0/0x1f0 returned 0 after 10477 usecs
calling  hso_init+0x0/0x1e0 @ 1
hso: drivers/net/usb/hso.c: 1.2 Option Wireless
usbcore: registered new interface driver hso
initcall hso_init+0x0/0x1e0 returned 0 after 8254 usecs
calling  cdc_init+0x0/0x20 @ 1
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x20 returned 0 after 4547 usecs
calling  dm9601_init+0x0/0x20 @ 1
usbcore: registered new interface driver dm9601
initcall dm9601_init+0x0/0x20 returned 0 after 4289 usecs
calling  plusb_init+0x0/0x20 @ 1
usbcore: registered new interface driver plusb
initcall plusb_init+0x0/0x20 returned 0 after 4204 usecs
calling  rndis_init+0x0/0x20 @ 1
usbcore: registered new interface driver rndis_host
initcall rndis_init+0x0/0x20 returned 0 after 4643 usecs
calling  zaurus_init+0x0/0x20 @ 1
usbcore: registered new interface driver zaurus
initcall zaurus_init+0x0/0x20 returned 0 after 4294 usecs
calling  mcs7830_init+0x0/0x20 @ 1
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall mcs7830_init+0x0/0x20 returned 0 after 6075 usecs
calling  usbnet_init+0x0/0x30 @ 1
initcall usbnet_init+0x0/0x30 returned 0 after 3 usecs
calling  strip_init_driver+0x0/0x70 @ 1
STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
initcall strip_init_driver+0x0/0x70 returned 0 after 4972 usecs
calling  init_orinoco+0x0/0x20 @ 1
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
initcall init_orinoco+0x0/0x20 returned 0 after 8366 usecs
calling  init_hermes+0x0/0x10 @ 1
initcall init_hermes+0x0/0x10 returned 0 after 1 usecs
calling  init_hermes_dld+0x0/0x10 @ 1
initcall init_hermes_dld+0x0/0x10 returned 0 after 0 usecs
calling  orinoco_plx_init+0x0/0x30 @ 1
orinoco_plx 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au>, Daniel Barlow <dan@telent.net>)
initcall orinoco_plx_init+0x0/0x30 returned 0 after 10907 usecs
calling  orinoco_pci_init+0x0/0x30 @ 1
orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
initcall orinoco_pci_init+0x0/0x30 returned 0 after 11082 usecs
calling  orinoco_tmd_init+0x0/0x30 @ 1
orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
initcall orinoco_tmd_init+0x0/0x30 returned 0 after 4888 usecs
calling  orinoco_nortel_init+0x0/0x30 @ 1
orinoco_nortel 0.15 (Tobias Hoffmann & Christoph Jungegger <disdos@traum404.de>)
initcall orinoco_nortel_init+0x0/0x30 returned 0 after 7086 usecs
calling  atmel_init_module+0x0/0x20 @ 1
initcall atmel_init_module+0x0/0x20 returned 0 after 88 usecs
calling  hostap_init+0x0/0x50 @ 1
initcall hostap_init+0x0/0x50 returned 0 after 4 usecs
calling  init_prism2_plx+0x0/0x20 @ 1
initcall init_prism2_plx+0x0/0x20 returned 0 after 93 usecs
calling  init_prism2_pci+0x0/0x20 @ 1
initcall init_prism2_pci+0x0/0x20 returned 0 after 88 usecs
calling  rndis_wlan_init+0x0/0x20 @ 1
usbcore: registered new interface driver rndis_wlan
initcall rndis_wlan_init+0x0/0x20 returned 0 after 4628 usecs
calling  zd1201_init+0x0/0x20 @ 1
usbcore: registered new interface driver zd1201
initcall zd1201_init+0x0/0x20 returned 0 after 4288 usecs
calling  lbs_init_module+0x0/0xf0 @ 1
initcall lbs_init_module+0x0/0xf0 returned 0 after 8 usecs
calling  if_usb_init_module+0x0/0xd0 @ 1
usbcore: registered new interface driver usb8xxx
initcall if_usb_init_module+0x0/0xd0 returned 0 after 4373 usecs
calling  dmfe_init_module+0x0/0x100 @ 1
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
initcall dmfe_init_module+0x0/0x100 returned 0 after 5397 usecs
calling  w840_init+0x0/0x30 @ 1
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
initcall w840_init+0x0/0x30 returned 0 after 10771 usecs
calling  de_init+0x0/0x20 @ 1
initcall de_init+0x0/0x20 returned 0 after 87 usecs
calling  tulip_init+0x0/0x40 @ 1
initcall tulip_init+0x0/0x40 returned 0 after 89 usecs
calling  de4x5_module_init+0x0/0x20 @ 1
initcall de4x5_module_init+0x0/0x20 returned 0 after 87 usecs
calling  uli526x_init_module+0x0/0xb0 @ 1
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
initcall uli526x_init_module+0x0/0xb0 returned 0 after 5567 usecs
calling  yam_init_driver+0x0/0x150 @ 1
YAM driver version 0.8 by F1OAT/F6FBB
initcall yam_init_driver+0x0/0x150 returned 0 after 5178 usecs
calling  bpq_init_driver+0x0/0x70 @ 1
AX.25: bpqether driver version 004
initcall bpq_init_driver+0x0/0x70 returned 0 after 3099 usecs
calling  init_baycomserfdx+0x0/0x120 @ 1
baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
baycom_ser_fdx: version 0.10 compiled 11:12:29 Nov 29 2008
initcall init_baycomserfdx+0x0/0x120 returned 0 after 12265 usecs
calling  hdlcdrv_init_driver+0x0/0x30 @ 1
hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
hdlcdrv: version 0.8 compiled 11:12:32 Nov 29 2008
initcall hdlcdrv_init_driver+0x0/0x30 returned 0 after 8839 usecs
calling  init_baycomserhdx+0x0/0x110 @ 1
baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
baycom_ser_hdx: version 0.10 compiled 11:12:35 Nov 29 2008
initcall init_baycomserhdx+0x0/0x110 returned 0 after 12484 usecs
calling  stir_init+0x0/0x20 @ 1
usbcore: registered new interface driver stir4200
initcall stir_init+0x0/0x20 returned 0 after 4487 usecs
calling  nsc_ircc_init+0x0/0x240 @ 1
initcall nsc_ircc_init+0x0/0x240 returned -19 after 361 usecs
calling  w83977af_init+0x0/0x650 @ 1
initcall w83977af_init+0x0/0x650 returned -19 after 59 usecs
calling  smsc_ircc_init+0x0/0x670 @ 1
initcall smsc_ircc_init+0x0/0x670 returned -19 after 283 usecs
calling  vlsi_mod_init+0x0/0x170 @ 1
initcall vlsi_mod_init+0x0/0x170 returned 0 after 102 usecs
calling  via_ircc_init+0x0/0x30 @ 1
initcall via_ircc_init+0x0/0x30 returned 0 after 90 usecs
calling  irtty_sir_init+0x0/0x60 @ 1
initcall irtty_sir_init+0x0/0x60 returned 0 after 1 usecs
calling  sir_wq_init+0x0/0x40 @ 1
initcall sir_wq_init+0x0/0x40 returned 0 after 33 usecs
calling  esi_sir_init+0x0/0x20 @ 1
initcall esi_sir_init+0x0/0x20 returned 0 after 1 usecs
calling  litelink_sir_init+0x0/0x20 @ 1
initcall litelink_sir_init+0x0/0x20 returned 0 after 1 usecs
calling  girbil_sir_init+0x0/0x20 @ 1
initcall girbil_sir_init+0x0/0x20 returned 0 after 1 usecs
calling  act200l_sir_init+0x0/0x20 @ 1
initcall act200l_sir_init+0x0/0x20 returned 0 after 1 usecs
calling  toim3232_sir_init+0x0/0x30 @ 1
initcall toim3232_sir_init+0x0/0x30 returned 0 after 1 usecs
calling  ks959_init+0x0/0x20 @ 1
usbcore: registered new interface driver ks959-sir
initcall ks959_init+0x0/0x20 returned 0 after 4548 usecs
calling  init_netconsole+0x0/0x260 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x260 returned 0 after 5551 usecs
calling  saa7146_vv_init_module+0x0/0x10 @ 1
initcall saa7146_vv_init_module+0x0/0x10 returned 0 after 0 usecs
calling  videodev_init+0x0/0xa0 @ 1
Linux video capture interface: v2.00
initcall videodev_init+0x0/0xa0 returned 0 after 3358 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 163 usecs
calling  bttv_init_module+0x0/0x110 @ 1
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
initcall bttv_init_module+0x0/0x110 returned 0 after 8685 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 172 usecs
calling  tda9875_init+0x0/0x20 @ 1
initcall tda9875_init+0x0/0x20 returned 0 after 81 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 163 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 159 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 160 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 164 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 199 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 81 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 81 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 198 usecs
calling  saa7191_init+0x0/0x20 @ 1
initcall saa7191_init+0x0/0x20 returned 0 after 82 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 161 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 168 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 165 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 162 usecs
calling  stradis_init+0x0/0x50 @ 1
initcall stradis_init+0x0/0x50 returned 0 after 91 usecs
calling  cpia_init+0x0/0x80 @ 1
V4L-Driver for Vision CPiA based cameras v1.2.3
Since in-kernel colorspace conversion is not allowed, it is disabled by default now. Users should fix the applications in case they don't work without conversion reenabled by setting the 'colorspace_conv' module parameter to 1
initcall cpia_init+0x0/0x80 returned 0 after 23589 usecs
calling  usb_cpia_init+0x0/0x60 @ 1
USB driver for Vision CPiA based cameras v1.2.3
usbcore: registered new interface driver cpia
initcall usb_cpia_init+0x0/0x60 returned 0 after 8330 usecs
calling  saa7134_init+0x0/0x50 @ 1
saa7130/34: v4l2 driver version 0.2.14 loaded
initcall saa7134_init+0x0/0x50 returned 0 after 4135 usecs
calling  empress_register+0x0/0x20 @ 1
initcall empress_register+0x0/0x20 returned 0 after 1 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 166 usecs
calling  tvp5150_init+0x0/0x20 @ 1
initcall tvp5150_init+0x0/0x20 returned 0 after 82 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 162 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 82 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 165 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 81 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 162 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 162 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 90 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 82 usecs
calling  cpia2_init+0x0/0x1c0 @ 1
cpia2: V4L-Driver for Vision CPiA2 based cameras v2.0.0
usbcore: registered new interface driver cpia2
initcall cpia2_init+0x0/0x1c0 returned 0 after 9091 usecs
calling  mxb_init_module+0x0/0x60 @ 1
saa7146: register extension 'Multimedia eXtension Board'.
initcall mxb_init_module+0x0/0x60 returned 0 after 5144 usecs
calling  v4l2_i2c_drv_init+0x0/0x110 @ 1
initcall v4l2_i2c_drv_init+0x0/0x110 returned 0 after 162 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 86 usecs
calling  v4l2_i2c_drv_init+0x0/0x80 @ 1
initcall v4l2_i2c_drv_init+0x0/0x80 returned 0 after 87 usecs
calling  cafe_init+0x0/0x90 @ 1
Marvell M88ALP01 'CAFE' Camera Controller version 2
initcall cafe_init+0x0/0x90 returned 0 after 4652 usecs
calling  ov7670_mod_init+0x0/0x30 @ 1
OmniVision ov7670 sensor driver, at your service
initcall ov7670_mod_init+0x0/0x30 returned 0 after 4372 usecs
calling  dabusb_init+0x0/0xf0 @ 1
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
initcall dabusb_init+0x0/0xf0 returned 0 after 9321 usecs
calling  module_start+0x0/0xc0 @ 1
ivtv:  Start initialization, version 1.4.0
ivtv:  End initialization
initcall module_start+0x0/0xc0 returned 0 after 6209 usecs
calling  ivtvfb_init+0x0/0x730 @ 1
ivtvfb:  no cards foundinitcall ivtvfb_init+0x0/0x730 returned -19 after 1995 usecs
calling  sh_mobile_ceu_init+0x0/0x20 @ 1
initcall sh_mobile_ceu_init+0x0/0x20 returned 0 after 81 usecs
calling  soc_camera_init+0x0/0x50 @ 1
initcall soc_camera_init+0x0/0x50 returned 0 after 163 usecs
calling  mt9m001_mod_init+0x0/0x20 @ 1
initcall mt9m001_mod_init+0x0/0x20 returned 0 after 82 usecs
calling  mt9m111_mod_init+0x0/0x20 @ 1
initcall mt9m111_mod_init+0x0/0x20 returned 0 after 81 usecs
calling  soc_camera_platform_module_init+0x0/0x20 @ 1
initcall soc_camera_platform_module_init+0x0/0x20 returned 0 after 100 usecs
calling  dsbr100_init+0x0/0x40 @ 1
usbcore: registered new interface driver dsbr100
dsbr100: v0.41:D-Link DSB-R100 USB FM radio driver
initcall dsbr100_init+0x0/0x40 returned 0 after 8840 usecs
calling  si470x_module_init+0x0/0x30 @ 1
USB radio driver for Si470x FM Radio Receivers, Version 1.0.8
usbcore: registered new interface driver radio-si470x
initcall si470x_module_init+0x0/0x30 returned 0 after 10188 usecs
calling  amradio_init+0x0/0x50 @ 1
usbcore: registered new interface driver radio-mr800
radio_mr800: 0.01 AverMedia MR 800 USB FM radio driver
initcall amradio_init+0x0/0x50 returned 0 after 9524 usecs
calling  zatm_init_module+0x0/0x20 @ 1
initcall zatm_init_module+0x0/0x20 returned 0 after 89 usecs
calling  uPD98402_module_init+0x0/0x10 @ 1
initcall uPD98402_module_init+0x0/0x10 returned 0 after 1 usecs
calling  amb_module_init+0x0/0x180 @ 1
Madge ATM Ambassador driver version 1.2.4
amb: debug bitmap is 0
initcall amb_module_init+0x0/0x180 returned 0 after 5868 usecs
calling  ia_module_init+0x0/0x80 @ 1
initcall ia_module_init+0x0/0x80 returned 0 after 94 usecs
calling  fore200e_module_init+0x0/0x30 @ 1
fore200e: FORE Systems 200E-series ATM driver - version 0.3e
initcall fore200e_module_init+0x0/0x30 returned 0 after 5396 usecs
calling  eni_init+0x0/0x20 @ 1
initcall eni_init+0x0/0x20 returned 0 after 99 usecs
calling  adummy_init+0x0/0xc0 @ 1
adummy: version 1.0
initcall adummy_init+0x0/0xc0 returned 0 after 1949 usecs
calling  atmtcp_init+0x0/0x20 @ 1
initcall atmtcp_init+0x0/0x20 returned 0 after 1 usecs
calling  firestream_init_module+0x0/0x20 @ 1
initcall firestream_init_module+0x0/0x20 returned 0 after 95 usecs
calling  lanai_module_init+0x0/0x40 @ 1
initcall lanai_module_init+0x0/0x40 returned 0 after 89 usecs
calling  scsi_tgt_init+0x0/0xa0 @ 1
initcall scsi_tgt_init+0x0/0xa0 returned 0 after 399 usecs
calling  raid_init+0x0/0x20 @ 1
initcall raid_init+0x0/0x20 returned 0 after 80 usecs
calling  spi_transport_init+0x0/0x30 @ 1
initcall spi_transport_init+0x0/0x30 returned 0 after 155 usecs
calling  fc_transport_init+0x0/0x50 @ 1
initcall fc_transport_init+0x0/0x50 returned 0 after 321 usecs
calling  iscsi_transport_init+0x0/0x170 @ 1
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x170 returned 0 after 3995 usecs
calling  srp_transport_init+0x0/0x50 @ 1
initcall srp_transport_init+0x0/0x50 returned 0 after 173 usecs
calling  iscsi_tcp_init+0x0/0x50 @ 1
iscsi: registered transport (tcp)
initcall iscsi_tcp_init+0x0/0x50 returned 0 after 3124 usecs
calling  BusLogic_init+0x0/0x1320 @ 1
initcall BusLogic_init+0x0/0x1320 returned 0 after 48 usecs
calling  adpt_init+0x0/0x1140 @ 1
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
initcall adpt_init+0x0/0x1140 returned -19 after 7912 usecs
calling  arcmsr_module_init+0x0/0x20 @ 1
initcall arcmsr_module_init+0x0/0x20 returned 0 after 94 usecs
calling  ahc_linux_init+0x0/0x70 @ 1
initcall ahc_linux_init+0x0/0x70 returned 0 after 172 usecs
calling  ahd_linux_init+0x0/0x90 @ 1
initcall ahd_linux_init+0x0/0x90 returned 0 after 104 usecs
calling  aac_init+0x0/0x80 @ 1
Adaptec aacraid driver 1.1-5[2456]-ms
initcall aac_init+0x0/0x80 returned 0 after 3462 usecs
calling  qla1280_init+0x0/0x20 @ 1
initcall qla1280_init+0x0/0x20 returned 0 after 94 usecs
calling  qla2x00_module_init+0x0/0x1b0 @ 1
QLogic Fibre Channel HBA Driver: 8.02.01-k9
initcall qla2x00_module_init+0x0/0x1b0 returned 0 after 4132 usecs
calling  qla4xxx_module_init+0x0/0x160 @ 1
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
initcall qla4xxx_module_init+0x0/0x160 returned 0 after 5884 usecs
calling  dmx3191d_init+0x0/0x20 @ 1
initcall dmx3191d_init+0x0/0x20 returned 0 after 99 usecs
calling  sym2_init+0x0/0x120 @ 1
initcall sym2_init+0x0/0x120 returned 0 after 94 usecs
calling  init_this_scsi_driver+0x0/0x110 @ 1
initcall init_this_scsi_driver+0x0/0x110 returned -19 after 7 usecs
calling  dc395x_module_init+0x0/0x20 @ 1
initcall dc395x_module_init+0x0/0x20 returned 0 after 90 usecs
calling  dc390_module_init+0x0/0xb0 @ 1
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=1" and report to maintainers
initcall dc390_module_init+0x0/0xb0 returned 0 after 11227 usecs
calling  megaraid_init+0x0/0xd0 @ 1
initcall megaraid_init+0x0/0xd0 returned 0 after 103 usecs
calling  atp870u_init+0x0/0x20 @ 1
initcall atp870u_init+0x0/0x20 returned 0 after 90 usecs
calling  gdth_init+0x0/0xf0 @ 1
GDT-HA: Storage RAID Controller Driver. Version: 3.05
initcall gdth_init+0x0/0xf0 returned 0 after 4808 usecs
calling  twa_init+0x0/0x30 @ 1
3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
initcall twa_init+0x0/0x30 returned 0 after 5988 usecs
calling  stex_init+0x0/0x30 @ 1
stex: Promise SuperTrak EX Driver version: 3.6.0000.1
initcall stex_init+0x0/0x30 returned 0 after 4819 usecs
calling  init_st+0x0/0x1b0 @ 1
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
initcall init_st+0x0/0x1b0 returned 0 after 10019 usecs
calling  init_osst+0x0/0x150 @ 1
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
Driver 'osst' needs updating - please use bus_type methods
initcall init_osst+0x0/0x150 returned 0 after 15644 usecs
calling  init_sd+0x0/0xd0 @ 1
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0xd0 returned 0 after 5137 usecs
calling  init_sr+0x0/0x60 @ 1
Driver 'sr' needs updating - please use bus_type methods
initcall init_sr+0x0/0x60 returned 0 after 5050 usecs
calling  init_sg+0x0/0x170 @ 1
initcall init_sg+0x0/0x170 returned 0 after 109 usecs
calling  init_ch_module+0x0/0xc0 @ 1
SCSI Media Changer driver v0.25 
Driver 'ch' needs updating - please use bus_type methods
initcall init_ch_module+0x0/0xc0 returned 0 after 8054 usecs
calling  ses_init+0x0/0x50 @ 1
Driver 'ses' needs updating - please use bus_type methods
initcall ses_init+0x0/0x50 returned 0 after 5132 usecs
calling  ahci_init+0x0/0x20 @ 1
initcall ahci_init+0x0/0x20 returned 0 after 95 usecs
calling  k2_sata_init+0x0/0x20 @ 1
initcall k2_sata_init+0x0/0x20 returned 0 after 94 usecs
calling  piix_init+0x0/0x30 @ 1
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
ata2: port disabled. ignoring.
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 9
ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 9
ata3.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata4.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: ATAPI: PLEXTOR DVDR   PX-755A, 1.03, max UDMA/66
ata4.00: configured for UDMA/133
ata4.01: configured for UDMA/66
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors: (164 GB/153 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors: (164 GB/153 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 3:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors: (164 GB/153 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors: (164 GB/153 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg1 type 0
scsi 3:0:1:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.03 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:1:0: Attached scsi CD-ROM sr0
sr 3:0:1:0: Attached scsi generic sg2 type 5
initcall piix_init+0x0/0x30 returned 0 after 814080 usecs
calling  pdc_ata_init+0x0/0x20 @ 1
initcall pdc_ata_init+0x0/0x20 returned 0 after 103 usecs
calling  sil_init+0x0/0x20 @ 1
sata_sil 0000:05:05.0: version 2.3
sata_sil 0000:05:05.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
sata_sil 0000:05:05.0: Applying R_ERR on DMA activate FIS errata fix
scsi4 : sata_sil
scsi5 : sata_sil
scsi6 : sata_sil
scsi7 : sata_sil
ata5: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000c880 irq 10
ata6: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000c8c0 irq 10
ata7: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000ca80 irq 10
ata8: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000cac0 irq 10
ata5: SATA link down (SStatus 0 SControl 310)
ata6: SATA link down (SStatus 0 SControl 310)
ata7: SATA link down (SStatus 0 SControl 310)
ata8: SATA link down (SStatus 0 SControl 310)
initcall sil_init+0x0/0x20 returned 0 after 1311670 usecs
calling  vsc_sata_init+0x0/0x20 @ 1
initcall vsc_sata_init+0x0/0x20 returned 0 after 90 usecs
calling  sis_init+0x0/0x20 @ 1
initcall sis_init+0x0/0x20 returned 0 after 94 usecs
calling  nv_init+0x0/0x20 @ 1
initcall nv_init+0x0/0x20 returned 0 after 100 usecs
calling  mv_init+0x0/0x60 @ 1
initcall mv_init+0x0/0x60 returned 0 after 177 usecs
calling  inic_init+0x0/0x20 @ 1
initcall inic_init+0x0/0x20 returned 0 after 108 usecs
calling  adma_ata_init+0x0/0x20 @ 1
initcall adma_ata_init+0x0/0x20 returned 0 after 93 usecs
calling  ali_init+0x0/0x20 @ 1
initcall ali_init+0x0/0x20 returned 0 after 135 usecs
calling  amd_init+0x0/0x20 @ 1
initcall amd_init+0x0/0x20 returned 0 after 90 usecs
calling  artop_init+0x0/0x20 @ 1
initcall artop_init+0x0/0x20 returned 0 after 89 usecs
calling  atiixp_init+0x0/0x20 @ 1
initcall atiixp_init+0x0/0x20 returned 0 after 90 usecs
calling  cmd64x_init+0x0/0x20 @ 1
initcall cmd64x_init+0x0/0x20 returned 0 after 112 usecs
calling  cs5520_init+0x0/0x20 @ 1
initcall cs5520_init+0x0/0x20 returned 0 after 89 usecs
calling  cs5530_init+0x0/0x20 @ 1
initcall cs5530_init+0x0/0x20 returned 0 after 89 usecs
calling  cy82c693_init+0x0/0x20 @ 1
initcall cy82c693_init+0x0/0x20 returned 0 after 88 usecs
calling  efar_init+0x0/0x20 @ 1
initcall efar_init+0x0/0x20 returned 0 after 93 usecs
calling  hpt36x_init+0x0/0x20 @ 1
initcall hpt36x_init+0x0/0x20 returned 0 after 89 usecs
calling  hpt37x_init+0x0/0x20 @ 1
initcall hpt37x_init+0x0/0x20 returned 0 after 94 usecs
calling  it821x_init+0x0/0x20 @ 1
initcall it821x_init+0x0/0x20 returned 0 after 89 usecs
calling  jmicron_init+0x0/0x20 @ 1
initcall jmicron_init+0x0/0x20 returned 0 after 89 usecs
calling  ninja32_init+0x0/0x20 @ 1
initcall ninja32_init+0x0/0x20 returned 0 after 89 usecs
calling  ns87410_init+0x0/0x20 @ 1
initcall ns87410_init+0x0/0x20 returned 0 after 89 usecs
calling  ns87415_init+0x0/0x20 @ 1
initcall ns87415_init+0x0/0x20 returned 0 after 93 usecs
calling  opti_init+0x0/0x20 @ 1
initcall opti_init+0x0/0x20 returned 0 after 90 usecs
calling  oldpiix_init+0x0/0x20 @ 1
initcall oldpiix_init+0x0/0x20 returned 0 after 90 usecs
calling  pdc2027x_init+0x0/0x20 @ 1
initcall pdc2027x_init+0x0/0x20 returned 0 after 90 usecs
calling  pdc202xx_init+0x0/0x20 @ 1
initcall pdc202xx_init+0x0/0x20 returned 0 after 90 usecs
calling  rz1000_init+0x0/0x20 @ 1
initcall rz1000_init+0x0/0x20 returned 0 after 94 usecs
calling  sc1200_init+0x0/0x20 @ 1
initcall sc1200_init+0x0/0x20 returned 0 after 90 usecs
calling  serverworks_init+0x0/0x20 @ 1
initcall serverworks_init+0x0/0x20 returned 0 after 90 usecs
calling  sil680_init+0x0/0x20 @ 1
initcall sil680_init+0x0/0x20 returned 0 after 99 usecs
calling  via_init+0x0/0x20 @ 1
initcall via_init+0x0/0x20 returned 0 after 90 usecs
calling  sis_init+0x0/0x20 @ 1
initcall sis_init+0x0/0x20 returned 0 after 94 usecs
calling  triflex_init+0x0/0x20 @ 1
initcall triflex_init+0x0/0x20 returned 0 after 89 usecs
calling  pata_platform_init+0x0/0x20 @ 1
initcall pata_platform_init+0x0/0x20 returned 0 after 80 usecs
calling  pacpi_init+0x0/0x20 @ 1
initcall pacpi_init+0x0/0x20 returned 0 after 92 usecs
calling  ata_generic_init+0x0/0x20 @ 1
initcall ata_generic_init+0x0/0x20 returned 0 after 91 usecs
calling  fw_core_init+0x0/0xc0 @ 1
initcall fw_core_init+0x0/0xc0 returned 0 after 95 usecs
calling  fw_ohci_init+0x0/0x20 @ 1
firewire_ohci 0000:05:04.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
firewire_ohci: Added fw-ohci device 0000:05:04.0, OHCI version 1.10
initcall fw_ohci_init+0x0/0x20 returned 0 after 82766 usecs
calling  uio_init+0x0/0x10 @ 1
initcall uio_init+0x0/0x10 returned 0 after 1 usecs
calling  hilscher_init_module+0x0/0x20 @ 1
initcall hilscher_init_module+0x0/0x20 returned 0 after 90 usecs
calling  uio_pdrv_init+0x0/0x20 @ 1
initcall uio_pdrv_init+0x0/0x20 returned 0 after 86 usecs
calling  uio_pdrv_genirq_init+0x0/0x20 @ 1
initcall uio_pdrv_genirq_init+0x0/0x20 returned 0 after 81 usecs
calling  smx_ce_init_module+0x0/0x20 @ 1
initcall smx_ce_init_module+0x0/0x20 returned 0 after 81 usecs
calling  cdrom_init+0x0/0x10 @ 1
initcall cdrom_init+0x0/0x10 returned 0 after 1 usecs
calling  aoe_init+0x0/0xc0 @ 1
aoe: AoE v47 initialised.
initcall aoe_init+0x0/0xc0 returned 0 after 3251 usecs
calling  mon_init+0x0/0x140 @ 1
initcall mon_init+0x0/0x140 returned 0 after 199 usecs
calling  ehci_hcd_init+0x0/0x120 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 11, io mem 0x50404400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc6-tip-01066-gb8cb0e0-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
initcall ehci_hcd_init+0x0/0x120 returned 0 after 99380 usecs
calling  isp116x_init+0x0/0x40 @ 1
116x: driver isp116x-hcd, 03 Nov 2005
initcall isp116x_init+0x0/0x40 returned 0 after 3445 usecs
calling  ohci_hcd_mod_init+0x0/0x140 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
initcall ohci_hcd_mod_init+0x0/0x140 returned 0 after 5064 usecs
calling  uhci_hcd_init+0x0/0x100 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00004080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-rc6-tip-01066-gb8cb0e0-dirty uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: irq 9, io base 0x00004060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-rc6-tip-01066-gb8cb0e0-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: irq 10, io base 0x00004040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28-rc6-tip-01066-gb8cb0e0-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: irq 11, io base 0x00004020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28-rc6-tip-01066-gb8cb0e0-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
initcall uhci_hcd_init+0x0/0x100 returned 0 after 261315 usecs
calling  sl811h_init+0x0/0x40 @ 1
sl811: driver sl811-hcd, 19 May 2005
initcall sl811h_init+0x0/0x40 returned 0 after 3414 usecs
calling  r8a66597_init+0x0/0x40 @ 1
r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
initcall r8a66597_init+0x0/0x40 returned 0 after 4409 usecs
calling  c67x00_init+0x0/0x20 @ 1
firewire_core: created device fw0: GUID 0090270001ab6fc2, S400
initcall c67x00_init+0x0/0x20 returned 0 after 5569 usecs
calling  acm_init+0x0/0x150 @ 1
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
initcall acm_init+0x0/0x150 returned 0 after 11804 usecs
calling  usblp_init+0x0/0x20 @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x20 returned 0 after 4208 usecs
calling  wdm_init+0x0/0x20 @ 1
usbcore: registered new interface driver cdc_wdm
initcall wdm_init+0x0/0x20 returned 0 after 4397 usecs
calling  usbtmc_init+0x0/0x40 @ 1
usbcore: registered new interface driver usbtmc
initcall usbtmc_init+0x0/0x40 returned 0 after 4296 usecs
calling  usb_usual_init+0x0/0x50 @ 1
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x50 returned 0 after 4477 usecs
calling  usb_mdc800_init+0x0/0x270 @ 1
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall usb_mdc800_init+0x0/0x270 returned 0 after 10544 usecs
calling  microtek_drv_init+0x0/0x20 @ 1
usbcore: registered new interface driver microtekX6
initcall microtek_drv_init+0x0/0x20 returned 0 after 4635 usecs
calling  adu_init+0x0/0xa0 @ 1
drivers/usb/misc/adutux.c :  adu_init : enter 
usbcore: registered new interface driver adutux
adutux adutux (see www.ontrak.net) v0.0.13
adutux is an experimental driver. Use at your own risk
drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
initcall adu_init+0x0/0xa0 returned 0 after 22472 usecs
calling  berry_init+0x0/0x20 @ 1
usbcore: registered new interface driver berry_charge
initcall berry_init+0x0/0x20 returned 0 after 4807 usecs
calling  usb_cytherm_init+0x0/0x60 @ 1
usbcore: registered new interface driver cytherm
cytherm: v1.0:Cypress USB Thermometer driver
initcall usb_cytherm_init+0x0/0x60 returned 0 after 8341 usecs
calling  emi26_init+0x0/0x20 @ 1
usbcore: registered new interface driver emi26 - firmware loader
initcall emi26_init+0x0/0x20 returned 0 after 5730 usecs
calling  emi62_init+0x0/0x40 @ 1
usbcore: registered new interface driver emi62 - firmware loader
initcall emi62_init+0x0/0x40 returned 0 after 5735 usecs
calling  usb_idmouse_init+0x0/0x50 @ 1
idmouse: 0.6:Siemens ID Mouse FingerTIP Sensor Driver
usbcore: registered new interface driver idmouse
initcall usb_idmouse_init+0x0/0x50 returned 0 after 9093 usecs
calling  iowarrior_init+0x0/0x20 @ 1
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x20 returned 0 after 4564 usecs
calling  usb_lcd_init+0x0/0x40 @ 1
usbcore: registered new interface driver usblcd
initcall usb_lcd_init+0x0/0x40 returned 0 after 4293 usecs
calling  usb_led_init+0x0/0x40 @ 1
usbcore: registered new interface driver usbled
initcall usb_led_init+0x0/0x40 returned 0 after 4293 usecs
calling  lego_usb_tower_init+0x0/0x90 @ 1
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
usbcore: registered new interface driver legousbtower
legousbtower: v0.96:LEGO USB Tower Driver
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
initcall lego_usb_tower_init+0x0/0x90 returned 0 after 20314 usecs
calling  init_phidget+0x0/0x40 @ 1
initcall init_phidget+0x0/0x40 returned 0 after 81 usecs
calling  interfacekit_init+0x0/0x40 @ 1
usbcore: registered new interface driver phidgetkit
initcall interfacekit_init+0x0/0x40 returned 0 after 4632 usecs
calling  phidget_servo_init+0x0/0x40 @ 1
usbcore: registered new interface driver phidgetservo
initcall phidget_servo_init+0x0/0x40 returned 0 after 4801 usecs
calling  usb_sevseg_init+0x0/0x40 @ 1
usbcore: registered new interface driver usbsevseg
initcall usb_sevseg_init+0x0/0x40 returned 0 after 4545 usecs
calling  vstusb_init+0x0/0x50 @ 1
usbcore: registered new interface driver vstusb
initcall vstusb_init+0x0/0x50 returned 0 after 4319 usecs
calling  cxacru_init+0x0/0x20 @ 1
usbcore: registered new interface driver cxacru
initcall cxacru_init+0x0/0x20 returned 0 after 4297 usecs
calling  speedtch_usb_init+0x0/0x40 @ 1
drivers/usb/atm/speedtch.c: speedtch_usb_init: driver version 1.10
usbcore: registered new interface driver speedtch
initcall speedtch_usb_init+0x0/0x40 returned 0 after 10274 usecs
calling  usbatm_usb_init+0x0/0x70 @ 1
drivers/usb/atm/usbatm.c: usbatm_usb_init: driver version 1.10
initcall usbatm_usb_init+0x0/0x70 returned 0 after 5477 usecs
calling  xusbatm_init+0x0/0x140 @ 1
drivers/usb/atm/xusbatm.c: xusbatm_init
xusbatm: malformed module parameters
initcall xusbatm_init+0x0/0x140 returned -22 after 6806 usecs
initcall xusbatm_init+0x0/0x140 returned with error code -22 
calling  i8042_init+0x0/0x420 @ 1
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x420 returned 0 after 16594 usecs
calling  serport_init+0x0/0x40 @ 1
initcall serport_init+0x0/0x40 returned 0 after 1 usecs
calling  ct82c710_init+0x0/0x1d0 @ 1
initcall ct82c710_init+0x0/0x1d0 returned -19 after 14 usecs
calling  pcips2_init+0x0/0x20 @ 1
initcall pcips2_init+0x0/0x20 returned 0 after 299 usecs
calling  serio_raw_init+0x0/0x20 @ 1
initcall serio_raw_init+0x0/0x20 returned 0 after 83 usecs
calling  l4_init+0x0/0x2b0 @ 1
initcall l4_init+0x0/0x2b0 returned -19 after 8 usecs
calling  mousedev_init+0x0/0xa0 @ 1
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0xa0 returned 0 after 4079 usecs
calling  joydev_init+0x0/0x20 @ 1
initcall joydev_init+0x0/0x20 returned 0 after 2 usecs
calling  evdev_init+0x0/0x20 @ 1
initcall evdev_init+0x0/0x20 returned 0 after 26406 usecs
calling  evbug_init+0x0/0x20 @ 1
evbug.c: Connected device: input0 (Power Button (FF) at LNXPWRBN/button/input0)
evbug.c: Connected device: input1 (Sleep Button (CM) at PNP0C0E/button/input0)
initcall evbug_init+0x0/0x20 returned 0 after 37783 usecs
calling  atkbd_init+0x0/0x30 @ 1
initcall atkbd_init+0x0/0x30 returned 0 after 88 usecs
calling  xtkbd_init+0x0/0x20 @ 1
initcall xtkbd_init+0x0/0x20 returned 0 after 106 usecs
calling  skbd_init+0x0/0x20 @ 1
initcall skbd_init+0x0/0x20 returned 0 after 92 usecs
calling  gpio_keys_init+0x0/0x20 @ 1
initcall gpio_keys_init+0x0/0x20 returned 0 after 88 usecs
calling  atp_init+0x0/0x20 @ 1
usbcore: registered new interface driver appletouch
initcall atp_init+0x0/0x20 returned 0 after 4665 usecs
calling  bcm5974_init+0x0/0x20 @ 1
usbcore: registered new interface driver bcm5974
initcall bcm5974_init+0x0/0x20 returned 0 after 4395 usecs
calling  psmouse_init+0x0/0x80 @ 1
initcall psmouse_init+0x0/0x80 returned 0 after 125 usecs
calling  sermouse_init+0x0/0x20 @ 1
initcall sermouse_init+0x0/0x20 returned 0 after 95 usecs
calling  vsxxxaa_init+0x0/0x20 @ 1
initcall vsxxxaa_init+0x0/0x20 returned 0 after 192 usecs
calling  gpio_mouse_init+0x0/0x20 @ 1
input: AT Translated Set 2 keyboard as /class/input/input2
initcall gpio_mouse_init+0x0/0x20 returned -19 after 5349 usecs
calling  a3d_init+0x0/0x20 @ 1
initcall a3d_init+0x0/0x20 returned 0 after 83 usecs
calling  adi_init+0x0/0x20 @ 1
initcall adi_init+0x0/0x20 returned 0 after 85 usecs
calling  analog_init+0x0/0x130 @ 1
initcall analog_init+0x0/0x130 returned 0 after 96 usecs
calling  grip_init+0x0/0x20 @ 1
initcall grip_init+0x0/0x20 returned 0 after 84 usecs
calling  iforce_init+0x0/0x10 @ 1
initcall iforce_init+0x0/0x10 returned 0 after 1 usecs
calling  interact_init+0x0/0x20 @ 1
initcall interact_init+0x0/0x20 returned 0 after 186 usecs
calling  joydump_init+0x0/0x20 @ 1
initcall joydump_init+0x0/0x20 returned 0 after 93 usecs
calling  sw_init+0x0/0x20 @ 1
evbug.c: Connected device: input2 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
initcall sw_init+0x0/0x20 returned 0 after 7952 usecs
calling  spaceball_init+0x0/0x20 @ 1
initcall spaceball_init+0x0/0x20 returned 0 after 231 usecs
calling  spaceorb_init+0x0/0x20 @ 1
initcall spaceorb_init+0x0/0x20 returned 0 after 144 usecs
calling  stinger_init+0x0/0x20 @ 1
initcall stinger_init+0x0/0x20 returned 0 after 161 usecs
calling  twidjoy_init+0x0/0x20 @ 1
initcall twidjoy_init+0x0/0x20 returned 0 after 146 usecs
calling  warrior_init+0x0/0x20 @ 1
initcall warrior_init+0x0/0x20 returned 0 after 143 usecs
calling  usb_xpad_init+0x0/0x40 @ 1
usbcore: registered new interface driver xpad
xpad: X-Box pad driver
initcall usb_xpad_init+0x0/0x40 returned 0 after 6296 usecs
calling  gtco_init+0x0/0x60 @ 1
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006initcall gtco_init+0x0/0x60 returned 0 after 7104 usecs
calling  gunze_init+0x0/0x20 @ 1
initcall gunze_init+0x0/0x20 returned 0 after 146 usecs
calling  fujitsu_init+0x0/0x20 @ 1
initcall fujitsu_init+0x0/0x20 returned 0 after 143 usecs
calling  inexio_init+0x0/0x20 @ 1
initcall inexio_init+0x0/0x20 returned 0 after 142 usecs
calling  mtouch_init+0x0/0x20 @ 1
initcall mtouch_init+0x0/0x20 returned 0 after 143 usecs
calling  mk712_init+0x0/0x200 @ 1
mk712: device not present
initcall mk712_init+0x0/0x200 returned -19 after 2335 usecs
calling  usbtouch_init+0x0/0x20 @ 1
usbcore: registered new interface driver usbtouchscreen
initcall usbtouch_init+0x0/0x20 returned 0 after 5041 usecs
calling  touchit213_init+0x0/0x20 @ 1
initcall touchit213_init+0x0/0x20 returned 0 after 147 usecs
calling  pcspkr_init+0x0/0x20 @ 1
input: PC Speaker as /class/input/input3
evbug.c: Connected device: input3 (PC Speaker at isa0061/input0)
initcall pcspkr_init+0x0/0x20 returned 0 after 45735 usecs
calling  atlas_acpi_init+0x0/0x40 @ 1
initcall atlas_acpi_init+0x0/0x40 returned 0 after 161 usecs
calling  ati_remote2_init+0x0/0x60 @ 1
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.3
initcall ati_remote2_init+0x0/0x60 returned 0 after 9214 usecs
calling  powermate_init+0x0/0x20 @ 1
usbcore: registered new interface driver powermate
initcall powermate_init+0x0/0x20 returned 0 after 4625 usecs
calling  yealink_dev_init+0x0/0x40 @ 1
usbcore: registered new interface driver yealink
yealink: yld-20051230:Yealink phone driver
initcall yealink_dev_init+0x0/0x40 returned 0 after 8240 usecs
calling  cm109_init+0x0/0x100 @ 1
cm109: Keymap for Komunikate KIP1000 phone loaded
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
initcall cm109_init+0x0/0x100 returned 0 after 13887 usecs
calling  apanel_init+0x0/0x1f0 @ 1
apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
initcall apanel_init+0x0/0x1f0 returned -19 after 5182 usecs
calling  cmos_init+0x0/0x60 @ 1
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram
initcall cmos_init+0x0/0x60 returned 0 after 12411 usecs
calling  ds1286_init+0x0/0x20 @ 1
initcall ds1286_init+0x0/0x20 returned 0 after 139 usecs
calling  ds1374_init+0x0/0x20 @ 1
initcall ds1374_init+0x0/0x20 returned 0 after 150 usecs
calling  ds1742_init+0x0/0x20 @ 1
initcall ds1742_init+0x0/0x20 returned 0 after 139 usecs
calling  isl1208_init+0x0/0x20 @ 1
initcall isl1208_init+0x0/0x20 returned 0 after 146 usecs
calling  m41t80_rtc_init+0x0/0x20 @ 1
initcall m41t80_rtc_init+0x0/0x20 returned 0 after 83 usecs
calling  m48t35_init+0x0/0x20 @ 1
initcall m48t35_init+0x0/0x20 returned 0 after 140 usecs
calling  m48t59_rtc_init+0x0/0x20 @ 1
initcall m48t59_rtc_init+0x0/0x20 returned 0 after 140 usecs
calling  pcf8563_init+0x0/0x20 @ 1
initcall pcf8563_init+0x0/0x20 returned 0 after 139 usecs
calling  pcf8583_init+0x0/0x20 @ 1
initcall pcf8583_init+0x0/0x20 returned 0 after 140 usecs
calling  rs5c372_init+0x0/0x20 @ 1
initcall rs5c372_init+0x0/0x20 returned 0 after 144 usecs
calling  rx8581_init+0x0/0x20 @ 1
initcall rx8581_init+0x0/0x20 returned 0 after 139 usecs
calling  s35390a_rtc_init+0x0/0x20 @ 1
initcall s35390a_rtc_init+0x0/0x20 returned 0 after 146 usecs
calling  stk17ta8_init+0x0/0x20 @ 1
initcall stk17ta8_init+0x0/0x20 returned 0 after 84 usecs
calling  test_init+0x0/0xd0 @ 1
elantech.c: unexpected magic knock result 0x00, 0x00, 0x14.
rtc-test rtc-test.0: rtc core: registered test as rtc1
rtc-test rtc-test.1: rtc core: registered test as rtc2
initcall test_init+0x0/0xd0 returned 0 after 15514 usecs
calling  v3020_init+0x0/0x20 @ 1
initcall v3020_init+0x0/0x20 returned 0 after 141 usecs
calling  x1205_init+0x0/0x20 @ 1
initcall x1205_init+0x0/0x20 returned 0 after 141 usecs
calling  ali1563_init+0x0/0x20 @ 1
initcall ali1563_init+0x0/0x20 returned 0 after 157 usecs
calling  i2c_ali15x3_init+0x0/0x20 @ 1
initcall i2c_ali15x3_init+0x0/0x20 returned 0 after 155 usecs
calling  amd756_init+0x0/0x20 @ 1
initcall amd756_init+0x0/0x20 returned 0 after 93 usecs
calling  i2c_amd8111_init+0x0/0x20 @ 1
initcall i2c_amd8111_init+0x0/0x20 returned 0 after 199 usecs
calling  i2c_sis5595_init+0x0/0x20 @ 1
initcall i2c_sis5595_init+0x0/0x20 returned 0 after 149 usecs
calling  i2c_sis630_init+0x0/0x20 @ 1
initcall i2c_sis630_init+0x0/0x20 returned 0 after 150 usecs
calling  i2c_vt586b_init+0x0/0x20 @ 1
initcall i2c_vt586b_init+0x0/0x20 returned 0 after 154 usecs
calling  i2c_vt596_init+0x0/0x20 @ 1
initcall i2c_vt596_init+0x0/0x20 returned 0 after 150 usecs
calling  ocores_i2c_init+0x0/0x20 @ 1
initcall ocores_i2c_init+0x0/0x20 returned 0 after 146 usecs
calling  i2c_parport_init+0x0/0x180 @ 1
i2c-parport-light: adapter type unspecified
initcall i2c_parport_init+0x0/0x180 returned -19 after 3880 usecs
calling  at24_init+0x0/0x40 @ 1
initcall at24_init+0x0/0x40 returned 0 after 142 usecs
calling  max6875_init+0x0/0x20 @ 1
initcall max6875_init+0x0/0x20 returned 0 after 84 usecs
calling  pcf8591_init+0x0/0x40 @ 1
initcall pcf8591_init+0x0/0x40 returned 0 after 81 usecs
calling  tsl2550_init+0x0/0x20 @ 1
initcall tsl2550_init+0x0/0x20 returned 0 after 85 usecs
calling  w1_init+0x0/0xb0 @ 1
Driver for 1-wire Dallas network protocol.
initcall w1_init+0x0/0xb0 returned 0 after 4035 usecs
calling  matrox_w1_init+0x0/0x20 @ 1
initcall matrox_w1_init+0x0/0x20 returned 0 after 90 usecs
calling  ds_init+0x0/0x40 @ 1
usbcore: registered new interface driver DS9490R
initcall ds_init+0x0/0x40 returned 0 after 4378 usecs
calling  w1_gpio_init+0x0/0x20 @ 1
initcall w1_gpio_init+0x0/0x20 returned -19 after 166 usecs
calling  w1_therm_init+0x0/0x40 @ 1
initcall w1_therm_init+0x0/0x40 returned 0 after 3 usecs
calling  w1_ds2760_init+0x0/0x30 @ 1
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
initcall w1_ds2760_init+0x0/0x30 returned 0 after 7351 usecs
calling  w1_bq27000_init+0x0/0x30 @ 1
initcall w1_bq27000_init+0x0/0x30 returned 0 after 1 usecs
calling  asb100_init+0x0/0x20 @ 1
initcall asb100_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_w83793_init+0x0/0x20 @ 1
initcall sensors_w83793_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_w83791d_init+0x0/0x20 @ 1
initcall sensors_w83791d_init+0x0/0x20 returned 0 after 81 usecs
calling  abituguru_init+0x0/0x1c0 @ 1
initcall abituguru_init+0x0/0x1c0 returned -19 after 1 usecs
calling  abituguru3_init+0x0/0x220 @ 1
initcall abituguru3_init+0x0/0x220 returned -19 after 1 usecs
calling  ad7418_init+0x0/0x20 @ 1
initcall ad7418_init+0x0/0x20 returned 0 after 86 usecs
calling  sensors_adm1021_init+0x0/0x20 @ 1
initcall sensors_adm1021_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_adm1025_init+0x0/0x20 @ 1
initcall sensors_adm1025_init+0x0/0x20 returned 0 after 81 usecs
calling  sm_adm1026_init+0x0/0x20 @ 1
initcall sm_adm1026_init+0x0/0x20 returned 0 after 85 usecs
calling  sensors_adm1029_init+0x0/0x20 @ 1
initcall sensors_adm1029_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_adm1031_init+0x0/0x20 @ 1
initcall sensors_adm1031_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_adm9240_init+0x0/0x20 @ 1
initcall sensors_adm9240_init+0x0/0x20 returned 0 after 81 usecs
calling  adt7473_init+0x0/0x20 @ 1
initcall adt7473_init+0x0/0x20 returned 0 after 80 usecs
calling  applesmc_init+0x0/0x620 @ 1
applesmc: supported laptop not found!
applesmc: driver init failed (ret=-19)!
initcall applesmc_init+0x0/0x620 returned -19 after 6896 usecs
calling  dme1737_init+0x0/0x180 @ 1
initcall dme1737_init+0x0/0x180 returned 0 after 89 usecs
calling  ds1621_init+0x0/0x20 @ 1
initcall ds1621_init+0x0/0x20 returned 0 after 81 usecs
calling  f71805f_init+0x0/0x190 @ 1
initcall f71805f_init+0x0/0x190 returned -19 after 15 usecs
calling  f71882fg_init+0x0/0x120 @ 1
f71882fg: Not a Fintek device
f71882fg: Not a Fintek device
initcall f71882fg_init+0x0/0x120 returned -19 after 5366 usecs
calling  sm_fscpos_init+0x0/0x20 @ 1
initcall sm_fscpos_init+0x0/0x20 returned 0 after 88 usecs
calling  sensors_gl518sm_init+0x0/0x20 @ 1
initcall sensors_gl518sm_init+0x0/0x20 returned 0 after 81 usecs
calling  hdaps_init+0x0/0x210 @ 1
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
initcall hdaps_init+0x0/0x210 returned -19 after 6392 usecs
calling  i5k_amb_init+0x0/0x80 @ 1
initcall i5k_amb_init+0x0/0x80 returned 0 after 200 usecs
calling  k8temp_init+0x0/0x20 @ 1
initcall k8temp_init+0x0/0x20 returned 0 after 91 usecs
calling  lis3lv02d_init_module+0x0/0x40 @ 1
lis3lv02d driver loaded.
initcall lis3lv02d_init_module+0x0/0x40 returned 0 after 2357 usecs
calling  sensors_lm63_init+0x0/0x20 @ 1
initcall sensors_lm63_init+0x0/0x20 returned 0 after 87 usecs
calling  sensors_lm77_init+0x0/0x20 @ 1
initcall sensors_lm77_init+0x0/0x20 returned 0 after 82 usecs
calling  sm_lm78_init+0x0/0x460 @ 1
initcall sm_lm78_init+0x0/0x460 returned 0 after 97 usecs
calling  sensors_lm83_init+0x0/0x20 @ 1
initcall sensors_lm83_init+0x0/0x20 returned 0 after 81 usecs
calling  sm_lm85_init+0x0/0x20 @ 1
initcall sm_lm85_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_lm87_init+0x0/0x20 @ 1
initcall sensors_lm87_init+0x0/0x20 returned 0 after 83 usecs
calling  sensors_lm90_init+0x0/0x20 @ 1
initcall sensors_lm90_init+0x0/0x20 returned 0 after 85 usecs
calling  sensors_max1619_init+0x0/0x20 @ 1
initcall sensors_max1619_init+0x0/0x20 returned 0 after 81 usecs
calling  sensors_max6650_init+0x0/0x20 @ 1
initcall sensors_max6650_init+0x0/0x20 returned 0 after 82 usecs
calling  pc87360_init+0x0/0x1c0 @ 1
pc87360: PC8736x not detected, module not inserted.
initcall pc87360_init+0x0/0x1c0 returned -19 after 4555 usecs
calling  pc87427_init+0x0/0x140 @ 1
initcall pc87427_init+0x0/0x140 returned -19 after 9 usecs
calling  sm_sis5595_init+0x0/0x20 @ 1
initcall sm_sis5595_init+0x0/0x20 returned 0 after 91 usecs
calling  sm_smsc47m1_init+0x0/0x250 @ 1
initcall sm_smsc47m1_init+0x0/0x250 returned -19 after 6 usecs
calling  smsc47m192_init+0x0/0x20 @ 1
initcall smsc47m192_init+0x0/0x20 returned 0 after 81 usecs
calling  sm_thmc50_init+0x0/0x20 @ 1
initcall sm_thmc50_init+0x0/0x20 returned 0 after 87 usecs
calling  vt1211_init+0x0/0x190 @ 1
initcall vt1211_init+0x0/0x190 returned -19 after 11 usecs
calling  sm_vt8231_init+0x0/0x20 @ 1
initcall sm_vt8231_init+0x0/0x20 returned 0 after 95 usecs
calling  sensors_w83627ehf_init+0x0/0x180 @ 1
initcall sensors_w83627ehf_init+0x0/0x180 returned -19 after 18 usecs
calling  sensors_w83l785ts_init+0x0/0x20 @ 1
initcall sensors_w83l785ts_init+0x0/0x20 returned 0 after 142 usecs
calling  sensors_w83l786ng_init+0x0/0x20 @ 1
initcall sensors_w83l786ng_init+0x0/0x20 returned 0 after 162 usecs
calling  pcipcwd_init_module+0x0/0x40 @ 1
initcall pcipcwd_init_module+0x0/0x40 returned 0 after 154 usecs
calling  wdtpci_init+0x0/0x20 @ 1
initcall wdtpci_init+0x0/0x20 returned 0 after 96 usecs
calling  acq_init+0x0/0x70 @ 1
WDT driver for Acquire single board computer initialising.
acquirewdt: I/O address 0x0043 already in use
acquirewdt: probe of acquirewdt failed with error -5
initcall acq_init+0x0/0x70 returned 0 after 14014 usecs
calling  advwdt_init+0x0/0x70 @ 1
WDT driver for Advantech single board computer initialising.
advantechwdt: initialized. timeout=60 sec (nowayout=1)
initcall advwdt_init+0x0/0x70 returned 0 after 10407 usecs
calling  watchdog_init+0x0/0x1b0 @ 1
initcall watchdog_init+0x0/0x1b0 returned -19 after 10 usecs
calling  alim7101_wdt_init+0x0/0x200 @ 1
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: ALi M7101 PMU not present - WDT not set
initcall alim7101_wdt_init+0x0/0x200 returned -16 after 8843 usecs
initcall alim7101_wdt_init+0x0/0x200 returned with error code -16 
calling  sc520_wdt_init+0x0/0x110 @ 1
sc520_wdt: cannot register miscdev on minor=130 (err=-16)
initcall sc520_wdt_init+0x0/0x110 returned -16 after 5068 usecs
initcall sc520_wdt_init+0x0/0x110 returned with error code -16 
calling  wafwdt_init+0x0/0x190 @ 1
WDT driver for Wafer 5823 single board computer initialising.
Wafer 5823 WDT: I/O address 0x0443 already in use
initcall wafwdt_init+0x0/0x190 returned -5 after 9770 usecs
initcall wafwdt_init+0x0/0x190 returned with error code -5 
calling  watchdog_init+0x0/0x330 @ 1
initcall watchdog_init+0x0/0x330 returned -19 after 5 usecs
calling  iTCO_wdt_init_module+0x0/0x80 @ 1
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: No card detected
initcall iTCO_wdt_init_module+0x0/0x80 returned 0 after 8045 usecs
calling  iTCO_vendor_init_module+0x0/0x20 @ 1
iTCO_vendor_support: vendor-support=0
initcall iTCO_vendor_init_module+0x0/0x20 returned 0 after 3362 usecs
calling  it8712f_wdt_init+0x0/0x220 @ 1
initcall it8712f_wdt_init+0x0/0x220 returned -19 after 13 usecs
calling  sbc60xxwdt_init+0x0/0x1a0 @ 1
sbc60xxwdt: I/O address 0x0443 already in use
initcall sbc60xxwdt_init+0x0/0x1a0 returned -5 after 4041 usecs
initcall sbc60xxwdt_init+0x0/0x1a0 returned with error code -5 
calling  cpu5wdt_init_module+0x0/0x160 @ 1
cpu5wdt: sorry, was my fault
cpu5wdt: misc_register failed
initcall cpu5wdt_init_module+0x0/0x160 returned -16 after 5272 usecs
initcall cpu5wdt_init_module+0x0/0x160 returned with error code -16 
calling  wdt_init+0x0/0x220 @ 1
WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
initcall wdt_init+0x0/0x220 returned -16 after 12511 usecs
initcall wdt_init+0x0/0x220 returned with error code -16 
calling  wdt_init+0x0/0x210 @ 1
w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
w83697hf/hg WDT: Looking for watchdog at address 0x2e
w83697hf/hg WDT: watchdog not found at address 0x2e
w83697hf/hg WDT: No W83697HF/HG could be found
initcall wdt_init+0x0/0x210 returned -5 after 18360 usecs
initcall wdt_init+0x0/0x210 returned with error code -5 
calling  w83877f_wdt_init+0x0/0x180 @ 1
w83877f_wdt: I/O address 0x0443 already in use
initcall w83877f_wdt_init+0x0/0x180 returned -5 after 4127 usecs
initcall w83877f_wdt_init+0x0/0x180 returned with error code -5 
calling  w83977f_wdt_init+0x0/0x140 @ 1
W83977F WDT: W83977F WDT driver, v1.00
W83977F WDT: cannot register miscdev on minor=130 (err=-16)
initcall w83977f_wdt_init+0x0/0x140 returned -16 after 8670 usecs
initcall w83977f_wdt_init+0x0/0x140 returned with error code -16 
calling  zf_init+0x0/0x1a0 @ 1
machzwd: MachZ ZF-Logic Watchdog driver initializing.
machzwd: no ZF-Logic found
initcall zf_init+0x0/0x1a0 returned -19 after 7131 usecs
calling  watchdog_init+0x0/0xc0 @ 1
epx_c3: cannot register miscdev on minor=130 (err=-16)
initcall watchdog_init+0x0/0xc0 returned -16 after 4802 usecs
initcall watchdog_init+0x0/0xc0 returned with error code -16 
calling  telephony_init+0x0/0x50 @ 1
Linux telephony interface: v1.00
initcall telephony_init+0x0/0x50 returned 0 after 2942 usecs
calling  raid0_init+0x0/0x20 @ 1
md: raid0 personality registered for level 0
initcall raid0_init+0x0/0x20 returned 0 after 3953 usecs
calling  raid_init+0x0/0x20 @ 1
md: raid1 personality registered for level 1
initcall raid_init+0x0/0x20 returned 0 after 3953 usecs
calling  raid_init+0x0/0x20 @ 1
md: faulty personality registered for level -5
initcall raid_init+0x0/0x20 returned 0 after 4122 usecs
calling  dm_init+0x0/0x70 @ 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x70 returned 0 after 11081 usecs
calling  dm_delay_init+0x0/0xe0 @ 1
initcall dm_delay_init+0x0/0xe0 returned 0 after 183 usecs
calling  dm_multipath_init+0x0/0x130 @ 1
device-mapper: multipath: version 1.0.5 loaded
initcall dm_multipath_init+0x0/0x130 returned 0 after 4357 usecs
calling  dm_rr_init+0x0/0x50 @ 1
device-mapper: multipath round-robin: version 1.0.0 loaded
initcall dm_rr_init+0x0/0x50 returned 0 after 5139 usecs
calling  dm_snapshot_init+0x0/0x220 @ 1
initcall dm_snapshot_init+0x0/0x220 returned 0 after 502 usecs
calling  dm_mirror_init+0x0/0x40 @ 1
initcall dm_mirror_init+0x0/0x40 returned 0 after 2 usecs
calling  dm_dirty_log_init+0x0/0x60 @ 1
initcall dm_dirty_log_init+0x0/0x60 returned 0 after 2 usecs
calling  dm_zero_init+0x0/0x40 @ 1
initcall dm_zero_init+0x0/0x40 returned 0 after 2 usecs
calling  cpufreq_stats_init+0x0/0xb0 @ 1
initcall cpufreq_stats_init+0x0/0xb0 returned 0 after 4 usecs
calling  cpufreq_gov_powersave_init+0x0/0x20 @ 1
initcall cpufreq_gov_powersave_init+0x0/0x20 returned 0 after 1 usecs
calling  cpufreq_gov_userspace_init+0x0/0x20 @ 1
initcall cpufreq_gov_userspace_init+0x0/0x20 returned 0 after 1 usecs
calling  cpufreq_gov_dbs_init+0x0/0xa0 @ 1
initcall cpufreq_gov_dbs_init+0x0/0xa0 returned 0 after 96 usecs
calling  cpufreq_gov_dbs_init+0x0/0x20 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x20 returned 0 after 1 usecs
calling  init_ladder+0x0/0x20 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x20 returned 0 after 2770 usecs
calling  init_menu+0x0/0x20 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x20 returned 0 after 2602 usecs
calling  i7300_idle_init+0x0/0x670 @ 1
initcall i7300_idle_init+0x0/0x670 returned -19 after 49 usecs
calling  mmc_test_init+0x0/0x20 @ 1
initcall mmc_test_init+0x0/0x20 returned 0 after 145 usecs
calling  sdio_uart_init+0x0/0x130 @ 1
initcall sdio_uart_init+0x0/0x130 returned 0 after 101 usecs
calling  sdhci_drv_init+0x0/0x30 @ 1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
initcall sdhci_drv_init+0x0/0x30 returned 0 after 7820 usecs
calling  wbsd_drv_init+0x0/0xd0 @ 1
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
initcall wbsd_drv_init+0x0/0xd0 returned 0 after 7614 usecs
calling  tifm_sd_init+0x0/0x20 @ 1
initcall tifm_sd_init+0x0/0x20 returned 0 after 140 usecs
calling  memstick_init+0x0/0xa0 @ 1
initcall memstick_init+0x0/0xa0 returned 0 after 281 usecs
calling  mspro_block_init+0x0/0x90 @ 1
initcall mspro_block_init+0x0/0x90 returned 0 after 140 usecs
calling  tifm_ms_init+0x0/0x20 @ 1
initcall tifm_ms_init+0x0/0x20 returned 0 after 142 usecs
calling  jmb38x_ms_init+0x0/0x20 @ 1
initcall jmb38x_ms_init+0x0/0x20 returned 0 after 171 usecs
calling  clevo_mail_led_init+0x0/0xb0 @ 1
initcall clevo_mail_led_init+0x0/0xb0 returned -19 after 2 usecs
calling  pca955x_leds_init+0x0/0x20 @ 1
initcall pca955x_leds_init+0x0/0x20 returned 0 after 146 usecs
calling  da903x_led_init+0x0/0x20 @ 1
initcall da903x_led_init+0x0/0x20 returned 0 after 145 usecs
calling  timer_trig_init+0x0/0x20 @ 1
initcall timer_trig_init+0x0/0x20 returned 0 after 2 usecs
calling  heartbeat_trig_init+0x0/0x20 @ 1
initcall heartbeat_trig_init+0x0/0x20 returned 0 after 1 usecs
calling  bl_trig_init+0x0/0x20 @ 1
initcall bl_trig_init+0x0/0x20 returned 0 after 1 usecs
calling  ib_core_init+0x0/0x50 @ 1
initcall ib_core_init+0x0/0x50 returned 0 after 138 usecs
calling  ib_mad_init_module+0x0/0xb0 @ 1
initcall ib_mad_init_module+0x0/0xb0 returned 0 after 211 usecs
calling  ib_sa_init+0x0/0xb0 @ 1
initcall ib_sa_init+0x0/0xb0 returned 0 after 99 usecs
calling  ib_cm_init+0x0/0x170 @ 1
initcall ib_cm_init+0x0/0x170 returned 0 after 182 usecs
calling  iw_cm_init+0x0/0x40 @ 1
initcall iw_cm_init+0x0/0x40 returned 0 after 107 usecs
calling  addr_init+0x0/0x50 @ 1
initcall addr_init+0x0/0x50 returned 0 after 93 usecs
calling  cma_init+0x0/0xf0 @ 1
initcall cma_init+0x0/0xf0 returned 0 after 206 usecs
calling  ib_umad_init+0x0/0xf0 @ 1
initcall ib_umad_init+0x0/0xf0 returned 0 after 160 usecs
calling  ib_uverbs_init+0x0/0x180 @ 1
initcall ib_uverbs_init+0x0/0x180 returned 0 after 173 usecs
calling  ib_ucm_init+0x0/0xc0 @ 1
initcall ib_ucm_init+0x0/0xc0 returned 0 after 4 usecs
calling  ucma_init+0x0/0x60 @ 1
initcall ucma_init+0x0/0x60 returned 0 after 172 usecs
calling  mthca_init+0x0/0x160 @ 1
initcall mthca_init+0x0/0x160 returned 0 after 209 usecs
calling  infinipath_init+0x0/0xe0 @ 1
initcall infinipath_init+0x0/0xe0 returned 0 after 183 usecs
calling  nes_init_module+0x0/0x180 @ 1
initcall nes_init_module+0x0/0x180 returned 0 after 337 usecs
calling  srp_init_module+0x0/0x110 @ 1
initcall srp_init_module+0x0/0x110 returned 0 after 194 usecs
calling  dcdrbu_init+0x0/0x170 @ 1
initcall dcdrbu_init+0x0/0x170 returned 0 after 168 usecs
calling  ibft_init+0x0/0x630 @ 1
No iBFT detected.
initcall ibft_init+0x0/0x630 returned 0 after 1675 usecs
calling  dmatest_init+0x0/0x30 @ 1
initcall dmatest_init+0x0/0x30 returned 0 after 2 usecs
calling  ioat_init_module+0x0/0x20 @ 1
initcall ioat_init_module+0x0/0x20 returned 0 after 152 usecs
calling  oprofile_init+0x0/0x60 @ 1
oprofile: using timer interrupt.
initcall oprofile_init+0x0/0x60 returned 0 after 2950 usecs
calling  sysctl_core_init+0x0/0x30 @ 1
initcall sysctl_core_init+0x0/0x30 returned 0 after 190 usecs
calling  flow_cache_init+0x0/0x1e0 @ 1
initcall flow_cache_init+0x0/0x1e0 returned 0 after 221 usecs
calling  pg_init+0x0/0x2e0 @ 1
pktgen v2.70: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x2e0 returned 0 after 5588 usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after 2 usecs
calling  snap_init+0x0/0x40 @ 1
initcall snap_init+0x0/0x40 returned 0 after 2 usecs
calling  rif_init+0x0/0xa0 @ 1
initcall rif_init+0x0/0xa0 returned 0 after 30 usecs
calling  blackhole_module_init+0x0/0x20 @ 1
initcall blackhole_module_init+0x0/0x20 returned 0 after 1 usecs
calling  gact_init_module+0x0/0x20 @ 1
GACT probability on
initcall gact_init_module+0x0/0x20 returned 0 after 1839 usecs
calling  mirred_init_module+0x0/0x20 @ 1
Mirror/redirect action on
initcall mirred_init_module+0x0/0x20 returned 0 after 2345 usecs
calling  nat_init_module+0x0/0x20 @ 1
initcall nat_init_module+0x0/0x20 returned 0 after 1 usecs
calling  pedit_init_module+0x0/0x20 @ 1
initcall pedit_init_module+0x0/0x20 returned 0 after 1 usecs
calling  simp_init_module+0x0/0x40 @ 1
Simple TC action Loaded
initcall simp_init_module+0x0/0x40 returned 0 after 2162 usecs
calling  cbq_module_init+0x0/0x20 @ 1
initcall cbq_module_init+0x0/0x20 returned 0 after 1 usecs
calling  htb_module_init+0x0/0x20 @ 1
initcall htb_module_init+0x0/0x20 returned 0 after 1 usecs
calling  ingress_module_init+0x0/0x20 @ 1
initcall ingress_module_init+0x0/0x20 returned 0 after 1 usecs
calling  teql_init+0x0/0xf0 @ 1
input: ImPS/2 Generic Wheel Mouse as /class/input/input4
initcall teql_init+0x0/0xf0 returned 0 after 5809 usecs
calling  netem_module_init+0x0/0x20 @ 1
netem: version 1.2
initcall netem_module_init+0x0/0x20 returned 0 after 1740 usecs
calling  init_u32+0x0/0x50 @ 1
u32 classifier
    Performance counters on
    input device check on 
    Actions configured 
initcall init_u32+0x0/0x50 returned 0 after 8507 usecs
calling  init_route4+0x0/0x20 @ 1
initcall init_route4+0x0/0x20 returned 0 after 1 usecs
calling  init_fw+0x0/0x20 @ 1
initcall init_fw+0x0/0x20 returned 0 after 1 usecs
calling  init_rsvp+0x0/0x20 @ 1
initcall init_rsvp+0x0/0x20 returned 0 after 1 usecs
calling  init_tcindex+0x0/0x20 @ 1
initcall init_tcindex+0x0/0x20 returned 0 after 1 usecs
calling  init_rsvp+0x0/0x20 @ 1
initcall init_rsvp+0x0/0x20 returned 0 after 1 usecs
calling  cls_flow_init+0x0/0x20 @ 1
initcall cls_flow_init+0x0/0x20 returned 0 after 1 usecs
calling  init_em_cmp+0x0/0x20 @ 1
initcall init_em_cmp+0x0/0x20 returned 0 after 1 usecs
calling  init_em_nbyte+0x0/0x20 @ 1
initcall init_em_nbyte+0x0/0x20 returned 0 after 1 usecs
calling  init_em_text+0x0/0x20 @ 1
initcall init_em_text+0x0/0x20 returned 0 after 1 usecs
calling  sysctl_ipv4_init+0x0/0x60 @ 1
initcall sysctl_ipv4_init+0x0/0x60 returned 0 after 776 usecs
calling  ipip_init+0x0/0x80 @ 1
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x80 returned 0 after 3539 usecs
calling  ipgre_init+0x0/0xd0 @ 1
GRE over IPv4 tunneling driver
initcall ipgre_init+0x0/0xd0 returned 0 after 3605 usecs
calling  init_syncookies+0x0/0x20 @ 1
initcall init_syncookies+0x0/0x20 returned 0 after 20 usecs
calling  ah4_init+0x0/0x70 @ 1
initcall ah4_init+0x0/0x70 returned 0 after 2 usecs
calling  esp4_init+0x0/0x70 @ 1
initcall esp4_init+0x0/0x70 returned 0 after 1 usecs
calling  ipcomp4_init+0x0/0x70 @ 1
initcall ipcomp4_init+0x0/0x70 returned 0 after 1 usecs
calling  ipip_init+0x0/0xc0 @ 1
initcall ipip_init+0x0/0xc0 returned 0 after 2 usecs
calling  xfrm4_beet_init+0x0/0x20 @ 1
initcall xfrm4_beet_init+0x0/0x20 returned 0 after 1 usecs
calling  tunnel4_init+0x0/0x70 @ 1
initcall tunnel4_init+0x0/0x70 returned 0 after 1 usecs
calling  xfrm4_transport_init+0x0/0x20 @ 1
initcall xfrm4_transport_init+0x0/0x20 returned 0 after 1 usecs
calling  xfrm4_mode_tunnel_init+0x0/0x20 @ 1
initcall xfrm4_mode_tunnel_init+0x0/0x20 returned 0 after 1 usecs
calling  bictcp_register+0x0/0x20 @ 1
TCP bic registered
initcall bictcp_register+0x0/0x20 returned 0 after 1740 usecs
calling  hstcp_register+0x0/0x20 @ 1
TCP highspeed registered
initcall hstcp_register+0x0/0x20 returned 0 after 2261 usecs
calling  hybla_register+0x0/0x20 @ 1
TCP hybla registered
initcall hybla_register+0x0/0x20 returned 0 after 1923 usecs
calling  htcp_register+0x0/0x20 @ 1
TCP htcp registered
initcall htcp_register+0x0/0x20 returned 0 after 1824 usecs
calling  tcp_vegas_register+0x0/0x20 @ 1
TCP vegas registered
initcall tcp_vegas_register+0x0/0x20 returned 0 after 1907 usecs
calling  tcp_veno_register+0x0/0x20 @ 1
TCP veno registered
initcall tcp_veno_register+0x0/0x20 returned 0 after 1839 usecs
calling  tcp_yeah_register+0x0/0x20 @ 1
TCP yeah registered
initcall tcp_yeah_register+0x0/0x20 returned 0 after 1842 usecs
calling  tcp_illinois_register+0x0/0x20 @ 1
TCP illinois registered
initcall tcp_illinois_register+0x0/0x20 returned 0 after 2177 usecs
calling  xfrm_user_init+0x0/0x60 @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x60 returned 0 after 2950 usecs
calling  inet6_init+0x0/0x290 @ 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
initcall inet6_init+0x0/0x290 returned 0 after 17450 usecs
calling  ah6_init+0x0/0x70 @ 1
initcall ah6_init+0x0/0x70 returned 0 after 1 usecs
calling  ipcomp6_init+0x0/0x70 @ 1
initcall ipcomp6_init+0x0/0x70 returned 0 after 1 usecs
calling  xfrm6_tunnel_init+0x0/0x120 @ 1
initcall xfrm6_tunnel_init+0x0/0x120 returned 0 after 159 usecs
calling  tunnel6_init+0x0/0x70 @ 1
initcall tunnel6_init+0x0/0x70 returned 0 after 1 usecs
calling  xfrm6_transport_init+0x0/0x20 @ 1
initcall xfrm6_transport_init+0x0/0x20 returned 0 after 1 usecs
calling  xfrm6_mode_tunnel_init+0x0/0x20 @ 1
initcall xfrm6_mode_tunnel_init+0x0/0x20 returned 0 after 1 usecs
calling  xfrm6_ro_init+0x0/0x20 @ 1
initcall xfrm6_ro_init+0x0/0x20 returned 0 after 1 usecs
calling  xfrm6_beet_init+0x0/0x20 @ 1
initcall xfrm6_beet_init+0x0/0x20 returned 0 after 1 usecs
calling  mip6_init+0x0/0xd0 @ 1
Mobile IPv6
initcall mip6_init+0x0/0xd0 returned 0 after 1147 usecs
calling  packet_init+0x0/0x50 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x50 returned 0 after 3115 usecs
calling  ipsec_pfkey_init+0x0/0xa0 @ 1
NET: Registered protocol family 15
initcall ipsec_pfkey_init+0x0/0xa0 returned 0 after 3111 usecs
calling  br_init+0x0/0xe0 @ 1
initcall br_init+0x0/0xe0 returned 0 after 316 usecs
calling  dsa_init_module+0x0/0x20 @ 1
initcall dsa_init_module+0x0/0x20 returned 0 after 91 usecs
calling  ipx_init+0x0/0x120 @ 1
NET: Registered protocol family 4
evbug.c: Connected device: input4 (ImPS/2 Generic Wheel Mouse at isa0060/serio1/input0)
initcall ipx_init+0x0/0x120 returned 0 after 19948 usecs
calling  atalk_init+0x0/0xa0 @ 1
NET: Registered protocol family 5
initcall atalk_init+0x0/0xa0 returned 0 after 23380 usecs
calling  x25_init+0x0/0x70 @ 1
NET: Registered protocol family 9
X.25 for Linux Version 0.2
initcall x25_init+0x0/0x70 returned 0 after 5559 usecs
calling  nr_proto_init+0x0/0x2c0 @ 1
NET: Registered protocol family 6
initcall nr_proto_init+0x0/0x2c0 returned 0 after 6825 usecs
calling  rose_proto_init+0x0/0x2f0 @ 1
NET: Registered protocol family 11
initcall rose_proto_init+0x0/0x2f0 returned 0 after 13490 usecs
calling  ax25_init+0x0/0xb0 @ 1
NET: Registered protocol family 3
initcall ax25_init+0x0/0xb0 returned 0 after 3043 usecs
calling  can_init+0x0/0x120 @ 1
can: controller area network core (rev 20071116 abi 8)
NET: Registered protocol family 29
initcall can_init+0x0/0x120 returned 0 after 8078 usecs
calling  raw_module_init+0x0/0x50 @ 1
can: raw protocol (rev 20071116)
initcall raw_module_init+0x0/0x50 returned 0 after 2924 usecs
calling  irlan_init+0x0/0x250 @ 1
initcall irlan_init+0x0/0x250 returned 0 after 2126 usecs
calling  irnet_init+0x0/0x20 @ 1
initcall irnet_init+0x0/0x20 returned 0 after 136 usecs
calling  ircomm_init+0x0/0xa0 @ 1
IrCOMM protocol (Dag Brattli)
initcall ircomm_init+0x0/0xa0 returned 0 after 2689 usecs
calling  ircomm_tty_init+0x0/0x180 @ 1
initcall ircomm_tty_init+0x0/0x180 returned 0 after 3790 usecs
calling  init_sunrpc+0x0/0x80 @ 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall init_sunrpc+0x0/0x80 returned 0 after 7804 usecs
calling  init_rpcsec_gss+0x0/0x50 @ 1
initcall init_rpcsec_gss+0x0/0x50 returned 0 after 18 usecs
calling  init_kerberos_module+0x0/0x40 @ 1
initcall init_kerberos_module+0x0/0x40 returned 0 after 11 usecs
calling  init_spkm3_module+0x0/0x40 @ 1
initcall init_spkm3_module+0x0/0x40 returned 0 after 8 usecs
calling  xprt_rdma_init+0x0/0xd0 @ 1
RPC: Registered rdma transport module.
initcall xprt_rdma_init+0x0/0xd0 returned 0 after 3570 usecs
calling  svc_rdma_init+0x0/0x180 @ 1
initcall svc_rdma_init+0x0/0x180 returned 0 after 565 usecs
calling  af_rxrpc_init+0x0/0x1d0 @ 1
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x1d0 returned 0 after 3457 usecs
calling  atm_clip_init+0x0/0xb0 @ 1
initcall atm_clip_init+0x0/0xb0 returned 0 after 176 usecs
calling  br2684_init+0x0/0x40 @ 1
initcall br2684_init+0x0/0x40 returned 0 after 4 usecs
calling  lane_module_init+0x0/0x60 @ 1
lec.c: Nov 29 2008 11:11:00 initialized
initcall lane_module_init+0x0/0x60 returned 0 after 3534 usecs
calling  atm_mpoa_init+0x0/0x40 @ 1
mpc.c: Nov 29 2008 11:10:34 initialized
initcall atm_mpoa_init+0x0/0x40 returned 0 after 3535 usecs
calling  econet_proto_init+0x0/0x1f0 @ 1
NET: Registered protocol family 19
initcall econet_proto_init+0x0/0x1f0 returned 0 after 3132 usecs
calling  phonet_init+0x0/0x90 @ 1
NET: Registered protocol family 35
initcall phonet_init+0x0/0x90 returned 0 after 3314 usecs
calling  pep_register+0x0/0x20 @ 1
initcall pep_register+0x0/0x20 returned 0 after 151 usecs
calling  vlan_proto_init+0x0/0xd0 @ 1
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall vlan_proto_init+0x0/0xd0 returned 0 after 10035 usecs
calling  dccp_init+0x0/0x3d0 @ 1
initcall dccp_init+0x0/0x3d0 returned 0 after 3254 usecs
calling  dccp_v4_init+0x0/0xa0 @ 1
initcall dccp_v4_init+0x0/0xa0 returned 0 after 13296 usecs
calling  dccp_v6_init+0x0/0xa0 @ 1
initcall dccp_v6_init+0x0/0xa0 returned 0 after 482 usecs
calling  ccid3_module_init+0x0/0x20 @ 1
CCID: Registered CCID 3 (TCP-Friendly Rate Control)
initcall ccid3_module_init+0x0/0x20 returned 0 after 4859 usecs
calling  ccid2_module_init+0x0/0x20 @ 1
CCID: Registered CCID 2 (TCP-like)
initcall ccid2_module_init+0x0/0x20 returned 0 after 3406 usecs
calling  tfrc_module_init+0x0/0x50 @ 1
initcall tfrc_module_init+0x0/0x50 returned 0 after 450 usecs
calling  sctp_init+0x0/0x7d0 @ 1
SCTP: Hash tables configured (established 14563 bind 14563)
sctp_init_sock(sk: ffff88003d548000)
initcall sctp_init+0x0/0x7d0 returned 0 after 40556 usecs
calling  ieee80211_init+0x0/0x30 @ 1
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
initcall ieee80211_init+0x0/0x30 returned 0 after 12138 usecs
calling  ieee80211_crypto_init+0x0/0x20 @ 1
ieee80211_crypt: registered algorithm 'NULL'
initcall ieee80211_crypto_init+0x0/0x20 returned 0 after 3954 usecs
calling  ieee80211_crypto_wep_init+0x0/0x20 @ 1
ieee80211_crypt: registered algorithm 'WEP'
initcall ieee80211_crypto_wep_init+0x0/0x20 returned 0 after 3872 usecs
calling  tipc_init+0x0/0xc0 @ 1
TIPC: Activated (version 1.6.4 compiled Nov 29 2008 11:12:07)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall tipc_init+0x0/0xc0 returned 0 after 12403 usecs
calling  powernowk8_init+0x0/0x90 @ 1
initcall powernowk8_init+0x0/0x90 returned -19 after 1 usecs
calling  acpi_cpufreq_init+0x0/0xd0 @ 1
initcall acpi_cpufreq_init+0x0/0xd0 returned 0 after 1775 usecs
calling  centrino_init+0x0/0x40 @ 1
initcall centrino_init+0x0/0x40 returned -16 after 1 usecs
initcall centrino_init+0x0/0x40 returned with error code -16 
calling  hpet_insert_resource+0x0/0x30 @ 1
initcall hpet_insert_resource+0x0/0x30 returned 0 after 4 usecs
calling  lapic_insert_resource+0x0/0x50 @ 1
initcall lapic_insert_resource+0x0/0x50 returned 0 after 1 usecs
calling  init_lapic_nmi_sysfs+0x0/0x40 @ 1
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 1 usecs
calling  ioapic_insert_resources+0x0/0x60 @ 1
IO APIC resources could be not be allocated.
initcall ioapic_insert_resources+0x0/0x60 returned -1 after 3953 usecs
initcall ioapic_insert_resources+0x0/0x60 returned with error code -1 
calling  io_apic_bug_finalize+0x0/0x20 @ 1
initcall io_apic_bug_finalize+0x0/0x20 returned 0 after 1 usecs
calling  check_early_ioremap_leak+0x0/0x70 @ 1
initcall check_early_ioremap_leak+0x0/0x70 returned 0 after 1 usecs
calling  sched_init_debug+0x0/0x30 @ 1
initcall sched_init_debug+0x0/0x30 returned 0 after 12 usecs
calling  init_oops_id+0x0/0x30 @ 1
initcall init_oops_id+0x0/0x30 returned 0 after 1 usecs
calling  disable_boot_consoles+0x0/0x40 @ 1
initcall disable_boot_consoles+0x0/0x40 returned 0 after 1 usecs
calling  pm_qos_power_init+0x0/0x90 @ 1
initcall pm_qos_power_init+0x0/0x90 returned 0 after 492 usecs
calling  taskstats_init+0x0/0xb0 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0xb0 returned 0 after 2786 usecs
calling  afs_init+0x0/0x140 @ 1
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x140 returned 0 after 4177 usecs
calling  random32_reseed+0x0/0xa0 @ 1
initcall random32_reseed+0x0/0xa0 returned 0 after 4 usecs
calling  pci_sysfs_init+0x0/0x60 @ 1
initcall pci_sysfs_init+0x0/0x60 returned 0 after 240 usecs
calling  acpi_wakeup_device_init+0x0/0xac @ 1
initcall acpi_wakeup_device_init+0x0/0xac returned 0 after 3 usecs
calling  acpi_sleep_proc_init+0x0/0x4f @ 1
initcall acpi_sleep_proc_init+0x0/0x4f returned 0 after 8 usecs
calling  boot_wait_for_devices+0x0/0x20 @ 1
initcall boot_wait_for_devices+0x0/0x20 returned 0 after 1 usecs
calling  seqgen_init+0x0/0x10 @ 1
initcall seqgen_init+0x0/0x10 returned 0 after 10 usecs
calling  hd_init+0x0/0x350 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x350 returned -1 after 6373 usecs
initcall hd_init+0x0/0x350 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x100 @ 1
initcall scsi_complete_async_scans+0x0/0x100 returned 0 after 1 usecs
calling  rtc_hctosys+0x0/0x1a0 @ 1
rtc_cmos 00:03: setting system clock to 2008-11-29 10:16:44 UTC (1227953804)
initcall rtc_hctosys+0x0/0x1a0 returned 0 after 6683 usecs
calling  edd_init+0x0/0x2c0 @ 1
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
initcall edd_init+0x0/0x2c0 returned 0 after 4848 usecs
calling  tcp_congestion_default+0x0/0x20 @ 1
initcall tcp_congestion_default+0x0/0x20 returned 0 after 2 usecs
calling  ip_auto_config+0x0/0xeb0 @ 1
initcall ip_auto_config+0x0/0xeb0 returned 0 after 15 usecs
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory ffffffff814a1000..ffffffff81759000
Write protecting the kernel read-only data: 17316k
Testing CPA: undo ffffffff80209000-ffffffff812f2000
Testing CPA: again
khelper used greatest stack depth: 4856 bytes left
uname used greatest stack depth: 4712 bytes left
mount used greatest stack depth: 3640 bytes left
sed used greatest stack depth: 3568 bytes left
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2519, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2519, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2519, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
rc.sysinit used greatest stack depth: 3400 bytes left
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2680, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2680, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2680, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2685, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2685, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2685, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a70a4>] ? __rmqueue_smallest+0x144/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2686, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2686, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2686, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2687, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2687, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2687, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2688, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2688, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2688, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2689, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2689, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2689, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2690, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2690, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2690, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2691, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2691, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2691, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2692, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2692, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2692, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2693, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2693, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2693, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2694, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2694, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2694, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2695, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2695, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2695, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2696, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2696, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2696, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2697, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2697, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2697, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2698, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2698, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2698, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2699, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2699, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2699, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2700, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2700, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2700, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2701, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2701, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2701, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2702, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2702, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2702, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2703, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2703, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2703, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2704, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2704, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2704, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2705, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2705, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2705, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2706, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2706, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2706, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2707, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2707, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2707, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2708, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2708, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2708, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2709, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2709, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2709, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2710, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2710, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2710, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2711, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2711, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2711, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2712, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2712, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2712, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2713, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2713, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2713, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2714, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2714, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2714, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2715, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2715, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2715, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2716, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2716, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2716, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2717, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2717, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2717, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2718, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2718, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2718, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
ADDRCONF(NETDEV_UP): eth0: link is not ready
CPA self-test:
 4k 261888 large 0 gb 0 x 261888[ffff880000000000-ffff88003feff000] miss 0
 4k 261888 large 0 gb 0 x 261888[ffff880000000000-ffff88003feff000] miss 0
 4k 261888 large 0 gb 0 x 261888[ffff880000000000-ffff88003feff000] miss 0
ok.
0000:04:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2994, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2994, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 2994, comm: sysctl Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3181, comm: distccd Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a2a00>] ? find_get_page+0x0/0xd0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8023f834>] ia32_sysret+0x0/0xa
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3181, comm: distccd Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8023f834>] ia32_sysret+0x0/0xa
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3181, comm: distccd Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8023f834>] ia32_sysret+0x0/0xa
---[ end trace 4eaa2a86a8e2da22 ]---
eth0: no IPv6 routers present
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3011, comm: irqbalance Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3011, comm: irqbalance Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3011, comm: irqbalance Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
evbug.c: Event. Dev: input2, Type: 20, Code: 0, Value: 500
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3613, comm: pgrep Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3613, comm: pgrep Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3613, comm: pgrep Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3620, comm: pgrep Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3620, comm: pgrep Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3620, comm: pgrep Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff802553fd>] ? release_console_sem+0x20d/0x230
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802baf7f>] ? vma_adjust+0xff/0x470
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e43e36>] ? _spin_unlock+0x26/0x30
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802cbd18>] ? check_bytes_and_report+0x38/0xe0
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff80278148>] ? debug_mutex_init+0x38/0x60
 [<ffffffff802ef6d9>] ? seq_open+0x89/0xb0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff80e42503>] ? __mutex_lock_common+0x343/0x430
 [<ffffffff802efa69>] ? seq_read+0x39/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
irq >= NR_IRQS in irq_to_desc: 4352 4352
------------[ cut here ]------------
WARNING: at kernel/irq/handle.c:164 irq_to_desc+0x42/0x50()
Hardware name:         
Pid: 3617, comm: ps Tainted: G        W  2.6.28-rc6-tip-01066-gb8cb0e0-dirty #1
Call Trace:
 [<ffffffff80254b37>] warn_slowpath+0xd7/0x100
 [<ffffffff80255e1c>] ? vprintk+0x2dc/0x4d0
 [<ffffffff802a703f>] ? __rmqueue_smallest+0xdf/0x160
 [<ffffffff80256077>] ? printk+0x67/0x70
 [<ffffffff802a8f40>] ? get_page_from_freelist+0x5e0/0x6d0
 [<ffffffff80291da2>] irq_to_desc+0x42/0x50
 [<ffffffff803234af>] show_stat+0x15f/0x500
 [<ffffffff802a71de>] ? __get_free_pages+0xe/0x60
 [<ffffffff802efb4e>] ? seq_read+0x11e/0x340
 [<ffffffff802efb0a>] seq_read+0xda/0x340
 [<ffffffff805cd265>] ? _raw_spin_unlock+0x55/0xa0
 [<ffffffff802efa30>] ? seq_read+0x0/0x340
 [<ffffffff8031afdd>] proc_reg_read+0x7d/0xc0
 [<ffffffff802d565c>] vfs_read+0xbc/0x110
 [<ffffffff802d61a0>] sys_read+0x50/0x90
 [<ffffffff8021363a>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
gam_server[3555]: segfault at 0 ip 00000031a2e72af9 sp 00007fff89888df0 error 4 in libc-2.5.so[31a2e00000+146000]

