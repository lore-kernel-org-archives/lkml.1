Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbXCFMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbXCFMqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933868AbXCFMqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:46:17 -0500
Received: from www.osadl.org ([213.239.205.134]:39660 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933259AbXCFMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:46:15 -0500
Subject: Re: 2.6.21-rc2-mm2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Con Kolivas <kernel@kolivas.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <200703062258.19940.kernel@kolivas.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	 <200703062258.19940.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 13:52:17 +0100
Message-Id: <1173185537.24738.323.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 22:58 +1100, Con Kolivas wrote:
> (tglx cc'ed as he may know something about this - sorry if it's inappropriate)

John cc'ed as well :)

> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.
> >6.20-rc2-mm2/
> 
> qemu doesn't like it with the config from my core2duo (attached below).
> 
> qemu-system-x86_64 -kernel  
> arch/x86_64/boot/bzImage -hda ../temp/linux-0.2.img -append 
> root=/dev/hda -smp 2 -nographic -serial stdio -append console=ttyS0
> 
> Could not configure '/dev/rtc' to have a 1024 Hz timer. This is not a fatal
> error, but for better emulation accuracy either use a 2.6 host Linux kernel or
> type 'echo 1024 > /proc/sys/dev/rtc/max-user-freq' as root.
> (qemu) Linux version 2.6.21-rc2-mm2 (con@duo.kolivas.org) (gcc version 4.1.2 
> 20061115 (prerelease) (Debian 4.1.1-21)) #2 SMP PREEMPT Tue Mar 6 22:42:56 
> EST 2007
> Command line: console=ttyS0
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
>  BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
>  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> end_pfn_map = 1048576
> DMI not present or invalid.
> ACPI: RSDP 000FA6D0, 0014 (r0 QEMU  )
> ACPI: RSDT 07FF0000, 002C (r0 QEMU   QEMURSDT        1 QEMU        1)
> ACPI: FACP 07FF002C, 0074 (r0 QEMU   QEMUFACP        1 QEMU        1)
> ACPI: DSDT 07FF0100, 0832 (r1   BXPC   BXDSDT        1 INTL 20060912)
> ACPI: FACS 07FF00C0, 0040
> ACPI: APIC 07FF0938, 0048 (r0 QEMU   QEMUAPIC        1 QEMU        1)
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0:        0 ->      159
>     0:      256 ->    32752
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Processor #1
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
> Setting APIC routing to flat
> Using ACPI (MADT) for SMP configuration information
> Nosave address range: 000000000009f000 - 00000000000a0000
> Nosave address range: 00000000000a0000 - 00000000000e8000
> Nosave address range: 00000000000e8000 - 0000000000100000
> Allocating PCI resources starting at 10000000 (gap: 8000000:f7fc0000)
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 33792 bytes of per cpu data
> Built 1 zonelists.  Total pages: 31110
> Kernel command line: console=ttyS0
> Initializing CPU#0
> PID hash table entries: 512 (order: 9, 4096 bytes)
> Marking TSC unstable due to TSCs unsynchronized
> time.c: Detected 2461.549 MHz processor.
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
> Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
> Checking aperture...
> Memory: 123928k/131008k available (2332k kernel code, 6532k reserved, 1359k 
> data, 216k init)
> Calibrating delay using timer specific routine.. 5715.81 BogoMIPS 
> (lpj=2857906)
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> SMP alternatives: switching to UP code
> ACPI: Core revision 20070126
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> do_IRQ: 0.48 No irq handler for vector
> Using local APIC timer interrupts.
> result 62504298
> Detected 62.504 MHz APIC timer.
> SMP alternatives: switching to SMP code
> Booting processor 1/2 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 11970.64 BogoMIPS 
> (lpj=5985322)

Hmm, CPU#1 has ~ double speed of CPU#0

> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> QEMU Virtual CPU version 0.9.0 stepping 03
> Brought up 2 CPUs
> migration_cost=1939
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: Using configuration type 1
> ACPI: Interpreter enabled
> ACPI: (supports S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> 0000:00:01.1: cannot adjust BAR0 (not I/O)
> 0000:00:01.1: cannot adjust BAR1 (not I/O)
> 0000:00:01.1: cannot adjust BAR2 (not I/O)
> 0000:00:01.1: cannot adjust BAR3 (not I/O)
> PCI quirk: region b000-b03f claimed by PIIX4 ACPI
> PCI quirk: region b100-b10f claimed by PIIX4 SMB
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 6 devices
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> PCI-GART: No AMD northbridge found.
> Unable to handle kernel NULL pointer dereference at 0000000000000830 RIP:
>  [<ffffffff8018401c>] do_timer+0x301/0x419
> PGD 0
> Oops: 0000 [1] PREEMPT SMP
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.21-rc2-mm2 #2
> RIP: 0010:[<ffffffff8018401c>]  [<ffffffff8018401c>] do_timer+0x301/0x419
> RSP: 0000:ffffffff804efda8  EFLAGS: 00000097
> RAX: 0000000045ed53ec RBX: 0000000000000800 RCX: 0000000000000008
> RDX: 000000000f41a777 RSI: 00000000000f4240 RDI: ffffffff8046c1c0
> RBP: 000000032d8863b3 R08: 0000000000000004 R09: ffffffff804e7700
> R10: ffff810080cdffc0 R11: 7fffffffffffffff R12: ffffffff8046c3c0
> R13: 0000000000000000 R14: 0000000000000001 R15: ffffffffffffffff
> FS:  0000000000000000(0000) GS:ffffffff8049c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000830 CR3: 0000000000101000 CR4: 00000000000006e0
> Process swapper (pid: 1, threadinfo ffff810001450000, task ffff81000144f420)
> Stack:  ffffffff804efef4 0000000000000001 ffffffff804efee8 ffffffff80465e20
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  ffff810002602288 ffffffff801638fc 0000000000000080 0000000000000100
> Call Trace:
>  <IRQ>  [<ffffffff801638fc>] main_timer_handler+0x24/0x1de
>  [<ffffffff80163ac8>] timer_interrupt+0x12/0x27
>  [<ffffffff801104c5>] handle_IRQ_event+0x25/0x53
>  [<ffffffff8019965c>] handle_edge_irq+0xe5/0x129
>  [<ffffffff80162b4e>] do_IRQ+0x6c/0xd3
>  [<ffffffff8017be24>] run_rebalance_domains+0x13d/0x3fd
>  [<ffffffff80156e31>] ret_from_intr+0x0/0xa
>  [<ffffffff80111839>] __do_softirq+0x3b/0x93
>  [<ffffffff80157adc>] call_softirq+0x1c/0x28
>  [<ffffffff80162a91>] do_softirq+0x2c/0x7d
>  [<ffffffff80180fe0>] irq_exit+0x3f/0x50
>  [<ffffffff8016c48b>] smp_apic_timer_interrupt+0x49/0x5c
>  [<ffffffff80160d16>] default_idle+0x0/0x3d
>  [<ffffffff80157586>] apic_timer_interrupt+0x66/0x70
>  <EOI>  [<ffffffff8010d03b>] permission+0x4e/0xb3
>  [<ffffffff80132d52>] __lookup_hash+0x28/0x126
>  [<ffffffff801b4246>] lookup_one_len_nd+0x62/0x70
>  [<ffffffff801d63f5>] create_dir+0x46/0x1e3
>  [<ffffffff801d65e9>] sysfs_create_dir+0x57/0x75
>  [<ffffffff80220201>] kobject_shadow_add+0xe9/0x19d
>  [<ffffffff802203e9>] kobject_register+0x20/0x39
>  [<ffffffff8028d4dc>] bus_add_driver+0x59/0x19a
>  [<ffffffff804b55fd>] init+0x142/0x23f
>  [<ffffffff8015b1e0>] preempt_schedule+0x4f/0x7f
>  [<ffffffff80125438>] schedule_tail+0x38/0x98
>  [<ffffffff80157768>] child_rip+0xa/0x12
>  [<ffffffff8024493d>] acpi_ds_init_one_object+0x0/0x7c
>  [<ffffffff804b54bb>] init+0x0/0x23f
>  [<ffffffff8015775e>] child_rip+0x0/0x12
> 
> 
> Code: 8b 53 30 48 c7 c7 5c e6 3f 80 8b 4b 34 48 89 6b 48 48 c7 43
> RIP  [<ffffffff8018401c>] do_timer+0x301/0x419
>  RSP <ffffffff804efda8>
> CR2: 0000000000000830
> Kernel panic - not syncing: Aiee, killing interrupt handler!
> Terminated
> 
> ---
> 
> list *do_timer+0x301
> 0xffffffff8018401c is in do_timer 
> (/home/con/kernel/linux-2.6.21-rc2-mm2/include/linux/clocksource.h:186).
> 181             u64 tmp;
> 182
> 183             /* XXX - All of this could use a whole lot of optimization */
> 184             tmp = length_nsec;
> 185             tmp <<= c->shift;
> 186             tmp += c->mult/2;
> 187             do_div(tmp, c->mult);
> 188
> 189             c->cycle_interval = (cycle_t)tmp;
> 190             if (c->cycle_interval == 0)

That's extremly strange. This is inside of
clocksource_calculate_interval() in:

static void change_clocksource(void)
{
        struct clocksource *new;
        cycle_t now;
        u64 nsec;

        new = clocksource_get_next();

        if (clock == new)
                return;

        now = clocksource_read(new);
        nsec =  __get_nsec_offset();
        timespec_add_ns(&xtime, nsec);

        clock = new;
        clock->cycle_last = now;

        clock->error = 0;
        clock->xtime_nsec = 0;
	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);

        tick_clock_notify();

        printk(KERN_INFO "Time: %s clocksource has been installed.\n",
               clock->name);
}

So clock seems to be NULL, but was accessed before
clocksource_calculate_interval() as well.

	tglx




