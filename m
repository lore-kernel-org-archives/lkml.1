Return-Path: <linux-kernel-owner+w=401wt.eu-S1751028AbXEXR5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbXEXR5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXEXR5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:57:42 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3446 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbXEXR5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:57:41 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] add missing braces in dm driver debug code
Date: Thu, 24 May 2007 19:57:39 +0200
User-Agent: KMail/1.9.5
Cc: Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241957.39667.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Add missing braces in md debug macros.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -upr linux-2.6.22-rc2-mm1-a/drivers/md/dm.h linux-2.6.22-rc2-mm1-b/drivers/md/dm.h
--- linux-2.6.22-rc2-mm1-a/drivers/md/dm.h  2007-05-23 13:04:21.000000000 +0200
+++ linux-2.6.22-rc2-mm1-b/drivers/md/dm.h  2007-05-24 19:23:46.000000000 +0200
@@ -25,7 +25,7 @@
        if (printk_ratelimit()) \
            printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
                   f "\n", ## arg); \
-   while (0)
+   } while (0)
 
 #define DMWARN(f, arg...) \
    printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
@@ -34,7 +34,7 @@
        if (printk_ratelimit()) \
            printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
                   f "\n", ## arg); \
-   while (0)
+   } while (0)
 
 #define DMINFO(f, arg...) \
    printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
@@ -43,7 +43,7 @@
        if (printk_ratelimit()) \
            printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
                   "\n", ## arg); \
-   while (0)
+   } while (0)
 
 #ifdef CONFIG_DM_DEBUG
 #  define DMDEBUG(f, arg...) \
@@ -53,7 +53,7 @@
        if (printk_ratelimit()) \
            printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
                   "\n", ## arg); \
-   while (0)
+   } while (0)
 #else
 #  define DMDEBUG(f, arg...) do {} while (0)
 #  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
