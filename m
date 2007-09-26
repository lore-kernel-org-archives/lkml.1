Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbXIZAyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbXIZAyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbXIZAyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:54:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46699 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXIZAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:54:05 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] mv643xx_eth: duplicate methods in initializer
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <E1IaLA0-00084w-8g@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 26 Sep 2007 01:53:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/mv643xx_eth.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 6a117e9..456d1e1 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -2768,8 +2768,6 @@ static const struct ethtool_ops mv643xx_ethtool_ops = {
 	.get_stats_count        = mv643xx_get_stats_count,
 	.get_ethtool_stats      = mv643xx_get_ethtool_stats,
 	.get_strings            = mv643xx_get_strings,
-	.get_stats_count        = mv643xx_get_stats_count,
-	.get_ethtool_stats      = mv643xx_get_ethtool_stats,
 	.nway_reset		= mv643xx_eth_nway_restart,
 };
 
-- 
1.5.3.GIT


