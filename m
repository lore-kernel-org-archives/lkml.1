Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYDWJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYDWJ50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYDWJwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:52:17 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59453 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbYDWJwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:52:13 -0400
Date: Wed, 23 Apr 2008 12:51:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jochen Friedrich <jochen@scram.de>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [2.6 patch] drivers/of/of_i2c.c: add MODULE_LICENSE
Message-ID: <20080423095134.GZ28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 585468e5d5962660867c269e26f0a4b89a599473
([POWERPC] i2c: Fix build breakage introduced by OF helpers)
drivers/of/of_i2c.c needs a MODULE_LICENSE.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/of/of_i2c.c |    3 +++
 1 file changed, 3 insertions(+)

946ca8103416a313577b0b9d52d30541fe7eef85 diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 6316891..715a444 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -13,6 +13,7 @@
 
 #include <linux/i2c.h>
 #include <linux/of.h>
+#include <linux/module.h>
 
 struct i2c_driver_device {
 	char    *of_device;
@@ -113,3 +114,5 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 	}
 }
 EXPORT_SYMBOL(of_register_i2c_devices);
+
+MODULE_LICENSE("GPL");

