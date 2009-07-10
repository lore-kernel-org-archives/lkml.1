Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZGJByv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZGJByv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZGJByo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:54:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZGJByo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:54:44 -0400
Date: Thu, 9 Jul 2009 21:54:39 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Fix compile error in bmac.c
Message-ID: <20090710015439.GA28864@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the change in ad361c9884e809340f6daca80d56a9e9c871690a
wasn't compile tested.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.30.noarch/drivers/net/bmac.c~	2009-07-09 21:51:36.000000000 -0400
+++ linux-2.6.30.noarch/drivers/net/bmac.c	2009-07-09 21:51:47.000000000 -0400
@@ -431,7 +431,7 @@ bmac_init_phy(struct net_device *dev)
 			printk(KERN_DEBUG);
 		printk(KERN_CONT " %.4x", bmac_mif_read(dev, addr));
 	}
-	print(KERN_CONT "\n");
+	printk(KERN_CONT "\n");
 
 	if (bp->is_bmac_plus) {
 		unsigned int capable, ctrl;
