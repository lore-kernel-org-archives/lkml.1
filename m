Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0BVM1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:27:23 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50207 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab0BVM1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vG93p7J2GZRQmhAPSfrjZ2Xq8OZJZ2iSYY6QeuTZQ4HHtK9fGonI3EgPtRNXYy+F0K
         Cxiowula2jdxjtNJ9nfjZqGIm4J2zaIVHSRkvQeKvVzyspR4HnDwB+wH5m6mTp5urEzb
         K+gldr+F0gzc2X0dsTt0FDrT39YI5gn7/Bd8k=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 7/8] cdrom: fixed indentation coding style issues
Date: Mon, 22 Feb 2010 13:26:37 +0100
Message-Id: <1266841598-19662-7-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all indentation coding style issues

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index dc0abd1..4d96369 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -315,8 +315,8 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
 
 #if (ERRLOGMASK != CD_NOTHING)
 #define cdinfo(type, fmt, args...) \
-        if ((ERRLOGMASK & type) || debug == 1) \
-            printk(KERN_INFO "cdrom: " fmt, ## args)
+	if ((ERRLOGMASK & type) || debug == 1) \
+		printk(KERN_INFO "cdrom: " fmt, ## args)
 #else
 #define cdinfo(type, fmt, args...)
 #endif
@@ -387,8 +387,8 @@ static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 int register_cdrom(struct cdrom_device_info *cdi)
 {
 	static char banner_printed;
-        struct cdrom_device_ops *cdo = cdi->ops;
-        int *change_capability = (int *)&cdo->capability; /* hack */
+	struct cdrom_device_ops *cdo = cdi->ops;
+	int *change_capability = (int *)&cdo->capability; /* hack */
 
 	cdinfo(CD_OPEN, "entering register_cdrom\n");
 
@@ -411,7 +411,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	ENSURE(generic_packet, CDC_GENERIC_PACKET);
 	cdi->mc_flags = 0;
 	cdo->n_minors = 0;
-        cdi->options = CDO_USE_FFLAGS;
+	cdi->options = CDO_USE_FFLAGS;
 
 	if (autoclose == 1 && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |= (int) CDO_AUTO_CLOSE;
@@ -917,9 +917,9 @@ static int cdrom_open_write(struct cdrom_device_info *cdi)
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
 		ret = cdrom_dvdram_open_write(cdi);
- 	else if (CDROM_CAN(CDC_RAM) &&
- 		 !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW|CDC_MO_DRIVE))
- 		ret = cdrom_ram_open_write(cdi);
+	else if (CDROM_CAN(CDC_RAM) &&
+		 !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW|CDC_MO_DRIVE))
+		ret = cdrom_ram_open_write(cdi);
 	else if (CDROM_CAN(CDC_MO_DRIVE))
 		ret = mo_open_write(cdi);
 	else if (!cdrom_is_dvd_rw(cdi))
@@ -1142,7 +1142,7 @@ clean_up_and_return:
 static int check_for_audio_disc(struct cdrom_device_info *cdi,
 				struct cdrom_device_ops *cdo)
 {
-        int ret;
+	int ret;
 	tracktype tracks;
 	cdinfo(CD_OPEN, "entering check_for_audio_disc\n");
 	if (!(cdi->options & CDO_CHECK_TYPE))
@@ -1185,7 +1185,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
 	}
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error)
-		return(tracks.error);
+		return tracks.error;
 
 	if (tracks.audio == 0)
 		return -EMEDIUMTYPE;
@@ -1376,7 +1376,7 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 
 	if (cdi->use_count > 1 || keeplocked) {
 		if (slot == CDSL_CURRENT)
-	    		return curslot;
+			return curslot;
 		else
 			return -EBUSY;
 	}
@@ -2447,7 +2447,7 @@ static int cdrom_ioctl_debug(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_get_capability(struct cdrom_device_info *cdi)
 {
 	cdinfo(CD_DO_IOCTL, "entering CDROM_GET_CAPABILITY\n");
-	return (cdi->ops->capability & ~cdi->mask);
+	return cdi->ops->capability & ~cdi->mask;
 }
 
 /*
@@ -3345,7 +3345,7 @@ static int cdrom_get_next_writable(struct cdrom_device_info *cdi, long *next_wri
 	if (ti_size < 0 || ti_size < offsetof(typeof(ti), track_start))
 		goto use_last_written;
 
-        /* if this track is blank, try the previous. */
+	/* if this track is blank, try the previous. */
 	if (ti.blank) {
 		if (last_track == 1)
 			goto use_last_written;
@@ -3450,7 +3450,7 @@ static int cdrom_print_info(const char *header, int val, char *info,
 }
 
 static int cdrom_sysctl_info(ctl_table *ctl, int write,
-                           void __user *buffer, size_t *lenp, loff_t *ppos)
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int pos;
 	char *info = cdrom_sysctl_settings.info;
@@ -3584,7 +3584,7 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write,
 		cdrom_update_settings();
 	}
 
-        return ret;
+	return ret;
 }
 
 /* Place files in /proc/sys/dev/cdrom */
-- 
1.7.0

