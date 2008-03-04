Return-Path: <linux-kernel-owner+w=401wt.eu-S1765952AbYCDQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765952AbYCDQgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765364AbYCDQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:50 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48614 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765462AbYCDQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:49 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 04/11] memstick: drop DRIVER_VERSION numbers as meaningless
Date: Wed,  5 Mar 2008 03:02:21 +1100
Message-Id: <1204646548-27466-5-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c    |    2 --
 drivers/memstick/core/mspro_block.c |    2 --
 drivers/memstick/host/tifm_ms.c     |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index decd6a4..de80dba 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 
 #define DRIVER_NAME "memstick"
-#define DRIVER_VERSION "0.2"
 
 static unsigned int cmd_retries = 3;
 module_param(cmd_retries, uint, 0644);
@@ -636,4 +635,3 @@ module_exit(memstick_exit);
 MODULE_AUTHOR("Alex Dubov");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Sony MemoryStick core driver");
-MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 214211c..00e74ea 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -19,7 +19,6 @@
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
-#define DRIVER_VERSION "0.2"
 
 static int major;
 module_param(major, int, 0644);
@@ -1348,4 +1347,3 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("Sony MemoryStickPro block device driver");
 MODULE_DEVICE_TABLE(memstick, mspro_block_id_tbl);
-MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 8b1c102..c62e709 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -20,7 +20,6 @@
 #include <asm/io.h>
 
 #define DRIVER_NAME "tifm_ms"
-#define DRIVER_VERSION "0.1"
 
 static int no_dma;
 module_param(no_dma, bool, 0644);
@@ -678,7 +677,6 @@ MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("TI FlashMedia MemoryStick driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(tifm, tifm_ms_id_tbl);
-MODULE_VERSION(DRIVER_VERSION);
 
 module_init(tifm_ms_init);
 module_exit(tifm_ms_exit);
-- 
1.5.3.6

