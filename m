Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769Ab0AVExI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0AVExI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992Ab0AVExA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:00 -0500
Received: from mail.perches.com ([173.55.12.10]:1338 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0AVEw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:56 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/24] drivers/block/floppy.c: Convert some #include <asm/ to #include <linux/
Date: Thu, 21 Jan 2010 20:52:31 -0800
Message-Id: <e526517439fffcd4ede9f8c98867abf79a600afa.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3266b4f..a62f211 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -180,6 +180,8 @@ static int print_unex = 1;
 #include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
@@ -191,8 +193,6 @@ static int slow_floppy;
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/system.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
 
 static int FLOPPY_IRQ = 6;
 static int FLOPPY_DMA = 2;
-- 
1.6.6.rc0.57.gad7a

