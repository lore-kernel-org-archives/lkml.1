Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXGOUDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXGOUDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbXGOUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbXGOUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:52 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ax88796: dev_dbg() wants device, not platform device
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1IAAGx-00055h-WB@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ax88796.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index d19874b..1d88236 100644
--- a/drivers/net/ax88796.c
+++ b/drivers/net/ax88796.c
@@ -459,7 +459,7 @@ static int ax_open(struct net_device *dev)
 	struct ei_device *ei_local = netdev_priv(dev);
 	int ret;
 
-	dev_dbg(ax->dev, "%s: open\n", dev->name);
+	dev_dbg(&ax->dev->dev, "%s: open\n", dev->name);
 
 	ret = request_irq(dev->irq, ax_ei_interrupt, 0, dev->name, dev);
 	if (ret)
@@ -492,7 +492,7 @@ static int ax_close(struct net_device *dev)
 	struct ax_device *ax = to_ax_dev(dev);
 	struct ei_device *ei_local = netdev_priv(dev);
 
-	dev_dbg(ax->dev, "%s: close\n", dev->name);
+	dev_dbg(&ax->dev->dev, "%s: close\n", dev->name);
 
 	/* turn the phy off */
 
-- 
1.5.3.GIT


