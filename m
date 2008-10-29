Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYJ2N4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYJ2N4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYJ2N4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:56:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47400 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYJ2N4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:56:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: nico@cam.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SMC91x: delete unused local variable "lp"
Date: Wed, 29 Oct 2008 09:56:06 -0400
Message-Id: <1225288566-18457-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/net/smc91x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index c70870e..6f9895d 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -2060,7 +2060,6 @@ static int smc_request_attrib(struct platform_device *pdev,
 			      struct net_device *ndev)
 {
 	struct resource * res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "smc91x-attrib");
-	struct smc_local *lp = netdev_priv(ndev);
 
 	if (!res)
 		return 0;
@@ -2075,7 +2074,6 @@ static void smc_release_attrib(struct platform_device *pdev,
 			       struct net_device *ndev)
 {
 	struct resource * res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "smc91x-attrib");
-	struct smc_local *lp = netdev_priv(ndev);
 
 	if (res)
 		release_mem_region(res->start, ATTRIB_SIZE);
-- 
1.6.0.2

