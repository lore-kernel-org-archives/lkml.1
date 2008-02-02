Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbYBBXng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbYBBXng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764072AbYBBXn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:43:26 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:26466 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755937AbYBBXnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:43:25 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 18:43:24 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ae65mxYVJj1m67onYY30EF/ZQlxvGyJ3JlSR7vB39CaGc5WhoajwVxiZ5nn4QfMROcwSlNwiZEesBfT+RU3s2EbBj3m4nlROdsTG9PpJTVw8cZiN5uJA8B2a2inc7u653p/ZCq/qhWdGzRmZ+gRVbMvzxT1/DYZ7bxlh3+7AY5I=;
X-YMail-OSG: V0OcrdAVM1kX5qc98K9AgsIxlPP8Q86cwgryXL_A5GAUxsN9_4JjgEKl2P5F6hn6Wg--
Date: Sat, 2 Feb 2008 23:36:42 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] 2.6.24 refuses to boot - NMI watchdog problem?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <123100.29626.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a 1 GHz Coppermine PC with 512 MB RAM, and it is failing to boot with the nmi_watchdog=1
option. This kernel was rebuilt after doing a "make mrproper". The dmesg log follows:

Linux version 2.6.24 (chris@twopit.underworld) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1
SMP PREEMPT Sat Feb 2 22:21:52 GMT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffeb000 (usable)
 BIOS-e820: 000000001ffeb000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131051
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131051
DMI 2.3 present.
ACPI: RSDP 000F7B40, 0014 (r0 ASUS  )
ACPI: RSDT 1FFEB000, 0030 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: FACP 1FFEB100, 0074 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: DSDT 1FFEB180, 39FA (r1   ASUS TUSL2-C      1000 MSFT  100000B)
ACPI: FACS 1FFFF000, 0040
ACPI: BOOT 1FFEB040, 0028 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: APIC 1FFEB080, 005A (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
Enabling APIC mode:  Logical Cluster.  Using 1 I/O APICs, target cpus f
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130028
Kernel command line: ro root=LABEL=/ nmi_watchdog=1 video=matroxfb:vesa:0x11A
console=ttyS0,115200n8 console=tty0
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0356000 soft=c0352000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1005.043 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513520k/524204k available (1548k kernel code, 10088k reserved, 605k data, 192k init, 0k
highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffeb000   ( 511 MB)
      .init : 0xc031f000 - 0xc034f000   ( 192 kB)
      .data : 0xc02830d2 - 0xc031a7c4   ( 605 kB)
      .text : 0xc0100000 - 0xc02830d2   (1548 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 2011.85 BogoMIPS (lpj=4023702)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 9k freed
ACPI: Core revision 20070126
CPU0: Intel Pentium III (Coppermine) stepping 06
Leaving ESR disabled.
Total of 1 processors activated (2011.85 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 1, comm: swapper Not tainted 2.6.24 #1
 [<c0112a37>] native_smp_call_function_mask+0x43/0x114
 [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
 [<c01049b3>] common_interrupt+0x23/0x28
 [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
 [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
 [<c0113c07>] smp_call_function+0x1c/0x1f
 [<c01244e2>] on_each_cpu+0x28/0x54
 [<c0115eee>] setup_nmi+0x30/0x47
 [<c032a820>] setup_IO_APIC+0x88c/0xe49
 [<c01b2166>] number+0x159/0x22f
 [<c0103078>] __switch_to+0x23/0x133
 [<c0282231>] _spin_unlock_irq+0xe/0x22
 [<c011bd5a>] finish_task_switch+0x1c/0x50
 [<c02807a5>] schedule+0x527/0x541
 [<c02821a6>] _spin_unlock+0xd/0x21
 [<c028083e>] preempt_schedule+0x43/0x54
 [<c0120c92>] vprintk+0x2c1/0x2fc
 [<c020c610>] device_add+0x318/0x541
 [<c0328084>] native_smp_prepare_cpus+0x45f/0x46f
 [<c01e0b07>] acpi_ns_get_device_callback+0xfe/0x11c
 [<c0282087>] _spin_lock+0xd/0x5a
 [<c011a998>] task_rq_lock+0x28/0x4b
 [<c028220f>] _spin_unlock_irqrestore+0xf/0x23
 [<c011c13f>] set_cpus_allowed+0x86/0x8e
 [<c020e0d9>] __driver_attach+0x0/0x7f
 [<c0209860>] serial8250_set_termios+0x2b4/0x2c8
 [<c031f349>] kernel_init+0x0/0x2b2
 [<c031f39b>] kernel_init+0x52/0x2b2
 [<c0282231>] _spin_unlock_irq+0xe/0x22
 [<c011bd5a>] finish_task_switch+0x1c/0x50
 [<c011cced>] schedule_tail+0x17/0x51
 [<c0103ec2>] ret_from_fork+0x6/0x1c
 [<c031f349>] kernel_init+0x0/0x2b2
 [<c031f349>] kernel_init+0x0/0x2b2
 [<c0104bc3>] kernel_thread_helper+0x7/0x10
 =======================
APIC timer registered as dummy, due to nmi_watchdog=1!
Brought up 1 CPUs
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0e30, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
BUG: NMI Watchdog detected LOCKUP on CPU0, eip c0102ad1, registers:
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.24 #1)
EIP: 0060:[<c0102ad1>] EFLAGS: 00000246 CPU: 0
EIP is at default_idle+0x2c/0x3e
EAX: 00000000 EBX: c0102aa5 ECX: 010bb000 EDX: fffedb3c
ESI: 00000000 EDI: c1409284 EBP: 00000004 ESP: c031bfc8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c031b000 task=c02f4320 task.ti=c031b000)
Stack: c010258e c140c000 c034e284 c031f8dc 00000037 c031f0e0 00000000 00009000 
       c033b260 00000002 00099800 c0311000 007a2007 00000000 
Call Trace:
 [<c010258e>] cpu_idle+0x97/0xcc
 [<c031f8dc>] start_kernel+0x2e1/0x2e9
 [<c031f0e0>] unknown_bootoption+0x0/0x195
 =======================
Code: 3d 48 a9 35 c0 00 75 32 80 3d e5 97 31 c0 00 74 29 89 e0 25 00 f0 ff ff 83 60 0c fd f0 83 04
24 00 fa 8b 40 08 a8 04 75 04 fb f4 <eb> 01 fb 89 e0 25 00 f0 ff ff 83 48 0c 02 c3 f3 90 c3 55 57
56 

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

