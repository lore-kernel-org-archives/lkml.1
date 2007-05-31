Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbXEaORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbXEaORj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXEaORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:17:32 -0400
Received: from er-systems.de ([85.25.136.202]:59336 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbXEaORc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:17:32 -0400
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 10:17:31 EDT
Date: Thu, 31 May 2007 15:44:38 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: linux-kernel@vger.kernel.org
Subject: hisax isdn card (Sedlbauer Speed Fax+) does not get an interrupt
Message-ID: <Pine.LNX.4.63.0705311520150.9151@er-systems.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-622072900-1180619078=:9151"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-622072900-1180619078=:9151
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi,

after finally upgrading our systems from Kernel 2.4 to 2.6 we experienced 
problems with the ISDN cards, a hisax driven Sedlbauer Speed Fax+.


A "modprobe hisax type=28 protocol=2" ends in this mess:

==========================================================================
<05>2007 May 30 14:21:40 cbs kern: ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2 loaded
<06>2007 May 30 14:21:40 cbs kern: HiSax: Linux Driver for passive ISDN cards
<06>2007 May 30 14:21:40 cbs kern: HiSax: Version 3.5 (module)
<06>2007 May 30 14:21:40 cbs kern: HiSax: Layer1 Revision 2.46.2.5
<06>2007 May 30 14:21:40 cbs kern: HiSax: Layer2 Revision 2.30.2.4
<06>2007 May 30 14:21:40 cbs kern: HiSax: TeiMgr Revision 2.20.2.3
<06>2007 May 30 14:21:40 cbs kern: HiSax: Layer3 Revision 2.22.2.3
<06>2007 May 30 14:21:40 cbs kern: HiSax: LinkLayer Revision 2.59.2.4
<06>2007 May 30 14:21:40 cbs kern: HiSax module removed
<06>2007 May 30 14:21:40 cbs kern: HiSax: Linux Driver for passive ISDN cards
<06>2007 May 30 14:21:40 cbs kern: HiSax: Version 3.5 (module)
<06>2007 May 30 14:21:40 cbs kern: HiSax: Layer1 Revision 2.46.2.5
<06>2007 May 30 14:21:40 cbs kern: HiSax: Layer2 Revision 2.30.2.4
<06>2007 May 30 14:21:40 cbs kern: HiSax: TeiMgr Revision 2.20.2.3
<06>2007 May 30 14:21:40 cbs kern: HiSax: Layer3 Revision 2.22.2.3
<06>2007 May 30 14:21:40 cbs kern: HiSax: LinkLayer Revision 2.59.2.4
<07>2007 May 30 14:21:40 cbs kern: HiSax: Total 1 card defined
<06>2007 May 30 14:21:40 cbs kern: HiSax: Card 1 Protocol EDSS1 Id=isdn0 (0)
<06>2007 May 30 14:21:40 cbs kern: HiSax: Sedlbauer driver Rev. 1.34.2.6
<06>2007 May 30 14:21:40 cbs kern: ACPI: PCI Interrupt 0000:01:03.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: PCI subvendor:51 subid 1
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: PCI base adr 0xa800
<03>2007 May 30 14:21:40 cbs kern: irq 11: nobody cared (try booting with the \"irqpoll\" option)
<04>2007 May 30 14:21:40 cbs kern: [<c012f243>] __report_bad_irq+0x2b/0x69
<04>2007 May 30 14:21:40 cbs kern: [<c012f3e7>] note_interrupt+0x166/0x193
<04>2007 May 30 14:21:40 cbs kern: [<c03089c0>] usb_hcd_irq+0x23/0x4f
<04>2007 May 30 14:21:40 cbs kern: [<c012ee7c>] handle_IRQ_event+0x21/0x4a
<04>2007 May 30 14:21:40 cbs kern: [<c012ef0d>] __do_IRQ+0x68/0x8f
<04>2007 May 30 14:21:40 cbs kern: [<c01050de>] do_IRQ+0x5c/0x77
<04>2007 May 30 14:21:40 cbs kern: =======================
<04>2007 May 30 14:21:40 cbs kern: [<c0103ada>] common_interrupt+0x1a/0x20
<04>2007 May 30 14:21:40 cbs kern: [<c011a87c>] __do_softirq+0x2c/0x7d
<04>2007 May 30 14:21:40 cbs kern: [<c0105131>] do_softirq+0x38/0x3f
<04>2007 May 30 14:21:40 cbs kern: =======================
<04>2007 May 30 14:21:40 cbs kern: [<c01050f0>] do_IRQ+0x6e/0x77
<04>2007 May 30 14:21:40 cbs kern: [<c0103ada>] common_interrupt+0x1a/0x20
<04>2007 May 30 14:21:40 cbs kern: [<d894007b>] W6692B_interrupt+0x23c/0x559 [hisax]
<04>2007 May 30 14:21:40 cbs kern: [<c010b893>] delay_pmtmr+0xb/0x13
<04>2007 May 30 14:21:40 cbs kern: [<c01b73f5>] __delay+0x9/0xa
<04>2007 May 30 14:21:40 cbs kern: [<d892f834>] setup_sedlbauer+0x1ee/0x534 [hisax]
<04>2007 May 30 14:21:40 cbs kern: [<c01175e8>] printk+0x12/0x16
<04>2007 May 30 14:21:40 cbs kern: [<d890dcdb>] checkcard+0x201/0x566 [hisax]
<04>2007 May 30 14:21:40 cbs kern: [<d890dd62>] checkcard+0x288/0x566 [hisax]
<04>2007 May 30 14:21:40 cbs kern: [<d88554dc>] HiSax_init+0x4dc/0x57a [hisax]
<04>2007 May 30 14:21:40 cbs kern: [<c0159693>] new_inode+0x14/0x76
<04>2007 May 30 14:21:40 cbs kern: [<c017340c>] sysfs_add_file+0x1f/0x52
<04>2007 May 30 14:21:40 cbs kern: [<c01275fc>] debug_mutex_add_waiter+0x14/0x24
<04>2007 May 30 14:21:40 cbs kern: [<c0173995>] sysfs_new_dirent+0x17/0x56
<04>2007 May 30 14:21:40 cbs kern: [<c012a782>] sys_init_module+0x1364/0x1439
<04>2007 May 30 14:21:40 cbs kern: [<c013711c>] vma_prio_tree_insert+0x17/0x2a
<04>2007 May 30 14:21:40 cbs kern: [<c013ac54>] vma_link+0x85/0x8b
<04>2007 May 30 14:21:40 cbs kern: [<c013c7a4>] do_mmap_pgoff+0x4e7/0x634
<04>2007 May 30 14:21:40 cbs kern: [<c0106f44>] sys_mmap2+0x61/0x90
<04>2007 May 30 14:21:40 cbs kern: [<c0102a79>] syscall_call+0x7/0xb
<03>2007 May 30 14:21:40 cbs kern: handlers:
<03>2007 May 30 14:21:40 cbs kern: [<c030899d>] (usb_hcd_irq+0x0/0x4f)
<00>2007 May 30 14:21:40 cbs kern: Disabling IRQ #11
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: defined at 0xa800-0xa900 IRQ 11
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: speed fax+ pyramid detected
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: ISAC version (0): 2086/2186 V1.1
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: ISAR version 1
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ 11 count 100000
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ 11 count 100000
<04>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ(11) getting no interrupts during init 1
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ 11 count 100000
<04>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ(11) getting no interrupts during init 2
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ 11 count 100000
<04>2007 May 30 14:21:40 cbs kern: Sedlbauer Speed Fax +: IRQ(11) getting no interrupts during init 3
<06>2007 May 30 14:21:40 cbs kern: Sedlbauer: resetting card
<04>2007 May 30 14:21:40 cbs kern: HiSax: Card Sedlbauer Speed Fax + not installed !
==========================================================================

While the output seems to suggest a hardware problem, the same system 
loads the hisax driver perfectly on recent 2.4 kernels.

We tried several kernel versions, up to 2.6.21.3

Any hints are appreciated :)

Best,
      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-622072900-1180619078=:9151--
