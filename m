Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYLAKrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYLAKrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYLAKq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:46:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:60086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYLAKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=j28DfANBrCVarBM9Id3fztn4FZ4B4J9gkCDQ3UGkCuZPrR66oz61ytJv5uOAgTcFKq
         XXz+vPkV8Yc27Vf4SDujjs0YEUGyhSaqvaOXVMePu+5DT/aQ2BHlnw+Zbo9lTDpIj6Gt
         Fe6o/2mv5e/HCvK2ycm3AyA08hXlcXj8jvlx8=
Message-ID: <c4e36d110812010246i71f730bbsd789c99b1b81b1ac@mail.gmail.com>
Date: Mon, 1 Dec 2008 11:46:51 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: KVM apic error
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm using qemu & kvm and recently with 2.6.28-rc6 kernel I've got the
error boot message posted bellow.

boot log from qemu guest:


[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00

[    0.000000] Linux version 2.6.28-rc6 (gcc version 4.3.2 20081105
(Red Hat 4.3.2-7) (GCC) ) #89 SMP Fri Nov 28 12:18:37 CET 2008

[    0.000000] Command line: root=/dev/sda1 ro console=ttyS0
console=tty0 selinux=off

[    0.000000] KERNEL supported cpus:

[    0.000000]   Intel GenuineIntel

[    0.000000]   AMD AuthenticAMD

[    0.000000]   Centaur CentaurHauls

[    0.000000] PAT WC disabled due to known CPU erratum.

[    0.000000] BIOS-provided physical RAM map:

[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)

[    0.000000]  BIOS-e820: 0000000000100000 - 0000000013ff0000 (usable)

[    0.000000]  BIOS-e820: 0000000013ff0000 - 0000000014000000 (ACPI data)

[    0.000000]  BIOS-e820: 00000000fffbd000 - 0000000100000000 (reserved)

[    0.000000] DMI 2.4 present.

[    0.000000] last_pfn = 0x13ff0 max_arch_pfn = 0x3ffffffff

[    0.000000] Scanning 2 areas for low memory corruption

[    0.000000] modified physical RAM map:

[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)

[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)

[    0.000000]  modified: 0000000000006000 - 0000000000008000 (usable)

[    0.000000]  modified: 0000000000008000 - 0000000000010000 (reserved)

[    0.000000]  modified: 0000000000010000 - 0000000000092c00 (usable)

[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)

[    0.000000]  modified: 00000000000e8000 - 0000000000100000 (reserved)

[    0.000000]  modified: 0000000000100000 - 0000000013ff0000 (usable)

[    0.000000]  modified: 0000000013ff0000 - 0000000014000000 (ACPI data)

[    0.000000]  modified: 00000000fffbd000 - 0000000100000000 (reserved)

[    0.000000] init_memory_mapping: 0000000000000000-0000000013ff0000

[    0.000000] last_map_addr: 13ff0000 end: 13ff0000

[    0.000000] ACPI: RSDP 000FB9F0, 0014 (r0 QEMU  )

[    0.000000] ACPI: RSDT 13FF0000, 002C (r1 QEMU   QEMURSDT        1
QEMU        1)

[    0.000000] ACPI: FACP 13FF002C, 0074 (r1 QEMU   QEMUFACP        1
QEMU        1)

[    0.000000] ACPI: DSDT 13FF0100, 253C (r1   BXPC   BXDSDT        1
INTL 20061109)

[    0.000000] ACPI: FACS 13FF00C0, 0040

[    0.000000] ACPI: APIC 13FF2640, 00E0 (r1 QEMU   QEMUAPIC        1
QEMU        1)

[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 0013ff0000]

[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]

[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]

[    0.000000]   #2 [0000200000 - 00010bdbd8]    TEXT DATA BSS ==>
[0000200000 - 00010bdbd8]

[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]

[    0.000000]   #4 [0000010000 - 0000011000]          PGTABLE ==>
[0000010000 - 0000011000]

[    0.000000] found SMP MP-table at [ffff8800000fb8b0] 000fb8b0

[    0.000000] Zone PFN ranges:

[    0.000000]   DMA      0x00000000 -> 0x00001000

[    0.000000]   DMA32    0x00001000 -> 0x00100000

[    0.000000]   Normal   0x00100000 -> 0x00100000

[    0.000000] Movable zone start PFN for each node

[    0.000000] early_node_map[4] active PFN ranges

[    0.000000]     0: 0x00000000 -> 0x00000001

[    0.000000]     0: 0x00000006 -> 0x00000008

[    0.000000]     0: 0x00000010 -> 0x00000092

[    0.000000]     0: 0x00000100 -> 0x00013ff0

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

[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)

[    0.000000] Using ACPI (MADT) for SMP configuration information

[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs

[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000

[    0.000000] PM: Registered nosave memory: 0000000000008000 - 0000000000010000

[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000

[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000

[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000

[    0.000000] Allocating PCI resources starting at 20000000 (gap:
14000000:ebfbd000)

[    0.000000] PERCPU: Allocating 1622016 bytes of per cpu data

[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 79759

[    0.000000] Kernel command line: root=/dev/sda1 ro console=ttyS0
console=tty0 selinux=off

[    0.000000] Initializing CPU#0

[    0.000000] PID hash table entries: 2048 (order: 11, 16384 bytes)

[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops

[    0.000000] Detected 2194.535 MHz processor.

[    0.003333] Console: colour VGA+ 80x25

[    0.003333] console [tty0] enabled

[    0.003333] console [ttyS0] enabled

[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar

[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8

[    0.003333] ... MAX_LOCK_DEPTH:          48

[    0.003333] ... MAX_LOCKDEP_KEYS:        8191

[    0.003333] ... CLASSHASH_SIZE:           4096

[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192

[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384

[    0.003333] ... CHAINHASH_SIZE:          8192

[    0.003333]  memory used by lock dependency info: 4095 kB

[    0.003333]  per task-struct memory footprint: 2688 bytes

[    0.003333] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)

[    0.003333] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)

[    0.003333] Scanning for low memory corruption every 60 seconds

[    0.003333] Checking aperture...

[    0.003333] No AGP bridge found

[    0.003333] Memory: 294220k/327616k available (3282k kernel code,
492k absent, 32560k reserved, 1770k data, 1944k init)

[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1

[    0.003359] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4390.94 BogoMIPS (lpj=7315116)

[    0.006784] Security Framework initialized

[    0.008717] SELinux:  Initializing.

[    0.010166] Mount-cache hash table entries: 256

[    0.014844] CPU: L1 I cache: 32K, L1 D cache: 32K

[    0.016675] CPU: L2 cache: 2048K

[    0.018326] ACPI: Core revision 20080926

[    0.022674] Setting APIC routing to flat

[    0.025335] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1

[    0.026665] ..MP-BIOS bug: 8254 timer not connected to IO-APIC

[    0.026665] ...trying to set up timer (IRQ0) through the 8259A ...

[    0.026665] ..... (found apic 0 pin 0) ...

[    0.026665] ....... failed.

[    0.026665] ...trying to set up timer as Virtual Wire IRQ...

[    0.026665] ..... failed.

[    0.026665] ...trying to set up timer as ExtINT IRQ...

[    0.026665] ..... failed :(.

[    0.026665] Kernel panic - not syncing: IO-APIC + timer doesn't
work!  Boot with apic=debug and send a report.  Then try booting with
the 'noapic' option.

[    0.026665]

[    0.026665] ------------[ cut here ]------------

[    0.026665] WARNING: at kernel/smp.c:333 smp_call_function_mask+0x22a/0x230()

[    0.026665] Modules linked in:

[    0.026665] Pid: 1, comm: swapper Not tainted 2.6.28-rc6 #89

[    0.026665] Call Trace:

[    0.026665]  [<ffffffff802446ef>] warn_on_slowpath+0x5f/0x90

[    0.026665]  [<ffffffff8026b75f>] ? save_trace+0x3f/0xb0

[    0.026665]  [<ffffffff8026d732>] ? mark_lock+0x132/0x7f0

[    0.026665]  [<ffffffff80213853>] ? native_sched_clock+0x13/0x60

[    0.026665]  [<ffffffff80275e5a>] smp_call_function_mask+0x22a/0x230

[    0.026665]  [<ffffffff80221420>] ? stop_this_cpu+0x0/0x30

[    0.026665]  [<ffffffff8026a51d>] ? trace_hardirqs_off+0xd/0x10

[    0.026665]  [<ffffffff8052a948>] ? __mutex_unlock_slowpath+0x128/0x170

[    0.026665]  [<ffffffff8052a999>] ? mutex_unlock+0x9/0x10

[    0.026665]  [<ffffffff80281fa4>] ? crash_kexec+0x74/0x100

[    0.026665]  [<ffffffff80275e7b>] smp_call_function+0x1b/0x20

[    0.026665]  [<ffffffff80221480>] native_smp_send_stop+0x30/0x70

[    0.026665]  [<ffffffff80528e9f>] panic+0x84/0x13d

[    0.026665]  [<ffffffff80722c8d>] setup_IO_APIC+0x60e/0x801

[    0.026665]  [<ffffffff802233a4>] ? clear_IO_APIC_pin+0x94/0xa0

[    0.026665]  [<ffffffff8071ec77>] native_smp_prepare_cpus+0x2fd/0x344

[    0.026665]  [<ffffffff8071059f>] kernel_init+0x52/0x194

[    0.026665]  [<ffffffff8052c5e6>] ? trace_hardirqs_on_thunk+0x3a/0x3f

[    0.026665]  [<ffffffff8020d719>] child_rip+0xa/0x11

[    0.026665]  [<ffffffff8020cc34>] ? restore_args+0x0/0x30

[    0.026665]  [<ffffffff8071054d>] ? kernel_init+0x0/0x194

[    0.026665]  [<ffffffff8020d70f>] ? child_rip+0x0/0x11

[    0.026665] ---[ end trace 4eaa2a86a8e2da22 ]---




My hosting machine was logging this message in the same time of the
qemu startup:

Unsupported delivery mode 7

-----

And here is the regular startup of my qemu guest:

Also note this warning message:

ACPI Warning (nspredef-0852): \_PR_.CPU2._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]

this message is kind of 'new' - but qemu seems to  be working.


BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc6 (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7)
(GCC) ) #89 SMP Fri Nov 28 12:18:37 CET 2008
Command line: root=/dev/sda1 ro console=ttyS0 console=tty0 selinux=off
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000013ff0000 (usable)
 BIOS-e820: 0000000013ff0000 - 0000000014000000 (ACPI data)
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x13ff0 max_arch_pfn = 0x3ffffffff
Scanning 2 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000001000 (usable)
 modified: 0000000000001000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 0000000000008000 (usable)
 modified: 0000000000008000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 0000000000092c00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e8000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 0000000013ff0000 (usable)
 modified: 0000000013ff0000 - 0000000014000000 (ACPI data)
 modified: 00000000fffbc000 - 0000000100000000 (reserved)
init_memory_mapping: 0000000000000000-0000000013ff0000
last_map_addr: 13ff0000 end: 13ff0000
ACPI: RSDP 000FBCA0, 0014 (r0 QEMU  )
ACPI: RSDT 13FF0000, 002C (r1 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 13FF002C, 0074 (r1 QEMU   QEMUFACP        1 QEMU        1)
ACPI: DSDT 13FF0100, 24A4 (r1   BXPC   BXDSDT        1 INTL 20061109)
ACPI: FACS 13FF00C0, 0040
ACPI: APIC 13FF25A8, 00E0 (r1 QEMU   QEMUAPIC        1 QEMU        1)
(5 early reservations) ==> bootmem [0000000000 - 0013ff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00010bdbd8]    TEXT DATA BSS ==> [0000200000 - 00010bdbd8]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
found SMP MP-table at [ffff8800000fbb60] 000fbb60
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x00000001
    0: 0x00000006 -> 0x00000008
    0: 0x00000010 -> 0x00000092
    0: 0x00000100 -> 0x00013ff0
ACPI: PM-Timer IO Port: 0xb008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PM: Registered nosave memory: 0000000000001000 - 0000000000006000
PM: Registered nosave memory: 0000000000008000 - 0000000000010000
PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 20000000 (gap: 14000000:ebfbc000)
PERCPU: Allocating 1622016 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 79759
Kernel command line: root=/dev/sda1 ro console=ttyS0 console=tty0 selinux=off
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
TSC: Unable to calibrate against PIT
TSC: using PMTIMER reference calibration
Detected 2194.306 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4095 kB
 per task-struct memory footprint: 2688 bytes
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Scanning for low memory corruption every 60 seconds
Checking aperture...
No AGP bridge found
Memory: 294220k/327616k available (3282k kernel code, 492k absent,
32560k reserved, 1770k data, 1944k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4390.47 BogoMIPS (lpj=7314353)
Security Framework initialized
SELinux:  Initializing.
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4390.29 BogoMIPS (lpj=7314075)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU1: Intel QEMU Virtual CPU version 0.9.1 stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 14505823816 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (8780.76 BogoMIPS).
khelper used greatest stack depth: 5680 bytes left
net_namespace: 1472 bytes
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD GART found.
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 7 devices
ACPI: ACPI bus type pnp unregistered
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
audit: initializing netlink socket (disabled)
type=2000 audit(1227884380.503:1): initialized
msgmni has been set to 575
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
processor ACPI_CPU:00: registered as cooling_device0
ACPI Warning (nspredef-0852): \_PR_.CPU1._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
processor ACPI_CPU:01: registered as cooling_device1
ACPI Warning (nspredef-0852): \_PR_.CPU2._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU3._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU4._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU5._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU6._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU7._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU8._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPU9._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPUA._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPUB._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPUC._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPUD._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
ACPI Warning (nspredef-0852): \_PR_.CPUE._MAT: Return type mismatch -
found Integer, expected Buffer [20080926]
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Driver 'sd' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
ata1.00: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100
ata1.00: 4194304 sectors, multi 16: LBA48
ata1.01: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100
ata1.01: 16777216 sectors, multi 16: LBA48
ata1.00: configured for MWDMA2
ata1.01: configured for MWDMA2
ata2.00: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100
ata2.00: 1433600 sectors, multi 16: LBA48
ata2.00: configured for MWDMA2
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 4194304 512-byte hardware sectors: (2.14 GB/2.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 4194304 512-byte hardware sectors: (2.14 GB/2.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
sd 0:0:1:0: [sdb] 16777216 512-byte hardware sectors: (8.58 GB/8.00 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:1:0: [sdb] 16777216 512-byte hardware sectors: (8.58 GB/8.00 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: unknown partition table
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:1:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
sd 1:0:0:0: [sdc] 1433600 512-byte hardware sectors: (734 MB/700 MiB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdc] 1433600 512-byte hardware sectors: (734 MB/700 MiB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4
sd 1:0:0:0: [sdc] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg2 type 0
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
Fusion MPT misc device (ioctl) driver 3.04.07
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
registered taskstats version 1
Clocksource tsc unstable (delta = 4391265055203 ns)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 1944k freed
khelper used greatest stack depth: 5232 bytes left
stty used greatest stack depth: 4376 bytes left
mount used greatest stack depth: 3696 bytes left
FDC 0 is a S82078B
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, high) -> IRQ 11
eth0: RTL-8139C+ at 0xffffc20000318000, 00:16:3e:45:0c:98, IRQ 11
input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input1
modprobe used greatest stack depth: 3320 bytes left
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 10 (level,
high) -> IRQ 10
piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button (FF) [PWRF]
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:01.2: PCI INT D -> Link[LNKD] -> GSI 10 (level, high) -> IRQ 10
uhci_hcd 0000:00:01.2: UHCI Host Controller
uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:01.2: irq 10, io base 0x0000c020
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc6 uhci_hcd
usb usb1: SerialNumber: 0000:00:01.2
rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
EXT3 FS on sda1, internal journal
loop: module loaded
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
NET: Registered protocol family 10
RPC: Registered udp transport module.
RPC: Registered tcp transport module.

-------

Any idea what could be the reason for this problem?

My host machine is T61, C2D, 2GB, x86_64,  kernel 2.6.28-rc6 - same
kernel runs guest.

Zdenek
