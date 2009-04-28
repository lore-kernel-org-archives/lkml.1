Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZD1KO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZD1KO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZD1KN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:13:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54737 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755203AbZD1KN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:13:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Set MODULE_ALIAS for regulator drivers
Date: Tue, 28 Apr 2009 11:13:55 +0100
Message-Id: <1240913635-22404-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240913635-22404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1240913635-22404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the regulator drivers didn't have MODULE_ALIAS so couldn't be
auto loaded. Add the MODULE_ALIAS in case they do get built as modules.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c            |    1 +
 drivers/regulator/virtual.c          |    1 +
 drivers/regulator/wm8350-regulator.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 4c525af..cdc674f 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -141,3 +141,4 @@ module_exit(regulator_fixed_voltage_exit);
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("Fixed voltage regulator");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:reg-fixed-voltage");
diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 3d08348..8820900 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -347,3 +347,4 @@ module_exit(regulator_virtual_consumer_exit);
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("Virtual regulator consumer");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:reg-virt-consumer");
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 771eca1..17a00b0 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1570,3 +1570,4 @@ module_exit(wm8350_regulator_exit);
 MODULE_AUTHOR("Liam Girdwood");
 MODULE_DESCRIPTION("WM8350 voltage and current regulator driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-regulator");
-- 
1.6.2.4

