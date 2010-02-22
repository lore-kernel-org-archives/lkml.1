Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0BVM2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:28:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56602 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0BVM1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oK7QT25KOVjkgeLHFINYWpzGxHNSQk7jQQTJqaKI+CtbnaD2tlYgDDs7KG9nlg/jXO
         5ZwOj5eMh+4r12wbmlUAQWrekzaJ82y9DxzK2uR1qhthXnBSPt3SJNxLDkBFeEyISNyf
         vuL1huo70k5i6U71Ovd5eYKwIhYfFrrjDerwQ=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 4/8] cdrom: added some spaces to fix coding style issues
Date: Mon, 22 Feb 2010 13:26:34 +0100
Message-Id: <1266841598-19662-4-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added required spaces around binary operators and after commas.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |   66 ++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index fdd251e..6a4f0ab 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -288,7 +288,7 @@ static int debug;
 /* used to keep tray locked at all times */
 static int keeplocked;
 /* default compatibility mode */
-static int autoclose=1;
+static int autoclose = 1;
 static int autoeject;
 static int lockdoor = 1;
 /* will we ever get to use this... sigh. */
@@ -313,9 +313,9 @@ static const char *mrw_format_status[] = {
 
 static const char *mrw_address_space[] = { "DMA", "GAA" };
 
-#if (ERRLOGMASK!=CD_NOTHING)
+#if (ERRLOGMASK != CD_NOTHING)
 #define cdinfo(type, fmt, args...) \
-        if ((ERRLOGMASK & type) || debug==1 ) \
+        if ((ERRLOGMASK & type) || debug == 1 ) \
             printk(KERN_INFO "cdrom: " fmt, ## args)
 #else
 #define cdinfo(type, fmt, args...)
@@ -335,7 +335,7 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
 #define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
 
 /* used in the audio ioctls */
-#define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
+#define CHECKAUDIO if ((ret = check_for_audio_disc(cdi, cdo))) return ret
 
 /*
  * Another popular OS uses 7 seconds as the hard timeout for default
@@ -413,13 +413,13 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	cdo->n_minors = 0;
         cdi->options = CDO_USE_FFLAGS;
 
-	if (autoclose==1 && CDROM_CAN(CDC_CLOSE_TRAY))
+	if (autoclose == 1 && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |= (int) CDO_AUTO_CLOSE;
-	if (autoeject==1 && CDROM_CAN(CDC_OPEN_TRAY))
+	if (autoeject == 1 && CDROM_CAN(CDC_OPEN_TRAY))
 		cdi->options |= (int) CDO_AUTO_EJECT;
-	if (lockdoor==1)
+	if (lockdoor == 1)
 		cdi->options |= (int) CDO_LOCK;
-	if (check_media_type==1)
+	if (check_media_type == 1)
 		cdi->options |= (int) CDO_CHECK_TYPE;
 
 	if (CDROM_CAN(CDC_MRW_W))
@@ -617,7 +617,7 @@ static int cdrom_mrw_exit(struct cdrom_device_info *cdi)
 	int ret;
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < (int)offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < (int)offsetof(typeof(di), disc_type))
 		return 1;
 
 	ret = 0;
@@ -767,7 +767,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	}
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < offsetof(typeof(di), disc_type))
 		return 1;
 
 	if (!di.erasable)
@@ -1038,7 +1038,7 @@ int open_for_data(struct cdrom_device_info *cdi)
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cdinfo(CD_OPEN, "trying to close the tray.\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
 					cdinfo(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
@@ -1046,27 +1046,27 @@ int open_for_data(struct cdrom_device_info *cdi)
 					couldn't close the tray.  We only care
 					that there is no disc in the drive,
 					since that is the _REAL_ problem here.*/
-					ret=-ENOMEDIUM;
+					ret = -ENOMEDIUM;
 					goto clean_up_and_return;
 				}
 			} else {
 				cdinfo(CD_OPEN, "bummer. this drive can't close the tray.\n");
-				ret=-ENOMEDIUM;
+				ret = -ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
 				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n");
 				cdinfo(CD_OPEN, "tray might not contain a medium.\n");
-				ret=-ENOMEDIUM;
+				ret = -ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			cdinfo(CD_OPEN, "the tray is now closed.\n");
 		}
 		/* the door should be closed now, check for the disc */
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		if (ret!=CDS_DISC_OK) {
+		if (ret != CDS_DISC_OK) {
 			ret = -ENOMEDIUM;
 			goto clean_up_and_return;
 		}
@@ -1074,19 +1074,19 @@ int open_for_data(struct cdrom_device_info *cdi)
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error == CDS_NO_DISC) {
 		cdinfo(CD_OPEN, "bummer. no disc.\n");
-		ret=-ENOMEDIUM;
+		ret = -ENOMEDIUM;
 		goto clean_up_and_return;
 	}
 	/* CD-Players which don't use O_NONBLOCK, workman
 	 * for example, need bit CDO_CHECK_TYPE cleared! */
