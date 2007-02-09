Return-Path: <linux-kernel-owner+w=401wt.eu-S1946557AbXBIQFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946557AbXBIQFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946569AbXBIQFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53625 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946557AbXBIQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:17 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] spider_net breakage from class_device -> device
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYFM-0004ql-0L@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/spider_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index bf6ff39..64ed8ff 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -1907,7 +1907,7 @@ spider_net_stop(struct net_device *netdev)
 	spider_net_write_reg(card, SPIDER_NET_GHIINT2MSK, 0);
 
 	/* free_irq(netdev->irq, netdev);*/
-	free_irq(to_pci_dev(netdev->class_dev.dev)->irq, netdev);
+	free_irq(to_pci_dev(netdev->dev.parent)->irq, netdev);
 
 	spider_net_write_reg(card, SPIDER_NET_GDTDMACCNTR,
 			     SPIDER_NET_DMA_TX_FEND_VALUE);
-- 
1.5.0-rc2.GIT


