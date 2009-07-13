Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZGMULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZGMULk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZGMULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:11:39 -0400
Received: from mail.tpi.com ([70.99.223.143]:3384 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbZGMULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:11:39 -0400
To: yi.zhu@intel.com
Subject: [PATCH] iwlwifi 3945: Fix IWL_SCAN compile error
Cc: ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Message-Id: <20090713190803.9A70BF8D2C@sepang.rtg.net>
Date: Mon, 13 Jul 2009 13:08:03 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2c7c806570ad72f5af2e778f2fe71aae7d727e02 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 13 Jul 2009 12:53:32 -0600
Subject: [PATCH] iwlwifi 3945: Fix IWL_DEBUG_SCAN compile

Added a missing parameter in the macro invocation to correct a
compile error when CONFIG_IWLWIFI_DEBUG is enabled.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2564288..67332fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2962,7 +2962,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	}
 
 	if (scan->channel_count == 0) {
-		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		IWL_DEBUG_SCAN(priv,"channel count %d\n", scan->channel_count);
 		goto done;
 	}
 
-- 
1.6.3.3

