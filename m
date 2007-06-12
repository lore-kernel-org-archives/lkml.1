Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbXFLPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbXFLPyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbXFLPyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:54:08 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:61078 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbXFLPyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:54:07 -0400
Date: Wed, 13 Jun 2007 00:54:38 +0900 (JST)
Message-Id: <20070613.005438.126760855.anemo@mba.ocn.ne.jp>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org
Subject: [PATCH] i2c-gpio: Make some internal functions static
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_gpio_getsda() and i2c_gpio_getscl() are only used in this file.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index a7dd546..ca74092 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -63,14 +63,14 @@ static void i2c_gpio_setscl_val(void *data, int state)
 	gpio_set_value(pdata->scl_pin, state);
 }
 
-int i2c_gpio_getsda(void *data)
+static int i2c_gpio_getsda(void *data)
 {
 	struct i2c_gpio_platform_data *pdata = data;
 
 	return gpio_get_value(pdata->sda_pin);
 }
 
-int i2c_gpio_getscl(void *data)
+static int i2c_gpio_getscl(void *data)
 {
 	struct i2c_gpio_platform_data *pdata = data;
 
