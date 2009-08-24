Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbZHXJtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbZHXJtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZHXJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:49:30 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36880 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZHXJt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rp/vaaKen4V9zqhaAhGbR8bBEuQNLcese8cdC4rxb3abl0aCZEhG1eE/xZ2sZu17O6
         urkmgeCPMTUvPtZrq9ltpUCFSc1FlBWbynl55zn3BDQiHHUvlO7lWjW85uKuYkoQ/mQL
         QEJo/EYgCOt+mvG1dH+kNuh31WcLbTzZ4jAUM=
MIME-Version: 1.0
Date: Mon, 24 Aug 2009 11:49:28 +0200
Message-ID: <c4e36d110908240249v7e039fa0i837872ffec7b7bfb@mail.gmail.com>
Subject: not syncing: IO-APIC in qemu kvm
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, yaniv@qumranet.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


I've just booted -rc7 kernel  (3edf2fb9d80a46d6c32ba12547a42419845b4b76)
And the first boot give me this error:

[    0.000000] Linux version 2.6.31-rc7-00015-ge740538
(kabi@dhcp-0-185.brq.redhat.com) (gcc version 4.4.1 20090818 (Red Hat
4.4.1-6) (GCC) ) #18 SMP PREEMPT Mon Aug 24 10:56:53 CEST 2009
[    0.000000] Command line: root=/dev/sda1 ro console=ttyS0
console=tty0 selinux=0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1fff0 max_arch_pfn = 0x400000000
[    0.000000] PAT not supported by CPU.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  modified: 000000001fff0000 - 0000000020000000 (ACPI data)
[    0.000000]  modified: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000001fff0000
[    0.000000] ACPI: RSDP 00000000000fbd40 00014 (v00 QEMU  )
[    0.000000] ACPI: RSDT 000000001fff0000 00034 (v01 QEMU   QEMURSDT
00000001 QEMU 00000001)
[    0.000000] ACPI: FACP 000000001fff01b4 00074 (v01 QEMU   QEMUFACP
00000001 QEMU 00000001)
[    0.000000] ACPI: DSDT 000000001fff0280 01DD4 (v01   BXPC   BXDSDT
00000001 INTL 20090123)
[    0.000000] ACPI: FACS 000000001fff0240 00040
[    0.000000] ACPI: SSDT 000000001fff2054 009E3 (v01   BXPC   BXSSDT
00000001 INTL 20090123)
[    0.000000] ACPI: APIC 000000001fff2a38 000EA (v01 QEMU   QEMUAPIC
00000001 QEMU 00000001)
[    0.000000] ACPI: HPET 000000001fff2b90 00038 (v01 QEMU   QEMUHPET
00000001 QEMU 00000001)
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 001fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00022b1c60]    TEXT DATA BSS ==>
[0001000000 - 00022b1c60]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #4 [00022b2000 - 00022b203d]              BRK ==>
[00022b2000 - 00022b203d]
[    0.000000]   #5 [0000008000 - 0000009000]          PGTABLE ==>
[0000008000 - 0000009000]
[    0.000000] found SMP MP-table at [ffff8800000fbc20] fbc20
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001fff0
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
20000000:dffbc000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages at ffff8800022c1000, static
data 1925728 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 129062
[    0.000000] Kernel command line: root=/dev/sda1 ro console=ttyS0
console=tty0 selinux=0
[    0.000000] PID hash table entries: 2048 (order: 11, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 491336k/524224k available (3981k kernel code,
408k absent, 32056k reserved, 2125k data, 2264k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:320
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: HPET/PMTIMER calibration failed.
[    0.000000] Marking TSC unstable due to could not calculate TSC khz
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6207 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.003333] Calibrating delay loop... 4287.64 BogoMIPS (lpj=7143424)
[    0.083333] Security Framework initialized
[    0.086666] SELinux:  Disabled at boot.
[    0.093333] Mount-cache hash table entries: 256
[    0.099999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.103333] CPU: L2 cache: 2048K
[    0.106666] mce: CPU supports 0 MCE banks
[    0.106666] Performance Counters: unsupported p6 CPU model 2 no PMU
driver, software counters only.
[    0.113333] ACPI: Core revision 20090521
[    0.183333] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.186666] ftrace: allocating 14831 entries in 59 pages
[    0.253332] Setting APIC routing to flat
[    0.256666] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.256666] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.256666] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.256666] ..... (found apic 0 pin 2) ...
[    0.256666] ....... failed.
[    0.256666] ...trying to set up timer as Virtual Wire IRQ...
[    0.256666] ..... failed.
[    0.256666] ...trying to set up timer as ExtINT IRQ...
[    0.256666] ..... failed :(.
[    0.256666] Kernel panic - not syncing: IO-APIC + timer doesn't
work!  Boot with apic=debug and send a report.  Then try booting with
the 'noapic' option.
[    0.256666]
[    0.256666] Pid: 1, comm: swapper Not tainted 2.6.31-rc7-00015-ge740538 #18
[    0.256666] Call Trace:
[    0.256666]  [<ffffffff813d7ec0>] panic+0x82/0x138
[    0.256666]  [<ffffffff813dbdc8>] ? _spin_unlock_irqrestore+0x38/0x80
[    0.256666]  [<ffffffff8160fada>] setup_IO_APIC+0x779/0x7da
[    0.256666]  [<ffffffff81025bed>] ? setup_apic_nmi_watchdog+0x4d/0xd0
[    0.256666]  [<ffffffff8160b9f3>] native_smp_prepare_cpus+0x369/0x404
[    0.256666]  [<ffffffff816013ec>] kernel_init+0x56/0x1a7
[    0.256666]  [<ffffffff8100d2da>] child_rip+0xa/0x20
[    0.256666]  [<ffffffff8100cc40>] ? restore_args+0x0/0x30
[    0.256666]  [<ffffffff81601396>] ? kernel_init+0x0/0x1a7
[    0.256666]  [<ffffffff8100d2d0>] ? child_rip+0x0/0x20



I've checked second time with  acpi=debug - and there was not problem.
here shortened log:

[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:320
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: HPET/PMTIMER calibration failed. Using PIT calibration
[    0.000000] Detected 2194.331 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.003333] ... MAX_LOCKDEP_CHAINS:      32768
[    0.003333] ... CHAINHASH_SIZE:          16384
[    0.003333]  memory used by lock dependency info: 6207 kB
[    0.003333]  per task-struct memory footprint: 2688 bytes
[    0.003380] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4390.52 BogoMIPS (lpj=7314436)
[    0.008804] Security Framework initialized
[    0.010032] SELinux:  Disabled at boot.
[    0.013468] Mount-cache hash table entries: 256
[    0.025608] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.028052] CPU: L2 cache: 2048K
[    0.030020] mce: CPU supports 0 MCE banks
[    0.032369] Performance Counters: unsupported p6 CPU model 2 no PMU
driver, software counters only.
[    0.036927] ACPI: Core revision 20090521
[    0.107906] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.110029] ftrace: allocating 14831 entries in 59 pages
[    0.173960] Setting APIC routing to flat
[    0.176709] Getting VERSION: 50014
[    0.178805] Getting VERSION: 50014
[    0.180021] Getting ID: 0
[    0.183354] Getting ID: ff000000
[    0.185376] Getting LVT0: 700
[    0.186682] Getting LVT1: 10000
[    0.188738] enabled ExtINT on CPU#0
[    0.193730] ENABLING IO-APIC IRQs
[    0.200949] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.243006] CPU0: Intel QEMU Virtual CPU version 0.10.91 stepping 03
[    0.246672] Using local APIC timer interrupts.
[    0.246674] calibrating APIC timer ...
[    0.253332] ... lapic delta = 6304581
[    0.253332] ... PM-Timer delta = 361098
[    0.253332] ... PM-Timer result ok
[    0.253332] ..... delta 6304581
[    0.253332] ..... mult: 270797348
[    0.253332] ..... calibration result: 3362443
[    0.253332] ..... CPU clock speed is 2214.0013 MHz.
[    0.253332] ..... host bus clock speed is 1008.2779 MHz.
[    0.290275] lockdep: fixing up alternatives.
[    0.293367] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] masked ExtINT on CPU#1
[    0.003333] Calibrating delay using timer specific routine..
4429.86 BogoMIPS (lpj=7378983)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] mce: CPU supports 0 MCE banks
[    0.407574] CPU1: Intel QEMU Virtual CPU version 0.10.91 stepping 03
[    0.417869] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.419999] Measured 401973 cycles TSC warp between CPUs, turning
off TSC clock.
[    0.419999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.426820] Brought up 2 CPUs
[    0.428751] Total of 2 processors activated (8819.38 BogoMIPS).
[    0.437248] regulator: core version 0.5
[    0.440833] NET: Registered protocol family 16
[    0.447188] ACPI: bus type pci registered
[    0.463426] PCI: Using configuration type 1 for base access
[    0.533991] bio: create slab <bio-0> at 0
[    0.647578] ACPI: Interpreter enabled
[    0.649831] ACPI: (supports S0 S3 S4 S5)
[    0.653373] ACPI: Using IOAPIC for interrupt routing
[    0.786354] ACPI: No dock devices found.
[    0.786939] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.805247] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
[    0.806873] pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
[    1.004642] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.011300] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.020801] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.027396] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.037755] SCSI subsystem initialized
[    1.043735] PCI: Using ACPI for IRQ routing
[    1.408312] DMA-API: preallocated 32768 debug entries
[    1.410002] DMA-API: debugging enabled by kernel config
[    1.413661] ... APIC ID:      00000000 (0)
[    1.416663] ... APIC VERSION: 00050014
[    1.416663] 0000000000000000000000000000000000000000000000000000000000000000
[    1.416663] 0000000000000000000000000000000000000000000000000000000000000000
[    1.416663] 0000000000000000000000000000000000000000000000000000000000008000
[    1.416663]
[    1.416663] ... APIC ID:      01000000 (1)
[    1.416663] ... APIC VERSION: 00050014
[    1.416663] 0000000000000000000000000000000000000000000000000000000000000000
[    1.416663] 0000000000000000000000000000000000000000000000000000000000000000
[    1.416663] 0000000000000000000000000000000000000000000000000000000000008000
[    1.416663]
[    1.459522] testing the IO APIC.......................
[    1.460038]
[    1.464198] .................................... done.
[    1.556895] pnp: PnP ACPI init
[    1.560567] ACPI: bus type pnp registered
[    1.591972] pnp: PnP ACPI: found 7 devices
[    1.593719] ACPI: ACPI bus type pnp unregistered
[    1.622061] NET: Registered protocol family 2


