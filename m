Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXFDJYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXFDJYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXFDJYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:24:25 -0400
Received: from er-systems.de ([85.25.136.202]:53015 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbXFDJYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:24:24 -0400
Date: Mon, 4 Jun 2007 11:24:22 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: hisax isdn card (Sedlbauer Speed Fax+) does not get an interrupt
In-Reply-To: <465EDDC0.6090601@shaw.ca>
Message-ID: <Pine.LNX.4.63.0706041033140.17261@er-systems.de>
References: <fa./GDxiXMgfJlsQXnkvKu3TibPJV8@ifi.uio.no> <465EDDC0.6090601@shaw.ca>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-1357626722-1180946019=:17261"
Content-ID: <Pine.LNX.4.63.0706041123450.18714@er-systems.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-1357626722-1180946019=:17261
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.63.0706041033441.17261@er-systems.de>

Hi Robert,

On Thu, 31 May 2007, Robert Hancock wrote:

> Thomas Voegtle wrote:
> > 
> > ==========================================================================
[...]
> > <03>2007 May 30 14:21:40 cbs kern: irq 11: nobody cared (try booting with
> > the \"irqpoll\" option)
> > <04>2007 May 30 14:21:40 cbs kern: [<c012f243>] __report_bad_irq+0x2b/0x69
> > <04>2007 May 30 14:21:40 cbs kern: [<c012f3e7>] note_interrupt+0x166/0x193
> > <04>2007 May 30 14:21:40 cbs kern: [<c03089c0>] usb_hcd_irq+0x23/0x4f
> > <04>2007 May 30 14:21:40 cbs kern: [<c012ee7c>] handle_IRQ_event+0x21/0x4a
> > <04>2007 May 30 14:21:40 cbs kern: [<c012ef0d>] __do_IRQ+0x68/0x8f
> > <04>2007 May 30 14:21:40 cbs kern: [<c01050de>] do_IRQ+0x5c/0x77
> > <04>2007 May 30 14:21:40 cbs kern: =======================
> > <04>2007 May 30 14:21:40 cbs kern: [<c0103ada>] common_interrupt+0x1a/0x20
> > <04>2007 May 30 14:21:40 cbs kern: [<c011a87c>] __do_softirq+0x2c/0x7d
> > <04>2007 May 30 14:21:40 cbs kern: [<c0105131>] do_softirq+0x38/0x3f
> > <04>2007 May 30 14:21:40 cbs kern: =======================
> > <04>2007 May 30 14:21:40 cbs kern: [<c01050f0>] do_IRQ+0x6e/0x77
> > <04>2007 May 30 14:21:40 cbs kern: [<c0103ada>] common_interrupt+0x1a/0x20
> > <04>2007 May 30 14:21:40 cbs kern: [<d894007b>] W6692B_interrupt+0x23c/0x559
> > [hisax]
> > <04>2007 May 30 14:21:40 cbs kern: [<c010b893>] delay_pmtmr+0xb/0x13
> > <04>2007 May 30 14:21:40 cbs kern: [<c01b73f5>] __delay+0x9/0xa
> > <04>2007 May 30 14:21:40 cbs kern: [<d892f834>] setup_sedlbauer+0x1ee/0x534
> > [hisax]
> > <04>2007 May 30 14:21:40 cbs kern: [<c01175e8>] printk+0x12/0x16
> > <04>2007 May 30 14:21:40 cbs kern: [<d890dcdb>] checkcard+0x201/0x566
> > [hisax]
> > <04>2007 May 30 14:21:40 cbs kern: [<d890dd62>] checkcard+0x288/0x566
> > [hisax]
> > <04>2007 May 30 14:21:40 cbs kern: [<d88554dc>] HiSax_init+0x4dc/0x57a
> > [hisax]
> > <04>2007 May 30 14:21:40 cbs kern: [<c0159693>] new_inode+0x14/0x76
> > <04>2007 May 30 14:21:40 cbs kern: [<c017340c>] sysfs_add_file+0x1f/0x52
> > <04>2007 May 30 14:21:40 cbs kern: [<c01275fc>]
> > debug_mutex_add_waiter+0x14/0x24
> > <04>2007 May 30 14:21:40 cbs kern: [<c0173995>] sysfs_new_dirent+0x17/0x56
> > <04>2007 May 30 14:21:40 cbs kern: [<c012a782>]
> > sys_init_module+0x1364/0x1439
> > <04>2007 May 30 14:21:40 cbs kern: [<c013711c>]
> > vma_prio_tree_insert+0x17/0x2a
> > <04>2007 May 30 14:21:40 cbs kern: [<c013ac54>] vma_link+0x85/0x8b
> > <04>2007 May 30 14:21:40 cbs kern: [<c013c7a4>] do_mmap_pgoff+0x4e7/0x634
> > <04>2007 May 30 14:21:40 cbs kern: [<c0106f44>] sys_mmap2+0x61/0x90
> > <04>2007 May 30 14:21:40 cbs kern: [<c0102a79>] syscall_call+0x7/0xb
> > <03>2007 May 30 14:21:40 cbs kern: handlers:
> > <03>2007 May 30 14:21:40 cbs kern: [<c030899d>] (usb_hcd_irq+0x0/0x4f)
> > <00>2007 May 30 14:21:40 cbs kern: Disabling IRQ #11
[...]
> 
> Likely a driver problem - the device is using IRQ 11, but the driver never
> actually registered a handler for that interrupt (it's not in the list of
> handlers, only USB is). Maybe retrieving the interrupt before
> pci_enable_device? (I haven't looked at the code in question.)

Thx for your answer. Unfortunately, it didn't help us yet in finding a fix 
for the problem.

The first IRQs are received after the call to pci_enable_device, but 
before the IRQ handler itself is registered (register_irq). The IRQs seem 
to be triggered by the write operations to the card registers 
(byteout()/outb() calls around lines 676ff in sedlbauer.c); the IRQ 
handler is registered much later, though. The dump above suggests that the 
kernel relays the interrupts to the USB handler (on the same IRQ) instead 
- which obviously is wrong.

In short:
* pci_enable_device
* writing to card registers -> triggering interrupts
  (handler not yet installed -> error)
* register interrupt -> fails, as it already was disabled due to the 
  errors

Again: thx for your comments. Do you have any further ideas/advice on how 
to get the driver running?

      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-1357626722-1180946019=:17261--
