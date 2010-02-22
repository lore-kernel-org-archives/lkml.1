Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0BVM1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:27:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36184 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0BVM1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HtGBjzMcR4olYqbyK+RNip16EE1sIMbnahbXkRaN5+aEWqfR++h6YecG3wsrU/0sJU
         I2cWulC7kHgcUagZMrQrQj4huIp7vffqzRvtGtntuBI/o5YGDtIyZGvTmVuk5Z8HulIR
         aB1Yu2srioxMGMf2X7XEpBlWSNqt3A/Gk5VxE=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 1/8] cdrom: removed trailing whitespaces
Date: Mon, 22 Feb 2010 13:26:31 +0100
Message-Id: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all trailing whitespace coding style issues.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |  200 ++++++++++++++++++++++++------------------------
 1 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e3749d0..f803426 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -63,8 +63,8 @@
 
 2.12  Jan  24, 1998 -- Erik Andersen <andersee@debian.org>
   -- Fixed a bug in the IOCTL_IN and IOCTL_OUT macros.  It turns out that
-  copy_*_user does not return EFAULT on error, but instead returns the number 
-  of bytes not copied.  I was returning whatever non-zero stuff came back from 
+  copy_*_user does not return EFAULT on error, but instead returns the number
+  of bytes not copied.  I was returning whatever non-zero stuff came back from
   the copy_*_user functions directly, which would result in strange errors.
 
 2.13  July 17, 1998 -- Erik Andersen <andersee@debian.org>
@@ -78,7 +78,7 @@
 
   2.14 August 17, 1998 -- Erik Andersen <andersee@debian.org>
   -- Fixed a bug in cdrom_media_changed and handling of reporting that
-  the media had changed for devices that _don't_ implement media_changed.  
+  the media had changed for devices that _don't_ implement media_changed.
   Thanks to Grant R. Guenther <grant@torque.net> for spotting this bug.
   -- Made a few things more pedanticly correct.
 
@@ -86,12 +86,12 @@
   -- New maintainers! Erik was too busy to continue the work on the driver,
   so now Chris Zwilling <chris@cloudnet.com> and Jens Axboe <axboe@image.dk>
   will do their best to follow in his footsteps
-  
+
   2.51 Dec 20, 1998 - Jens Axboe <axboe@image.dk>
   -- Check if drive is capable of doing what we ask before blindly changing
   cdi->options in various ioctl.
   -- Added version to proc entry.
-  
+
   2.52 Jan 16, 1999 - Jens Axboe <axboe@image.dk>
   -- Fixed an error in open_for_data where we would sometimes not return
   the correct error value. Thanks Huba Gaspar <huba@softcell.hu>.
@@ -100,7 +100,7 @@
   modules had entries in dev. Feb 02 - real bug was in sysctl.c where
   dev would be removed even though it was used. cdrom.c just illuminated
   that bug.
-  
+
   2.53 Feb 22, 1999 - Jens Axboe <axboe@image.dk>
   -- Fixup of several ioctl calls, in particular CDROM_SET_OPTIONS has
   been "rewritten" because capabilities and options aren't in sync. They
@@ -110,16 +110,16 @@
   -- Added CDROM_DEBUG ioctl. Enable debug messages on-the-fly.
   -- Added CDROM_GET_CAPABILITY ioctl. This relieves userspace programs
   from parsing /proc/sys/dev/cdrom/info.
-  
+
   2.54 Mar 15, 1999 - Jens Axboe <axboe@image.dk>
   -- Check capability mask from low level driver when counting tracks as
   per suggestion from Corey J. Scotts <cstotts@blue.weeg.uiowa.edu>.
-  
+
   2.55 Apr 25, 1999 - Jens Axboe <axboe@image.dk>
   -- autoclose was mistakenly checked against CDC_OPEN_TRAY instead of
   CDC_CLOSE_TRAY.
   -- proc info didn't mask against capabilities mask.
-  
+
   3.00 Aug 5, 1999 - Jens Axboe <axboe@image.dk>
   -- Unified audio ioctl handling across CD-ROM drivers. A lot of the
   code was duplicated before. Drives that support the generic packet
