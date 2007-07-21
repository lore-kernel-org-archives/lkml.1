Return-Path: <linux-kernel-owner+w=401wt.eu-S938207AbXGUPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938207AbXGUPJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939232AbXGUPDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938650AbXGUPDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=oWcnusaKh+DwOAoasCBlVxQ4NtOcQhHJBalPpEqvdU5eYoQfh/I9hZ8u1HAawzLSF2xA6zm3roZeE5YYP7m74npDVqEO/TW5FaYNOI20ECzranup89cd9NFFyaTx1/gsbOl7L6ZtND7PzoUYvuUNq3LmobIoiHq/jVQt3MtZ3zw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][11/37] Clean up duplicate includes in drivers/mtd/
Date: Sat, 21 Jul 2007 17:02:36 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>,
       Thayne Harbaugh <tharbaugh@lnxi.com>,
       Mike Lavender <mike@steroidmicros.com>,
       Thies Moeller <thies.moeller@baslerweb.com>,
       Thomas Koeller <thomas.koeller@baslerweb.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.37086.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/mtd/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 58e561e..f8aa287 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -17,7 +17,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 78c2511..474a55e 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
-#include <linux/interrupt.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
diff --git a/drivers/mtd/nand/excite_nandflash.c b/drivers/mtd/nand/excite_nandflash.c
index 7e9afc4..bed8729 100644
--- a/drivers/mtd/nand/excite_nandflash.c
+++ b/drivers/mtd/nand/excite_nandflash.c
@@ -27,7 +27,6 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/err.h>
-#include <linux/kernel.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
