Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbXCGXum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbXCGXum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXCGXum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:50:42 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:46701 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXCGXul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:50:41 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 7 Mar 2007 18:38:32 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Replace misspelled "PRINTK" with "CONFIG_PRINTK".
Message-ID: <Pine.LNX.4.64.0703071836420.3888@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace the apparently misspelled preprocessor variable "PRINTK"
with "CONFIG_PRINTK".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not sure who the official maintainer here is, sorry.

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5554ada..0c09772 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -53,7 +53,7 @@
 //#define DPRINTK PRINTK /* set this NULL to avoid verbose debug output */
 #define DPRINTK(x...) do { } while(0)

-#ifndef PRINTK
+#ifndef CONFIG_PRINTK
 #  if DEBUG > 0
 #    define PRINTK(x...) printk(KERN_DEBUG x)
 #  else

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
