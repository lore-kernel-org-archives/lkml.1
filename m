Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZJLJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZJLJ2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZJLJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:28:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZJLJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:28:17 -0400
Date: Mon, 12 Oct 2009 11:27:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012092713.GA32647@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <20091012091954.GA31171@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20091012091954.GA31171@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


i also have a crash with vanilla -rc4, test on this commit:

  d93a8f8: Revert "USB: Work around BIOS bugs by quiescing USB controllers earlier"

crashlog pasted below - config attached.

	Ingo

Linux version 2.6.32-rc4 (mingo@aldebaran) (gcc version 4.4.2 20091002 (prerelease) (GCC) ) #1 Mon Oct 12 11:22:47 CEST 2009
Command line: root=/dev/sda3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
 BIOS-e820: 000000007ffa0000 - 000000007ffae000 (ACPI data)
 BIOS-e820: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x7ffa0 max_arch_pfn = 0x400000000
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009fc00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e4000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000007ffa0000 (usable)
 modified: 000000007ffa0000 - 000000007ffae000 (ACPI data)
 modified: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
 modified: 000000007ffe0000 - 0000000080000000 (reserved)
 modified: 00000000ffb80000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000007ffa0000
 0000000000 - 007ffa0000 page 4k
kernel direct mapping tables up to 7ffa0000 @ 100000-503000
ACPI: RSDP 00000000000facd0 00024 (v02 ACPIAM)
ACPI: XSDT 000000007ffa0100 00044 (v01 A M I  OEMXSDT  10000630 MSFT 00000097)
ACPI: FACP 000000007ffa0290 000F4 (v03 A M I  OEMFACP  10000630 MSFT 00000097)
ACPI: DSDT 000000007ffa0410 08318 (v01  A0227 A0227000 00000000 INTL 02002026)
ACPI: FACS 000000007ffae000 00040
ACPI: APIC 000000007ffa0390 00080 (v01 A M I  OEMAPIC  10000630 MSFT 00000097)
ACPI: OEMB 000000007ffae040 00066 (v01 A M I  AMI_OEM  10000630 MSFT 00000097)
ACPI: MCFG 000000007ffa8730 0003C (v01 A M I  OEMMCFG  10000630 MSFT 00000097)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 007ffa0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0002881080]    TEXT DATA BSS ==> [0001000000 - 0002881080]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0002882000 - 000288227c]              BRK ==> [0002882000 - 000288227c]
  #5 [0000100000 - 0000501000]          PGTABLE ==> [0000100000 - 0000501000]
 [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002e00000-ffff8800049fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007ffa0
On node 0 totalpages: 524079
  DMA zone: 56 pages used for memmap
  DMA zone: 1124 pages reserved
  DMA zone: 2803 pages, LIFO batch:0
  DMA32 zone: 7111 pages used for memmap
  DMA32 zone: 512985 pages, LIFO batch:31
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fc000 (fee00000)
mapped IOAPIC to ffffffffff5fb000 (fec00000)
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:7fb80000)
Booting paravirtualized kernel on bare hardware
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 515788
Kernel command line: root=/dev/sda3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Memory: 2034728k/2096768k available (7661k kernel code, 452k absent, 61180k reserved, 6599k data, 812k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:288
Console: colour VGA+ 80x25
console [tty0] enabled, bootconsole disabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6335 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:failed|failed|  ok  |failed|failed|failed|
                 A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
             A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
             A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |failed|
           recursive read-lock #2:             |  ok  |             |failed|
            mixed read-write-lock:             |failed|             |failed|
            mixed write-read-lock:             |failed|             |failed|
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
     soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
     hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
     soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
       sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
       sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
         hard-safe-A + irqs-on/12:failed|failed|  ok  |
         soft-safe-A + irqs-on/12:failed|failed|  ok  |
         hard-safe-A + irqs-on/21:failed|failed|  ok  |
         soft-safe-A + irqs-on/21:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
      hard-irq lock-inversion/123:failed|failed|  ok  |
      soft-irq lock-inversion/123:failed|failed|  ok  |
      hard-irq lock-inversion/132:failed|failed|  ok  |
      soft-irq lock-inversion/132:failed|failed|  ok  |
      hard-irq lock-inversion/213:failed|failed|  ok  |
      soft-irq lock-inversion/213:failed|failed|  ok  |
      hard-irq lock-inversion/231:failed|failed|  ok  |
      soft-irq lock-inversion/231:failed|failed|  ok  |
      hard-irq lock-inversion/312:failed|failed|  ok  |
      soft-irq lock-inversion/312:failed|failed|  ok  |
      hard-irq lock-inversion/321:failed|failed|  ok  |
      soft-irq lock-inversion/321:failed|failed|  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
--------------------------------------------------------
133 out of 218 testcases failed, as expected. |
----------------------------------------------------
allocated 20971520 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 3456.952 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6916.98 BogoMIPS (lpj=11523173)
Security Framework initialized
TOMOYO Linux initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
mce: CPU supports 4 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: no PMU driver, software events only.
CPU: Intel(R) Pentium(R) D CPU 3.00GHz stepping 02
ACPI: Core revision 20090903
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 32532 entries in 128 pages
calling  spawn_ksoftirqd+0x0/0x39 @ 1
initcall spawn_ksoftirqd+0x0/0x39 returned 0 after 0 usecs
calling  spawn_softlockup_task+0x0/0x55 @ 1
initcall spawn_softlockup_task+0x0/0x55 returned 0 after 0 usecs
calling  relay_init+0x0/0x8 @ 1
initcall relay_init+0x0/0x8 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x1a1 @ 1
initcall tracer_alloc_buffers+0x0/0x1a1 returned 0 after 0 usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
calling  trace_workqueue_early_init+0x0/0xea @ 1
initcall trace_workqueue_early_init+0x0/0xea returned 0 after 0 usecs
Setting APIC routing to flat
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 2-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1440239
..... delta 1440239
..... mult: 61861827
..... calibration result: 768127
..... CPU clock speed is 3456.3059 MHz.
..... host bus clock speed is 230.1537 MHz.
... verify APIC timer
... jiffies delta = 30
... jiffies result ok
PM: Adding info for No Bus:platform
khelper used greatest stack depth: 5808 bytes left
calling  init_mmap_min_addr+0x0/0x16 @ 1
initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
calling  net_ns_init+0x0/0x153 @ 1
initcall net_ns_init+0x0/0x153 returned 0 after 0 usecs
calling  e820_mark_nvs_memory+0x0/0x40 @ 1
initcall e820_mark_nvs_memory+0x0/0x40 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x14 @ 1
initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x2d @ 1
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
calling  ksysfs_init+0x0/0xc0 @ 1
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
calling  async_init+0x0/0x60 @ 1
initcall async_init+0x0/0x60 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  pm_init+0x0/0x34 @ 1
initcall pm_init+0x0/0x34 returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x19 @ 1
initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x31 @ 1
initcall swsusp_header_init+0x0/0x31 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x35 @ 1
initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5c @ 1
initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
calling  securityfs_init+0x0/0x53 @ 1
initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
calling  random32_init+0x0/0x6d @ 1
initcall random32_init+0x0/0x6d returned 0 after 0 usecs
calling  gnttab_init+0x0/0x196 @ 1
initcall gnttab_init+0x0/0x196 returned -19 after 0 usecs
calling  regulator_init+0x0/0x2e @ 1
regulator: core version 0.5
initcall regulator_init+0x0/0x2e returned 0 after 3255 usecs
calling  early_resume_init+0x0/0x18 @ 1
Time:  9:22:18  Date: 10/12/09
initcall early_resume_init+0x0/0x18 returned 0 after 3255 usecs
calling  cpuidle_init+0x0/0x20 @ 1
initcall cpuidle_init+0x0/0x20 returned 0 after 0 usecs
calling  virtio_init+0x0/0x2b @ 1
initcall virtio_init+0x0/0x2b returned 0 after 0 usecs
calling  sock_init+0x0/0x59 @ 1
initcall sock_init+0x0/0x59 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x41 @ 1
initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x19e @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x19e returned 0 after 3255 usecs
calling  bdi_class_init+0x0/0x41 @ 1
initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x54 @ 1
initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 3255 usecs
calling  backlight_class_init+0x0/0x5d @ 1
initcall backlight_class_init+0x0/0x5d returned 0 after 3255 usecs
calling  xenbus_probe_init+0x0/0x107 @ 1
initcall xenbus_probe_init+0x0/0x107 returned -19 after 0 usecs
calling  tty_class_init+0x0/0x38 @ 1
initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc2 @ 1
PM: Adding info for No Bus:vtcon0
initcall vtconsole_class_init+0x0/0xc2 returned 0 after 3255 usecs
calling  spi_init+0x0/0xd7 @ 1
initcall spi_init+0x0/0xd7 returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x3c @ 1
initcall amd_postcore_init+0x0/0x3c returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x2d @ 1
initcall arch_kdebugfs_init+0x0/0x2d returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x7e @ 1
initcall ffh_cstate_init+0x0/0x7e returned 0 after 0 usecs
calling  acpi_pci_init+0x0/0x57 @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x57 returned 0 after 3255 usecs
calling  dmi_id_init+0x0/0xfb @ 1
PM: Adding info for No Bus:id
initcall dmi_id_init+0x0/0xfb returned 0 after 3255 usecs
calling  pci_arch_init+0x0/0x57 @ 1
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x57 returned 0 after 6510 usecs
calling  topology_init+0x0/0x16 @ 1
initcall topology_init+0x0/0x16 returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0xe4 @ 1
khelper used greatest stack depth: 5464 bytes left
initcall param_sysfs_init+0x0/0xe4 returned 0 after 136718 usecs
calling  pm_sysrq_init+0x0/0x1e @ 1
initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x2f @ 1
initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
calling  init_slow_work+0x0/0x1b @ 1
initcall init_slow_work+0x0/0x1b returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xc6 @ 1
PM: Adding info for No Bus:default
initcall default_bdi_init+0x0/0xc6 returned 0 after 3255 usecs
calling  init_bio+0x0/0x128 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0x128 returned 0 after 3255 usecs
calling  fsnotify_init+0x0/0x12 @ 1
initcall fsnotify_init+0x0/0x12 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x68 @ 1
initcall fsnotify_notification_init+0x0/0x68 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x12 @ 1
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x2e @ 1
initcall blk_softirq_init+0x0/0x2e returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x2e @ 1
initcall blk_iopoll_setup+0x0/0x2e returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x66 @ 1
initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
calling  blk_dev_integrity_init+0x0/0x2a @ 1
initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
calling  gpiolib_debugfs_init+0x0/0x24 @ 1
initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x4b @ 1
initcall pci_slot_init+0x0/0x4b returned 0 after 0 usecs
calling  acpi_init+0x0/0x134 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXCPU:00
PM: Adding info for acpi:LNXCPU:01
PM: Adding info for acpi:LNXCPU:02
PM: Adding info for acpi:LNXCPU:03
PM: Adding info for acpi:LNXSYBUS:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:device:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:ATK0110:00
PM: Adding info for acpi:PNP0C02:02
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0C02:03
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:PNP0C01:01
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:LNXTHERM:00
PM: Adding info for acpi:LNXPWRBN:00
ACPI Warning: Incorrect checksum in table [OEMB] - 5F, should be 52 (20090903/tbutils-314)
initcall acpi_init+0x0/0x134 returned 0 after 957029 usecs
calling  dock_init+0x0/0x8d @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0x8d returned 0 after 3255 usecs
calling  acpi_pci_root_init+0x0/0x28 @ 1
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:0000:00
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xd7cf8000-0xd7cfbfff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x7000-0x701f]
pci 0000:00:1d.1: reg 20 io port: [0x7400-0x741f]
pci 0000:00:1d.2: reg 20 io port: [0x7800-0x781f]
pci 0000:00:1d.3: reg 20 io port: [0x8000-0x801f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xd7cff800-0xd7cffbff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:1f.2: reg 10 io port: [0x9800-0x9807]
pci 0000:00:1f.2: reg 14 io port: [0x9400-0x9403]
pci 0000:00:1f.2: reg 18 io port: [0x9000-0x9007]
pci 0000:00:1f.2: reg 1c io port: [0x8800-0x8803]
pci 0000:00:1f.2: reg 20 io port: [0x8400-0x840f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xd7cffc00-0xd7cfffff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:04:00.0: reg 10 32bit mmio pref: [0xd8000000-0xdfffffff]
pci 0000:04:00.0: reg 14 io port: [0xe000-0xe0ff]
pci 0000:04:00.0: reg 18 32bit mmio: [0xd7fe0000-0xd7feffff]
pci 0000:04:00.0: reg 30 32bit mmio pref: [0xd7fc0000-0xd7fdffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.1: reg 10 32bit mmio: [0xd7ff0000-0xd7ffffff]
pci 0000:04:00.1: supports D1 D2
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
pci 0000:00:01.0: bridge 32bit mmio: [0xd7f00000-0xd7ffffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xd8000000-0xdfffffff]
pci 0000:00:1c.0: bridge io port: [0xd000-0xdfff]
pci 0000:02:00.0: reg 10 64bit mmio: [0xd7efc000-0xd7efffff]
pci 0000:02:00.0: reg 18 io port: [0xc800-0xc8ff]
pci 0000:02:00.0: reg 30 32bit mmio pref: [0xd7ec0000-0xd7edffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xd7e00000-0xd7efffff]
pci 0000:01:01.0: reg 10 32bit mmio: [0xd7ddf000-0xd7ddffff]
pci 0000:01:01.0: reg 14 32bit mmio: [0xd7dde000-0xd7ddefff]
pci 0000:01:01.0: supports D1
pci 0000:01:03.0: reg 10 io port: [0xb800-0xb807]
pci 0000:01:03.0: reg 14 io port: [0xb400-0xb403]
pci 0000:01:03.0: reg 18 io port: [0xb000-0xb007]
pci 0000:01:03.0: reg 1c io port: [0xa800-0xa803]
pci 0000:01:03.0: reg 20 io port: [0xa400-0xa40f]
pci 0000:01:03.0: reg 30 32bit mmio pref: [0xd7de0000-0xd7dfffff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xa000-0xbfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xd7d00000-0xd7dfffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.3
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:04:00.0
PM: Adding info for pci:0000:04:00.1
PM: Adding info for No Bus:0000:04
PM: Adding info for No Bus:0000:03
PM: Adding info for pci:0000:02:00.0
PM: Adding info for No Bus:0000:02
PM: Adding info for pci:0000:01:01.0
Clocksource tsc unstable (delta = 115790085 ns)
PM: Adding info for pci:0000:01:03.0
PM: Adding info for No Bus:0000:01
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 475259 usecs
calling  acpi_pci_link_init+0x0/0x43 @ 1
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
initcall acpi_pci_link_init+0x0/0x43 returned 0 after 58593 usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
calling  setup_shutdown_event+0x0/0x14 @ 1
initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
calling  misc_init+0x0/0xb7 @ 1
initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x80 @ 1
PM: Adding info for No Bus:vga_arbiter
vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x80 returned 0 after 6510 usecs
calling  init_scsi+0x0/0x81 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x81 returned 0 after 3255 usecs
calling  ata_init+0x0/0x8d @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x8d returned 0 after 3255 usecs
calling  phy_init+0x0/0x2e @ 1
initcall phy_init+0x0/0x2e returned 0 after 0 usecs
calling  init_pcmcia_cs+0x0/0x36 @ 1
initcall init_pcmcia_cs+0x0/0x36 returned 0 after 0 usecs
calling  nop_usb_xceiv_init+0x0/0x12 @ 1
initcall nop_usb_xceiv_init+0x0/0x12 returned 0 after 0 usecs
calling  usb_init+0x0/0x1ad @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x1ad returned 0 after 13020 usecs
calling  serio_init+0x0/0x86 @ 1
initcall serio_init+0x0/0x86 returned 0 after 0 usecs
calling  input_init+0x0/0xbd @ 1
khelper used greatest stack depth: 5224 bytes left
initcall input_init+0x0/0xbd returned 0 after 3255 usecs
calling  init_dvbdev+0x0/0xd7 @ 1
initcall init_dvbdev+0x0/0xd7 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x38 @ 1
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
calling  thermal_init+0x0/0x57 @ 1
initcall thermal_init+0x0/0x57 returned 0 after 0 usecs
calling  ac97_bus_init+0x0/0x12 @ 1
initcall ac97_bus_init+0x0/0x12 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x107 @ 1
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x107 returned 0 after 3255 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x15e @ 1
PM: Adding info for No Bus:lo
initcall net_dev_init+0x0/0x15e returned 0 after 3255 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  genl_init+0x0/0x8f @ 1
initcall genl_init+0x0/0x8f returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x88 @ 1
initcall cipso_v4_init+0x0/0x88 returned 0 after 0 usecs
calling  wanrouter_init+0x0/0x55 @ 1
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x55 returned 0 after 3255 usecs
calling  bt_init+0x0/0x5a @ 1
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
initcall bt_init+0x0/0x5a returned 0 after 9765 usecs
calling  wireless_nlevent_init+0x0/0x12 @ 1
initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
calling  netlbl_init+0x0/0x81 @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x81 returned 0 after 13020 usecs
calling  rfkill_init+0x0/0x79 @ 1
PM: Adding info for No Bus:rfkill
initcall rfkill_init+0x0/0x79 returned 0 after 3255 usecs
calling  wpan_phy_class_init+0x0/0x19 @ 1
initcall wpan_phy_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x17 @ 1
initcall pci_iommu_init+0x0/0x17 returned 0 after 0 usecs
calling  print_all_ICs+0x0/0x4b @ 1

printing PIC contents
... PIC  IMR: ffff
... PIC  IRR: 0c29
... PIC  ISR: 0000
... PIC ELCR: 0e28
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00050014
... APIC TASKPRI: 00000000 (00)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000c0630
... APIC ICR2: ff000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000bb87
... APIC TMCCT: 000027f5
... APIC TDCR: 00000003

number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 001 0    0    0   0   0    1    1    31
 02 001 0    0    0   0   0    1    1    30
 03 001 0    0    0   0   0    1    1    33
 04 001 0    0    0   0   0    1    1    34
 05 001 0    0    0   0   0    1    1    35
 06 001 0    0    0   0   0    1    1    36
 07 001 0    0    0   0   0    1    1    37
 08 001 0    0    0   0   0    1    1    38
 09 001 0    1    0   0   0    1    1    39
 0a 001 0    0    0   0   0    1    1    3A
 0b 001 0    0    0   0   0    1    1    3B
 0c 001 0    0    0   0   0    1    1    3C
 0d 001 0    0    0   0   0    1    1    3D
 0e 001 0    0    0   0   0    1    1    3E
 0f 001 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
initcall print_all_ICs+0x0/0x4b returned 0 after 175780 usecs
calling  hpet_late_init+0x0/0x6b @ 1
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
initcall hpet_late_init+0x0/0x6b returned 0 after 13020 usecs
calling  clocksource_done_booting+0x0/0x38 @ 1
Switching to clocksource hpet
initcall clocksource_done_booting+0x0/0x38 returned 0 after 3258 usecs
calling  ftrace_init_debugfs+0x0/0xba @ 1
initcall ftrace_init_debugfs+0x0/0xba returned 0 after 167 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 18 usecs
calling  tracer_init_debugfs+0x0/0x24d @ 1
initcall tracer_init_debugfs+0x0/0x24d returned 0 after 774 usecs
calling  init_trace_printk_function_export+0x0/0x2f @ 1
initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 18 usecs
calling  stat_workqueue_init+0x0/0x2b @ 1
initcall stat_workqueue_init+0x0/0x2b returned 0 after 41 usecs
calling  event_trace_init+0x0/0x1f7 @ 1
initcall event_trace_init+0x0/0x1f7 returned 0 after 37202 usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after 162 usecs
calling  eventpoll_init+0x0/0xe3 @ 1
initcall eventpoll_init+0x0/0xe3 returned 0 after 27 usecs
calling  anon_inode_init+0x0/0x127 @ 1
initcall anon_inode_init+0x0/0x127 returned 0 after 73 usecs
calling  tomoyo_initerface_init+0x0/0x11b @ 1
initcall tomoyo_initerface_init+0x0/0x11b returned 0 after 263 usecs
calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 1 usecs
calling  acpi_event_init+0x0/0x81 @ 1
initcall acpi_event_init+0x0/0x81 returned 0 after 108 usecs
calling  pnpacpi_init+0x0/0x8c @ 1
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
PM: Adding info for pnp:00:05
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
PM: Adding info for pnp:00:06
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0c
PM: Adding info for pnp:00:0d
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 157696 usecs
calling  pnp_system_init+0x0/0x12 @ 1
system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
system 00:08: ioport range 0x290-0x297 has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x800-0x87f has been reserved
system 00:09: ioport range 0x480-0x4bf has been reserved
system 00:09: ioport range 0x900-0x91f has been reserved
system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:09: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xdffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 95376 usecs
calling  chr_dev_init+0x0/0xc3 @ 1
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
initcall chr_dev_init+0x0/0xc3 returned 0 after 30412 usecs
calling  firmware_class_init+0x0/0x79 @ 1
initcall firmware_class_init+0x0/0x79 returned 0 after 261 usecs
calling  ssb_modinit+0x0/0x49 @ 1
initcall ssb_modinit+0x0/0x49 returned 0 after 330 usecs
calling  pcibios_assign_resources+0x0/0x74 @ 1
pci 0000:01:03.0: BAR 6: address space collision on of device [0xd7de0000-0xd7dfffff]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:04
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xd7f00000-0xd7ffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: 0xd000-0xdfff
pci 0000:00:1c.0:   MEM window: 0x80000000-0x801fffff
pci 0000:00:1c.0:   PREFETCH window: 0x00000080200000-0x000000803fffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
pci 0000:00:1c.3:   MEM window: 0xd7e00000-0xd7efffff
pci 0000:00:1c.3:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0xa000-0xbfff
pci 0000:00:1e.0:   MEM window: 0xd7d00000-0xd7dfffff
pci 0000:00:1e.0:   PREFETCH window: 0x80400000-0x804fffff
IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
IOAPIC[0]: Set routing entry (2-19 -> 0x51 -> IRQ 19 Mode:1 Active:1)
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:04: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:04: resource 1 mem: [0xd7f00000-0xd7ffffff]
pci_bus 0000:04: resource 2 pref mem [0xd8000000-0xdfffffff]
pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:03: resource 1 mem: [0x80000000-0x801fffff]
pci_bus 0000:03: resource 2 pref mem [0x80200000-0x803fffff]
pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:02: resource 1 mem: [0xd7e00000-0xd7efffff]
pci_bus 0000:01: resource 0 io:  [0xa000-0xbfff]
pci_bus 0000:01: resource 1 mem: [0xd7d00000-0xd7dfffff]
pci_bus 0000:01: resource 2 pref mem [0x80400000-0x804fffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
initcall pcibios_assign_resources+0x0/0x74 returned 0 after 201862 usecs
calling  inet_init+0x0/0x199 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
IPv4 FIB: Using LC-trie version 0.409
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 32768 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 262144 bind 32768)
TCP reno registered
initcall inet_init+0x0/0x199 returned 0 after 38666 usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 3138 usecs
calling  populate_rootfs+0x0/0x10f @ 1
initcall populate_rootfs+0x0/0x10f returned 0 after 422 usecs
calling  calgary_fixup_tce_spaces+0x0/0xf9 @ 1
initcall calgary_fixup_tce_spaces+0x0/0xf9 returned -19 after 0 usecs
calling  irqfd_module_init+0x0/0x35 @ 1
initcall irqfd_module_init+0x0/0x35 returned 0 after 168 usecs
calling  vmx_init+0x0/0x1fd @ 1
PM: Adding info for No Bus:kvm
initcall vmx_init+0x0/0x1fd returned 0 after 4498 usecs
calling  i8259A_init_sysfs+0x0/0x22 @ 1
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 499 usecs
calling  vsyscall_init+0x0/0xbd @ 1
initcall vsyscall_init+0x0/0xbd returned 0 after 1 usecs
calling  sbf_init+0x0/0xe9 @ 1
initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x22 @ 1
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 601 usecs
calling  add_rtc_cmos+0x0/0xa9 @ 1
initcall add_rtc_cmos+0x0/0xa9 returned 0 after 3 usecs
calling  cache_sysfs_init+0x0/0x26 @ 1
initcall cache_sysfs_init+0x0/0x26 returned 0 after 911 usecs
calling  cpu_debug_init+0x0/0xa9 @ 1
cpu0(1) debug files 237
initcall cpu_debug_init+0x0/0xa9 returned 0 after 12677 usecs
calling  mce_init_device+0x0/0xc6 @ 1
PM: Adding info for No Bus:mcelog
initcall mce_init_device+0x0/0xc6 returned 0 after 4075 usecs
calling  inject_init+0x0/0x32 @ 1
Machine check injector initialized
initcall inject_init+0x0/0x32 returned 0 after 3183 usecs
calling  thermal_throttle_init_device+0x0/0x3e @ 1
initcall thermal_throttle_init_device+0x0/0x3e returned 0 after 38 usecs
calling  cpuid_init+0x0/0xdf @ 1
PM: Adding info for No Bus:cpu0
initcall cpuid_init+0x0/0xdf returned 0 after 3619 usecs
calling  ioapic_init_sysfs+0x0/0xb3 @ 1
initcall ioapic_init_sysfs+0x0/0xb3 returned 0 after 506 usecs
calling  microcode_init+0x0/0xfe @ 1
PM: Adding info for platform:microcode
microcode: CPU0 sig=0xf62, pf=0x4, revision=0xf
PM: Adding info for No Bus:microcode
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
initcall microcode_init+0x0/0xfe returned 0 after 18589 usecs
calling  start_periodic_check_for_corruption+0x0/0x3c @ 1
Scanning for low memory corruption every 60 seconds
initcall start_periodic_check_for_corruption+0x0/0x3c returned 0 after 4624 usecs
calling  audit_classes_init+0x0/0xaf @ 1
initcall audit_classes_init+0x0/0xaf returned 0 after 88 usecs
calling  start_pageattr_test+0x0/0x47 @ 1
initcall start_pageattr_test+0x0/0x47 returned 0 after 71 usecs
calling  crypto_fpu_module_init+0x0/0x12 @ 1
initcall crypto_fpu_module_init+0x0/0x12 returned 0 after 40 usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after 199 usecs
calling  aesni_init+0x0/0x142 @ 1
Intel AES-NI instructions are not detected.
initcall aesni_init+0x0/0x142 returned -19 after 3944 usecs
calling  init_vdso_vars+0x0/0x210 @ 1
initcall init_vdso_vars+0x0/0x210 returned 0 after 53 usecs
calling  sysenter_setup+0x0/0xaf @ 1
initcall sysenter_setup+0x0/0xaf returned 0 after 7 usecs
calling  init_sched_debug_procfs+0x0/0x2c @ 1
initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 26 usecs
calling  proc_schedstat_init+0x0/0x22 @ 1
initcall proc_schedstat_init+0x0/0x22 returned 0 after 18 usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after 17 usecs
calling  ioresources_init+0x0/0x3c @ 1
initcall ioresources_init+0x0/0x3c returned 0 after 32 usecs
calling  uid_cache_init+0x0/0x8a @ 1
initcall uid_cache_init+0x0/0x8a returned 0 after 18 usecs
calling  init_posix_timers+0x0/0x17a @ 1
initcall init_posix_timers+0x0/0x17a returned 0 after 12 usecs
calling  init_posix_cpu_timers+0x0/0xe5 @ 1
initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 3 usecs
calling  create_proc_profile+0x0/0x4b @ 1
initcall create_proc_profile+0x0/0x4b returned 0 after 18 usecs
calling  timekeeping_init_device+0x0/0x22 @ 1
initcall timekeeping_init_device+0x0/0x22 returned 0 after 472 usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 573 usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 33 usecs
calling  lockdep_proc_init+0x0/0x5f @ 1
initcall lockdep_proc_init+0x0/0x5f returned 0 after 48 usecs
calling  futex_init+0x0/0x7d @ 1
initcall futex_init+0x0/0x7d returned 0 after 6 usecs
calling  init_rttest+0x0/0x155 @ 1
Initializing RT-Tester: OK
initcall init_rttest+0x0/0x155 returned 0 after 5544 usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after 39 usecs
calling  proc_modules_init+0x0/0x22 @ 1
initcall proc_modules_init+0x0/0x22 returned 0 after 18 usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after 18 usecs
calling  snapshot_device_init+0x0/0x12 @ 1
PM: Adding info for No Bus:snapshot
initcall snapshot_device_init+0x0/0x12 returned 0 after 3632 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x4a5 @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x4a5 returned 0 after 28 usecs
calling  crash_notes_memory_init+0x0/0x88 @ 1
initcall crash_notes_memory_init+0x0/0x88 returned 0 after 23 usecs
calling  backtrace_regression_test+0x0/0x105 @ 1
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
Pid: 1, comm: swapper Not tainted 2.6.32-rc4 #1
Call Trace:
 [<ffffffff810aa403>] ? backtrace_regression_test+0x0/0x105
 [<ffffffff810aa440>] backtrace_regression_test+0x3d/0x105
 [<ffffffff817756db>] ? printk+0x41/0x43
 [<ffffffff8108e8f3>] ? ktime_get+0x65/0xbb
 [<ffffffff810aa403>] ? backtrace_regression_test+0x0/0x105
 [<ffffffff810aa403>] ? backtrace_regression_test+0x0/0x105
 [<ffffffff8100a05c>] do_one_initcall+0x5c/0x15b
 [<ffffffff81def660>] do_basic_setup+0x4f/0x61
 [<ffffffff81def6cf>] kernel_init+0x5d/0xa0
 [<ffffffff81777f54>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81039dca>] child_rip+0xa/0x20
 [<ffffffff8106a56a>] ? T.1296+0x0/0xd5
 [<ffffffff810398ce>] ? restore_args+0x0/0x30
 [<ffffffff81def672>] ? kernel_init+0x0/0xa0
 [<ffffffff81039dc0>] ? child_rip+0x0/0x20
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.32-rc4 #1
Call Trace:
 <IRQ>  [<ffffffff810aa3f5>] backtrace_test_irq_callback+0xe/0x1c
 [<ffffffff810746e0>] tasklet_action+0x63/0xaa
 [<ffffffff810758c8>] __do_softirq+0xe0/0x1b4
 [<ffffffff81039eca>] call_softirq+0x1a/0x30
 <EOI>  [<ffffffff8103b8d5>] do_softirq+0x49/0xa4
 [<ffffffff81075293>] ksoftirqd+0x4c/0xc9
 [<ffffffff81075247>] ? ksoftirqd+0x0/0xc9
 [<ffffffff81086b98>] kthread+0x7e/0x86
 [<ffffffff81039dca>] child_rip+0xa/0x20
 [<ffffffff8106a56a>] ? T.1296+0x0/0xd5
 [<ffffffff810398ce>] ? restore_args+0x0/0x30
 [<ffffffff81086b1a>] ? kthread+0x0/0x86
 [<ffffffff81039dc0>] ? child_rip+0x0/0x20
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<ffffffff81043bbd>] save_stack_trace+0x2e/0x4b
 [<ffffffff810aa4e4>] backtrace_regression_test+0xe1/0x105
 [<ffffffff8100a05c>] do_one_initcall+0x5c/0x15b
 [<ffffffff81def660>] do_basic_setup+0x4f/0x61
 [<ffffffff81def6cf>] kernel_init+0x5d/0xa0
 [<ffffffff81039dca>] child_rip+0xa/0x20
 [<ffffffffffffffff>] 0xffffffffffffffff
====[ end of backtrace testing ]====
initcall backtrace_regression_test+0x0/0x105 returned 0 after 191206 usecs
calling  audit_init+0x0/0x153 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1255339340.578:1): initialized
initcall audit_init+0x0/0x153 returned 0 after 8401 usecs
calling  audit_tree_init+0x0/0x49 @ 1
initcall audit_tree_init+0x0/0x49 returned 0 after 10 usecs
calling  hung_task_init+0x0/0x53 @ 1
initcall hung_task_init+0x0/0x53 returned 0 after 65 usecs
calling  rcuclassic_trace_init+0x0/0xf8 @ 1
initcall rcuclassic_trace_init+0x0/0xf8 returned 0 after 121 usecs
calling  init_tracepoints+0x0/0x17 @ 1
initcall init_tracepoints+0x0/0x17 returned 0 after 1 usecs
calling  init_lstats_procfs+0x0/0x25 @ 1
initcall init_lstats_procfs+0x0/0x25 returned 0 after 19 usecs
calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 11 usecs
calling  init_events+0x0/0x64 @ 1
initcall init_events+0x0/0x64 returned 0 after 13 usecs
calling  init_sched_switch_trace+0x0/0x12 @ 1
initcall init_sched_switch_trace+0x0/0x12 returned 0 after 4 usecs
calling  init_stack_trace+0x0/0x12 @ 1
initcall init_stack_trace+0x0/0x12 returned 0 after 2 usecs
calling  init_function_trace+0x0/0x3e @ 1
initcall init_function_trace+0x0/0x3e returned 0 after 3 usecs
calling  init_irqsoff_tracer+0x0/0x14 @ 1
initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 2 usecs
calling  init_wakeup_tracer+0x0/0x22 @ 1
initcall init_wakeup_tracer+0x0/0x22 returned 0 after 3 usecs
calling  stack_trace_init+0x0/0x6b @ 1
initcall stack_trace_init+0x0/0x6b returned 0 after 52 usecs
calling  init_blk_tracer+0x0/0x55 @ 1
initcall init_blk_tracer+0x0/0x55 returned 0 after 4 usecs
calling  perf_event_sysfs_init+0x0/0x19 @ 1
initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 30 usecs
calling  init_per_zone_wmark_min+0x0/0x67 @ 1
initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 149 usecs
calling  kswapd_init+0x0/0x14 @ 1
initcall kswapd_init+0x0/0x14 returned 0 after 73 usecs
calling  setup_vmstat+0x0/0x7c @ 1
initcall setup_vmstat+0x0/0x7c returned 0 after 80 usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after 29 usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after 18 usecs
calling  procswaps_init+0x0/0x22 @ 1
initcall procswaps_init+0x0/0x22 returned 0 after 18 usecs
calling  pfn_inject_init+0x0/0x64 @ 1
initcall pfn_inject_init+0x0/0x64 returned 0 after 34 usecs
calling  fasync_init+0x0/0x2a @ 1
initcall fasync_init+0x0/0x2a returned 0 after 5 usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after 19 usecs
calling  dnotify_init+0x0/0x80 @ 1
initcall dnotify_init+0x0/0x80 returned 0 after 22 usecs
calling  inotify_setup+0x0/0x12 @ 1
initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0xbe @ 1
initcall inotify_user_setup+0x0/0xbe returned 0 after 82 usecs
calling  aio_setup+0x0/0xa5 @ 1
initcall aio_setup+0x0/0xa5 returned 0 after 91 usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after 21 usecs
calling  init_sys32_ioctl+0x0/0x83 @ 1
initcall init_sys32_ioctl+0x0/0x83 returned 0 after 18 usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after 3 usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after 19 usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 19 usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after 19 usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after 18 usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after 18 usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after 18 usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after 21 usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after 19 usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after 18 usecs
calling  proc_softirqs_init+0x0/0x22 @ 1
initcall proc_softirqs_init+0x0/0x22 returned 0 after 18 usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after 19 usecs
calling  configfs_init+0x0/0xb3 @ 1
initcall configfs_init+0x0/0xb3 returned 0 after 32 usecs
calling  init_devpts_fs+0x0/0x4c @ 1
initcall init_devpts_fs+0x0/0x4c returned 0 after 100 usecs
calling  init_ext3_fs+0x0/0x71 @ 1
initcall init_ext3_fs+0x0/0x71 returned 0 after 47 usecs
calling  init_ext4_fs+0x0/0xe9 @ 1
initcall init_ext4_fs+0x0/0xe9 returned 0 after 99 usecs
calling  journal_init+0x0/0x1e @ 1
initcall journal_init+0x0/0x1e returned 0 after 36 usecs
calling  journal_init+0x0/0x73 @ 1
initcall journal_init+0x0/0x73 returned 0 after 58 usecs
calling  init_cramfs_fs+0x0/0x2e @ 1
initcall init_cramfs_fs+0x0/0x2e returned 0 after 54 usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after 2 usecs
calling  init_fat_fs+0x0/0x4f @ 1
initcall init_fat_fs+0x0/0x4f returned 0 after 14 usecs
calling  init_vfat_fs+0x0/0x12 @ 1
initcall init_vfat_fs+0x0/0x12 returned 0 after 2 usecs
calling  init_msdos_fs+0x0/0x12 @ 1
initcall init_msdos_fs+0x0/0x12 returned 0 after 2 usecs
calling  init_hfsplus_fs+0x0/0x5f @ 1
initcall init_hfsplus_fs+0x0/0x5f returned 0 after 10 usecs
calling  ecryptfs_init+0x0/0x1d5 @ 1
PM: Adding info for No Bus:ecryptfs
initcall ecryptfs_init+0x0/0x1d5 returned 0 after 3849 usecs
calling  init_nls_cp850+0x0/0x12 @ 1
initcall init_nls_cp850+0x0/0x12 returned 0 after 9 usecs
calling  init_nls_cp852+0x0/0x12 @ 1
initcall init_nls_cp852+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp855+0x0/0x12 @ 1
initcall init_nls_cp855+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp860+0x0/0x12 @ 1
initcall init_nls_cp860+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp864+0x0/0x12 @ 1
initcall init_nls_cp864+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_ascii+0x0/0x12 @ 1
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_1+0x0/0x12 @ 1
initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_5+0x0/0x12 @ 1
initcall init_nls_iso8859_5+0x0/0x12 returned 0 after 1 usecs
calling  init_nls_cp1255+0x0/0x12 @ 1
initcall init_nls_cp1255+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_14+0x0/0x12 @ 1
initcall init_nls_iso8859_14+0x0/0x12 returned 0 after 1 usecs
calling  init_nls_koi8_u+0x0/0x12 @ 1
initcall init_nls_koi8_u+0x0/0x12 returned 0 after 1 usecs
calling  init_nls_koi8_ru+0x0/0x48 @ 1
initcall init_nls_koi8_ru+0x0/0x48 returned 0 after 1 usecs
calling  init_nls_utf8+0x0/0x29 @ 1
initcall init_nls_utf8+0x0/0x29 returned 0 after 1 usecs
calling  init_efs_fs+0x0/0x71 @ 1
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x71 returned 0 after 3718 usecs
calling  init_affs_fs+0x0/0x63 @ 1
initcall init_affs_fs+0x0/0x63 returned 0 after 10 usecs
calling  init_adfs_fs+0x0/0x63 @ 1
initcall init_adfs_fs+0x0/0x63 returned 0 after 10 usecs
calling  init_befs_fs+0x0/0x7f @ 1
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0x7f returned 0 after 1921 usecs
calling  ipc_init+0x0/0x23 @ 1
msgmni has been set to 3974
initcall ipc_init+0x0/0x23 returned 0 after 2665 usecs
calling  init_mqueue_fs+0x0/0xc7 @ 1
initcall init_mqueue_fs+0x0/0xc7 returned 0 after 119 usecs
calling  key_proc_init+0x0/0x59 @ 1
initcall key_proc_init+0x0/0x59 returned 0 after 34 usecs
calling  crypto_wq_init+0x0/0x32 @ 1
initcall crypto_wq_init+0x0/0x32 returned 0 after 80 usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after 22 usecs
calling  skcipher_module_init+0x0/0x13 @ 1
initcall skcipher_module_init+0x0/0x13 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after 5 usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after 4 usecs
calling  seqiv_module_init+0x0/0x12 @ 1
initcall seqiv_module_init+0x0/0x12 returned 0 after 4 usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after 4 usecs
calling  md5_mod_init+0x0/0x12 @ 1
initcall md5_mod_init+0x0/0x12 returned 0 after 185 usecs
calling  rmd320_mod_init+0x0/0x12 @ 1
initcall rmd320_mod_init+0x0/0x12 returned 0 after 196 usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 183 usecs
calling  sha256_generic_mod_init+0x0/0x3f @ 1
initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 361 usecs
calling  sha512_generic_mod_init+0x0/0x3f @ 1
initcall sha512_generic_mod_init+0x0/0x3f returned 0 after 429 usecs
calling  wp512_mod_init+0x0/0x64 @ 1
initcall wp512_mod_init+0x0/0x64 returned 0 after 610 usecs
calling  tgr192_mod_init+0x0/0x65 @ 1
initcall tgr192_mod_init+0x0/0x65 returned 0 after 536 usecs
calling  crypto_ecb_module_init+0x0/0x12 @ 1
initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 20 usecs
calling  crypto_cbc_module_init+0x0/0x12 @ 1
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 4 usecs
calling  crypto_pcbc_module_init+0x0/0x12 @ 1
initcall crypto_pcbc_module_init+0x0/0x12 returned 0 after 4 usecs
calling  crypto_cts_module_init+0x0/0x12 @ 1
initcall crypto_cts_module_init+0x0/0x12 returned 0 after 4 usecs
calling  crypto_ctr_module_init+0x0/0x3e @ 1
initcall crypto_ctr_module_init+0x0/0x3e returned 0 after 6 usecs
calling  crypto_gcm_module_init+0x0/0xe3 @ 1
initcall crypto_gcm_module_init+0x0/0xe3 returned 0 after 14 usecs
calling  crypto_ccm_module_init+0x0/0x60 @ 1
initcall crypto_ccm_module_init+0x0/0x60 returned 0 after 9 usecs
calling  cryptd_init+0x0/0x2e @ 1
initcall cryptd_init+0x0/0x2e returned 0 after 9 usecs
calling  fcrypt_mod_init+0x0/0x12 @ 1
alg: No test for fcrypt (fcrypt-generic)
initcall fcrypt_mod_init+0x0/0x12 returned 0 after 3789 usecs
calling  blowfish_mod_init+0x0/0x12 @ 1
initcall blowfish_mod_init+0x0/0x12 returned 0 after 663 usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after 229 usecs
calling  camellia_init+0x0/0x12 @ 1
initcall camellia_init+0x0/0x12 returned 0 after 243 usecs
calling  arc4_init+0x0/0x12 @ 1
initcall arc4_init+0x0/0x12 returned 0 after 191 usecs
calling  tea_mod_init+0x0/0x64 @ 1
initcall tea_mod_init+0x0/0x64 returned 0 after 687 usecs
calling  seed_init+0x0/0x12 @ 1
initcall seed_init+0x0/0x12 returned 0 after 209 usecs
calling  salsa20_generic_mod_init+0x0/0x12 @ 1
initcall salsa20_generic_mod_init+0x0/0x12 returned 0 after 116 usecs
calling  deflate_mod_init+0x0/0x12 @ 1
initcall deflate_mod_init+0x0/0x12 returned 0 after 657 usecs
calling  crc32c_mod_init+0x0/0x12 @ 1
initcall crc32c_mod_init+0x0/0x12 returned 0 after 322 usecs
calling  crypto_authenc_module_init+0x0/0x12 @ 1
initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 21 usecs
calling  krng_mod_init+0x0/0x12 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x12 returned 0 after 2968 usecs
calling  ghash_mod_init+0x0/0x12 @ 1
alg: No test for ghash (ghash-generic)
initcall ghash_mod_init+0x0/0x12 returned 0 after 3654 usecs
calling  proc_genhd_init+0x0/0x3c @ 1
initcall proc_genhd_init+0x0/0x3c returned 0 after 54 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 2684 usecs
calling  as_init+0x0/0x14 @ 1
io scheduler anticipatory registered (default)
initcall as_init+0x0/0x14 returned 0 after 4197 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 3014 usecs
calling  dynamic_debug_init+0x0/0x12c @ 1
initcall dynamic_debug_init+0x0/0x12c returned 0 after 1011 usecs
calling  pci_init+0x0/0x3a @ 1
pci 0000:04:00.0: Boot video device
initcall pci_init+0x0/0x3a returned 0 after 3605 usecs
calling  pci_proc_init+0x0/0x6a @ 1
initcall pci_proc_init+0x0/0x6a returned 0 after 627 usecs
calling  pcie_portdrv_init+0x0/0x4c @ 1
pcieport-driver 0000:00:01.0: setting latency timer to 64
PM: Adding info for pci_express:0000:00:01.0:pcie01
PM: Adding info for pci_express:0000:00:01.0:pcie08
pcieport-driver 0000:00:1c.0: setting latency timer to 64
PM: Adding info for pci_express:0000:00:1c.0:pcie01
PM: Adding info for pci_express:0000:00:1c.0:pcie04
PM: Adding info for pci_express:0000:00:1c.0:pcie08
pcieport-driver 0000:00:1c.3: setting latency timer to 64
PM: Adding info for pci_express:0000:00:1c.3:pcie01
PM: Adding info for pci_express:0000:00:1c.3:pcie08
initcall pcie_portdrv_init+0x0/0x4c returned 0 after 51719 usecs
calling  aer_service_init+0x0/0xb @ 1
initcall aer_service_init+0x0/0xb returned -6 after 0 usecs
initcall aer_service_init+0x0/0xb returned with error code -6 
calling  aer_inject_init+0x0/0x12 @ 1
PM: Adding info for No Bus:aer_inject
initcall aer_inject_init+0x0/0x12 returned 0 after 3854 usecs
calling  genericbl_init+0x0/0x12 @ 1
initcall genericbl_init+0x0/0x12 returned 0 after 276 usecs
calling  progearbl_init+0x0/0x55 @ 1
PM: Adding info for platform:progear-bl
ALI M7101 PMU not found.
initcall progearbl_init+0x0/0x55 returned 0 after 6756 usecs
calling  display_class_init+0x0/0x7e @ 1
initcall display_class_init+0x0/0x7e returned 0 after 279 usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 44 usecs
calling  irqrouter_init_sysfs+0x0/0x38 @ 1
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 455 usecs
calling  acpi_button_init+0x0/0x56 @ 1
PM: Adding info for No Bus:input0
input: Power Button as /class/input/input0
ACPI: Power Button [PWRB]
PM: Adding info for No Bus:input1
input: Power Button as /class/input/input1
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0x56 returned 0 after 20714 usecs
calling  acpi_fan_init+0x0/0x56 @ 1
initcall acpi_fan_init+0x0/0x56 returned 0 after 315 usecs
calling  acpi_smb_hc_init+0x0/0x18 @ 1
initcall acpi_smb_hc_init+0x0/0x18 returned 0 after 345 usecs
calling  acpi_sbs_init+0x0/0x4f @ 1
initcall acpi_sbs_init+0x0/0x4f returned 0 after 341 usecs
calling  xenfs_init+0x0/0x2d @ 1
XENFS: not registering filesystem on non-xen platform
initcall xenfs_init+0x0/0x2d returned 0 after 4788 usecs
calling  hypervisor_subsys_init+0x0/0x25 @ 1
initcall hypervisor_subsys_init+0x0/0x25 returned -19 after 0 usecs
calling  hyper_sysfs_init+0x0/0xfb @ 1
initcall hyper_sysfs_init+0x0/0xfb returned -19 after 0 usecs
calling  regulator_virtual_consumer_init+0x0/0x12 @ 1
initcall regulator_virtual_consumer_init+0x0/0x12 returned 0 after 276 usecs
calling  rand_initialize+0x0/0x31 @ 1
initcall rand_initialize+0x0/0x31 returned 0 after 28 usecs
calling  tty_init+0x0/0xf5 @ 1
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
initcall tty_init+0x0/0xf5 returned 0 after 238267 usecs
calling  pty_init+0x0/0xd @ 1
PM: Adding info for No Bus:ptmx
initcall pty_init+0x0/0xd returned 0 after 3386 usecs
calling  sysrq_init+0x0/0x25 @ 1
initcall sysrq_init+0x0/0x25 returned 0 after 42 usecs
calling  xen_init+0x0/0x93 @ 1
initcall xen_init+0x0/0x93 returned -19 after 0 usecs
calling  init+0x0/0x12 @ 1
initcall init+0x0/0x12 returned 0 after 254 usecs
calling  raw_init+0x0/0xe5 @ 1
PM: Adding info for No Bus:rawctl
initcall raw_init+0x0/0xe5 returned 0 after 3749 usecs
calling  applicom_init+0x0/0x4c8 @ 1
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall applicom_init+0x0/0x4c8 returned -6 after 16570 usecs
initcall applicom_init+0x0/0x4c8 returned with error code -6 
calling  hpet_init+0x0/0x6a @ 1
PM: Adding info for No Bus:hpet
initcall hpet_init+0x0/0x6a returned 0 after 3587 usecs
calling  mwave_init+0x0/0x1dd @ 1
smapi::smapi_init, ERROR invalid usSmapiID
mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
mwave: mwavedd::mwave_init: Error: Failed to initialize board data
mwave: mwavedd::mwave_init: Error: Failed to initialize
initcall mwave_init+0x0/0x1dd returned -5 after 22723 usecs
initcall mwave_init+0x0/0x1dd returned with error code -5 
calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 3484 usecs
calling  hangcheck_init+0x0/0x9b @ 1
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
initcall hangcheck_init+0x0/0x9b returned 0 after 10503 usecs
calling  init_tis+0x0/0x8e @ 1
initcall init_tis+0x0/0x8e returned 0 after 279 usecs
calling  init_atmel+0x0/0x182 @ 1
initcall init_atmel+0x0/0x182 returned -19 after 595 usecs
calling  serial8250_init+0x0/0x143 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
initcall serial8250_init+0x0/0x143 returned 0 after 28157 usecs
calling  serial8250_pnp_init+0x0/0x12 @ 1
PM: Removing info for No Bus:ttyS0
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 12094 usecs
calling  serial8250_pci_init+0x0/0x1b @ 1
initcall serial8250_pci_init+0x0/0x1b returned 0 after 330 usecs
calling  jsm_init_module+0x0/0x45 @ 1
initcall jsm_init_module+0x0/0x45 returned 0 after 389 usecs
calling  floppy_init+0x0/0x5c4 @ 1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PM: Adding info for platform:floppy.0
PM: Adding info for No Bus:fd0
PM: Adding info for No Bus:2:0
initcall floppy_init+0x0/0x5c4 returned 0 after 34334 usecs
calling  cpqarray_init+0x0/0x6b @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x6b returned -19 after 3496 usecs
calling  cciss_init+0x0/0x9e @ 1
HP CISS Driver (v 3.6.20)
initcall cciss_init+0x0/0x9e returned 0 after 3123 usecs
calling  DAC960_init_module+0x0/0x4d @ 1
PM: Adding info for No Bus:dac960_gam
initcall DAC960_init_module+0x0/0x4d returned 0 after 4192 usecs
calling  ub_init+0x0/0x8e @ 1
usbcore: registered new interface driver ub
initcall ub_init+0x0/0x8e returned 0 after 4329 usecs
calling  xlblk_init+0x0/0x7a @ 1
initcall xlblk_init+0x0/0x7a returned -19 after 0 usecs
calling  ibmasm_init+0x0/0x64 @ 1
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
initcall ibmasm_init+0x0/0x64 returned 0 after 5703 usecs
calling  phantom_init+0x0/0x10b @ 1
Phantom Linux Driver, version n0.9.8, init OK
initcall phantom_init+0x0/0x10b returned 0 after 4737 usecs
calling  enclosure_init+0x0/0x19 @ 1
initcall enclosure_init+0x0/0x19 returned 0 after 247 usecs
calling  init_kgdbts+0x0/0x16 @ 1
initcall init_kgdbts+0x0/0x16 returned 0 after 0 usecs
calling  ilo_init+0x0/0x95 @ 1
initcall ilo_init+0x0/0x95 returned 0 after 625 usecs
calling  mac_hid_init+0x0/0xb @ 1
PM: Adding info for No Bus:input2
input: Macintosh mouse button emulation as /class/input/input2
initcall mac_hid_init+0x0/0xb returned 0 after 9274 usecs
calling  scsi_tgt_init+0x0/0x86 @ 1
PM: Adding info for No Bus:tgt
initcall scsi_tgt_init+0x0/0x86 returned 0 after 3404 usecs
calling  raid_init+0x0/0x12 @ 1
initcall raid_init+0x0/0x12 returned 0 after 259 usecs
calling  spi_transport_init+0x0/0x79 @ 1
initcall spi_transport_init+0x0/0x79 returned 0 after 553 usecs
calling  fc_transport_init+0x0/0x4c @ 1
initcall fc_transport_init+0x0/0x4c returned 0 after 1026 usecs
calling  iscsi_transport_init+0x0/0x14f @ 1
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x14f returned 0 after 5164 usecs
calling  sas_transport_init+0x0/0xcc @ 1
initcall sas_transport_init+0x0/0xcc returned 0 after 1494 usecs
calling  sas_class_init+0x0/0x31 @ 1
initcall sas_class_init+0x0/0x31 returned 0 after 22 usecs
calling  scsi_dh_init+0x0/0x3f @ 1
initcall scsi_dh_init+0x0/0x3f returned 0 after 1 usecs
calling  libfc_init+0x0/0x73 @ 1
initcall libfc_init+0x0/0x73 returned 0 after 88 usecs
calling  fnic_init_module+0x0/0x1e9 @ 1
fnic: Cisco FCoE HBA Driver, ver 1.0.0.1121
initcall fnic_init_module+0x0/0x1e9 returned 0 after 4429 usecs
calling  iscsi_sw_tcp_init+0x0/0x42 @ 1
PM: Adding info for No Bus:tcp
iscsi: registered transport (tcp)
initcall iscsi_sw_tcp_init+0x0/0x42 returned 0 after 6390 usecs
calling  BusLogic_init+0x0/0x5df @ 1
initcall BusLogic_init+0x0/0x5df returned 0 after 178 usecs
calling  arcmsr_module_init+0x0/0x20 @ 1
initcall arcmsr_module_init+0x0/0x20 returned 0 after 293 usecs
calling  ahc_linux_init+0x0/0x65 @ 1
initcall ahc_linux_init+0x0/0x65 returned 0 after 424 usecs
calling  ahd_linux_init+0x0/0x80 @ 1
initcall ahd_linux_init+0x0/0x80 returned 0 after 386 usecs
calling  aac_init+0x0/0x73 @ 1
Adaptec aacraid driver 1.1-5[2461]-ms
initcall aac_init+0x0/0x73 returned 0 after 3826 usecs
calling  ips_module_init+0x0/0x67 @ 1
initcall ips_module_init+0x0/0x67 returned -19 after 590 usecs
calling  init_this_scsi_driver+0x0/0xe3 @ 1
scsi: <fdomain> Detection failed (no card)
initcall init_this_scsi_driver+0x0/0xe3 returned -19 after 4061 usecs
calling  qla1280_init+0x0/0x1b @ 1
initcall qla1280_init+0x0/0x1b returned 0 after 287 usecs
calling  lpfc_init+0x0/0xcd @ 1
Emulex LightPulse Fibre Channel SCSI driver 8.3.4
Copyright(c) 2004-2009 Emulex.  All rights reserved.
initcall lpfc_init+0x0/0xcd returned 0 after 9478 usecs
calling  init_this_scsi_driver+0x0/0xe3 @ 1
initcall init_this_scsi_driver+0x0/0xe3 returned -19 after 37 usecs
calling  dc395x_module_init+0x0/0x1b @ 1
initcall dc395x_module_init+0x0/0x1b returned 0 after 285 usecs
calling  megaraid_init+0x0/0xbc @ 1
initcall megaraid_init+0x0/0xbc returned 0 after 352 usecs
calling  megasas_init+0x0/0x16e @ 1
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
initcall megasas_init+0x0/0x16e returned 0 after 4893 usecs
calling  _scsih_init+0x0/0x119 @ 1
mpt2sas version 02.100.03.00 loaded
PM: Adding info for No Bus:mpt2ctl
initcall _scsih_init+0x0/0x119 returned 0 after 7225 usecs
calling  initio_init_driver+0x0/0x1b @ 1
initcall initio_init_driver+0x0/0x1b returned 0 after 308 usecs
calling  inia100_init+0x0/0x1b @ 1
initcall inia100_init+0x0/0x1b returned 0 after 310 usecs
calling  tw_init+0x0/0x30 @ 1
3ware Storage Controller device driver for Linux v1.26.02.002.
initcall tw_init+0x0/0x30 returned 0 after 5860 usecs
calling  twa_init+0x0/0x30 @ 1
3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
initcall twa_init+0x0/0x30 returned 0 after 6338 usecs
calling  stex_init+0x0/0x30 @ 1
stex: Promise SuperTrak EX Driver version: 4.6.0000.3
initcall stex_init+0x0/0x30 returned 0 after 5096 usecs
calling  pmcraid_init+0x0/0x13b @ 1
initcall pmcraid_init+0x0/0x13b returned 0 after 671 usecs
calling  init_sd+0x0/0x161 @ 1
initcall init_sd+0x0/0x161 returned 0 after 728 usecs
calling  init_sr+0x0/0x46 @ 1
initcall init_sr+0x0/0x46 returned 0 after 275 usecs
calling  init_sg+0x0/0x125 @ 1
initcall init_sg+0x0/0x125 returned 0 after 461 usecs
calling  ahci_init+0x0/0x1b @ 1
initcall ahci_init+0x0/0x1b returned 0 after 390 usecs
calling  k2_sata_init+0x0/0x1b @ 1
initcall k2_sata_init+0x0/0x1b returned 0 after 305 usecs
calling  piix_init+0x0/0x29 @ 1
ata_piix 0000:00:1f.1: version 2.13
IOAPIC[0]: Set routing entry (2-22 -> 0x59 -> IRQ 22 Mode:1 Active:1)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
PM: Adding info for No Bus:host0
PM: Adding info for No Bus:host0
scsi1 : ata_piix
PM: Adding info for No Bus:host1
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
IOAPIC[0]: Set routing entry (2-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
ata_piix 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
calling  1_async_port_probe+0x0/0xbb @ 827
calling  2_async_port_probe+0x0/0xbb @ 828
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
PM: Adding info for No Bus:host2
PM: Adding info for No Bus:host2
scsi3 : ata_piix
PM: Adding info for No Bus:host3
PM: Adding info for No Bus:host3
ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 23
ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 23
calling  3_async_port_probe+0x0/0xbb @ 833
calling  4_async_port_probe+0x0/0xbb @ 834
initcall piix_init+0x0/0x29 returned 0 after 175181 usecs
calling  pdc_ata_init+0x0/0x1b @ 1
initcall pdc_ata_init+0x0/0x1b returned 0 after 326 usecs
calling  sil24_init+0x0/0x1b @ 1
initcall sil24_init+0x0/0x1b returned 0 after 317 usecs
calling  nv_init+0x0/0x1b @ 1
initcall nv_init+0x0/0x1b returned 0 after 369 usecs
calling  amd_init+0x0/0x1b @ 1
initcall amd_init+0x0/0x1b returned 0 after 311 usecs
calling  atp867x_init+0x0/0x1b @ 1
initcall atp867x_init+0x0/0x1b returned 0 after 309 usecs
calling  cmd64x_init+0x0/0x1b @ 1
initcall cmd64x_init+0x0/0x1b returned 0 after 316 usecs
calling  cs5520_init+0x0/0x1b @ 1
initcall cs5520_init+0x0/0x1b returned 0 after 307 usecs
calling  it8213_init+0x0/0x1b @ 1
initcall it8213_init+0x0/0x1b returned 0 after 309 usecs
calling  ninja32_init+0x0/0x1b @ 1
initcall ninja32_init+0x0/0x1b returned 0 after 308 usecs
calling  ns87415_init+0x0/0x1b @ 1
initcall ns87415_init+0x0/0x1b returned 0 after 304 usecs
calling  marvell_init+0x0/0x1b @ 1
initcall marvell_init+0x0/0x1b returned 0 after 368 usecs
calling  oldpiix_init+0x0/0x1b @ 1
ata1.00: unsupported CDB len
async_waiting @ 828
initcall oldpiix_init+0x0/0x1b returned 0 after 16153 usecs
calling  pdc2027x_init+0x0/0x1b @ 1
initcall pdc2027x_init+0x0/0x1b returned 0 after 305 usecs
calling  radisys_init+0x0/0x1b @ 1
initcall radisys_init+0x0/0x1b returned 0 after 358 usecs
calling  sil680_init+0x0/0x1b @ 1
initcall sil680_init+0x0/0x1b returned 0 after 313 usecs
calling  via_init+0x0/0x1b @ 1
async_waiting @ 834
initcall via_init+0x0/0x1b returned 0 after 13206 usecs
calling  spi_gpio_init+0x0/0x19 @ 1
initcall spi_gpio_init+0x0/0x19 returned -19 after 557 usecs
calling  e1000_init_module+0x0/0x6b @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
initcall e1000_init_module+0x0/0x6b returned 0 after 9562 usecs
calling  ipg_init_module+0x0/0x1b @ 1
initcall ipg_init_module+0x0/0x1b returned 0 after 312 usecs
calling  atl1c_init_module+0x0/0x1b @ 1
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
initcall atl1c_init_module+0x0/0x1b returned 0 after 10278 usecs
calling  enic_init_module+0x0/0x37 @ 1
enic: Cisco 10G Ethernet Driver, ver 1.1.0.100
initcall enic_init_module+0x0/0x37 returned 0 after 4660 usecs
calling  ne2k_pci_init+0x0/0x1b @ 1
initcall ne2k_pci_init+0x0/0x1b returned 0 after 542 usecs
calling  e100_init_module+0x0/0x5d @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5d returned 0 after 9302 usecs
calling  sis900_init_module+0x0/0x1b @ 1
initcall sis900_init_module+0x0/0x1b returned 0 after 387 usecs
calling  yellowfin_init+0x0/0x1b @ 1
ata3.00: configured for UDMA/133
async_waiting @ 833
initcall yellowfin_init+0x0/0x1b returned 0 after 5340 usecs
calling  ns83820_init+0x0/0x29 @ 1
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
initcall ns83820_init+0x0/0x29 returned 0 after 5818 usecs
calling  fealnx_init+0x0/0x1b @ 1
initcall fealnx_init+0x0/0x1b returned 0 after 308 usecs
calling  tg3_init+0x0/0x1b @ 1
initcall tg3_init+0x0/0x1b returned 0 after 309 usecs
calling  skge_init_module+0x0/0x1b @ 1
initcall skge_init_module+0x0/0x1b returned 0 after 313 usecs
calling  sky2_init_module+0x0/0x29 @ 1
sky2 driver version 1.25
sky2 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sky2 0000:02:00.0: setting latency timer to 64
sky2 0000:02:00.0: Yukon-2 EC chip revision 2
PM: Adding info for No Bus:eth0
sky2 eth0: addr 00:15:f2:e6:8e:6b
initcall sky2_init_module+0x0/0x29 returned 0 after 23877 usecs
calling  cicada_init+0x0/0x3c @ 1
initcall cicada_init+0x0/0x3c returned 0 after 552 usecs
calling  lxt_init+0x0/0x3c @ 1
initcall lxt_init+0x0/0x3c returned 0 after 562 usecs
calling  broadcom_init+0x0/0x143 @ 1
initcall broadcom_init+0x0/0x143 returned 0 after 2810 usecs
calling  ip175c_init+0x0/0x12 @ 1
initcall ip175c_init+0x0/0x12 returned 0 after 278 usecs
calling  realtek_init+0x0/0x12 @ 1
initcall realtek_init+0x0/0x12 returned 0 after 273 usecs
calling  et1011c_init+0x0/0x12 @ 1
initcall et1011c_init+0x0/0x12 returned 0 after 270 usecs
calling  fixed_mdio_bus_init+0x0/0xf7 @ 1
PM: Adding info for platform:Fixed MDIO bus.0
PM: Adding info for No Bus:0
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xf7 returned 0 after 9796 usecs
calling  sundance_init+0x0/0x1b @ 1
initcall sundance_init+0x0/0x1b returned 0 after 314 usecs
calling  hamachi_init+0x0/0x1b @ 1
initcall hamachi_init+0x0/0x1b returned 0 after 300 usecs
calling  net_olddevs_init+0x0/0x2f @ 1
initcall net_olddevs_init+0x0/0x2f returned 0 after 463 usecs
calling  hp100_module_init+0x0/0x1b @ 1
initcall hp100_module_init+0x0/0x1b returned 0 after 376 usecs
calling  init_nic+0x0/0x1b @ 1
initcall init_nic+0x0/0x1b returned 0 after 305 usecs
calling  ql3xxx_init_module+0x0/0x1b @ 1
initcall ql3xxx_init_module+0x0/0x1b returned 0 after 304 usecs
calling  qlge_init_module+0x0/0x1b @ 1
initcall qlge_init_module+0x0/0x1b returned 0 after 301 usecs
calling  ppp_init+0x0/0xf0 @ 1
PPP generic driver version 2.4.2
PM: Adding info for No Bus:ppp
initcall ppp_init+0x0/0xf0 returned 0 after 6664 usecs
calling  ppp_sync_init+0x0/0x36 @ 1
initcall ppp_sync_init+0x0/0x36 returned 0 after 1 usecs
calling  ppp_mppe_init+0x0/0x110 @ 1
PPP MPPE Compression module registered
initcall ppp_mppe_init+0x0/0x110 returned 0 after 4463 usecs
calling  pppox_init+0x0/0x12 @ 1
NET: Registered protocol family 24
initcall pppox_init+0x0/0x12 returned 0 after 3182 usecs
calling  pppoe_init+0x0/0x94 @ 1
initcall pppoe_init+0x0/0x94 returned 0 after 94 usecs
calling  slip_init+0x0/0xc1 @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xc1 returned 0 after 17263 usecs
calling  netif_init+0x0/0x52 @ 1
initcall netif_init+0x0/0x52 returned -19 after 0 usecs
calling  rtl8139_init_module+0x0/0x1b @ 1
initcall rtl8139_init_module+0x0/0x1b returned 0 after 306 usecs
calling  tun_init+0x0/0x93 @ 1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
PM: Adding info for No Bus:tun
initcall tun_init+0x0/0x93 returned 0 after 11886 usecs
calling  rio_init+0x0/0x1b @ 1
initcall rio_init+0x0/0x1b returned 0 after 306 usecs
calling  amd8111e_init+0x0/0x1b @ 1
initcall amd8111e_init+0x0/0x1b returned 0 after 310 usecs
calling  myri10ge_init_module+0x0/0x74 @ 1
myri10ge: Version 1.5.0-1.432
initcall myri10ge_init_module+0x0/0x74 returned 0 after 3128 usecs
calling  mlx4_init+0x0/0xa2 @ 1
initcall mlx4_init+0x0/0xa2 returned 0 after 464 usecs
calling  mlx4_en_init+0x0/0x12 @ 1
initcall mlx4_en_init+0x0/0x12 returned 0 after 30 usecs
calling  enc28j60_init+0x0/0x23 @ 1
initcall enc28j60_init+0x0/0x23 returned 0 after 251 usecs
calling  tms_pci_init+0x0/0x1b @ 1
initcall tms_pci_init+0x0/0x1b returned 0 after 308 usecs
calling  catc_init+0x0/0x39 @ 1
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x39 returned 0 after 9135 usecs
calling  kaweth_init+0x0/0x1b @ 1
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x1b returned 0 after 4596 usecs
calling  usb_rtl8150_init+0x0/0x29 @ 1
rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
usbcore: registered new interface driver rtl8150
initcall usb_rtl8150_init+0x0/0x29 returned 0 after 10226 usecs
calling  hso_init+0x0/0x1a7 @ 1
hso: drivers/net/usb/hso.c: 1.2 Option Wireless
usbcore: registered new interface driver hso
initcall hso_init+0x0/0x1a7 returned 0 after 8702 usecs
calling  cdc_init+0x0/0x1b @ 1
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x1b returned 0 after 4845 usecs
calling  smsc95xx_init+0x0/0x1b @ 1
usbcore: registered new interface driver smsc95xx
initcall smsc95xx_init+0x0/0x1b returned 0 after 4828 usecs
calling  net1080_init+0x0/0x1b @ 1
usbcore: registered new interface driver net1080
initcall net1080_init+0x0/0x1b returned 0 after 4693 usecs
calling  plusb_init+0x0/0x1b @ 1
usbcore: registered new interface driver plusb
initcall plusb_init+0x0/0x1b returned 0 after 4529 usecs
calling  zaurus_init+0x0/0x1b @ 1
usbcore: registered new interface driver zaurus
initcall zaurus_init+0x0/0x1b returned 0 after 4587 usecs
calling  mcs7830_init+0x0/0x1b @ 1
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall mcs7830_init+0x0/0x1b returned 0 after 6362 usecs
calling  usbnet_init+0x0/0x2b @ 1
initcall usbnet_init+0x0/0x2b returned 0 after 7 usecs
calling  w840_init+0x0/0x29 @ 1
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
initcall w840_init+0x0/0x29 returned 0 after 11127 usecs
calling  tulip_init+0x0/0x33 @ 1
initcall tulip_init+0x0/0x33 returned 0 after 307 usecs
calling  init_netconsole+0x0/0x165 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x165 returned 0 after 5916 usecs
calling  i2o_iop_init+0x0/0x49 @ 1
I2O subsystem v1.325
i2o: max drivers = 8
initcall i2o_iop_init+0x0/0x49 returned 0 after 4977 usecs
calling  i2o_block_init+0x0/0x121 @ 1
I2O Block Device OSM v1.325
initcall i2o_block_init+0x0/0x121 returned 0 after 3257 usecs
calling  i2o_scsi_init+0x0/0x44 @ 1
I2O SCSI Peripheral OSM v1.316
initcall i2o_scsi_init+0x0/0x44 returned 0 after 3117 usecs
calling  fusion_init+0x0/0x13b @ 1
Fusion MPT base driver 3.04.12
Copyright (c) 1999-2008 LSI Corporation
initcall fusion_init+0x0/0x13b returned 0 after 6523 usecs
calling  mptfc_init+0x0/0xf3 @ 1
Fusion MPT FC Host driver 3.04.12
initcall mptfc_init+0x0/0xf3 returned 0 after 3402 usecs
calling  cdrom_init+0x0/0x8 @ 1
initcall cdrom_init+0x0/0x8 returned 0 after 0 usecs
calling  uwb_subsys_init+0x0/0x51 @ 1
initcall uwb_subsys_init+0x0/0x51 returned 0 after 300 usecs
calling  mon_init+0x0/0x116 @ 1
PM: Adding info for No Bus:usbmon0
initcall mon_init+0x0/0x116 returned 0 after 3924 usecs
calling  ehci_hcd_init+0x0/0xbd @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
IOAPIC[0]: Set routing entry (2-20 -> 0x69 -> IRQ 20 Mode:1 Active:1)
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
PM: Adding info for No Bus:usbmon1
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xd7cff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
PM: Adding info for usb:usb1
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
initcall ehci_hcd_init+0x0/0xbd returned 0 after 92834 usecs
calling  isp116x_init+0x0/0x3e @ 1
116x: driver isp116x-hcd, 03 Nov 2005
initcall isp116x_init+0x0/0x3e returned 0 after 3722 usecs
calling  ohci_hcd_mod_init+0x0/0x8e @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
initcall ohci_hcd_mod_init+0x0/0x8e returned 0 after 5199 usecs
calling  uhci_hcd_init+0x0/0xbe @ 1
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
PM: Adding info for No Bus:usbmon2
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00007000
PM: Adding info for usb:usb2
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
IOAPIC[0]: Set routing entry (2-17 -> 0x71 -> IRQ 17 Mode:1 Active:1)
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
PM: Adding info for No Bus:usbmon3
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00007400
PM: Adding info for usb:usb3
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
IOAPIC[0]: Set routing entry (2-18 -> 0x79 -> IRQ 18 Mode:1 Active:1)
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
PM: Adding info for No Bus:usbmon4
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00007800
PM: Adding info for usb:usb4
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
PM: Adding info for No Bus:usbmon5
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00008000
PM: Adding info for usb:usb5
usb usb5: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_00
initcall uhci_hcd_init+0x0/0xbe returned 0 after 228120 usecs
calling  isp1760_init+0x0/0x50 @ 1
initcall isp1760_init+0x0/0x50 returned 0 after 621 usecs
calling  c67x00_init+0x0/0x12 @ 1
initcall c67x00_init+0x0/0x12 returned 0 after 288 usecs
calling  usb_usual_init+0x0/0x3f @ 1
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x3f returned 0 after 4922 usecs
calling  usb_mdc800_init+0x0/0x3a6 @ 1
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall usb_mdc800_init+0x0/0x3a6 returned 0 after 11071 usecs
calling  microtek_drv_init+0x0/0x1b @ 1
usbcore: registered new interface driver microtekX6
initcall microtek_drv_init+0x0/0x1b returned 0 after 4939 usecs
calling  adu_init+0x0/0x96 @ 1
usbcore: registered new interface driver adutux
adutux adutux (see www.ontrak.net) v0.0.13
adutux is an experimental driver. Use at your own risk
initcall adu_init+0x0/0x96 returned 0 after 13431 usecs
calling  appledisplay_init+0x0/0x59 @ 1
usbcore: registered new interface driver appledisplay
initcall appledisplay_init+0x0/0x59 returned 0 after 5277 usecs
calling  cypress_init+0x0/0x3a @ 1
usbcore: registered new interface driver cypress_cy7c63
initcall cypress_init+0x0/0x3a returned 0 after 5276 usecs
calling  emi62_init+0x0/0x38 @ 1
usbcore: registered new interface driver emi62 - firmware loader
initcall emi62_init+0x0/0x38 returned 0 after 6047 usecs
calling  iowarrior_init+0x0/0x1b @ 1
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x1b returned 0 after 4921 usecs
calling  ld_usb_init+0x0/0x3a @ 1
usbcore: registered new interface driver ldusb
initcall ld_usb_init+0x0/0x3a returned 0 after 4581 usecs
calling  lego_usb_tower_init+0x0/0x8b @ 1
usbcore: registered new interface driver legousbtower
legousbtower: v0.96:LEGO USB Tower Driver
initcall lego_usb_tower_init+0x0/0x8b returned 0 after 8982 usecs
calling  usb_sevseg_init+0x0/0x3a @ 1
usbcore: registered new interface driver usbsevseg
initcall usb_sevseg_init+0x0/0x3a returned 0 after 4854 usecs
calling  i8042_init+0x0/0xad @ 1
PNP: No PS/2 controller found. Probing ports directly.
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
initcall i8042_init+0x0/0xad returned 0 after 26526 usecs
calling  serio_raw_init+0x0/0x1b @ 1
initcall serio_raw_init+0x0/0x1b returned 0 after 438 usecs
calling  mousedev_init+0x0/0x8d @ 1
PM: Adding info for No Bus:mice
PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x8d returned 0 after 14489 usecs
calling  atkbd_init+0x0/0x27 @ 1
initcall atkbd_init+0x0/0x27 returned 0 after 302 usecs
calling  lkkbd_init+0x0/0x1b @ 1
initcall lkkbd_init+0x0/0x1b returned 0 after 422 usecs
calling  nkbd_init+0x0/0x1b @ 1
initcall nkbd_init+0x0/0x1b returned 0 after 303 usecs
calling  skbd_init+0x0/0x1b @ 1
initcall skbd_init+0x0/0x1b returned 0 after 321 usecs
calling  bcm5974_init+0x0/0x1b @ 1
usbcore: registered new interface driver bcm5974
initcall bcm5974_init+0x0/0x1b returned 0 after 5215 usecs
calling  sermouse_init+0x0/0x1b @ 1
initcall sermouse_init+0x0/0x1b returned 0 after 328 usecs
calling  kbtab_init+0x0/0x38 @ 1
usbcore: registered new interface driver kbtab
kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
initcall kbtab_init+0x0/0x38 returned 0 after 9099 usecs
calling  fujitsu_init+0x0/0x1b @ 1
initcall fujitsu_init+0x0/0x1b returned 0 after 649 usecs
calling  mk712_init+0x0/0x1ea @ 1
mk712: device not present
initcall mk712_init+0x0/0x1ea returned -19 after 2486 usecs
calling  powermate_init+0x0/0x1b @ 1
usbcore: registered new interface driver powermate
initcall powermate_init+0x0/0x1b returned 0 after 4845 usecs
calling  rotary_encoder_init+0x0/0x12 @ 1
initcall rotary_encoder_init+0x0/0x12 returned 0 after 256 usecs
calling  videodev_init+0x0/0x89 @ 1
Linux video capture interface: v2.00
initcall videodev_init+0x0/0x89 returned 0 after 3608 usecs
calling  w1_init+0x0/0xa9 @ 1
Driver for 1-wire Dallas network protocol.
initcall w1_init+0x0/0xa9 returned 0 after 4728 usecs
calling  matrox_w1_init+0x0/0x1b @ 1
initcall matrox_w1_init+0x0/0x1b returned 0 after 332 usecs
calling  ds_init+0x0/0x3f @ 1
usbcore: registered new interface driver DS9490R
initcall ds_init+0x0/0x3f returned 0 after 4742 usecs
calling  w1_gpio_init+0x0/0x19 @ 1
initcall w1_gpio_init+0x0/0x19 returned -19 after 512 usecs
calling  w1_therm_init+0x0/0x32 @ 1
initcall w1_therm_init+0x0/0x32 returned 0 after 48 usecs
calling  w1_ds2760_init+0x0/0x2c @ 1
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
initcall w1_ds2760_init+0x0/0x2c returned 0 after 7509 usecs
calling  ds2760_battery_init+0x0/0x12 @ 1
initcall ds2760_battery_init+0x0/0x12 returned 0 after 255 usecs
calling  wdtpci_init+0x0/0x1b @ 1
initcall wdtpci_init+0x0/0x1b returned 0 after 305 usecs
calling  advwdt_init+0x0/0x5f @ 1
WDT driver for Advantech single board computer initialising.
PM: Adding info for platform:advantechwdt
PM: Adding info for No Bus:watchdog
advantechwdt: initialized. timeout=60 sec (nowayout=0)
initcall advwdt_init+0x0/0x5f returned 0 after 18542 usecs
calling  sc520_wdt_init+0x0/0xef @ 1
sc520_wdt: cannot register miscdev on minor=130 (err=-16)
initcall sc520_wdt_init+0x0/0xef returned -16 after 5234 usecs
initcall sc520_wdt_init+0x0/0xef returned with error code -16 
calling  it87_wdt_init+0x0/0x4c8 @ 1
IT87 WDT: no device
initcall it87_wdt_init+0x0/0x4c8 returned -19 after 1937 usecs
calling  pc87413_init+0x0/0x91 @ 1
pc87413 WDT: Version 1.1 at io 0x2E
pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
initcall pc87413_init+0x0/0x91 returned -16 after 8598 usecs
initcall pc87413_init+0x0/0x91 returned with error code -16 
calling  sbc60xxwdt_init+0x0/0x185 @ 1
sbc60xxwdt: I/O address 0x0443 already in use
initcall sbc60xxwdt_init+0x0/0x185 returned -5 after 4137 usecs
initcall sbc60xxwdt_init+0x0/0x185 returned with error code -5 
calling  cpu5wdt_init_module+0x0/0x10 @ 1
cpu5wdt: sorry, was my fault
cpu5wdt: misc_register failed
initcall cpu5wdt_init_module+0x0/0x10 returned -16 after 5459 usecs
initcall cpu5wdt_init_module+0x0/0x10 returned with error code -16 
calling  w83977f_wdt_init+0x0/0x149 @ 1
W83977F WDT: W83977F WDT driver, v1.00
W83977F WDT: cannot register miscdev on minor=130 (err=-16)
initcall w83977f_wdt_init+0x0/0x149 returned -16 after 8838 usecs
initcall w83977f_wdt_init+0x0/0x149 returned with error code -16 
calling  bpa10x_init+0x0/0x30 @ 1
Bluetooth: Digianswer Bluetooth USB driver ver 0.10
usbcore: registered new interface driver bpa10x
initcall bpa10x_init+0x0/0x30 returned 0 after 9203 usecs
calling  bfusb_init+0x0/0x54 @ 1
Bluetooth: BlueFRITZ! USB driver ver 1.2
usbcore: registered new interface driver bfusb
initcall bfusb_init+0x0/0x54 returned 0 after 8194 usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 2875 usecs
calling  init_menu+0x0/0x12 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x12 returned 0 after 2685 usecs
calling  i7300_idle_init+0x0/0x17e @ 1
initcall i7300_idle_init+0x0/0x17e returned -19 after 187 usecs
calling  memstick_init+0x0/0x85 @ 1
initcall memstick_init+0x0/0x85 returned 0 after 625 usecs
calling  jmb38x_ms_init+0x0/0x1b @ 1
initcall jmb38x_ms_init+0x0/0x1b returned 0 after 374 usecs
calling  timer_trig_init+0x0/0x12 @ 1
initcall timer_trig_init+0x0/0x12 returned 0 after 61 usecs
calling  ib_core_init+0x0/0x44 @ 1
initcall ib_core_init+0x0/0x44 returned 0 after 241 usecs
calling  ib_mad_init_module+0x0/0xcd @ 1
initcall ib_mad_init_module+0x0/0xcd returned 0 after 27 usecs
calling  ib_sa_init+0x0/0x67 @ 1
initcall ib_sa_init+0x0/0x67 returned 0 after 89 usecs
calling  ib_cm_init+0x0/0x157 @ 1
initcall ib_cm_init+0x0/0x157 returned 0 after 393 usecs
calling  iw_cm_init+0x0/0x35 @ 1
initcall iw_cm_init+0x0/0x35 returned 0 after 89 usecs
calling  ib_umad_init+0x0/0xcb @ 1
initcall ib_umad_init+0x0/0xcb returned 0 after 262 usecs
calling  infinipath_init+0x0/0xc5 @ 1
initcall infinipath_init+0x0/0xc5 returned 0 after 480 usecs
calling  efivars_init+0x0/0x239 @ 1
initcall efivars_init+0x0/0x239 returned -19 after 0 usecs
calling  ibft_init+0x0/0x19b @ 1
No iBFT detected.
initcall ibft_init+0x0/0x19b returned 0 after 1826 usecs
calling  hid_init+0x0/0x66 @ 1
initcall hid_init+0x0/0x66 returned 0 after 653 usecs
calling  usb_kbd_init+0x0/0x38 @ 1
usbcore: registered new interface driver usbkbd
usbkbd: :USB HID Boot Protocol keyboard driver
initcall usb_kbd_init+0x0/0x38 returned 0 after 8905 usecs
calling  usb_mouse_init+0x0/0x38 @ 1
usbcore: registered new interface driver usbmouse
usbmouse: v1.6:USB HID Boot Protocol mouse driver
initcall usb_mouse_init+0x0/0x38 returned 0 after 9289 usecs
calling  init+0x0/0x12 @ 1
initcall init+0x0/0x12 returned 0 after 251 usecs
calling  init_soundcore+0x0/0x95 @ 1
initcall init_soundcore+0x0/0x95 returned 0 after 280 usecs
calling  alsa_sound_init+0x0/0xa4 @ 1
Advanced Linux Sound Architecture Driver Version 1.0.21.
initcall alsa_sound_init+0x0/0xa4 returned 0 after 5344 usecs
calling  alsa_hwdep_init+0x0/0x64 @ 1
initcall alsa_hwdep_init+0x0/0x64 returned 0 after 62 usecs
calling  alsa_timer_init+0x0/0xd7 @ 1
PM: Adding info for No Bus:timer
initcall alsa_timer_init+0x0/0xd7 returned 0 after 3472 usecs
calling  snd_hrtimer_init+0x0/0x108 @ 1
initcall snd_hrtimer_init+0x0/0x108 returned 0 after 26 usecs
calling  alsa_pcm_init+0x0/0x6c @ 1
initcall alsa_pcm_init+0x0/0x6c returned 0 after 43 usecs
calling  snd_mem_init+0x0/0x2c @ 1
initcall snd_mem_init+0x0/0x2c returned 0 after 19 usecs
calling  alsa_rawmidi_init+0x0/0xa4 @ 1
initcall alsa_rawmidi_init+0x0/0xa4 returned 0 after 13 usecs
calling  alsa_mixer_oss_init+0x0/0x3d @ 1
initcall alsa_mixer_oss_init+0x0/0x3d returned 0 after 0 usecs
calling  alsa_opl3_init+0x0/0x8 @ 1
initcall alsa_opl3_init+0x0/0x8 returned 0 after 0 usecs
calling  alsa_mpu401_uart_init+0x0/0x8 @ 1
initcall alsa_mpu401_uart_init+0x0/0x8 returned 0 after 0 usecs
calling  alsa_card_mpu401_init+0x0/0xc1 @ 1
initcall alsa_card_mpu401_init+0x0/0xc1 returned -19 after 1106 usecs
calling  alsa_vx_core_init+0x0/0x8 @ 1
initcall alsa_vx_core_init+0x0/0x8 returned 0 after 0 usecs
calling  alsa_sb_common_init+0x0/0x8 @ 1
initcall alsa_sb_common_init+0x0/0x8 returned 0 after 0 usecs
calling  alsa_card_als4000_init+0x0/0x1b @ 1
initcall alsa_card_als4000_init+0x0/0x1b returned 0 after 402 usecs
calling  alsa_card_atiixp_init+0x0/0x1b @ 1
initcall alsa_card_atiixp_init+0x0/0x1b returned 0 after 371 usecs
calling  alsa_card_atiixp_init+0x0/0x1b @ 1
initcall alsa_card_atiixp_init+0x0/0x1b returned 0 after 371 usecs
calling  alsa_card_azf3328_init+0x0/0x1b @ 1
initcall alsa_card_azf3328_init+0x0/0x1b returned 0 after 432 usecs
calling  alsa_card_cmipci_init+0x0/0x1b @ 1
initcall alsa_card_cmipci_init+0x0/0x1b returned 0 after 367 usecs
calling  alsa_card_cs4281_init+0x0/0x1b @ 1
initcall alsa_card_cs4281_init+0x0/0x1b returned 0 after 375 usecs
calling  alsa_card_es1938_init+0x0/0x1b @ 1
initcall alsa_card_es1938_init+0x0/0x1b returned 0 after 376 usecs
calling  alsa_card_es1968_init+0x0/0x1b @ 1
initcall alsa_card_es1968_init+0x0/0x1b returned 0 after 371 usecs
calling  alsa_card_intel8x0m_init+0x0/0x1b @ 1
initcall alsa_card_intel8x0m_init+0x0/0x1b returned 0 after 368 usecs
calling  alsa_card_rme96_init+0x0/0x1b @ 1
initcall alsa_card_rme96_init+0x0/0x1b returned 0 after 373 usecs
calling  alsa_card_sonicvibes_init+0x0/0x1b @ 1
initcall alsa_card_sonicvibes_init+0x0/0x1b returned 0 after 370 usecs
calling  alsa_ac97_init+0x0/0x8 @ 1
initcall alsa_ac97_init+0x0/0x8 returned 0 after 0 usecs
calling  alsa_card_vortex_init+0x0/0x1b @ 1
initcall alsa_card_vortex_init+0x0/0x1b returned 0 after 382 usecs
calling  alsa_card_vortex_init+0x0/0x1b @ 1
initcall alsa_card_vortex_init+0x0/0x1b returned 0 after 372 usecs
calling  ct_card_init+0x0/0x1b @ 1
initcall ct_card_init+0x0/0x1b returned 0 after 373 usecs
calling  alsa_card_cs46xx_init+0x0/0x1b @ 1
initcall alsa_card_cs46xx_init+0x0/0x1b returned 0 after 374 usecs
calling  mod_init+0x0/0x1b @ 1
initcall mod_init+0x0/0x1b returned 0 after 441 usecs
calling  alsa_card_echo_init+0x0/0x1b @ 1
initcall alsa_card_echo_init+0x0/0x1b returned 0 after 373 usecs
calling  alsa_card_echo_init+0x0/0x1b @ 1
initcall alsa_card_echo_init+0x0/0x1b returned 0 after 371 usecs
calling  alsa_card_echo_init+0x0/0x1b @ 1
initcall alsa_card_echo_init+0x0/0x1b returned 0 after 372 usecs
calling  alsa_card_echo_init+0x0/0x1b @ 1
initcall alsa_card_echo_init+0x0/0x1b returned 0 after 370 usecs
calling  alsa_card_echo_init+0x0/0x1b @ 1
initcall alsa_card_echo_init+0x0/0x1b returned 0 after 375 usecs
calling  alsa_card_emu10k1_init+0x0/0x1b @ 1
initcall alsa_card_emu10k1_init+0x0/0x1b returned 0 after 426 usecs
calling  alsa_card_hifier_init+0x0/0x1b @ 1
initcall alsa_card_hifier_init+0x0/0x1b returned 0 after 379 usecs
calling  alsa_card_riptide_init+0x0/0x1b @ 1
initcall alsa_card_riptide_init+0x0/0x1b returned 0 after 374 usecs
calling  alsa_card_hammerfall_init+0x0/0x1b @ 1
initcall alsa_card_hammerfall_init+0x0/0x1b returned 0 after 373 usecs
calling  alsa_card_hdspm_init+0x0/0x1b @ 1
initcall alsa_card_hdspm_init+0x0/0x1b returned 0 after 372 usecs
calling  alsa_card_vx222_init+0x0/0x1b @ 1
initcall alsa_card_vx222_init+0x0/0x1b returned 0 after 439 usecs
calling  alsa_util_mem_init+0x0/0x8 @ 1
initcall alsa_util_mem_init+0x0/0x8 returned 0 after 0 usecs
calling  alsa_sound_last_init+0x0/0x6f @ 1
ALSA device list:
  No soundcards found.
initcall alsa_sound_last_init+0x0/0x6f returned 0 after 3893 usecs
calling  flow_cache_init+0x0/0x11b @ 1
initcall flow_cache_init+0x0/0x11b returned 0 after 30 usecs
calling  pg_init+0x0/0x10e @ 1
pktgen 2.72: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x10e returned 0 after 5655 usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after 2 usecs
calling  llc2_init+0x0/0xa8 @ 1
NET: Registered protocol family 26
initcall llc2_init+0x0/0xa8 returned 0 after 3268 usecs
calling  snap_init+0x0/0x39 @ 1
initcall snap_init+0x0/0x39 returned 0 after 16 usecs
calling  rif_init+0x0/0x77 @ 1
initcall rif_init+0x0/0x77 returned 0 after 19 usecs
calling  ipip_init+0x0/0x71 @ 1
IPv4 over IPv4 tunneling driver
PM: Adding info for No Bus:tunl0
initcall ipip_init+0x0/0x71 returned 0 after 6683 usecs
calling  ipgre_init+0x0/0xb3 @ 1
GRE over IPv4 tunneling driver
PM: Adding info for No Bus:gre0
initcall ipgre_init+0x0/0xb3 returned 0 after 6513 usecs
calling  init_syncookies+0x0/0x19 @ 1
initcall init_syncookies+0x0/0x19 returned 0 after 32 usecs
calling  ipcomp4_init+0x0/0x66 @ 1
initcall ipcomp4_init+0x0/0x66 returned 0 after 3 usecs
calling  ipip_init+0x0/0x9c @ 1
initcall ipip_init+0x0/0x9c returned 0 after 20 usecs
calling  xfrm4_beet_init+0x0/0x17 @ 1
initcall xfrm4_beet_init+0x0/0x17 returned 0 after 1 usecs
calling  tunnel4_init+0x0/0x66 @ 1
initcall tunnel4_init+0x0/0x66 returned 0 after 1 usecs
calling  tcp_westwood_register+0x0/0x12 @ 1
TCP westwood registered
initcall tcp_westwood_register+0x0/0x12 returned 0 after 2242 usecs
calling  hybla_register+0x0/0x12 @ 1
TCP hybla registered
initcall hybla_register+0x0/0x12 returned 0 after 1996 usecs
calling  tcp_vegas_register+0x0/0x14 @ 1
TCP vegas registered
initcall tcp_vegas_register+0x0/0x14 returned 0 after 1987 usecs
calling  tcp_illinois_register+0x0/0x12 @ 1
TCP illinois registered
initcall tcp_illinois_register+0x0/0x12 returned 0 after 2249 usecs
calling  xfrm_user_init+0x0/0x4a @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x4a returned 0 after 3065 usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 3218 usecs
calling  br_init+0x0/0xad @ 1
initcall br_init+0x0/0xad returned 0 after 48 usecs
calling  ipx_init+0x0/0xf5 @ 1
NET: Registered protocol family 4
initcall ipx_init+0x0/0xf5 returned 0 after 3197 usecs
calling  atalk_init+0x0/0x88 @ 1
NET: Registered protocol family 5
initcall atalk_init+0x0/0x88 returned 0 after 3192 usecs
calling  can_init+0x0/0x120 @ 1
can: controller area network core (rev 20090105 abi 8)
NET: Registered protocol family 29
initcall can_init+0x0/0x120 returned 0 after 8231 usecs
calling  raw_module_init+0x0/0x3d @ 1
can: raw protocol (rev 20090105)
initcall raw_module_init+0x0/0x3d returned 0 after 3026 usecs
calling  bcm_module_init+0x0/0x5b @ 1
can: broadcast manager protocol (rev 20090105 t)
initcall bcm_module_init+0x0/0x5b returned 0 after 4385 usecs
calling  af_rxrpc_init+0x0/0x1a0 @ 1
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x1a0 returned 0 after 3330 usecs
calling  rxkad_init+0x0/0x68 @ 1
RxRPC: Registered security type 2 'rxkad'
initcall rxkad_init+0x0/0x68 returned 0 after 4626 usecs
calling  econet_proto_init+0x0/0x5b @ 1
NET: Registered protocol family 19
initcall econet_proto_init+0x0/0x5b returned 0 after 3316 usecs
calling  phonet_init+0x0/0x78 @ 1
NET: Registered protocol family 35
initcall phonet_init+0x0/0x78 returned 0 after 3279 usecs
calling  pep_register+0x0/0x17 @ 1
initcall pep_register+0x0/0x17 returned 0 after 5 usecs
calling  ieee802154_nl_init+0x0/0x8b @ 1
initcall ieee802154_nl_init+0x0/0x8b returned 0 after 95 usecs
calling  af_ieee802154_init+0x0/0x79 @ 1
NET: Registered protocol family 36
initcall af_ieee802154_init+0x0/0x79 returned 0 after 3200 usecs
calling  wimax_subsys_init+0x0/0x1f3 @ 1
initcall wimax_subsys_init+0x0/0x1f3 returned 0 after 61 usecs
calling  mce_debugfs_init+0x0/0x3c @ 1
initcall mce_debugfs_init+0x0/0x3c returned 0 after 39 usecs
calling  severities_debugfs_init+0x0/0x3c @ 1
initcall severities_debugfs_init+0x0/0x3c returned 0 after 18 usecs
calling  hpet_insert_resource+0x0/0x23 @ 1
initcall hpet_insert_resource+0x0/0x23 returned 1 after 0 usecs
initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
calling  lapic_insert_resource+0x0/0x3f @ 1
initcall lapic_insert_resource+0x0/0x3f returned 0 after 4 usecs
calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 usecs
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x65 @ 1
initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after 24 usecs
calling  init_oops_id+0x0/0x36 @ 1
initcall init_oops_id+0x0/0x36 returned 0 after 5 usecs
calling  disable_boot_consoles+0x0/0x45 @ 1
initcall disable_boot_consoles+0x0/0x45 returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0x61 @ 1
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
initcall pm_qos_power_init+0x0/0x61 returned 0 after 12911 usecs
calling  software_resume+0x0/0x1d8 @ 1
PM: Resume from disk failed.
initcall software_resume+0x0/0x1d8 returned -2 after 2746 usecs
initcall software_resume+0x0/0x1d8 returned with error code -2 
calling  taskstats_init+0x0/0x95 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 2870 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
calling  fail_page_alloc_debugfs+0x0/0xe1 @ 1
initcall fail_page_alloc_debugfs+0x0/0xe1 returned 0 after 177 usecs
calling  max_swapfiles_check+0x0/0x8 @ 1
initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
calling  failslab_debugfs_init+0x0/0x6b @ 1
initcall failslab_debugfs_init+0x0/0x6b returned 0 after 133 usecs
calling  kmemleak_late_init+0x0/0x89 @ 1
kmemleak: Kernel memory leak detector initialized
initcall kmemleak_late_init+0x0/0x89 returned 0 after 4553 usecs
calling  init_ima+0x0/0x1a @ 1
kmemleak: Automatic memory scanning thread started
No TPM chip found, activating TPM-bypass!
initcall init_ima+0x0/0x1a returned 0 after 8469 usecs
calling  fail_make_request_debugfs+0x0/0x19 @ 1
initcall fail_make_request_debugfs+0x0/0x19 returned 0 after 416 usecs
calling  fail_io_timeout_debugfs+0x0/0x19 @ 1
initcall fail_io_timeout_debugfs+0x0/0x19 returned 0 after 258 usecs
calling  random32_reseed+0x0/0x56 @ 1
initcall random32_reseed+0x0/0x56 returned 0 after 7 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 17 usecs
calling  pci_sysfs_init+0x0/0x51 @ 1
initcall pci_sysfs_init+0x0/0x51 returned 0 after 1271 usecs
calling  boot_wait_for_devices+0x0/0x19 @ 1
initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 usecs
calling  regulator_init_complete+0x0/0x140 @ 1
initcall regulator_init_complete+0x0/0x140 returned 0 after 19 usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after 13 usecs
calling  late_resume_init+0x0/0x126 @ 1
  Magic number: 13:700:373
vc vcsa1: hash matches
initcall late_resume_init+0x0/0x126 returned 0 after 4753 usecs
calling  hd_init+0x0/0x302 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x302 returned -1 after 6574 usecs
initcall hd_init+0x0/0x302 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x166 @ 1
initcall scsi_complete_async_scans+0x0/0x166 returned 0 after 0 usecs
calling  edd_init+0x0/0x1c6 @ 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
initcall edd_init+0x0/0x1c6 returned 0 after 5238 usecs
calling  memmap_init+0x0/0xa3 @ 1
initcall memmap_init+0x0/0xa3 returned 0 after 362 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x41 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x41 returned 0 after 9 usecs
calling  init_net_drop_monitor+0x0/0x142 @ 1
Initalizing network drop monitor service
initcall init_net_drop_monitor+0x0/0x142 returned 0 after 3777 usecs
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 2 usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after 5 usecs
async_waiting @ 1
ata1.00: unsupported CDB len
async_waiting @ 827
async_continuing @ 827 after 1 usec
initcall 1_async_port_probe+0x0/0xbb returned 0 after 10219617 usecs
async_continuing @ 828 after 10058431 usec
initcall 2_async_port_probe+0x0/0xbb returned 0 after 10225528 usecs
async_continuing @ 833 after 9899190 usec
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
PM: Adding info for No Bus:target2:0:0
PM: Adding info for scsi:2:0:0:0
PM: Adding info for No Bus:2:0:0:0
PM: Adding info for No Bus:2:0:0:0
calling  5_sd_probe_async+0x0/0x1ef @ 828
sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
PM: Adding info for No Bus:sg0
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
initcall 3_async_port_probe+0x0/0xbb returned 0 after 10241310 usecs
async_continuing @ 834 after 10078387 usec
initcall 4_async_port_probe+0x0/0xbb returned 0 after 10247317 usecs
async_continuing @ 1 after 6861372 usec
async_waiting @ 1
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:sda
 sda: sda1 sda2 sda3 sda4 < sda5 >
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:sda3
PM: Adding info for No Bus:sda4
PM: Adding info for No Bus:sda5
PM: Adding info for No Bus:8:0
sd 2:0:0:0: [sda] Attached SCSI disk
initcall 5_sd_probe_async+0x0/0x1ef returned 0 after 127432 usecs
async_continuing @ 1 after 89734 usec
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
async/2 used greatest stack depth: 4680 bytes left
async/1 used greatest stack depth: 4200 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
async_waiting @ 1
async_continuing @ 1 after 1 usec
debug: unmapping init memory ffffffff81def000..ffffffff81eba000
Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
modprobe used greatest stack depth: 3424 bytes left
BUG: unable to handle kernel NULL pointer dereference at 0000000000000240
IP: [<ffffffff812ed376>] uart_close+0x2a/0x1f9
PGD 79a76067 PUD 79aa9067 PMD 0 
Oops: 0000 [#1] DEBUG_PAGEALLOC
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1110, comm: hwclock Not tainted 2.6.32-rc4 #1 System Product Name
RIP: 0010:[<ffffffff812ed376>]  [<ffffffff812ed376>] uart_close+0x2a/0x1f9
RSP: 0018:ffff880079aafb28  EFLAGS: 00010246
RAX: ffffffff812ed34c RBX: ffff8800799cd000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880079a7cc80 RDI: ffff8800799cd000
RBP: ffff880079aafb68 R08: ffffffff81d2ede0 R09: 0000000000000246
R10: ffff880079a7cc80 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8800799cd000 R14: ffff880079a7cc80 R15: ffff880079a7cc80
FS:  00007f7ce2f906f0(0000) GS:ffffffff81b42000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000240 CR3: 0000000079aad000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hwclock (pid: 1110, threadinfo ffff880079aae000, task ffff88007a6a0000)
Stack:
 00000000ffffffff ffff88007bb88df0 ffff880079aafb68 ffff8800799cd000
<0> 0000000000000000 0000000000000000 ffff880079a7cc80 ffff88007bb88df0
<0> ffff880079aafc48 ffffffff812c772a 0000000000000001 ffffffff81776706
Call Trace:
 [<ffffffff812c772a>] tty_release_dev+0x1ad/0x4c0
 [<ffffffff81776706>] ? mutex_unlock+0xe/0x10
 [<ffffffff81776706>] ? mutex_unlock+0xe/0x10
 [<ffffffff812ecde8>] ? uart_open+0xb1/0x26a
 [<ffffffff812c802d>] __tty_open+0x37b/0x471
 [<ffffffff812c8131>] tty_open+0xe/0x11
 [<ffffffff81117dc8>] chrdev_open+0x18d/0x1ae
 [<ffffffff81117c3b>] ? chrdev_open+0x0/0x1ae
 [<ffffffff811133b8>] __dentry_open+0x1c1/0x333
 [<ffffffff811135f9>] nameidata_to_filp+0x41/0x52
 [<ffffffff81120ce7>] do_filp_open+0x4d5/0x9ae
 [<ffffffff8103ef41>] ? native_sched_clock+0x3b/0x52
 [<ffffffff8103ef02>] ? sched_clock+0x17/0x1b
 [<ffffffff81095043>] ? lock_release_holdtime+0x1c/0x10e
 [<ffffffff81778420>] ? _spin_unlock+0x2b/0x30
 [<ffffffff8112a4b3>] ? alloc_fd+0x112/0x124
 [<ffffffff811130ff>] do_sys_open+0x63/0x10f
 [<ffffffff811131de>] sys_open+0x20/0x22
 [<ffffffff81038dff>] system_call_fastpath+0x16/0x1b
Code: c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 f6 05 62 77 56 01 08 4c 8b a7 28 04 00 00 49 89 fd 49 89 f7 <4d> 8b b4 24 40 02 00 00 74 16 f6 05 4b 77 56 01 40 74 0d 80 3d 
RIP  [<ffffffff812ed376>] uart_close+0x2a/0x1f9
 RSP <ffff880079aafb28>
CR2: 0000000000000240
---[ end trace a9fc1313607e0850 ]---
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
CPA self-test:
 4k 524192 large 0 gb 0 x 262144[ffff880000000000-ffff88003ffff000] miss 0
 4k 524192 large 0 gb 0 x 262144[ffff880000000000-ffff88003ffff000] miss 0
 4k 524192 large 0 gb 0 x 262144[ffff880000000000-ffff88003ffff000] miss 0
ok.
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
Buffer I/O error on device fd0, logical block 0
end_request: I/O error, dev fd0, sector 0
Buffer I/O error on device fd0, logical block 0
EXT3 FS on sda3, internal journal
Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
rc.sysinit used greatest stack depth: 3376 bytes left
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
kmemleak: 11 new suspected memory leaks (see /sys/kernel/debug/kmemleak)


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.32-rc4
# Mon Oct 12 11:20:48 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_EVENT_PROFILE=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
# CONFIG_KVM_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MTRR is not set
CONFIG_EFI=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
# CONFIG_ECONET_NATIVE is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
CONFIG_CFG80211_DEFAULT_PS_VALUE=0
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=y
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_ISL29003=m
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=y
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_SRP=y
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=m
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
CONFIG_SATA_VITESSE=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATP867X=y
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=m
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_NS87415=y
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=m
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=m
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=y
CONFIG_VETH=m
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_ETHOC=m
CONFIG_DNET=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=y
CONFIG_DM9102=m
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_HP100=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_8139CP=m
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=m
CONFIG_SIS900=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=m
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_KS8842=m
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=y
CONFIG_E1000=m
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=m
CONFIG_IGBVF=m
CONFIG_NS83820=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_R8169 is not set
CONFIG_SIS190=m
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=m
CONFIG_ATL1C=y
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
CONFIG_ENIC=y
# CONFIG_IXGBE is not set
CONFIG_IXGB=m
CONFIG_S2IO=m
# CONFIG_VXGE is not set
CONFIG_MYRI10GE=y
# CONFIG_NETXEN_NIC is not set
CONFIG_NIU=m
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
CONFIG_TEHUTI=m
# CONFIG_BNX2X is not set
CONFIG_QLGE=y
# CONFIG_SFC is not set
CONFIG_BE2NET=m
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_3C359 is not set
CONFIG_TMS380TR=y
CONFIG_TMSPCI=y
# CONFIG_ABYSS is not set
CONFIG_WLAN=y
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_HSO=y
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_CDC_PHONET is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_PCMCIA_IBMTR=m
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=m
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
# CONFIG_DSCC4_PCI_RST is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=y
# CONFIG_CYCLADES_SYNC is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=m
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_QT2160=m
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_UCB1400=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_WINBOND_CIR=m
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_LANGWELL is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=m

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_CHARGER_PCF50633=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_UCB1400_CORE=m
CONFIG_TPS65010=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_PCF50633=m
CONFIG_MFD_MC13783=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_AB3100_CORE=m
# CONFIG_AB3100_OTP is not set
# CONFIG_EZX_PCAP is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_AB3100=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN=m
# CONFIG_VIDEO_ZORAN_DC30 is not set
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_HEXIUM_GEMINI=m
# CONFIG_VIDEO_CX88 is not set
CONFIG_VIDEO_CX23885=m
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_SAA7164=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
# CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV is not set
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_ETOMS=m
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_MARS=m
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_OV519 is not set
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_PAC207 is not set
CONFIG_USB_GSPCA_PAC7311=m
# CONFIG_USB_GSPCA_SN9C20X is not set
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
# CONFIG_USB_GSPCA_SPCA561 is not set
CONFIG_USB_GSPCA_SQ905=m
# CONFIG_USB_GSPCA_SQ905C is not set
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_SUNPLUS is not set
CONFIG_USB_GSPCA_T613=m
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_ALSA is not set
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
# CONFIG_USB_ZC0301 is not set
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=m
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
# CONFIG_RADIO_MAESTRO is not set
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
# CONFIG_USB_DSBR is not set
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DVB_BT8XX=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_PLL=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_HGA_ACCEL=y
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
# CONFIG_FB_MB862XX_PCI_GDC is not set
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=y
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
# CONFIG_SND_CS46XX_NEW_DSP is not set
# CONFIG_SND_CS5530 is not set
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=y
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=m
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=y
CONFIG_SND_HIFIER=y
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=y
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=y
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_SSCAPE=m
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=m
# CONFIG_SOUND_MSS is not set
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
# CONFIG_HID_APPLE is not set
# CONFIG_HID_WACOM is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=m
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_AT91 is not set
# CONFIG_MMC_ATMELMCI is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_ALIX2=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_BD2802=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_IPATH=y
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=m
CONFIG_INFINIBAND_CXGB3_DEBUG=y
CONFIG_MLX4_INFINIBAND=m
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_PCF50633=m
# CONFIG_RTC_DRV_AB3100 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_BACKTRACE_SELF_TEST=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_KMEMTRACE is not set
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
# CONFIG_KGDB_SERIAL_CONSOLE is not set
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=m
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y

--RnlQjJ0d97Da+TV1--
