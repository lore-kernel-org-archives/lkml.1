Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbYGOVgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbYGOVgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYGOVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:35:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYGOVfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:35:53 -0400
Date: Tue, 15 Jul 2008 17:34:30 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 4/7] dynamic debug v2 - convert bonding
Message-ID: <20080715213430.GE23331@redhat.com>
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
