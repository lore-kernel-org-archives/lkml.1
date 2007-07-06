Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbXGFMtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbXGFMtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760434AbXGFMs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:48:57 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38892 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760944AbXGFMs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:48:56 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 08:45:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] I386: Deactivate the test for the dead CONFIG_BALANCED_IRQ_DEBUG
 variable.
Message-ID: <Pine.LNX.4.64.0707060844280.23613@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 7f8b7af..c7a58f7 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -353,7 +353,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
 # include <linux/slab.h>		/* kmalloc() */
 # include <linux/timer.h>	/* time_after() */

-#ifdef CONFIG_BALANCED_IRQ_DEBUG
+#if 0 /* debug IRQ balancing */
 #  define TDprintk(x...) do { printk("<%ld:%s:%d>: ", jiffies, __FILE__, __LINE__); printk(x); } while (0)
 #  define Dprintk(x...) do { TDprintk(x); } while (0)
 # else
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
