Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXDLUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXDLUst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXDLUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:48:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39688 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbXDLUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:48:48 -0400
X-Originating-Ip: 74.109.98.130
Date: Thu, 12 Apr 2007 16:46:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: netdev@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] 3C509: Remove unnecessary include of <linux/pm_legacy.h>
Message-ID: <Pine.LNX.4.64.0704121644370.20699@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the apparently redundant include of <linux/pm_legacy.h>.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

compile-tested on x86, in preparation for the day when the legacy PM
code goes away.


diff --git a/drivers/net/3c509.c b/drivers/net/3c509.c
index f791bf0..a8ea346 100644
--- a/drivers/net/3c509.c
+++ b/drivers/net/3c509.c
@@ -83,7 +83,6 @@ static int max_interrupt_work = 10;
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>	/* for udelay() */
 #include <linux/spinlock.h>
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