@@ -137,13 +137,13 @@
   -- Now default to checking media type.
   -- CDROM_SEND_PACKET ioctl added. The infrastructure was in place for
   doing this anyway, with the generic_packet addition.
-  
+
   3.01 Aug 6, 1999 - Jens Axboe <axboe@image.dk>
   -- Fix up the sysctl handling so that the option flags get set
   correctly.
   -- Fix up ioctl handling so the device specific ones actually get
   called :).
-  
+
   3.02 Aug 8, 1999 - Jens Axboe <axboe@image.dk>
   -- Fixed volume control on SCSI drives (or others with longer audio
   page).
@@ -152,7 +152,7 @@
   DVD structures and ioctls in the first place! He designed the original
   DVD patches for ide-cd and while I rearranged and unified them, the
   interface is still the same.
-  
+
   3.03 Sep 1, 1999 - Jens Axboe <axboe@image.dk>
   -- Moved the rest of the audio ioctls from the CD-ROM drivers here. Only
   CDROMREADTOCENTRY and CDROMREADTOCHDR are left.
@@ -177,7 +177,7 @@
   for ide-cd to handle multisession discs.
   -- Export cdrom_mode_sense and cdrom_mode_select.
   -- init_cdrom_command() for setting up a cgc command.
-  
+
   3.05 Oct 24, 1999 - Jens Axboe <axboe@image.dk>
   -- Changed the interface for CDROM_SEND_PACKET. Before it was virtually
   impossible to send the drive data in a sensible way.
@@ -210,7 +210,7 @@
   DVD_HOST_SEND_RPC_STATE did not set buffer size in cdb, and
   dvd_do_auth passed uninitialized data to drive because init_cdrom_command
   did not clear a 0 sized buffer.
-  
+
   3.09 May 12, 2000 - Jens Axboe <axboe@suse.de>
   -- Fix Video-CD on SCSI drives that don't support READ_CD command. In
   that case switch block size and issue plain READ_10 again, then switch
@@ -271,7 +271,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/slab.h> 
+#include <linux/slab.h>
 #include <linux/cdrom.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
@@ -318,7 +318,7 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
         if ((ERRLOGMASK & type) || debug==1 ) \
             printk(KERN_INFO "cdrom: " fmt, ## args)
 #else
-#define cdinfo(type, fmt, args...) 
+#define cdinfo(type, fmt, args...)
 #endif
 
 /* These are used to simplify getting data in from and back to user land */
@@ -347,7 +347,7 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
 static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			 struct cdrom_device_ops * cdo);
-static void sanitize_format(union cdrom_addr *addr, 
+static void sanitize_format(union cdrom_addr *addr,
 		u_char * curr, u_char requested);
 static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 		     unsigned long arg);
@@ -390,7 +390,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
         struct cdrom_device_ops *cdo = cdi->ops;
         int *change_capability = (int *)&cdo->capability; /* hack */
 
-	cdinfo(CD_OPEN, "entering register_cdrom\n"); 
+	cdinfo(CD_OPEN, "entering register_cdrom\n");
 
 	if (cdo->open == NULL || cdo->release == NULL)
 		return -EINVAL;
@@ -412,7 +412,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	cdi->mc_flags = 0;
 	cdo->n_minors = 0;
         cdi->options = CDO_USE_FFLAGS;
