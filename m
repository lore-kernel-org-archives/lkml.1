Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXEJOAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXEJOAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760988AbXEJN4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:56:37 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55420 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706AbXEJN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:56:23 -0400
Message-Id: <20070510135646.171836016@de.ibm.com>
References: <20070510135152.178104939@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 15:52:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/15] Kconfig: no wireless on s390.
Content-Disposition: inline; filename=105-kconfig-wlan.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Hide the config menues for wireless on s390.

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/net/wireless/Kconfig |    1 +
 net/Kconfig                  |    1 +
 2 files changed, 2 insertions(+)

Index: quilt-2.6/drivers/net/wireless/Kconfig
===================================================================
--- quilt-2.6.orig/drivers/net/wireless/Kconfig
+++ quilt-2.6/drivers/net/wireless/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Wireless LAN"
+	depends on !S390
 
 config WLAN_PRE80211
 	bool "Wireless LAN (pre-802.11)"
Index: quilt-2.6/net/Kconfig
===================================================================
--- quilt-2.6.orig/net/Kconfig
+++ quilt-2.6/net/Kconfig
@@ -218,6 +218,7 @@ config FIB_RULES
 	bool
 
 menu "Wireless"
+	depends on !S390
 
 source "net/wireless/Kconfig"
 source "net/mac80211/Kconfig"

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

