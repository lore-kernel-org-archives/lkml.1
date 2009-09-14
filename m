Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZINWTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZINWTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZINWTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:19:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794AbZINWTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:19:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] Input: ad7879: add support for AD7889
Date: Mon, 14 Sep 2009 18:19:32 -0400
Message-Id: <1252966772-27645-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The AD7889 is a new part but 100% software compatible with the AD7879, so
add it to the id_table and help text.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/input/touchscreen/Kconfig  |    6 +++---
 drivers/input/touchscreen/ad7879.c |    6 ++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 72e2712..be5e9f6 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -48,8 +48,8 @@ config TOUCHSCREEN_AD7879_I2C
 	select TOUCHSCREEN_AD7879
 	help
 	  Say Y here if you have a touchscreen interface using the
-	  AD7879-1 controller, and your board-specific initialization
-	  code includes that in its table of I2C devices.
+	  AD7879-1/AD7889-1 controller, and your board-specific
+	  initialization code includes that in its table of I2C devices.
 
 	  If unsure, say N (but it's safe to say "Y").
 
@@ -62,7 +62,7 @@ config TOUCHSCREEN_AD7879_SPI
 	select TOUCHSCREEN_AD7879
 	help
 	  Say Y here if you have a touchscreen interface using the
-	  AD7879 controller, and your board-specific initialization
+	  AD7879/AD7889 controller, and your board-specific initialization
 	  code includes that in its table of SPI devices.
 
 	  If unsure, say N (but it's safe to say "Y").
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index 5d8a703..8064641 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (C) 2008 Michael Hennerich, Analog Devices Inc.
+ * Copyright (C) 2008-2009 Michael Hennerich, Analog Devices Inc.
  *
- * Description:	AD7879 based touchscreen, and GPIO driver (I2C/SPI Interface)
+ * Description:	AD7879/AD7889 based touchscreen, and GPIO driver
+ *		(I2C/SPI Interface)
  *
  * Bugs:        Enter bugs at http://blackfin.uclinux.org/
  *
@@ -747,6 +748,7 @@ static int __devexit ad7879_remove(struct i2c_client *client)
 
 static const struct i2c_device_id ad7879_id[] = {
 	{ "ad7879", 0 },
+	{ "ad7889", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ad7879_id);
-- 
1.6.4.2