-	
+
 	if (autoclose==1 && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |= (int) CDO_AUTO_CLOSE;
 	if (autoeject==1 && CDROM_CAN(CDC_OPEN_TRAY))
@@ -443,7 +443,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 
 void unregister_cdrom(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
+	cdinfo(CD_OPEN, "entering unregister_cdrom\n");
 
 	mutex_lock(&cdrom_mutex);
 	list_del(&cdi->list);
@@ -887,7 +887,7 @@ static int cdrom_open_write(struct cdrom_device_info *cdi)
 		ram_write = 1;
 	else
 		(void) cdrom_is_random_writable(cdi, &ram_write);
-	
+
 	if (mrw)
 		cdi->mask &= ~CDC_MRW;
 	else
@@ -977,7 +977,7 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t
 {
 	int ret;
 
-	cdinfo(CD_OPEN, "entering cdrom_open\n"); 
+	cdinfo(CD_OPEN, "entering cdrom_open\n");
 
 	/* if this was a O_NONBLOCK open and we should honor the flags,
 	 * do a quick open without drive/disc integrity checks. */
@@ -1031,38 +1031,38 @@ int open_for_data(struct cdrom_device_info * cdi)
 	   can do clever things.  If it can't, well, we at least tried! */
 	if (cdo->drive_status != NULL) {
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		cdinfo(CD_OPEN, "drive_status=%d\n", ret); 
+		cdinfo(CD_OPEN, "drive_status=%d\n", ret);
 		if (ret == CDS_TRAY_OPEN) {
-			cdinfo(CD_OPEN, "the tray is open...\n"); 
+			cdinfo(CD_OPEN, "the tray is open...\n");
 			/* can/may i close it? */
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
-				cdinfo(CD_OPEN, "trying to close the tray.\n"); 
+				cdinfo(CD_OPEN, "trying to close the tray.\n");
 				ret=cdo->tray_move(cdi,0);
 				if (ret) {
-					cdinfo(CD_OPEN, "bummer. tried to close the tray but failed.\n"); 
+					cdinfo(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
-					couldn't close the tray.  We only care 
-					that there is no disc in the drive, 
+					couldn't close the tray.  We only care
+					that there is no disc in the drive,
 					since that is the _REAL_ problem here.*/
 					ret=-ENOMEDIUM;
 					goto clean_up_and_return;
 				}
 			} else {
-				cdinfo(CD_OPEN, "bummer. this drive can't close the tray.\n"); 
+				cdinfo(CD_OPEN, "bummer. this drive can't close the tray.\n");
 				ret=-ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
 			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
-				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n"); 
+				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n");
 				cdinfo(CD_OPEN, "tray might not contain a medium.\n");
 				ret=-ENOMEDIUM;
 				goto clean_up_and_return;
 			}
-			cdinfo(CD_OPEN, "the tray is now closed.\n"); 
+			cdinfo(CD_OPEN, "the tray is now closed.\n");
 		}
 		/* the door should be closed now, check for the disc */
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
@@ -1083,7 +1083,7 @@ int open_for_data(struct cdrom_device_info * cdi)
 		if (cdi->options & CDO_CHECK_TYPE) {
 		    /* give people a warning shot, now that CDO_CHECK_TYPE
 		       is the default case! */
-		    cdinfo(CD_OPEN, "bummer. wrong media type.\n"); 
+		    cdinfo(CD_OPEN, "bummer. wrong media type.\n");
 		    cdinfo(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
 					(unsigned int)task_pid_nr(current));
 		    ret=-EMEDIUMTYPE;
@@ -1094,32 +1094,32 @@ int open_for_data(struct cdrom_device_info * cdi)
 		}
 	}
 
-	cdinfo(CD_OPEN, "all seems well, opening the device.\n"); 
+	cdinfo(CD_OPEN, "all seems well, opening the device.\n");
 
 	/* all seems well, we can open the device */
 	ret = cdo->open(cdi, 0); /* open for data */
-	cdinfo(CD_OPEN, "opening the device gave me %d.\n", ret); 
+	cdinfo(CD_OPEN, "opening the device gave me %d.\n", ret);
 	/* After all this careful checking, we shouldn't have problems
-	   opening the device, but we don't want the device locked if 
+	   opening the device, but we don't want the device locked if
 	   this somehow fails... */
 	if (ret) {
-		cdinfo(CD_OPEN, "open device failed.\n"); 
+		cdinfo(CD_OPEN, "open device failed.\n");
 		goto clean_up_and_return;
 	}
 	if (CDROM_CAN(CDC_LOCK) && (cdi->options & CDO_LOCK)) {
 			cdo->lock_door(cdi, 1);
 			cdinfo(CD_OPEN, "door locked.\n");
 	}
-	cdinfo(CD_OPEN, "device opened successfully.\n"); 
+	cdinfo(CD_OPEN, "device opened successfully.\n");
 	return ret;
 
 	/* Something failed.  Try to unlock the drive, because some drivers
 	(notably ide-cd) lock the drive after every command.  This produced
-	a nasty bug where after mount failed, the drive would remain locked!  
-	This ensures that the drive gets unlocked after a mount fails.  This 
-	is a goto to avoid bloating the driver with redundant code. */ 
+	a nasty bug where after mount failed, the drive would remain locked!
+	This ensures that the drive gets unlocked after a mount fails.  This
+	is a goto to avoid bloating the driver with redundant code. */
 clean_up_and_return:
-	cdinfo(CD_OPEN, "open failed.\n"); 
+	cdinfo(CD_OPEN, "open failed.\n");
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
 			cdo->lock_door(cdi, 0);
 			cdinfo(CD_OPEN, "door unlocked.\n");
@@ -1140,42 +1140,42 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 		return 0;
 	if (cdo->drive_status != NULL) {
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		cdinfo(CD_OPEN, "drive_status=%d\n", ret); 
+		cdinfo(CD_OPEN, "drive_status=%d\n", ret);
 		if (ret == CDS_TRAY_OPEN) {
-			cdinfo(CD_OPEN, "the tray is open...\n"); 
+			cdinfo(CD_OPEN, "the tray is open...\n");
 			/* can/may i close it? */
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
-				cdinfo(CD_OPEN, "trying to close the tray.\n"); 
+				cdinfo(CD_OPEN, "trying to close the tray.\n");
 				ret=cdo->tray_move(cdi,0);
 				if (ret) {
-					cdinfo(CD_OPEN, "bummer. tried to close tray but failed.\n"); 
+					cdinfo(CD_OPEN, "bummer. tried to close tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
-					couldn't close the tray.  We only care 
-					that there is no disc in the drive, 
+					couldn't close the tray.  We only care
+					that there is no disc in the drive,
 					since that is the _REAL_ problem here.*/
 					return -ENOMEDIUM;
 				}
 			} else {
-				cdinfo(CD_OPEN, "bummer. this driver can't close the tray.\n"); 
+				cdinfo(CD_OPEN, "bummer. this driver can't close the tray.\n");
 				return -ENOMEDIUM;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
 			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
-				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n"); 
+				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n");
 				return -ENOMEDIUM;
-			}	
+			}
 			if (ret!=CDS_DISC_OK) {
-				cdinfo(CD_OPEN, "bummer. disc isn't ready.\n"); 
+				cdinfo(CD_OPEN, "bummer. disc isn't ready.\n");
 				return -EIO;
-			}	
-			cdinfo(CD_OPEN, "the tray is now closed.\n"); 
-		}	
+			}
+			cdinfo(CD_OPEN, "the tray is now closed.\n");
+		}
 	}
 	cdrom_count_tracks(cdi, &tracks);
