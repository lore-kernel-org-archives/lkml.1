Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZD0JdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZD0JdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZD0JdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:33:14 -0400
Received: from smtp6.welho.com ([213.243.153.40]:35795 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZD0JdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:33:13 -0400
Date: Mon, 27 Apr 2009 12:33:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] mfd/pcf50633-gpio.c: add MODULE_LICENSE
Message-ID: <20090427093334.GD9259@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mfd/pcf50633-gpio.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/drivers/mfd/pcf50633-gpio.c b/drivers/mfd/pcf50633-gpio.c
index 2fa2eca..9ab19a8 100644
--- a/drivers/mfd/pcf50633-gpio.c
+++ b/drivers/mfd/pcf50633-gpio.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/gpio.h>
@@ -116,3 +117,5 @@ int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
 	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);
+
+MODULE_LICENSE("GPL");

