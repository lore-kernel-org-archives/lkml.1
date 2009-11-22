Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZKVITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZKVITs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZKVITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:19:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:49181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbZKVITq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:19:46 -0500
Subject: [PATCH] mac80211: Fix missing kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:47:58 +0530
Message-Id: <1258877878.4495.50.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following htmldocs warnings:

  Warning(net/mac80211/sta_info.h:322): No description found for parameter 'drv_unblock_wk'
  Warning(net/mac80211/sta_info.h:322): No description found for parameter 'drv_unblock_wk'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Miller <davem@davemloft.net>
---
 net/mac80211/sta_info.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4c84c22..b4810f6 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -185,6 +185,7 @@ struct sta_ampdu_mlme {
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @flaglock: spinlock for flags accesses
+ * @drv_unblock_wk: used for driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
  * @pin_status: used internally for pinning a STA struct into memory
  * @flags: STA flags, see &enum ieee80211_sta_info_flags
@@ -225,7 +226,6 @@ struct sta_ampdu_mlme {
  * @debugfs: debug filesystem info
  * @sta: station information we share with the driver
  * @dead: set to true when sta is unlinked
- * @drv_unblock_wk used for driver PS unblocking
  */
 struct sta_info {
 	/* General information, mostly static */
-- 
1.6.5.3