-	if (tracks.error) 
+	if (tracks.error)
 		return(tracks.error);
 
 	if (tracks.audio==0)
@@ -1221,7 +1221,7 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 	}
 }
 
-static int cdrom_read_mech_status(struct cdrom_device_info *cdi, 
+static int cdrom_read_mech_status(struct cdrom_device_info *cdi,
 				  struct cdrom_changer_info *buf)
 {
 	struct packet_command cgc;
@@ -1258,10 +1258,10 @@ static int cdrom_slot_status(struct cdrom_device_info *cdi, int slot)
 	struct cdrom_changer_info *info;
 	int ret;
 
-	cdinfo(CD_CHANGER, "entering cdrom_slot_status()\n"); 
+	cdinfo(CD_CHANGER, "entering cdrom_slot_status()\n");
 	if (cdi->sanyo_slot)
 		return CDS_NO_INFO;
-	
+
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
@@ -1279,18 +1279,18 @@ out_free:
 	return ret;
 }
 
-/* Return the number of slots for an ATAPI/SCSI cdrom, 
- * return 1 if not a changer. 
+/* Return the number of slots for an ATAPI/SCSI cdrom,
+ * return 1 if not a changer.
  */
-int cdrom_number_of_slots(struct cdrom_device_info *cdi) 
+int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 {
 	int status;
 	int nslots = 1;
 	struct cdrom_changer_info *info;
 
-	cdinfo(CD_CHANGER, "entering cdrom_number_of_slots()\n"); 
+	cdinfo(CD_CHANGER, "entering cdrom_number_of_slots()\n");
 	/* cdrom_read_mech_status requires a valid value for capacity: */
-	cdi->capacity = 0; 
+	cdi->capacity = 0;
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -1305,11 +1305,11 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 
 
 /* If SLOT < 0, unload the current slot.  Otherwise, try to load SLOT. */
-static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot) 
+static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot)
 {
 	struct packet_command cgc;
 
-	cdinfo(CD_CHANGER, "entering cdrom_load_unload()\n"); 
+	cdinfo(CD_CHANGER, "entering cdrom_load_unload()\n");
 	if (cdi->sanyo_slot && slot < 0)
 		return 0;
 
@@ -1319,7 +1319,7 @@ static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot)
 	cgc.cmd[8] = slot;
 	cgc.timeout = 60 * HZ;
 
