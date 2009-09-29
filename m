Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZI2OsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZI2OsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZI2OsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:48:14 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45595 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZI2OsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:48:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH] connector/dm: Fixed a compilation warning
Date: Tue, 29 Sep 2009 16:48:10 +0200
Message-Id: <1254235692-1631-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1254235692-1631-3-git-send-email-philipp.reisner@linbit.com>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
 <1254235692-1631-2-git-send-email-philipp.reisner@linbit.com>
 <1254235692-1631-3-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/md/dm-log-userspace-transfer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 556131f..1327e1a 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -129,9 +129,8 @@ static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(void *data, struct netlink_skb_parms *nsp)
+static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
 	spin_lock(&receiving_list_lock);
-- 
1.6.0.4

