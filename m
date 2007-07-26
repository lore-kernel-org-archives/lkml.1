Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXGZQdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXGZQdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933922AbXGZQdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:33:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35049 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933893AbXGZQdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:33:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] more VIRT_TO_BUS dependencies
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6Gp-00059R-CL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:32:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9dcbffd..e204e7b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -509,7 +509,7 @@ config VIDEO_VINO
 
 config VIDEO_STRADIS
 	tristate "Stradis 4:2:2 MPEG-2 video driver  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && !PPC64
+	depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && VIRT_TO_BUS
 	help
 	  Say Y here to enable support for the Stradis 4:2:2 MPEG-2 video
 	  driver for PCI.  There is a product page at
@@ -520,7 +520,7 @@ config VIDEO_ZORAN_ZR36060
 
 config VIDEO_ZORAN
 	tristate "Zoran ZR36057/36067 Video For Linux"
-	depends on PCI && I2C_ALGOBIT && VIDEO_V4L1 && !PPC64
+	depends on PCI && I2C_ALGOBIT && VIDEO_V4L1 && VIRT_TO_BUS
 	help
 	  Say Y for support for MJPEG capture cards based on the Zoran
 	  36057/36067 PCI controller chipset. This includes the Iomega
-- 
1.5.3.GIT


