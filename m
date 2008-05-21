Return-Path: <linux-kernel-owner+w=401wt.eu-S934978AbYEUBIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978AbYEUBIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933146AbYEUBHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:07:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48460 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbYEUBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:07:12 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing dependencies on HAS_DMA
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JycnP-0008Lk-LO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:07:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 2430
Lines: 75

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/Kconfig            |    2 +-
 drivers/mmc/host/Kconfig               |    2 +-
 drivers/net/Kconfig                    |    2 +-
 drivers/net/wireless/b43/Kconfig       |    2 +-
 drivers/net/wireless/b43legacy/Kconfig |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 89d8d37..3b26fbd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -901,7 +901,7 @@ endif # V4L_USB_DRIVERS
 
 config SOC_CAMERA
 	tristate "SoC camera support"
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2 && HAS_DMA
 	select VIDEOBUF_DMA_SG
 	help
 	  SoC Camera is a common API to several cameras, not connecting
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 3b3cd0e..dead617 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -119,7 +119,7 @@ config MMC_TIFM_SD
 
 config MMC_SPI
 	tristate "MMC/SD over SPI"
-	depends on MMC && SPI_MASTER && !HIGHMEM
+	depends on MMC && SPI_MASTER && !HIGHMEM && HAS_DMA
 	select CRC7
 	select CRC_ITU_T
 	help
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9f6cc8a..dd0ec9e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1353,7 +1353,7 @@ config APRICOT
 
 config B44
 	tristate "Broadcom 440x/47xx ethernet support"
-	depends on SSB_POSSIBLE
+	depends on SSB_POSSIBLE && HAS_DMA
 	select SSB
 	select MII
 	help
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index f51b2d9..1fa043d 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -1,6 +1,6 @@
 config B43
 	tristate "Broadcom 43xx wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211
+	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
 	select HW_RANDOM
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 13c65fa..aef2298 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -1,6 +1,6 @@
 config B43LEGACY
 	tristate "Broadcom 43xx-legacy wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211
+	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
 	select HW_RANDOM
-- 
1.5.3.GIT


