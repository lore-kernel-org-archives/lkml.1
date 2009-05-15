Return-Path: <linux-kernel-owner+w=401wt.eu-S1763366AbZEOSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366AbZEOSCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760047AbZEOSAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:00:07 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2056 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZEOSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:00:03 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Jeff Garzik <jgarzik@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Lennert Buytenhek <buytenh@marvell.com>
Subject: [PATCH 08/11] drivers/net: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:42 -0700
Message-Id: <d208c4b401aed61c0ba6a24e92467bb321c1f7ae.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/tc35815.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
index 0ce2db6..d737f6b 100644
--- a/drivers/net/tc35815.c
+++ b/drivers/net/tc35815.c
@@ -688,14 +688,11 @@ static void tc_handle_link_change(struct net_device *dev)
 
 	if (status_change && netif_msg_link(lp)) {
 		phy_print_status(phydev);
-#ifdef DEBUG
-		printk(KERN_DEBUG
-		       "%s: MII BMCR %04x BMSR %04x LPA %04x\n",
-		       dev->name,
-		       phy_read(phydev, MII_BMCR),
-		       phy_read(phydev, MII_BMSR),
-		       phy_read(phydev, MII_LPA));
-#endif
+		pr_debug("%s: MII BMCR %04x BMSR %04x LPA %04x\n",
+			 dev->name,
+			 phy_read(phydev, MII_BMCR),
+			 phy_read(phydev, MII_BMSR),
+			 phy_read(phydev, MII_LPA));
 	}
 }
 
-- 
1.6.3.1.9.g95405b.dirty

