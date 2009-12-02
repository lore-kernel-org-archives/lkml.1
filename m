Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZLBGJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZLBGJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZLBGHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:54 -0500
Received: from mail.perches.com ([173.55.12.10]:1228 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZLBGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:50 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 09/13] drivers/block/floppy.c: remove #define DEVICE_NAME "floppy"
Date: Tue,  1 Dec 2009 22:07:49 -0800
Message-Id: <2249f646682f34ebf63b08c77ff45f366fd1cf47.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use it directly in the one place it's used

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 96b1b21..cc76f3d 100644
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
 #define STRETCH(floppy) ((floppy)->stretch & FD_STRETCH)
-- 
1.6.6.rc0.57.gad7a

