Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZIVPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZIVPBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZIVPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:01:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZIVPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:01:46 -0400
Subject: [PATCH] STAGING: includecheck fix: rtl8187se, ieee80211.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:31:47 +0530
Message-Id: <1253631707.3784.36.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/rtl8187se/ieee80211/ieee80211.h: linux/wireless.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index 3222c22..655f419 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -218,7 +218,6 @@ do { if (ieee80211_debug_level & (level)) \
 #define IEEE80211_DEBUG_TX(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_TX, f, ## a)
 #define IEEE80211_DEBUG_RX(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_RX, f, ## a)
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/if_arp.h> /* ARPHRD_ETHER */
 
 #ifndef WIRELESS_SPY
-- 
1.6.0.6


