Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0CGHlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 02:41:12 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:62032 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CGHlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 02:41:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMDlkkvEwFEi/2dsb2JhbACbSXOpa4xShHgEgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Michael Tate <michael.tate@wanadoo.fr>
Subject: [PATCH 3/5] staging: et131x: et131x_netdev: Fix brace coding style issues.
Date: Sun,  7 Mar 2010 11:40:36 +0400
Message-Id: <1267947636-4490-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 3 brace coding style issues reported by checkpatch.pl
Not resolved - One line > 80 chars and 11 'avoid externs' warnings.

Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
---
 drivers/staging/et131x/et131x_netdev.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 24d97b4..6dd9b52 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -434,19 +434,16 @@ void et131x_multicast(struct net_device *netdev)
 	 * accordingly
 	 */
 
-	if (netdev->flags & IFF_PROMISC) {
+	if (netdev->flags & IFF_PROMISC)
 		adapter->PacketFilter |= ET131X_PACKET_TYPE_PROMISCUOUS;
-	} else {
+	else
 		adapter->PacketFilter &= ~ET131X_PACKET_TYPE_PROMISCUOUS;
-	}
 
-	if (netdev->flags & IFF_ALLMULTI) {
+	if (netdev->flags & IFF_ALLMULTI)
 		adapter->PacketFilter |= ET131X_PACKET_TYPE_ALL_MULTICAST;
-	}
 
-	if (netdev->mc_count > NIC_MAX_MCAST_LIST) {
+	if (netdev->mc_count > NIC_MAX_MCAST_LIST)
 		adapter->PacketFilter |= ET131X_PACKET_TYPE_ALL_MULTICAST;
-	}
 
 	if (netdev->mc_count < 1) {
 		adapter->PacketFilter &= ~ET131X_PACKET_TYPE_ALL_MULTICAST;
-- 
1.6.3.3

