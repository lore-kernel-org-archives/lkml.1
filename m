Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZLNAKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZLNAKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZLMX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbZLMX6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:04 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, netdev@vger.kernel.org,
       ilw@linux.intel.com, linville@tuxdriver.com, reinette.chatre@intel.com,
       yi.zhu@intel.com
Subject: [PATCH 1/1] Constify struct iwl_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:53 +0100
Message-Id: <c3f0fed4cb1def7f69464d517fcfff4baa7fa330.1260662999.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662999.git.re.emese@gmail.com>
References: <cover.1260662999.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8414178..ea0150e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -140,7 +140,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	 },
 };
 
-static struct iwl_ops iwl1000_ops = {
+static const struct iwl_ops iwl1000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl1000_lib,
 	.hcmd = &iwl5000_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7da1dab..3708b5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2811,7 +2811,7 @@ static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
 };
 
-static struct iwl_ops iwl3945_ops = {
+static const struct iwl_ops iwl3945_ops = {
 	.ucode = &iwl3945_ucode,
 	.lib = &iwl3945_lib,
 	.hcmd = &iwl3945_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 386513b..4cfb503 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2208,7 +2208,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	},
 };
 
-static struct iwl_ops iwl4965_ops = {
+static const struct iwl_ops iwl4965_ops = {
 	.ucode = &iwl4965_ucode,
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e2f8615..bf44b29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1554,7 +1554,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	 },
 };
 
-static struct iwl_ops iwl5000_ops = {
+static const struct iwl_ops iwl5000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
@@ -1562,7 +1562,7 @@ static struct iwl_ops iwl5000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-static struct iwl_ops iwl5150_ops = {
+static const struct iwl_ops iwl5150_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl5150_lib,
 	.hcmd = &iwl5000_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 74e5710..4c19d72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -252,7 +252,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	 },
 };
 
-static struct iwl_ops iwl6000_ops = {
+static const struct iwl_ops iwl6000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
@@ -267,7 +267,7 @@ static struct iwl_hcmd_utils_ops iwl6050_hcmd_utils = {
 	.calc_rssi = iwl5000_calc_rssi,
 };
 
-static struct iwl_ops iwl6050_ops = {
+static const struct iwl_ops iwl6050_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
-- 
1.6.5.3

