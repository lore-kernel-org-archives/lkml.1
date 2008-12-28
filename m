Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYL1QLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYL1QLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 11:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYL1QLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 11:11:31 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:41749 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbYL1QL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 11:11:29 -0500
Date: Sun, 28 Dec 2008 21:41:19 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081228161119.GA29660@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081227071138.GA4530@linux.vnet.ibm.com> <4955DBBC.4070508@kernel.org> <20081227083758.GA12138@elte.hu> <20081227083936.GA12609@elte.hu> <20081227112125.GB4530@linux.vnet.ibm.com> <20081227112450.GA24150@elte.hu> <20081227115712.GC4530@linux.vnet.ibm.com> <20081227122632.GA18909@elte.hu> <20081227152918.GD4530@linux.vnet.ibm.com> <20081228125510.GA10387@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081228125510.GA10387@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-28 13:55:10]:

> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi Ingo,
> > 
> > 	kernel still crashes, with the updated patch.
> 
> hm, i thought we got all bugs fixed - could you try latest tip/master:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> does it still crash in the same way? (if yes then please attach the new 
> crashlog if it's easy to do)
> 
> Thanks,
> 
> 	Ingo

Hi Ingo/Yinghai,

	I tried today's tip/master against 2.6.28, the kernel still crashes
at boot up.

root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /vmlinuz-autotest root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 c
onsole=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall
_debug earlyprintk=serial,ttyS1,19200 IDENT=1230478484
   [Linux-bzImage, setup=0x3000, size=0x276670]
initrd /initrd-autotest
   [Linux-initrd @ 0x37e5f000, 0x19097f bytes]

Linux version 2.6.28-autotest-tip (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Sun Dec 28 09:27:57 CST 2008
Command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230478484
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
 BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
 BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
DMI 2.3 present.
last_pfn = 0x3ffcd max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-000000003ffcd000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ffcd000 page 4k
kernel direct mapping tables up to 3ffcd000 @ 8000-b000
last_map_addr: 3ffcd000 end: 3ffcd000
RAMDISK: 37e5f000 - 37fef97f
ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
ACPI: FACS 3FFCFCC0, 0040
ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-40000000
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000003ffcd000
  NODE_DATA [0000000000009000 - 000000000000efff]
  bootmap [000000000000f000 -  0000000000016fff] pages 8
(6 early reservations) ==> bootmem [0000000000 - 003ffcd000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000977030]    TEXT DATA BSS ==> [0000200000 - 0000977030]
  #3 [0037e5f000 - 0037fef97f]          RAMDISK ==> [0037e5f000 - 0037fef97f]
  #4 [000009d400 - 0000100000]    BIOS reserved ==> [000009d400 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff88000009d540] 0009d540
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0003ffcd
On node 0 totalpages: 261994
  DMA zone: 64 pages used for memmap
  DMA zone: 2015 pages reserved
  DMA zone: 1918 pages, LIFO batch:0
  DMA32 zone: 4032 pages used for memmap
  DMA32 zone: 253965 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x2208
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 13, version 0, address 0xfec10000, GSI 24-27
ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
IOAPIC[2]: apic_id 12, version 0, address 0xfec20000, GSI 48-51
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228203 base: 0xfecff000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 65536 bytes of per cpu data
per cpu data for cpu0 on node0 at 000000000100e000
per cpu data for cpu1 on node0 at 000000000101e000
per cpu data for cpu2 on node0 at 000000000102e000
per cpu data for cpu3 on node0 at 000000000103e000
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255883
Policy zone: DMA32
Kernel command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230478484
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 1993.984 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Linux version 2.6.28-autotest-tip (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Sun Dec 28 09:27:57 CST 2008
Command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230478484
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
 BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
 BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
DMI 2.3 present.
last_pfn = 0x3ffcd max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-000000003ffcd000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ffcd000 page 4k
kernel direct mapping tables up to 3ffcd000 @ 8000-b000
last_map_addr: 3ffcd000 end: 3ffcd000
RAMDISK: 37e5f000 - 37fef97f
ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
ACPI: FACS 3FFCFCC0, 0040
ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-40000000
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000003ffcd000
  NODE_DATA [0000000000009000 - 000000000000efff]
  bootmap [000000000000f000 -  0000000000016fff] pages 8
(6 early reservations) ==> bootmem [0000000000 - 003ffcd000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000977030]    TEXT DATA BSS ==> [0000200000 - 0000977030]
  #3 [0037e5f000 - 0037fef97f]          RAMDISK ==> [0037e5f000 - 0037fef97f]
  #4 [000009d400 - 0000100000]    BIOS reserved ==> [000009d400 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff88000009d540] 0009d540
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0003ffcd
On node 0 totalpages: 261994
  DMA zone: 64 pages used for memmap
  DMA zone: 2015 pages reserved
  DMA zone: 1918 pages, LIFO batch:0
  DMA32 zone: 4032 pages used for memmap
  DMA32 zone: 253965 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x2208
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 13, version 0, address 0xfec10000, GSI 24-27
ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
IOAPIC[2]: apic_id 12, version 0, address 0xfec20000, GSI 48-51
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228203 base: 0xfecff000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 65536 bytes of per cpu data
per cpu data for cpu0 on node0 at 000000000100e000
per cpu data for cpu1 on node0 at 000000000101e000
per cpu data for cpu2 on node0 at 000000000102e000
per cpu data for cpu3 on node0 at 000000000103e000
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255883
Policy zone: DMA32
Kernel command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230478484
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 1993.984 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console handover: boot [earlyser0] -> real [ttyS1]
Checking aperture...
No AGP bridge found
Node 0: aperture @ dc000000 size 64 MB
Node 1: aperture @ dc000000 size 64 MB
Memory: 1021920k/1048372k available (3245k kernel code, 396k absent, 26056k reserved, 2111k data, 456k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3987.96 BogoMIPS (lpj=7975936)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20080926
Setting APIC routing to flat
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-autotest-tip #1
RIP: 0010:[<ffffffff8021f9a8>]  [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
RSP: 0018:ffff88003f9d7e40  EFLAGS: 00010282
RAX: ffffffff8073c300 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000018 R09: 0000000000000002
R10: 000000000000000f R11: ffffffff8021e8aa R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80855480(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
Stack:
 0000000000000000 0000000000000001 ffffffff8073c300 0000000000000001
 0000000000000001 ffffffff80874282 0000000000000286 0000000000000286
 0000000000010000 0000000000000206 0000000000000002 0000000000000002
Call Trace:
 [<ffffffff80874282>] setup_IO_APIC+0x12f/0x720
 [<ffffffff80525711>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8022221b>] get_apic_id+0x0/0x9
 [<ffffffff8087116f>] native_smp_prepare_cpus+0x256/0x2f1
 [<ffffffff808637ca>] kernel_init+0x50/0x1eb
 [<ffffffff8020ce9a>] child_rip+0xa/0x20
 [<ffffffff8086377a>] kernel_init+0x0/0x1eb
 [<ffffffff8020ce90>] child_rip+0x0/0x20
Code: 48 c7 c7 75 3c 5f 80 31 c0 e8 08 8d 01 00 5b 4c 89 e0 41 5c 41 5d c3 41 55 49 89 fd 89 f7 41 54 41 89 cc 55 89 d5 53 48 83 ec 08 <49> 8b 5d 00 48 85 db 75 36 e8 88 ff ff ff 48 85 c0 75 19 41 5b 
RIP  [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
 RSP <ffff88003f9d7e40>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.28-autotest-tip #1
Call Trace:
 [<ffffffff80237b4d>] panic+0x86/0x144
 [<ffffffff802373f4>] mm_release+0x3f/0xd3
 [<ffffffff802393b2>] exit_fs+0x35/0x46
 [<ffffffff8023a842>] do_exit+0x75/0x787
 [<ffffffff805262ce>] oops_end+0xa8/0xad
 [<ffffffff80527b1d>] do_page_fault+0x756/0x80f
 [<ffffffff805258df>] page_fault+0x1f/0x30
 [<ffffffff8021e8aa>] native_apic_mem_write+0x0/0x9
 [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
 [<ffffffff80874282>] setup_IO_APIC+0x12f/0x720
 [<ffffffff80525711>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff8022221b>] get_apic_id+0x0/0x9
 [<ffffffff8087116f>] native_smp_prepare_cpus+0x256/0x2f1
 [<ffffffff808637ca>] kernel_init+0x50/0x1eb
 [<ffffffff8020ce9a>] child_rip+0xa/0x20
 [<ffffffff8086377a>] kernel_init+0x0/0x1eb
 [<ffffffff8020ce90>] child_rip+0x0/0x20
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
