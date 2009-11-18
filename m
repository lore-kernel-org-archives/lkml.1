Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZKRSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZKRSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbZKRSZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:25:26 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56445 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbZKRSZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:25:23 -0500
Date: Wed, 18 Nov 2009 19:25:25 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org, arnd@arndb.de,
       joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 14/16] drivers/net/wireless/iwlwifi: remove exceptional & on
 function name
Message-ID: <Pine.LNX.4.64.0911181924510.20943@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this file, function names are otherwise used as pointers without &.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@

f(...) { ... }

@@
identifier r.f;
@@

- &f
+ f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c     |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index dc81e19..d4b4988 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -355,7 +355,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 
 	init_timer(&rs_sta->rate_scale_flush);
 	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
-	rs_sta->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
+	rs_sta->rate_scale_flush.function = iwl3945_bg_rate_scale_flush;
 
 	for (i = 0; i < IWL_RATE_COUNT_3945; i++)
 		iwl3945_clear_window(&rs_sta->win[i]);
