Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0CJLXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:23:10 -0500
Received: from smtp.nokia.com ([192.100.105.134]:58244 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0CJLXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:23:06 -0500
From: Luciano Coelho <luciano.coelho@Nokia.com>
To: linville@tuxdriver.com
Cc: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       ext-teemu.3.paasikivi@Nokia.com
Subject: [PATCH] wl1271: Changed wl1271_sdio to be selectable only on ARM
Date: Wed, 10 Mar 2010 13:22:31 +0200
Message-Id: <1268220151-19431-1-git-send-email-luciano.coelho@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268219993.10194.82.camel@chilepepper>
References: <1268219993.10194.82.camel@chilepepper>
X-OriginalArrivalTime: 10 Mar 2010 11:22:32.0668 (UTC) FILETIME=[FA3639C0:01CAC043]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

As wl1271_sdio implementation depends on ARM GPIO impelementation it is
not directly usable on other architectures at the moment. Added
ARM dependency to kernel configuration option.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 2f67335..337fc7b 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -53,7 +53,7 @@ config WL1271
 	  unsure.
 
 config WL1271_SPI
-	tristate "TI wl1251 SPI support"
+	tristate "TI wl1271 SPI support"
 	depends on WL1271 && SPI_MASTER
 	---help---
 	  This module adds support for the SPI interface of adapters using
@@ -65,7 +65,7 @@ config WL1271_SPI
 
 config WL1271_SDIO
 	tristate "TI wl1271 SDIO support"
-	depends on WL1271 && MMC
+	depends on WL1271 && MMC && ARM
 	---help---
 	  This module adds support for the SDIO interface of adapters using
 	  TI wl1271 chipset.  Select this if your platform is using
-- 
1.6.3.3

