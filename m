Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbXJWWjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbXJWWjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbXJWWgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:46 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44184 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbXJWWgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:45 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 7/12] eexpress: fix !SMP unused-var warning
Message-Id: <20071023223642.0BACC1F81B2@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:42 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/drivers/net/eexpress.c b/drivers/net/eexpress.c
index 9c85e50..70509ed 100644
--- a/drivers/net/eexpress.c
+++ b/drivers/net/eexpress.c
@@ -651,9 +651,9 @@ static void eexp_timeout(struct net_device *dev)
  */
 static int eexp_xmit(struct sk_buff *buf, struct net_device *dev)
 {
-	struct net_local *lp = netdev_priv(dev);
 	short length = buf->len;
 #ifdef CONFIG_SMP
+	struct net_local *lp = netdev_priv(dev);
 	unsigned long flags;
 #endif
 
