Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZAEQG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZAEQG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZAEQGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:06:15 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:54555 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZAEQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:06:14 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1 #2] IWL: fix WARN typo
Date: Mon,  5 Jan 2009 17:06:06 +0100
Message-Id: <1231171566-22984-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
References: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new kew -> a new key

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 412f66b..ce2ba40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -638,7 +638,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for new kew");
+		"no space for a new key");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
@@ -686,7 +686,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for new kew");
+		"no space for a new key");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
@@ -722,7 +722,7 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for new kew");
+		"no space for a new key");
 
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
-- 
1.6.0.6

