Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbYFJVn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbYFJVn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbYFJVnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:43:00 -0400
Received: from mail.macqel.be ([194.78.208.39]:2946 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751AbYFJVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:42:59 -0400
Date: Tue, 10 Jun 2008 23:42:55 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] driver/video/cirrusfb : Fix RAM address printk
Message-ID: <20080610214255.GA27749@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

In the cirrusfb driver, the RAM address printk has a superfluous 'x'
that could be interpreted as "don't care", while it is actually a typo.
Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 184e1bb486cf drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c	Mon Jun  9 19:30:13 2008 -0700
+++ b/drivers/video/cirrusfb.c	Tue Jun 10 13:25:22 2008 +0200
@@ -2432,7 +2432,7 @@ static int cirrusfb_pci_register(struct 
 	info->screen_size = board_size;
 	cinfo->unmap = cirrusfb_pci_unmap;
 
-	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
+	printk(KERN_INFO " RAM (%lu kB) at 0x%lx, ",
 		info->screen_size >> 10, board_addr);
 	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
 	pci_set_drvdata(pdev, info);