-	/* The Sanyo 3 CD changer uses byte 7 of the 
+	/* The Sanyo 3 CD changer uses byte 7 of the
 	GPCMD_TEST_UNIT_READY to command to switch CDs instead of
 	using the GPCMD_LOAD_UNLOAD opcode. */
 	if (cdi->sanyo_slot && -1 < slot) {
@@ -1338,7 +1338,7 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	int curslot;
 	int ret;
 
-	cdinfo(CD_CHANGER, "entering cdrom_select_disc()\n"); 
+	cdinfo(CD_CHANGER, "entering cdrom_select_disc()\n");
 	if (!CDROM_CAN(CDC_SELECT_DISC))
 		return -EDRIVE_CANT_DO_THIS;
 
@@ -1372,7 +1372,7 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 
 	/* Specifying CDSL_CURRENT will attempt to load the currnet slot,
 	which is useful if it had been previously unloaded.
-	Whether it can or not, it returns the current slot. 
+	Whether it can or not, it returns the current slot.
 	Similarly,  if slot happens to be the current one, we still
 	try and load it. */
 	if (slot == CDSL_CURRENT)
@@ -1412,9 +1412,9 @@ int media_changed(struct cdrom_device_info *cdi, int queue)
 
 int cdrom_media_changed(struct cdrom_device_info *cdi)
 {
-	/* This talks to the VFS, which doesn't like errors - just 1 or 0.  
-	 * Returning "0" is always safe (media hasn't been changed). Do that 
-	 * if the low-level cdrom driver dosn't support media changed. */ 
+	/* This talks to the VFS, which doesn't like errors - just 1 or 0.
+	 * Returning "0" is always safe (media hasn't been changed). Do that
+	 * if the low-level cdrom driver dosn't support media changed. */
 	if (cdi == NULL || cdi->ops->media_changed == NULL)
 		return 0;
 	if (!CDROM_CAN(CDC_MEDIA_CHANGED))
@@ -1433,7 +1433,7 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 	tracks->cdi=0;
 	tracks->xa=0;
 	tracks->error=0;
-	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n"); 
+	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
 	/* Grab the TOC header so we can see how many tracks there are */
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
 		if (ret == -ENOMEDIUM)
@@ -1441,7 +1441,7 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 		else
 			tracks->error = CDS_NO_INFO;
 		return;
-	}	
+	}
 	/* check what type of tracks are on this disc */
 	entry.cdte_format = CDROM_MSF;
 	for (i = header.cdth_trk0; i <= header.cdth_trk1; i++) {
@@ -1449,11 +1449,11 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 		if (cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &entry)) {
 			tracks->error=CDS_NO_INFO;
 			return;
-		}	
+		}
 		if (entry.cdte_ctrl & CDROM_DATA_TRACK) {
 		    if (entry.cdte_format == 0x10)
 			tracks->cdi++;
-		    else if (entry.cdte_format == 0x20) 
+		    else if (entry.cdte_format == 0x20)
 			tracks->xa++;
 		    else
 			tracks->data++;
@@ -1461,11 +1461,11 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 		    tracks->audio++;
 		cdinfo(CD_COUNT_TRACKS, "track %d: format=%d, ctrl=%d\n",
 		       i, entry.cdte_format, entry.cdte_ctrl);
-	}	
-	cdinfo(CD_COUNT_TRACKS, "disc has %d tracks: %d=audio %d=data %d=Cd-I %d=XA\n", 
-		header.cdth_trk1, tracks->audio, tracks->data, 
+	}
+	cdinfo(CD_COUNT_TRACKS, "disc has %d tracks: %d=audio %d=data %d=Cd-I %d=XA\n",
+		header.cdth_trk1, tracks->audio, tracks->data,
 		tracks->cdi, tracks->xa);
