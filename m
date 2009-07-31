Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZGaR7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZGaR7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZGaR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:59:55 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:29991 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300AbZGaR7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:59:54 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: include <linux/gpio.h> not <asm/gpio.h>
Date: Fri, 31 Jul 2009 10:59:50 -0700
Cc: David Brownell <dbrownell@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311059.51142.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should be including <linux/gpio.h> not <asm/gpio.h>.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index 984b587..fd1c54d 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -46,8 +46,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 /* Steal the hardware definitions from the bttv driver. */
 #include "../media/video/bt8xx/bt848.h"
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index f6fae0e..125f921 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -6,12 +6,10 @@
 #include <linux/device.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
-
+#include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/mcp23s08.h>
 
-#include <asm/gpio.h>
-
 
 /* Registers are all 8 bits wide.
  *
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index cdb6574..8f8fefd 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #ifdef CONFIG_OF_GPIO
@@ -20,8 +21,6 @@
 #include <linux/of_gpio.h>
 #endif
 
-#include <asm/gpio.h>
-
 #define PCA953X_INPUT          0
 #define PCA953X_OUTPUT         1
 #define PCA953X_INVERT         2
diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/pcf857x.c
index 9525724..72f2449 100644
--- a/drivers/gpio/pcf857x.c
+++ b/drivers/gpio/pcf857x.c
@@ -20,11 +20,10 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
 
-#include <asm/gpio.h>
-
 
 static const struct i2c_device_id pcf857x_id[] = {
 	{ "pcf8574", 8 },
