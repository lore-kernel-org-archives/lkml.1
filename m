Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766Ab0AVExp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0AVExp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998Ab0AVExK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1367 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab0AVExC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:02 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 21/24] drivers/block/floppy.c: remove #define DEVICE_NAME "floppy"
Date: Thu, 21 Jan 2010 20:52:51 -0800
Message-Id: <17ebc4240486606ea2b891da0fee0fd653ea3129.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use it directly in the one place it's used

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5e3286d..7132ee4 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -250,8 +250,6 @@ static int allowed_drive_mask = 0x33;
 
 static int irqdma_allocated;
 
-#define DEVICE_NAME "floppy"
-
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/cdrom.h>	/* for the compatibility eject ioctl */
@@ -312,7 +310,7 @@ static int initialising = 1;
 #define UFDCS	(&fdc_state[FDC(drive)])
 
 #define DPRINT(format, args...) \
-	pr_info(DEVICE_NAME "%d: " format, current_drive, ##args)
+	pr_info("floppy%d: " format, current_drive, ##args)
 
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
-- 
1.6.6.rc0.57.gad7a

