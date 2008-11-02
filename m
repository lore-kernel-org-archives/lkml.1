Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYKBUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYKBUsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYKBUsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:48:15 -0500
Received: from connectmail.carleton.ca ([134.117.2.12]:57663 "EHLO
	connectmail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYKBUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:48:13 -0500
Date: Sun, 02 Nov 2008 15:48:07 -0500
From: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Update: "nobody cared" on Toshiba Satellite A100
In-reply-to: <48FDFB97.1050208@suse.de>
To: Stefan Assmann <sassmann@suse.de>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Message-id: <490E1207.9050508@superonline.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
References: <48FB3ED5.60904@superonline.com>
 <1224431722.26279.4.camel@sven.thebigcorporation.com>
 <48FB6321.7030501@superonline.com> <48FC38AE.3030007@suse.de>
 <48FD0152.60907@superonline.com> <48FDFB97.1050208@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Stefan Assmann wrote:
> To get some more information I have some more things to suggest:

I am sorry for not letting you know of the results of my tests so far.
As you know, this problem is not predictable, and I have to wait a long
time or reboot multiple times before I can get a "nobody cared" message.

The contents of this e-mail were not written in chronological order.
I have tried your suggestions in the following order: third, first
and second.

> 1. try the noapic option

With the "noapic" option, there is yet another unpredictable problem.
Sometimes booting with the "noapic" option is okay, whereas sometimes
it causes "nobody cared" messages to get printed after the initramfs
phase.

With the "noapic" option, the problematic IRQ has switched from 18
to 11 and sometimes 10.

I have not tested a kernel with the "noapic" option long enough to see
whether a "nobody cared" message would pop up hours or days after the
computer boots.

Here are three common examples:

The following is from Sidux's kernel:

=== 8< ===
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 1598, comm: modprobe Not tainted 2.6.27-4.slh.2-sidux-686 #1
 [<c016d514>] __report_bad_irq+0x24/0x90
 [<c016d802>] note_interrupt+0x282/0x2c0
 [<c016cb40>] handle_IRQ_event+0x30/0x60
 [<c016e073>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c01327ad>] irq_exit+0x5d/0x90
 [<c01149b5>] smp_apic_timer_interrupt+0x55/0x80
 [<c0104993>] common_interrupt+0x23/0x28
 [<c03500d8>] pci_ite887x_exit+0x8/0x42
 [<c016cb20>] handle_IRQ_event+0x10/0x60
 [<c016e01d>] handle_level_irq+0x7d/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c016d2a1>] setup_irq+0x121/0x250
 [<c0104993>] common_interrupt+0x23/0x28
 [<c016007b>] proc_cpuset_show+0x9b/0xc0
 [<f8bb88cc>] yenta_probe_cb_irq+0x9c/0x110 [yenta_socket]
 [<f8bb8c58>] ti12xx_override+0x238/0x6a0 [yenta_socket]
 [<f8bba04a>] yenta_probe+0x62a/0x67b [yenta_socket]
 [<c01f0d62>] sysfs_add_one+0x12/0x50
 [<c01f0e0d>] sysfs_addrm_start+0x6d/0xc0
 [<c03592b5>] _spin_unlock+0x5/0x20
 [<c0246290>] pci_match_device+0xa0/0xc0
 [<c0246a66>] pci_device_probe+0x56/0x80
 [<c02ace16>] driver_probe_device+0x86/0x1a0
 [<c0358ea4>] _spin_lock_irqsave+0x34/0x50
 [<c02acfa1>] __driver_attach+0x71/0x80
 [<c02469b0>] pci_device_remove+0x0/0x40
 [<c02ac744>] bus_for_each_dev+0x44/0x70
 [<c02469b0>] pci_device_remove+0x0/0x40
 [<c02acca6>] driver_attach+0x16/0x20
 [<c02acf30>] __driver_attach+0x0/0x80
 [<c02ac107>] bus_add_driver+0x1a7/0x220
 [<c02469b0>] pci_device_remove+0x0/0x40
 [<c02ad13c>] driver_register+0x5c/0x130
 [<f8b81000>] yenta_socket_init+0x0/0x14 [yenta_socket]
 [<c0246ca7>] __pci_register_driver+0x47/0x90
 [<f8b81000>] yenta_socket_init+0x0/0x14 [yenta_socket]
 [<c010111a>] do_one_initcall+0x2a/0x160
 [<c0125d6b>] check_preempt_wakeup+0x11b/0x160
 [<c0127b9f>] try_to_wake_up+0xbf/0x190
 [<c0154b8b>] sys_init_module+0x8b/0x1b0
 [<c0103eef>] sysenter_do_call+0x12/0x2f
 [<c0350000>] serial8250_remove+0x10/0x42
 =======================
handlers:
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8878b60>] (irq_handler+0x0/0x490 [firewire_ohci])
Disabling IRQ #11
=== >8 ===

The following is from an unpatched, vanilla kernel. I also have
/proc/interrupts contents and lsusb output for this one. I have
modified /etc/rc.local to save these at boot time.

