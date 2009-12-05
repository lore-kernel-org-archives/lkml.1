Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZLEADA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZLEADA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbZLEAC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:02:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbZLEABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:01:10 -0500
Message-ID: <4B19A331.1050003@gmail.com>
Date: Sat, 05 Dec 2009 01:02:57 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
       linville@tuxdriver.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH 15/31] Constify struct iwl_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198DA7.1080809@gmail.com>
In-Reply-To: <4B198DA7.1080809@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

Constify struct iwl_ops.
Per Dave Miller's suggestion, resend with proper CC list and patch format.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 950267a..80d5fd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -137,7 +137,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	 },
 };
 
-static struct iwl_ops iwl1000_ops = {
+static const struct iwl_ops iwl1000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl1000_lib,
 	.hcmd = &iwl5000_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f059b49..fe90e0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2876,7 +2876,7 @@ static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
 };
 
-static struct iwl_ops iwl3945_ops = {
+static const struct iwl_ops iwl3945_ops = {
 	.ucode = &iwl3945_ucode,
 	.lib = &iwl3945_lib,
 	.hcmd = &iwl3945_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6f703a0..b7c4e48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2335,7 +2335,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	},
 };
 
-static struct iwl_ops iwl4965_ops = {
+static const struct iwl_ops iwl4965_ops = {
 	.ucode = &iwl4965_ucode,
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6e6f516..0ec1f24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1627,14 +1627,14 @@ static struct iwl_lib_ops iwl5150_lib = {
 	 },
 };
 
-struct iwl_ops iwl5000_ops = {
+const struct iwl_ops iwl5000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
 };
 
-static struct iwl_ops iwl5150_ops = {
+static const struct iwl_ops iwl5150_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl5150_lib,
 	.hcmd = &iwl5000_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1473452..f07d5e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -146,7 +146,7 @@ static struct iwl_hcmd_utils_ops iwl6000_hcmd_utils = {
 	.calc_rssi = iwl5000_calc_rssi,
 };
 
-static struct iwl_ops iwl6000_ops = {
+static const struct iwl_ops iwl6000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 028d505..0c927e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -67,7 +67,7 @@ struct iwl_tx_queue;
 
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
-extern struct iwl_ops iwl5000_ops;
+extern const struct iwl_ops iwl5000_ops;
 extern struct iwl_ucode_ops iwl5000_ucode;
 extern struct iwl_lib_ops iwl5000_lib;
 extern struct iwl_hcmd_ops iwl5000_hcmd;