-	if (tracks.data==0) {
+	if (tracks.data == 0) {
 		if (cdi->options & CDO_CHECK_TYPE) {
 		    /* give people a warning shot, now that CDO_CHECK_TYPE
 		       is the default case! */
 		    cdinfo(CD_OPEN, "bummer. wrong media type.\n");
 		    cdinfo(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
 					(unsigned int)task_pid_nr(current));
-		    ret=-EMEDIUMTYPE;
+		    ret = -EMEDIUMTYPE;
 		    goto clean_up_and_return;
 		} else {
 		    cdinfo(CD_OPEN, "wrong media type, but CDO_CHECK_TYPE not set.\n");
@@ -1146,7 +1146,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cdinfo(CD_OPEN, "trying to close the tray.\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
 					cdinfo(CD_OPEN, "bummer. tried to close tray but failed.\n");
 					/* Ignore the error from the low
@@ -1162,11 +1162,11 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
 				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n");
 				return -ENOMEDIUM;
 			}
-			if (ret!=CDS_DISC_OK) {
+			if (ret != CDS_DISC_OK) {
 				cdinfo(CD_OPEN, "bummer. disc isn't ready.\n");
 				return -EIO;
 			}
@@ -1177,7 +1177,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
 	if (tracks.error)
 		return(tracks.error);
 
-	if (tracks.audio==0)
+	if (tracks.audio == 0)
 		return -EMEDIUMTYPE;
 
 	return 0;
@@ -1426,11 +1426,11 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 	struct cdrom_tochdr header;
 	struct cdrom_tocentry entry;
 	int ret, i;
-	tracks->data=0;
-	tracks->audio=0;
-	tracks->cdi=0;
-	tracks->xa=0;
-	tracks->error=0;
+	tracks->data = 0;
+	tracks->audio = 0;
+	tracks->cdi = 0;
+	tracks->xa = 0;
+	tracks->error = 0;
 	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
 	/* Grab the TOC header so we can see how many tracks there are */
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
@@ -1445,7 +1445,7 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 	for (i = header.cdth_trk0; i <= header.cdth_trk1; i++) {
 		entry.cdte_track  = i;
 		if (cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &entry)) {
-			tracks->error=CDS_NO_INFO;
+			tracks->error = CDS_NO_INFO;
 			return;
 		}
 		if (entry.cdte_ctrl & CDROM_DATA_TRACK) {
@@ -1515,8 +1515,8 @@ void init_cdrom_command(struct packet_command *cgc, void *buf, int len,
 
 /* DVD handling */
 
-#define copy_key(dest,src)	memcpy((dest), (src), sizeof(dvd_key))
-#define copy_chal(dest,src)	memcpy((dest), (src), sizeof(dvd_challenge))
+#define copy_key(dest, src)	memcpy((dest), (src), sizeof(dvd_key))
+#define copy_chal(dest, src)	memcpy((dest), (src), sizeof(dvd_challenge))
 
 static void setup_report_key(struct packet_command *cgc, unsigned agid, unsigned type)
 {
@@ -2501,7 +2501,7 @@ static int cdrom_ioctl_disc_status(struct cdrom_device_info *cdi)
 		return CDS_DATA_1;
 	/* Policy mode off */
 
-	cdinfo(CD_WARNING,"This disc doesn't have any tracks I recognize!\n");
+	cdinfo(CD_WARNING, "This disc doesn't have any tracks I recognize!\n");
 	return CDS_NO_INFO;
 }
 
@@ -3248,7 +3248,7 @@ int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
 
 	/* if this track is blank, try the previous. */
 	if (ti.blank) {
-		if (last_track==1)
+		if (last_track == 1)
 			goto use_toc;
 		last_track--;
 		ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
-- 
1.7.0

