Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYEKCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYEKCMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 22:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYEKCMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 22:12:10 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61072 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752724AbYEKCMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 22:12:09 -0400
Date: Sun, 11 May 2008 03:10:29 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] I2C: SiByte: Correct a comment about frequency
Message-ID: <Pine.LNX.4.55.0805110302400.18978@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The frequency may have been once hardcoded to 100kHz, but currently it is
passed as an argument to i2c_sibyte_add_bus(), so update the comment to
match code.  While at it, reformat a nearby comment for consistency.  No
functional changes.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It should be obvious.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-sibyte-i2c-add-bus-16
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c
--- linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c	2008-05-05 02:55:25.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c	2008-05-11 01:14:30.000000000 +0000
@@ -136,10 +136,10 @@ int __init i2c_sibyte_add_bus(struct i2c
 {
 	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
 
-	/* register new adapter to i2c module... */
+	/* Register new adapter to i2c module... */
 	i2c_adap->algo = &i2c_sibyte_algo;
 
-	/* Set the frequency to 100 kHz */
+	/* Set the requested frequency. */
 	csr_out32(speed, SMB_CSR(adap,R_SMB_FREQ));
 	csr_out32(0, SMB_CSR(adap,R_SMB_CONTROL));
 
