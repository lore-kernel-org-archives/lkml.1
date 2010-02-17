Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0BQSph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:45:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56901 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753825Ab0BQSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:45:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] gpiolib: Correct debugfs display of WM831x GPIO inversion
Date: Wed, 17 Feb 2010 18:45:24 +0000
Message-Id: <1266432326-13030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/wm831x-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
index c5a00f7..2554180 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -176,7 +176,7 @@ static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			   wm831x_gpio_get(chip, i) ? "high" : "low",
 			   pull,
 			   powerdomain,
-			   reg & WM831X_GPN_POL ? " inverted" : "",
+			   reg & WM831X_GPN_POL ? "" : " inverted",
 			   reg & WM831X_GPN_OD ? "open-drain" : "CMOS",
 			   reg & WM831X_GPN_TRI ? " tristated" : "",
 			   reg);
-- 
1.6.6.1

