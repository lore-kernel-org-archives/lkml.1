Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbXGNUyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbXGNUyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbXGNUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:53:58 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:56867 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761019AbXGNUx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:53:57 -0400
X-Greylist: delayed 1246 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2007 16:53:57 EDT
Date: Sat, 14 Jul 2007 22:32:46 +0200
To: romieu@fr.zoreil.com, rolandd@cisco.com
Subject: [PATCH 2.6.22] Trivial: in-string typos of error
From: "Eddy L O Jansson" <eddy@klopper.net>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Message-ID: <op.tvg10w0r1eqlny@laptop.klopper.net>
User-Agent: Opera Mail/9.21 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One patch for two trivial typos of 'error' with three R's, appearing in message strings.

There's a bunch more of the same in comments, not dealt with here.

Signed-off-by: Eddy L O Jansson <eddy@klopper.net>
---
diff -uprN -X linux-2.6.22-vanilla/Documentation/dontdiff linux-2.6.22-vanilla/drivers/infiniband/hw/ehca/ehca_irq.c linux-2.6.22-errrorfixed/drivers/infiniband/hw/ehca/ehca_irq.c
--- linux-2.6.22-vanilla/drivers/infiniband/hw/ehca/ehca_irq.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22-errrorfixed/drivers/infiniband/hw/ehca/ehca_irq.c	2007-07-14 21:51:38.000000000 +0200
@@ -113,7 +113,7 @@ static void print_error_data(struct ehca
  	}
  	default:
  		ehca_err(&shca->ib_device,
-			 "Unknown errror type: %lx on %s.",
+			 "Unknown error type: %lx on %s.",
  			 type, shca->ib_device.name);
  		break;
  	}
diff -uprN -X linux-2.6.22-vanilla/Documentation/dontdiff linux-2.6.22-vanilla/drivers/net/via-velocity.c linux-2.6.22-errrorfixed/drivers/net/via-velocity.c
--- linux-2.6.22-vanilla/drivers/net/via-velocity.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22-errrorfixed/drivers/net/via-velocity.c	2007-07-14 21:51:11.000000000 +0200
@@ -1614,7 +1614,7 @@ static void velocity_error(struct veloci
  	if (status & ISR_TXSTLI) {
  		struct mac_regs __iomem * regs = vptr->mac_regs;

-		printk(KERN_ERR "TD structure errror TDindex=%hx\n", readw(&regs->TDIdx[0]));
+		printk(KERN_ERR "TD structure error TDindex=%hx\n", readw(&regs->TDIdx[0]));
  		BYTE_REG_BITS_ON(TXESR_TDSTR, &regs->TXESR);
  		writew(TRDCSR_RUN, &regs->TDCSRClr);
  		netif_stop_queue(vptr->dev);