-}	
+}
 
 /* Requests to the low-level drivers will /always/ be done in the
    following format convention:
@@ -1578,7 +1578,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	switch (ai->type) {
 	/* LU data send */
 	case DVD_LU_SEND_AGID:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_AGID\n"); 
+		cdinfo(CD_DVD, "entering DVD_LU_SEND_AGID\n");
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lsa.agid, 0);
 
@@ -1590,7 +1590,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_LU_SEND_KEY1:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_KEY1\n"); 
+		cdinfo(CD_DVD, "entering DVD_LU_SEND_KEY1\n");
 		setup_report_key(&cgc, ai->lsk.agid, 2);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
@@ -1601,7 +1601,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_LU_SEND_CHALLENGE:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_CHALLENGE\n"); 
+		cdinfo(CD_DVD, "entering DVD_LU_SEND_CHALLENGE\n");
 		setup_report_key(&cgc, ai->lsc.agid, 1);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
@@ -1613,7 +1613,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 	/* Post-auth key */
 	case DVD_LU_SEND_TITLE_KEY:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_TITLE_KEY\n"); 
+		cdinfo(CD_DVD, "entering DVD_LU_SEND_TITLE_KEY\n");
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lstk.agid, 4);
 		cgc.cmd[5] = ai->lstk.lba;
@@ -1632,9 +1632,9 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_LU_SEND_ASF:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_ASF\n"); 
+		cdinfo(CD_DVD, "entering DVD_LU_SEND_ASF\n");
 		setup_report_key(&cgc, ai->lsasf.agid, 5);
-		
+
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
 			return ret;
 
@@ -1643,7 +1643,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 	/* LU data receive (LU changes state) */
 	case DVD_HOST_SEND_CHALLENGE:
-		cdinfo(CD_DVD, "entering DVD_HOST_SEND_CHALLENGE\n"); 
+		cdinfo(CD_DVD, "entering DVD_HOST_SEND_CHALLENGE\n");
 		setup_send_key(&cgc, ai->hsc.agid, 1);
 		buf[1] = 0xe;
 		copy_chal(&buf[4], ai->hsc.chal);
@@ -1655,7 +1655,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_HOST_SEND_KEY2:
-		cdinfo(CD_DVD, "entering DVD_HOST_SEND_KEY2\n"); 
+		cdinfo(CD_DVD, "entering DVD_HOST_SEND_KEY2\n");
 		setup_send_key(&cgc, ai->hsk.agid, 3);
 		buf[1] = 0xa;
 		copy_key(&buf[4], ai->hsk.key);
@@ -1670,7 +1670,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	/* Misc */
 	case DVD_INVALIDATE_AGID:
 		cgc.quiet = 1;
-		cdinfo(CD_DVD, "entering DVD_INVALIDATE_AGID\n"); 
+		cdinfo(CD_DVD, "entering DVD_INVALIDATE_AGID\n");
 		setup_report_key(&cgc, ai->lsa.agid, 0x3f);
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
 			return ret;