Also next boot without any apic option worked just fine.

Could be the reason for this this locked depth error in my host machine ?

tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
device tap0 entered promiscuous mode
virbr0: topology change detected, propagating
virbr0: port 1(tap0) entering forwarding state
BUG: MAX_LOCK_DEPTH too low!
turning off the locking correctness validator.
Pid: 4419, comm: qemu-kvm Not tainted 2.6.31-rc7-00015-ge740538 #18
Call Trace:
 [<ffffffff8107efb6>] __lock_acquire+0xd66/0x1090
 [<ffffffff8107f37a>] lock_acquire+0x9a/0x180
 [<ffffffff810f34c9>] ? mm_take_all_locks+0x109/0x140
 [<ffffffff813db48c>] _spin_lock_nest_lock+0x4c/0x90
 [<ffffffff810f34c9>] ? mm_take_all_locks+0x109/0x140
 [<ffffffff810f34c9>] mm_take_all_locks+0x109/0x140
 [<ffffffff811002ec>] do_mmu_notifier_register+0x7c/0x1f0
 [<ffffffff81100493>] mmu_notifier_register+0x13/0x20
 [<ffffffffa0376911>] kvm_dev_ioctl+0x1c1/0x340 [kvm]
 [<ffffffff8111bca2>] vfs_ioctl+0x22/0xa0
 [<ffffffff8107d83d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8111be44>] do_vfs_ioctl+0x84/0x590
 [<ffffffff8122a4fb>] ? __up_read+0x8b/0xb0
 [<ffffffff8100cc2d>] ? retint_swapgs+0xe/0x13
 [<ffffffff8111c3d1>] sys_ioctl+0x81/0xa0
 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b
tap0: no IPv6 routers present

Zdenek
