Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYH0DsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYH0DsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 23:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYH0Drw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 23:47:52 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:39128 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYH0Drv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 23:47:51 -0400
X-IronPort-AV: E=Sophos;i="4.32,275,1217822400"; 
   d="scan'208";a="74144989"
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] netdev: Blackfin EMAC Driver: the BF526 also supports the MAC, so updates things accordingly
Date: Wed, 27 Aug 2008 11:47:57 +0800
Message-Id: <1219808877-15168-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index a5c141c..4a11296 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -822,14 +822,14 @@ config ULTRA32
 	  will be called smc-ultra32.
 
 config BFIN_MAC
-	tristate "Blackfin 527/536/537 on-chip mac support"
-	depends on NET_ETHERNET && (BF527 || BF537 || BF536)
+	tristate "Blackfin on-chip MAC support"
+	depends on NET_ETHERNET && (BF526 || BF527 || BF536 || BF537)
 	select CRC32
 	select MII
 	select PHYLIB
 	select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
 	help
-	  This is the driver for blackfin on-chip mac device. Say Y if you want it
+	  This is the driver for Blackfin on-chip mac device. Say Y if you want it
 	  compiled into the kernel. This driver is also available as a module
 	  ( = code which can be inserted in and removed from the running kernel
 	  whenever you want). The module will be called bfin_mac.
-- 
1.5.6
