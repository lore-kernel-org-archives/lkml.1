Return-Path: <linux-kernel-owner+w=401wt.eu-S934180AbYBBTtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180AbYBBTtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933966AbYBBTs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:48:56 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:35469 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933948AbYBBTsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:48:54 -0500
Message-ID: <47A4C920.4090202@tiscali.nl>
Date: Sat, 02 Feb 2008 20:48:48 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com
CC: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [wireless/iwlwifi/iwl-4965.c] add parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'!' has a higher priority than '&': bitanding has no effect.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 569347f..2439868 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
 
 	if (sta_ht_inf) {
 		if ((!sta_ht_inf->ht_supported) ||
-		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
+		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
 			return 0;
 	}
 
