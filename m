Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbXKOVfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbXKOVfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbXKOVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:34:57 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4085 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbXKOVez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:34:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       =?utf-8?q?Miguel=20Bot=C3=B3n?= <mboton.lkml@gmail.com>,
       Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: remove redundant initialization of final_mode
Date: Thu, 15 Nov 2007 16:31:25 -0500
Message-Id: <1195162285-26439-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <200711102049.32921.mboton.lkml@gmail.com>
References: <200711102049.32921.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Problem identified by Miguel Botón <mboton.lkml@gmail.com>, alternate
solution suggested by Zhu Yi <yi.zhu@intel.com>, patch by me. :-)

Cc: Miguel Botón <mboton.lkml@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e2cbd9e..15937c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2139,7 +2139,7 @@ static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
 
 static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
 {
-	u32 final_mode = mode;
+	u32 uninitialized_var(final_mode);
 	int rc;
 	struct iwl3945_powertable_cmd cmd;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ef17a98..30acd13 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2218,7 +2218,7 @@ static int iwl4965_update_power_cmd(struct iwl4965_priv *priv,
 
 static int iwl4965_send_power_mode(struct iwl4965_priv *priv, u32 mode)
 {
-	u32 final_mode = mode;
+	u32 uninitialized_var(final_mode);
 	int rc;
 	struct iwl4965_powertable_cmd cmd;
 
-- 
1.5.3.3