=== 8< ===
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 1616, comm: modprobe Not tainted 2.6.27.4 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d772>] note_interrupt+0x282/0x2c0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dfe3>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c013278d>] irq_exit+0x5d/0x90
 [<c01149b5>] smp_apic_timer_interrupt+0x55/0x80
 [<c0104993>] common_interrupt+0x23/0x28
 [<c03500d8>] cpuid4_cache_lookup+0x238/0x342
 [<c016ca90>] handle_IRQ_event+0x10/0x60
 [<c016df8d>] handle_level_irq+0x7d/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c016d211>] setup_irq+0x121/0x250
 [<c0104993>] common_interrupt+0x23/0x28
 [<c016007b>] cpuset_write_s64+0xb/0xa0
 [<f8ad28cc>] yenta_probe_cb_irq+0x9c/0x110 [yenta_socket]
 [<f8ad2c58>] ti12xx_override+0x238/0x6a0 [yenta_socket]
 [<f8ad404a>] yenta_probe+0x62a/0x67b [yenta_socket]
 [<c01f0542>] sysfs_add_one+0x12/0x50
 [<c01f05ed>] sysfs_addrm_start+0x6d/0xc0
 [<c0358ab5>] _spin_unlock+0x5/0x20
 [<c0245a80>] pci_match_device+0xa0/0xc0
 [<c0246256>] pci_device_probe+0x56/0x80
 [<c02ac5b6>] driver_probe_device+0x86/0x1a0
 [<c03586a4>] _spin_lock_irqsave+0x34/0x50
 [<c02ac741>] __driver_attach+0x71/0x80
 [<c02461a0>] pci_device_remove+0x0/0x40
 [<c02abee4>] bus_for_each_dev+0x44/0x70
 [<c02461a0>] pci_device_remove+0x0/0x40
 [<c02ac446>] driver_attach+0x16/0x20
 [<c02ac6d0>] __driver_attach+0x0/0x80
 [<c02ab8a7>] bus_add_driver+0x1a7/0x220
 [<c02461a0>] pci_device_remove+0x0/0x40
 [<c02ac8dc>] driver_register+0x5c/0x130
 [<f89eb000>] yenta_socket_init+0x0/0x14 [yenta_socket]
 [<c0246497>] __pci_register_driver+0x47/0x90
 [<f89eb000>] yenta_socket_init+0x0/0x14 [yenta_socket]
 [<c010111a>] do_one_initcall+0x2a/0x160
 [<c0125d81>] check_preempt_wakeup+0x131/0x160
 [<c0154afb>] sys_init_module+0x8b/0x1b0
 [<c0103eef>] sysenter_do_call+0x12/0x2f
 [<c0350000>] cpuid4_cache_lookup+0x160/0x342
 =======================
handlers:
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8880b60>] (irq_handler+0x0/0x490 [firewire_ohci])
Disabling IRQ #11
=== >8 ===

/proc/interrupts:
=== 8< ===
           CPU0       CPU1
  0:      21711          0    XT-PIC-XT        timer
  1:          8          0    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  3:          1          0    XT-PIC-XT
  4:          1          0    XT-PIC-XT
  5:          1          0    XT-PIC-XT
  6:          1          0    XT-PIC-XT
  7:          1          0    XT-PIC-XT
  8:          1          0    XT-PIC-XT        rtc0
  9:         92          0    XT-PIC-XT        acpi
 10:        872          0    XT-PIC-XT        uhci_hcd:usb3, uhci_hcd:usb4, mmc0, yenta, HDA Intel, tifm_7xx1, eth0
 11:     100020          0    XT-PIC-XT        uhci_hcd:usb1, uhci_hcd:usb2, ehci_hcd:usb5, firewire_ohci
 12:        132          0    XT-PIC-XT        i8042
 14:       5056          0    XT-PIC-XT        ata_piix
 15:        243          0    XT-PIC-XT        ata_piix
220:         27          0   PCI-MSI-edge      iwl3945
NMI:          0          0   Non-maskable interrupts
LOC:      14292      21324   Local timer interrupts
RES:       2321       5845   Rescheduling interrupts
CAL:       1296       1583   function call interrupts
TLB:        296        298   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
=== >8 ===

lsusb:
=== 8< ===
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 0d62:0004 Darfon Electronics Corp. Filter Driver
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
=== >8 ===

There is also IRQ 10, which sometimes gets disabled after IRQ 11 has
been disabled for 15-30 seconds. It is worth mentioning that this
kernel was built with the patch you provided, but with a 99 instead
of the 999. So this "nobody cared" message could be caused by 99's
being too small.

