Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYFMTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYFMTFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 15:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYFMTEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 15:04:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYFMTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 15:04:50 -0400
Date: Fri, 13 Jun 2008 15:03:45 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 5/8] dynamic debug - convert bonding
Message-ID: <20080613190345.GF8813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-convert bonding to dynamic printk

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 drivers/net/bonding/bonding.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)


diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index a3c74e2..28556dd 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -29,13 +29,8 @@
 
 #define BOND_MAX_ARP_TARGETS	16
 
-#ifdef BONDING_DEBUG
 #define dprintk(fmt, args...) \
-	printk(KERN_DEBUG     \
-	       DRV_NAME ": %s() %d: " fmt, __FUNCTION__, __LINE__ , ## args )
-#else
-#define dprintk(fmt, args...)
-#endif /* BONDING_DEBUG */
+	pr_debug(DRV_NAME ": %s() %d: " fmt, __FUNCTION__, __LINE__ , ## args)
 
 #define IS_UP(dev)					   \
 	      ((((dev)->flags & IFF_UP) == IFF_UP)	&& \
