Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZIRUpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZIRUpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbZIRUpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:45:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44589 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbZIRUpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:45:00 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Sep 2009 22:44:43 +0200
Message-Id: <1253306686-20616-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
References: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 1/4] regulator: fix typos
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple of typos I found while working with this subsystem.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/power/regulator/machine.txt |    4 ++--
 include/linux/regulator/machine.h         |    6 +++---
 include/linux/regulator/max1586.h         |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index ce3487d..63728fe 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -87,7 +87,7 @@ static struct platform_device regulator_devices[] = {
 },
 };
 /* register regulator 1 device */
-platform_device_register(&wm8350_regulator_devices[0]);
+platform_device_register(&regulator_devices[0]);
 
 /* register regulator 2 device */
-platform_device_register(&wm8350_regulator_devices[1]);
+platform_device_register(&regulator_devices[1]);
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index bac64fa..91aceae 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -41,7 +41,7 @@ struct regulator;
 #define REGULATOR_CHANGE_DRMS		0x10
 
 /**
- * struct regulator_state - regulator state during low power syatem states
+ * struct regulator_state - regulator state during low power system states
  *
  * This describes a regulators state during a system wide low power state.
  *
@@ -117,10 +117,10 @@ struct regulation_constraints {
 	/* mode to set on startup */
 	unsigned int initial_mode;
 
-	/* constriant flags */
+	/* constraint flags */
 	unsigned always_on:1;	/* regulator never off when system is on */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
-	unsigned apply_uV:1;	/* apply uV constraint iff min == max */
+	unsigned apply_uV:1;	/* apply uV constraint if min == max */
 };
 
 /**
diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
index 4456319..de9a7fa 100644
--- a/include/linux/regulator/max1586.h
+++ b/include/linux/regulator/max1586.h
@@ -36,7 +36,7 @@
  * max1586_subdev_data - regulator data
  * @id: regulator Id (either MAX1586_V3 or MAX1586_V6)
  * @name: regulator cute name (example for V3: "vcc_core")
- * @platform_data: regulator init data (contraints, supplies, ...)
+ * @platform_data: regulator init data (constraints, supplies, ...)
  */
 struct max1586_subdev_data {
 	int				id;
@@ -46,7 +46,7 @@ struct max1586_subdev_data {
 
 /**
  * max1586_platform_data - platform data for max1586
- * @num_subdevs: number of regultors used (may be 1 or 2)
+ * @num_subdevs: number of regulators used (may be 1 or 2)
  * @subdevs: regulator used
  *           At most, there will be a regulator for V3 and one for V6 voltages.
  * @v3_gain: gain on the V3 voltage output multiplied by 1e6.
-- 
1.6.3.3

