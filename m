Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0BVM1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:27:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36184 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0BVM1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KBK4kgCOIE/zJefwEs0L8hZfYXQrvs8dJDYbOjKR9zfw9yIHiddfAK45PNZ6FT4+Vx
         kX6Wejhi7cGbN6UuhsYUOGwarHjOd0IaoJXqe0JH5I8EXp55yA6o58NZZk6x+aS5OYtD
         o5EQgQ6ZA+Uez/Bi2SR+IU6s50Ek8R0GW5kVA=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 6/8] cdrom: fixed prohibited spaces coding style issues
Date: Mon, 22 Feb 2010 13:26:36 +0100
Message-Id: <1266841598-19662-6-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed all prohibited spaces.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 0062bf4..dc0abd1 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -315,7 +315,7 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
 
 #if (ERRLOGMASK != CD_NOTHING)
 #define cdinfo(type, fmt, args...) \
-        if ((ERRLOGMASK & type) || debug == 1 ) \
+        if ((ERRLOGMASK & type) || debug == 1) \
             printk(KERN_INFO "cdrom: " fmt, ## args)
 #else
 #define cdinfo(type, fmt, args...)
@@ -323,11 +323,11 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
 
 /* These are used to simplify getting data in from and back to user land */
 #define IOCTL_IN(arg, type, in)					\
-	if (copy_from_user(&(in), (type __user *) (arg), sizeof (in)))	\
+	if (copy_from_user(&(in), (type __user *) (arg), sizeof(in)))	\
 		return -EFAULT;
 
 #define IOCTL_OUT(arg, type, out) \
-	if (copy_to_user((type __user *) (arg), &(out), sizeof (out)))	\
+	if (copy_to_user((type __user *) (arg), &(out), sizeof(out)))	\
 		return -EFAULT;
 
 /* The (cdo->capability & ~cdi->mask & CDC_XXX) construct was used in
@@ -400,7 +400,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 		cdrom_sysctl_register();
 	}
 
-	ENSURE(drive_status, CDC_DRIVE_STATUS );
+	ENSURE(drive_status, CDC_DRIVE_STATUS);
 	ENSURE(media_changed, CDC_MEDIA_CHANGED);
 	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
 	ENSURE(lock_door, CDC_LOCK);
@@ -684,7 +684,7 @@ static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 	if (ret)
 		return ret;
 
-	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof (*rfd));
+	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof(*rfd));
 	return 0;
 }
 
@@ -2046,10 +2046,17 @@ static int cdrom_read_block(struct cdrom_device_info *cdi,
 
 	/* set the header info returned */
 	switch (blksize) {
-	case CD_FRAMESIZE_RAW0	: cgc->cmd[9] = 0x58; break;
-	case CD_FRAMESIZE_RAW1	: cgc->cmd[9] = 0x78; break;
-	case CD_FRAMESIZE_RAW	: cgc->cmd[9] = 0xf8; break;
-	default			: cgc->cmd[9] = 0x10;
+	case CD_FRAMESIZE_RAW0:
+		cgc->cmd[9] = 0x58;
+		break;
+	case CD_FRAMESIZE_RAW1:
+		cgc->cmd[9] = 0x78;
+		break;
+	case CD_FRAMESIZE_RAW:
+		cgc->cmd[9] = 0xf8;
+		break;
+	default:
+		cgc->cmd[9] = 0x10;
 	}
 
 	return cdo->generic_packet(cdi, cgc);
-- 
1.7.0

