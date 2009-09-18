Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZIRUpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZIRUpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbZIRUpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:45:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44597 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbZIRUpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:45:04 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Sep 2009 22:44:44 +0200
Message-Id: <1253306686-20616-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
References: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 2/4] regulator: drop 'default n'
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifying 'default n' is superfluous.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/regulator/Kconfig |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..19663fe 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -1,6 +1,5 @@
 menuconfig REGULATOR
 	bool "Voltage and Current Regulator Support"
-	default n
 	help
 	  Generic Voltage and Current Regulator support.
 
@@ -30,7 +29,6 @@ config REGULATOR_DEBUG
 
 config REGULATOR_FIXED_VOLTAGE
 	tristate "Fixed voltage regulator support"
-	default n
 	help
 	  This driver provides support for fixed voltage regulators,
 	  useful for systems which use a combination of software
@@ -38,7 +36,6 @@ config REGULATOR_FIXED_VOLTAGE
 
 config REGULATOR_VIRTUAL_CONSUMER
 	tristate "Virtual regulator consumer support"
-	default n
 	help
 	  This driver provides a virtual consumer for the voltage and
           current regulator API which provides sysfs controls for
@@ -49,7 +46,6 @@ config REGULATOR_VIRTUAL_CONSUMER
 
 config REGULATOR_USERSPACE_CONSUMER
 	tristate "Userspace regulator consumer support"
-	default n
 	help
 	  There are some classes of devices that are controlled entirely
 	  from user space. Usersapce consumer driver provides ability to
@@ -59,7 +55,6 @@ config REGULATOR_USERSPACE_CONSUMER
 
 config REGULATOR_BQ24022
 	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
-	default n
 	help
 	  This driver controls a TI bq24022 Charger attached via
 	  GPIOs. The provided current regulator can enable/disable
@@ -69,7 +64,6 @@ config REGULATOR_BQ24022
 config REGULATOR_MAX1586
 	tristate "Maxim 1586/1587 voltage regulator"
 	depends on I2C
-	default n
 	help
 	  This driver controls a Maxim 1586 or 1587 voltage output
 	  regulator via I2C bus. The provided regulator is suitable
-- 
1.6.3.3

