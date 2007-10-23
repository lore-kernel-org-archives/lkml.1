Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXJWWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXJWWj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbXJWWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:48 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49461 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbXJWWgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:45 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 8/12] ni5010: kill unused variable
Message-Id: <20071023223643.20AB01F81B3@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:43 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/drivers/net/ni5010.c b/drivers/net/ni5010.c
index 14a768f..a20005c 100644
--- a/drivers/net/ni5010.c
+++ b/drivers/net/ni5010.c
@@ -518,7 +518,6 @@ static void dump_packet(void *buf, int len)
 /* We have a good packet, get it out of the buffer. */
 static void ni5010_rx(struct net_device *dev)
 {
-	struct ni5010_local *lp = netdev_priv(dev);
 	int ioaddr = dev->base_addr;
 	unsigned char rcv_stat;
 	struct sk_buff *skb;
@@ -577,7 +576,6 @@ static void ni5010_rx(struct net_device *dev)
 
 	PRINTK2((KERN_DEBUG "%s: Received packet, size=%#4.4x\n",
 		dev->name, i_pkt_size));
-
 }
 
 static int process_xmt_interrupt(struct net_device *dev)
