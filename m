Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbXEOThV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbXEOThV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbXEOTgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:36:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761545AbXEOTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:36:41 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] em28xx and ivtv should depend on PCI
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
Message-Id: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:36:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/em28xx/Kconfig |    2 +-
 drivers/media/video/ivtv/Kconfig   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index 3823b62..2c450bd 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_EM28XX
 	tristate "Empia EM2800/2820/2840 USB video capture support"
-	depends on VIDEO_V4L1 && I2C
+	depends on VIDEO_V4L1 && I2C && PCI
 	select VIDEO_BUF
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/video/ivtv/Kconfig
index e854f3f..0cc98a0 100644
--- a/drivers/media/video/ivtv/Kconfig
+++ b/drivers/media/video/ivtv/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
-	depends on VIDEO_V4L1 && VIDEO_V4L2 && USB && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L1 && VIDEO_V4L2 && USB && I2C && EXPERIMENTAL && PCI
 	select FW_LOADER
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-- 
1.5.0-rc2.GIT