@@ -1903,7 +1903,7 @@ static int dvd_read_struct(struct cdrom_device_info *cdi, dvd_struct *s,
 
 	case DVD_STRUCT_MANUFACT:
 		return dvd_read_manufact(cdi, s, cgc);
-		
+
 	default:
 		cdinfo(CD_WARNING, ": Invalid DVD structure read requested (%d)\n",
 					s->type);
@@ -2019,7 +2019,7 @@ static int cdrom_read_block(struct cdrom_device_info *cdi,
 	cgc->cmd[7] = (nblocks >>  8) & 0xff;
 	cgc->cmd[8] = nblocks & 0xff;
 	cgc->buflen = blksize * nblocks;
-	
+
 	/* set the header info returned */
 	switch (blksize) {
 	case CD_FRAMESIZE_RAW0	: cgc->cmd[9] = 0x58; break;
@@ -2027,7 +2027,7 @@ static int cdrom_read_block(struct cdrom_device_info *cdi,
 	case CD_FRAMESIZE_RAW	: cgc->cmd[9] = 0xf8; break;
 	default			: cgc->cmd[9] = 0x10;
 	}
-	
+
 	return cdo->generic_packet(cdi, cgc);
 }
 
@@ -2191,7 +2191,7 @@ retry:
 
 	printk("cdrom: dropping to old style cdda (sense=%x)\n", cdi->last_sense);
 	cdi->cdda_method = CDDA_OLD;
-	return cdrom_read_cdda_old(cdi, ubuf, lba, nframes);	
+	return cdrom_read_cdda_old(cdi, ubuf, lba, nframes);
 }
 
 static int cdrom_ioctl_multisession(struct cdrom_device_info *cdi,
@@ -2964,7 +2964,7 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 	ret = cdrom_mode_sense(cdi, cgc, GPMODE_AUDIO_CTL_PAGE, 0);
 	if (ret)
 		return ret;
-		
+
 	/* originally the code depended on buffer[1] to determine
 	   how much data is available for transfer. buffer[1] is
 	   unfortunately ambigious and the only reliable way seem
@@ -2997,7 +2997,7 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 		IOCTL_OUT(arg, struct cdrom_volctrl, volctrl);
 		return 0;
 	}
-		
+
 	/* get the volume mask */
 	cgc->buffer = mask;
 	ret = cdrom_mode_sense(cdi, cgc, GPMODE_AUDIO_CTL_PAGE, 1);
@@ -3176,7 +3176,7 @@ static int cdrom_get_track_info(struct cdrom_device_info *cdi, __u16 track, __u8
 
 	if ((ret = cdo->generic_packet(cdi, &cgc)))
 		return ret;
-	
+
 	buflen = be16_to_cpu(ti->track_information_length) +
 		     sizeof(ti->track_information_length);
 
@@ -3418,7 +3418,7 @@ static int cdrom_sysctl_info(ctl_table *ctl, int write,
 	int pos;
 	char *info = cdrom_sysctl_settings.info;
 	const int max_size = sizeof(cdrom_sysctl_settings.info);
-	
+
 	if (!*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
@@ -3427,7 +3427,7 @@ static int cdrom_sysctl_info(ctl_table *ctl, int write,
 	mutex_lock(&cdrom_mutex);
 
 	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
-	
+
 	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
 		goto done;
 	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
@@ -3529,11 +3529,11 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
-	
+
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 
 	if (write) {
-	
+
 		/* we only care for 1 or 0. */
 		autoclose        = !!cdrom_sysctl_settings.autoclose;
 		autoeject        = !!cdrom_sysctl_settings.autoeject;
@@ -3554,7 +3554,7 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write,
 static ctl_table cdrom_table[] = {
 	{
 		.procname	= "info",
-		.data		= &cdrom_sysctl_settings.info, 
+		.data		= &cdrom_sysctl_settings.info,
 		.maxlen		= CDROM_STR_SIZE,
 		.mode		= 0444,
 		.proc_handler	= cdrom_sysctl_info,
-- 
1.7.0

