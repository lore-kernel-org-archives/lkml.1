Return-Path: <linux-kernel-owner+w=401wt.eu-S1763999AbYEVVT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763999AbYEVVT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762591AbYEVVTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:19:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760831AbYEVVTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:19:40 -0400
Date: Thu, 22 May 2008 17:19:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] debug printk infrastructure -convert bonding to dynamic printk
Message-ID: <20080522211909.GG28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 drivers/net/bonding/bonding.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index a3c74e2..9c5d08c 100644
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
+	pr_debug(DRV_NAME ": %s() %d: " fmt, __FUNCTION__, __LINE__ , ## args )
 
 #define IS_UP(dev)					   \
 	      ((((dev)->flags & IFF_UP) == IFF_UP)	&& \
-- 
1.5.4.5

