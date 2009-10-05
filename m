Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZJEVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZJEVPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZJEVPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:15:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55033 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbZJEVP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:15:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/3] mtd/maps: gpio-addr-flash: pull in linux/ headers rather than asm/
Date: Mon,  5 Oct 2009 17:14:48 -0400
Message-Id: <1254777289-32109-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
References: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there are linux/ versions of gpio.h and io.h, include those
rather than hitting the asm/ versions.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/maps/gpio-addr-flash.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index 44ef9a4..1ad5caf 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -13,7 +13,9 @@
  * Licensed under the GPL-2 or later.
  */
 
+#include <linux/gpio.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mtd/mtd.h>
@@ -23,9 +25,6 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 
-#include <asm/gpio.h>
-#include <asm/io.h>
-
 #define pr_devinit(fmt, args...) ({ static const __devinitconst char __fmt[] = fmt; printk(__fmt, ## args); })
 
 #define DRIVER_NAME "gpio-addr-flash"
-- 
1.6.5.rc2

