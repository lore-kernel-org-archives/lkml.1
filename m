Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbXKMVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbXKMVcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759995AbXKMVcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:32:18 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49308 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759837AbXKMVcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:32:16 -0500
Date: Tue, 13 Nov 2007 22:32:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: khali@linux-fr.org
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] drivers/i2c: Drop redundant includes of moduleparam.h
Message-ID: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Send to:
khali@linux-fr.org,
i2c@lm-sensors.org,
linux-kernel@vger.kernel.org,
kernel-janitors@vger.kernel.org

Subject: [PATCH 1/4] drivers/i2c: Drop redundant includes of moduleparam.h


------------------------------------------------------

From: Julia Lawall <julia@diku.dk>

Drop #include <linux/moduleparam.h> in files that also include #include
<linux/module.h>.  module.h includes moduleparam.h already.

The semantic patch implementing this change is as follows:

@ includesmodule @
@@

#include <linux/module.h>

@ depends on includesmodule @
@@

- #include <linux/moduleparam.h>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
--- a/drivers/i2c/algos/i2c-algo-pca.c 2007-10-22 11:25:06.000000000 +0200
+++ b/drivers/i2c/algos/i2c-algo-pca.c 2007-11-13 17:49:31.000000000 +0100
@@ -19,7 +19,6 @@

  #include <linux/kernel.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/delay.h>
  #include <linux/slab.h>
  #include <linux/init.h>
diff -u -p -b -B a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
--- a/drivers/i2c/busses/i2c-piix4.c 2007-09-09 08:31:35.000000000 +0200
+++ b/drivers/i2c/busses/i2c-piix4.c 2007-11-13 17:49:33.000000000 +0100
@@ -30,7 +30,6 @@
  */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/pci.h>
  #include <linux/kernel.h>
  #include <linux/delay.h>
diff -u -p -b -B a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
--- a/drivers/i2c/busses/i2c-pca-isa.c 2007-06-02 22:32:11.000000000 +0200
+++ b/drivers/i2c/busses/i2c-pca-isa.c 2007-11-13 17:49:34.000000000 +0100
@@ -20,7 +20,6 @@
  #include <linux/kernel.h>
  #include <linux/ioport.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/delay.h>
  #include <linux/slab.h>
  #include <linux/init.h>
