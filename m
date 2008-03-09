Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYCIX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYCIX6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYCIX56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:57:58 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4376 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYCIX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:57:57 -0400
Subject: [PATCH] include/net/ieee80211.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:10 -0700
Message-Id: <1205106910.656.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/net/ieee80211.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index 285b2ad..529816b 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -183,7 +183,6 @@ const char *escape_essid(const char *essid, u8 essid_len);
 #define IEEE80211_DEBUG_RX(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_RX, f, ## a)
 #define IEEE80211_DEBUG_QOS(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_QOS, f, ## a)
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/if_arp.h>	/* ARPHRD_ETHER */
 
 #ifndef WIRELESS_SPY


