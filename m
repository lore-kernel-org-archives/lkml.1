Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYEKCPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYEKCPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 22:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYEKCPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 22:15:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61104 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753041AbYEKCPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 22:15:42 -0400
Date: Sun, 11 May 2008 03:14:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] I2C: SiByte: Mark i2c_sibyte_add_bus() as static
Message-ID: <Pine.LNX.4.55.0805110311170.18978@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The i2c_sibyte_add_bus() function is not called, nor meant to, from 
outside, so mark it as static; fixing a sparse warning too.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It should be obvious.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-sibyte-i2c-sparse-16
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c
--- linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c	2008-05-05 02:55:25.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c	2008-05-11 01:11:00.000000000 +0000
@@ -132,7 +132,7 @@ static const struct i2c_algorithm i2c_si
 /*
  * registering functions to load algorithms at runtime
  */
-int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
+static int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
 {
 	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
 
