Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKDNrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKDNrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 08:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYKDNrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 08:47:14 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:58938 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbYKDNrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:47:13 -0500
Date: Tue, 4 Nov 2008 21:47:07 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: remove duplicated #include
Message-ID: <20081104134707.GA32622@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] drivers: remove duplicated #include

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 drivers/mtd/onenand/omap2.c     |    1 -
 drivers/net/atl1e/atl1e.h       |    1 -
 drivers/net/ucc_geth_ethtool.c  |    1 -
 drivers/pnp/interface.c         |    1 -
 drivers/sbus/char/jsflash.c     |    1 -
 drivers/staging/echo/echo.c     |    1 -
 drivers/staging/me4000/me4000.c |    1 -
 drivers/xen/balloon.c           |    1 -
 8 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index 8387e05..e39b21d 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -38,7 +38,6 @@
 #include <asm/arch/gpmc.h>
 #include <asm/arch/onenand.h>
 #include <asm/arch/gpio.h>
-#include <asm/arch/gpmc.h>
 #include <asm/arch/pm.h>
 
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/atl1e/atl1e.h b/drivers/net/atl1e/atl1e.h
index b645fa0..c49550d 100644
--- a/drivers/net/atl1e/atl1e.h
+++ b/drivers/net/atl1e/atl1e.h
@@ -46,7 +46,6 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/tcp.h>
-#include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
 #include <linux/workqueue.h>
diff --git a/drivers/net/ucc_geth_ethtool.c b/drivers/net/ucc_geth_ethtool.c
index cfbbfee..85f38a6 100644
--- a/drivers/net/ucc_geth_ethtool.c
+++ b/drivers/net/ucc_geth_ethtool.c
@@ -37,7 +37,6 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/types.h>
-#include <asm/uaccess.h>
 
 #include "ucc_geth.h"
 #include "ucc_geth_mii.h"
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index 478a4a7..c3f1c8e 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -12,7 +12,6 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/types.h>
-#include <linux/pnp.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 2bec9cc..a9a9893 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -36,7 +36,6 @@
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
 
diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index b8f2c5e..fd4007e 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -106,7 +106,6 @@
 
 #include <linux/kernel.h>	/* We're doing kernel work */
 #include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/slab.h>
 
 #include "bit_operations.h"
diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index cf8b01b..0394e27 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -39,7 +39,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 /* Include-File for the Meilhaus ME-4000 I/O board */
 #include "me4000.h"
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 8c83abc..a0fb5ea 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -41,7 +41,6 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
-#include <linux/highmem.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>
 
-- 
1.5.6.3

