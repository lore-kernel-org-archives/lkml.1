Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbYKAILX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbYKAILX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 04:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYKAILK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 04:11:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44225 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYKAILJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 04:11:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: nico@cam.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] smc91x: add __init markings to smc_drv_probe()
Date: Sat,  1 Nov 2008 04:11:06 -0400
Message-Id: <1225527066-28985-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smc_drv_probe() is the platform_driver probe function and it is only
called during init.  Further, it calls smc_probe() which is marked as __init
already.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/net/smc91x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index c70870e..c1a0653 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -2126,7 +2126,7 @@ static void smc_release_datacs(struct platform_device *pdev, struct net_device *
  *	0 --> there is a device
  *	anything else, error
  */
-static int smc_drv_probe(struct platform_device *pdev)
+static int __init smc_drv_probe(struct platform_device *pdev)
 {
 	struct smc91x_platdata *pd = pdev->dev.platform_data;
 	struct smc_local *lp;
-- 
1.6.0.2