=== 8< ===
irq 10: nobody cared (try booting with the "irqpoll" option)
Pid: 3920, comm: hal-system-kill Not tainted 2.6.27.4-spurious99 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d76a>] note_interrupt+0x27a/0x2b0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dfd3>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c013278d>] irq_exit+0x5d/0x90
 [<c01149b5>] smp_apic_timer_interrupt+0x55/0x80
 [<c0104993>] common_interrupt+0x23/0x28
 [<c013249e>] __do_softirq+0x4e/0xe0
 [<c0132585>] do_softirq+0x55/0x60
 [<c01327a5>] irq_exit+0x75/0x90
 [<c0107180>] do_IRQ+0x40/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<c019007b>] mprotect_fixup+0x1db/0x420
 [<c0189e08>] unmap_vmas+0x4a8/0x720
 [<c018db80>] exit_mmap+0x90/0x130
 [<c012ae5e>] mmput+0x1e/0x90
 [<c01a9e8d>] flush_old_exec+0x1ad/0x700
 [<c01aa46d>] kernel_read+0x3d/0x60
 [<c01d7f7e>] load_elf_binary+0x35e/0x18f0
 [<c01be896>] mnt_drop_write+0x56/0x130
 [<c0358aa5>] _spin_unlock+0x5/0x20
 [<c017c1c3>] generic_file_aio_read+0x5b3/0x6d0
 [<c01a4d35>] do_sync_read+0xd5/0x120
 [<c01bd738>] mntput_no_expire+0x18/0x110
 [<c0141980>] autoremove_wake_function+0x0/0x50
 [<c01a597b>] vfs_read+0xfb/0x160
 [<c01d7c20>] load_elf_binary+0x0/0x18f0
 [<c01a99dc>] search_binary_handler+0x16c/0x2d0
 [<c01aa46d>] kernel_read+0x3d/0x60
 [<c01d67a6>] load_script+0x1f6/0x240
 [<c018b214>] get_user_pages+0xe4/0x380
 [<c0358694>] _spin_lock_irqsave+0x34/0x50
 [<c0187efc>] set_page_address+0xbc/0x190
 [<c018809e>] page_address+0xce/0xf0
 [<c018809e>] page_address+0xce/0xf0
 [<c01d65b0>] load_script+0x0/0x240
 [<c01a99dc>] search_binary_handler+0x16c/0x2d0
 [<c01aacbb>] do_execve+0x24b/0x290
 [<c0102316>] sys_execve+0x46/0x80
 [<c0103eef>] sysenter_do_call+0x12/0x2f
 [<c0350000>] cpuid4_cache_lookup+0x170/0x342
 =======================
handlers:
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f887f940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8afa8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8b89640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8cbe7a0>] (azx_interrupt+0x0/0x130 [snd_hda_intel])
[<f88e31a0>] (e100_intr+0x0/0xe0 [e100])
[<f8e6ea90>] (i915_driver_irq_handler+0x0/0x230 [i915])
Disabling IRQ #10
=== >8 ===

> 2. try the irqpoll option

I have compiled 2.6.27.4 with the spurious interrupt patch you provided,
and I have booted it with the irqpoll option. Currently I am waiting for
a "nobody cared" message.

By the way, would I get any messages from the kernel if one of the IRQs
was not handled properly and hence the functionality enabled by "irqpoll"
was used?

> 3. try the latest 2.6.26 kernel to verify this has been introduced with
> 2.6.27

I have done some testing with Sidux's 2.6.27-6.slh.4, vanilla 2.6.27.7 and
vanilla 2.6.27.2, the last two of which had a modified version your patch
applied. The modification was the replacement of 99900 with 99 instead of
the 999 that you suggested in your patch. I hope that this has not caused
false positives. I didn't use any kernel command line options. 

Version:                                "nobody cared"?
2.6.27.2 (vanilla, no patch)            Yes
2.6.26.7 (vanilla, with patch)          Yes
2.6.26-6.slh.4 (Sidux, no patch)        Yes

Here's the chronology:

I first tried 2.6.27.2 without the patch. I got the "nobody cared"
message approximately 3.5 hours after the boot. Because of the
relative quickness, I didn't see the need to try it with the patch.

I then tried 2.6.26.7 with the patch, and I got the "nobody cared"
message after 9.5 hours.

Then I wanted to make sure that my changing the 999 into 99 did
not cause a false positive. I tried Sidux's 2.6.26.6 based kernel,
unmodified - that is without the patch applied. I got the "nobody
cared" message after approximately three days.

===

So, this might not be regression caused by 2.6.27 after all.
Before switching to 2.6.27-rcX series, I used 2.6.25.X, and I used to
attach my USB keyboard to one of the USB ports on the right side of the
laptop. During the time of the switch to 2.6.27-rcX, I started to use
the USB ports on the rear panel of the laptop to reduce desktop clutter,
and I started to get the "nobody cared" message. Not thinking about the
possibility of port or controller specific issues, I thought that this
could be a regression. (I will try 2.6.25.19 after I'm done with 2.6.27.4
and irqpoll.)

Is there anything I can do to get more information about this problem?
There seems to be too many variables and unpredictable behavior. If you
could provide me with a step by step systematic method to debug this
problem, I would really appreciate it.

Again, thank you for your help.

M. Vefa Bicakci

