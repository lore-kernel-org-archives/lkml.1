Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbYBGT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbYBGT6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYBGT6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:58:14 -0500
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18]:40178 "HELO
	web52908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753042AbYBGT6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:58:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=LQABf2WiSp+onLaJymGRzkUjHESYnrGybPYfVithiqmGc3/PvLXDWpTr4HeDU+VPAUoZTVe05ayxWpCcTEl/6pbU8joHpzJNQRbQ4C/K/EO70GJ6I3Rvm+USS/kQVgWHwjj/baIcuiHYDmu8UyW3+JxQ6igN+LDMX5cycZrLn00=;
X-YMail-OSG: ARkfujYVM1mYfpvkDaIbiqmKT6Yzz_uj65VEwsJm_xHLSAqM6L42K_X8djdicdoe7tOB17ASua6U5q2T87f8b8ppI65YWeVy1DQMMIrftI_qP5kX8IBzLIM4jNaQMOPn
Date: Thu, 7 Feb 2008 19:58:10 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] 2.6.24 refuses to boot - NMI watchdog problem?
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080206103252.d1eb300d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <50817.2630.qm@web52908.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> It isn't clear (to me) where in this mess we disabled interrupts around the
> set_cpus_allowed().  Chris, if this is repeatable it would be helpful to
> set CONFIG_FRAME_POINTER=y which hopefully will get us a cleaner trace,

Here you go,

Cheers,
Chris

Linux version 2.6.24 (chris@twopit.underworld) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1
SMP PREEMPT Thu Feb 7 00:01:40 GMT 2008
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
CPU 0 irqstacks, hard=c035f000 soft=c035b000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1005.086 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513484k/524204k available (1577k kernel code, 10128k reserved, 608k data, 196k init, 0k
highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffeb000   ( 511 MB)
      .init : 0xc0327000 - 0xc0358000   ( 196 kB)
      .data : 0xc028a722 - 0xc03227c4   ( 608 kB)
      .text : 0xc0100000 - 0xc028a722   (1577 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 2011.89 BogoMIPS (lpj=4023782)
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
Total of 1 processors activated (2011.89 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 1, comm: swapper Not tainted 2.6.24 #1
 [<c0105020>] show_trace_log_lvl+0x1a/0x2f
 [<c0105990>] show_trace+0x12/0x14
 [<c010613d>] dump_stack+0x6c/0x72
 [<c0113ab5>] native_smp_call_function_mask+0x44/0x102
 [<c0114cc5>] smp_call_function+0x1e/0x22
 [<c0125bb0>] on_each_cpu+0x2a/0x57
 [<c01170f2>] setup_nmi+0x33/0x4a
 [<c0332a22>] setup_IO_APIC+0x929/0xf11
 [<c0330178>] native_smp_prepare_cpus+0x487/0x497
 [<c03273de>] kernel_init+0x54/0x2c3
 [<c0104c83>] kernel_thread_helper+0x7/0x10
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
BUG: NMI Watchdog detected LOCKUP on CPU0, eip c0102b07, registers:
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.24 #1)
EIP: 0060:[<c0102b07>] EFLAGS: 00000246 CPU: 0
EIP is at default_idle+0x2f/0x43
EAX: 00000000 EBX: c0102ad8 ECX: 010b2000 EDX: fffedb3c
ESI: 00000000 EDI: c1409284 EBP: c0323fb4 ESP: c0323fb4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c0323000 task=c02fc320 task.ti=c0323000)
Stack: c0323fc4 c01025af c140c000 c0357284 c0323fcc c0287305 c0323ff8 c032792f 
       00000037 c0327108 00000000 00000004 00009000 c0343b00 00000002 00099800 
       c0319000 007ab007 00000000 
Call Trace:
 [<c0105020>] show_trace_log_lvl+0x1a/0x2f
 [<c01050d2>] show_stack_log_lvl+0x9d/0xa5
 [<c010517d>] show_registers+0xa3/0x1df
 [<c0105ba7>] die_nmi+0x81/0xd2
 [<c0115d72>] nmi_watchdog_tick+0xd5/0x12a
 [<c0105f19>] do_nmi+0x93/0x24b
 [<c0289adb>] nmi_stack_correct+0x26/0x2b
 [<c01025af>] cpu_idle+0x9a/0xcf
 [<c0287305>] rest_init+0x5d/0x5f
 [<c032792f>] start_kernel+0x2e2/0x2ea
 [<00000000>] _stext+0x3feff000/0x19
 =======================
Code: 36 c0 00 55 89 e5 75 33 80 3d e5 17 32 c0 00 74 2a 89 e0 25 00 f0 ff ff 83 60 0c fd f0 83 04
24 00 fa 8b 40 08 a8 04 75 04 fb f4 <eb> 01 fb 89 e0 25 00 f0 ff ff 83 48 0c 02 eb 02 f3 90 5d c3
55 


      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com
