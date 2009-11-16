Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZKPETG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZKPETG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZKPETE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:19:04 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZKPETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:19:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i4zXtX6f6hupGg6QF82f7GqSpwdhehM73CQTuQjOcYRF86B/mQmg/svf1UVnQ64Y8G
         3N7Hv1XLEckCbSbsYmtPXDXNfoEr3R8Abr7Kroc/NL++hPIDOzUcrd1NTrdC0bu3U2Ls
         847GeVQBqvKQUqDBl8dGGRgxkWJ8tuAqmPaYQ=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 09/13] staging: line6: Lindent and fix some checkpatch warnings in toneport.c
Date: Sun, 15 Nov 2009 22:17:58 -0600
Message-Id: <1258345082-11811-10-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/toneport.c |   99 +++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index eaa1229..84bf29c 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -17,10 +17,8 @@
 #include "playback.h"
 #include "toneport.h"
 
-
 static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2);
 
-
 static struct snd_ratden toneport_ratden = {
 	.num_min = 44100,
 	.num_max = 44100,
@@ -29,47 +27,44 @@ static struct snd_ratden toneport_ratden = {
 };
 
 static struct line6_pcm_properties toneport_pcm_properties = {
-  .snd_line6_playback_hw = {
-		.info = (SNDRV_PCM_INFO_MMAP |
-						 SNDRV_PCM_INFO_INTERLEAVED |
-						 SNDRV_PCM_INFO_BLOCK_TRANSFER |
-						 SNDRV_PCM_INFO_MMAP_VALID |
-						 SNDRV_PCM_INFO_PAUSE |
-						 SNDRV_PCM_INFO_SYNC_START),
-		.formats =          SNDRV_PCM_FMTBIT_S16_LE,
-		.rates =            SNDRV_PCM_RATE_KNOT,
-		.rate_min =         44100,
-		.rate_max =         44100,
-		.channels_min =     2,
-		.channels_max =     2,
-		.buffer_bytes_max = 60000,
-		.period_bytes_min = 180 * 4,
-		.period_bytes_max = 8192,
-		.periods_min =      1,
-		.periods_max =      1024
-	},
-  .snd_line6_capture_hw = {
-		.info = (SNDRV_PCM_INFO_MMAP |
-						 SNDRV_PCM_INFO_INTERLEAVED |
-						 SNDRV_PCM_INFO_BLOCK_TRANSFER |
-						 SNDRV_PCM_INFO_MMAP_VALID |
-						 SNDRV_PCM_INFO_SYNC_START),
-		.formats =          SNDRV_PCM_FMTBIT_S16_LE,
-		.rates =            SNDRV_PCM_RATE_KNOT,
-		.rate_min =         44100,
-		.rate_max =         44100,
-		.channels_min =     2,
-		.channels_max =     2,
-		.buffer_bytes_max = 60000,
-		.period_bytes_min = 188 * 4,
-		.period_bytes_max = 8192,
-		.periods_min =      1,
-		.periods_max =      1024
-	},
+	.snd_line6_playback_hw = {
+				  .info = (SNDRV_PCM_INFO_MMAP |
+					   SNDRV_PCM_INFO_INTERLEAVED |
+					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					   SNDRV_PCM_INFO_MMAP_VALID |
+					   SNDRV_PCM_INFO_PAUSE |
+					   SNDRV_PCM_INFO_SYNC_START),
+				  .formats = SNDRV_PCM_FMTBIT_S16_LE,
+				  .rates = SNDRV_PCM_RATE_KNOT,
+				  .rate_min = 44100,
+				  .rate_max = 44100,
+				  .channels_min = 2,
+				  .channels_max = 2,
+				  .buffer_bytes_max = 60000,
+				  .period_bytes_min = 180 * 4,
+				  .period_bytes_max = 8192,
+				  .periods_min = 1,
+				  .periods_max = 1024},
+	.snd_line6_capture_hw = {
+				 .info = (SNDRV_PCM_INFO_MMAP |
+					  SNDRV_PCM_INFO_INTERLEAVED |
+					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					  SNDRV_PCM_INFO_MMAP_VALID |
+					  SNDRV_PCM_INFO_SYNC_START),
+				 .formats = SNDRV_PCM_FMTBIT_S16_LE,
+				 .rates = SNDRV_PCM_RATE_KNOT,
+				 .rate_min = 44100,
+				 .rate_max = 44100,
+				 .channels_min = 2,
+				 .channels_max = 2,
+				 .buffer_bytes_max = 60000,
+				 .period_bytes_min = 188 * 4,
+				 .period_bytes_max = 8192,
+				 .periods_min = 1,
+				 .periods_max = 1024},
 	.snd_line6_rates = {
-		.nrats = 1,
-		.rats = &toneport_ratden
-	},
+			    .nrats = 1,
+			    .rats = &toneport_ratden},
 	.bytes_per_frame = 4
 };
 
@@ -117,9 +112,10 @@ static ssize_t toneport_set_led_green(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(led_red, S_IWUGO | S_IRUGO, line6_nop_read, toneport_set_led_red);
-static DEVICE_ATTR(led_green, S_IWUGO | S_IRUGO, line6_nop_read, toneport_set_led_green);
-
+static DEVICE_ATTR(led_red, S_IWUGO | S_IRUGO, line6_nop_read,
+		   toneport_set_led_red);
+static DEVICE_ATTR(led_green, S_IWUGO | S_IRUGO, line6_nop_read,
+		   toneport_set_led_green);
 
 static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2)
 {
@@ -196,16 +192,18 @@ int toneport_init(struct usb_interface *interface,
 	line6_write_data(line6, 0x80c6, &ticks, 4);
 
 	/*
-	seems to work without the first two...
-	*/
+	   seems to work without the first two...
+	 */
 	/* toneport_send_cmd(usbdev, 0x0201, 0x0002); */
 	/* toneport_send_cmd(usbdev, 0x0801, 0x0000); */
 	/* only one that works for me; on GP, TP might be different? */
 	toneport_send_cmd(usbdev, 0x0301, 0x0000);
 
 	if (usbdev->descriptor.idProduct != LINE6_DEVID_GUITARPORT) {
-		CHECK_RETURN(device_create_file(&interface->dev, &dev_attr_led_red));
-		CHECK_RETURN(device_create_file(&interface->dev, &dev_attr_led_green));
+		CHECK_RETURN(device_create_file
+			     (&interface->dev, &dev_attr_led_red));
+		CHECK_RETURN(device_create_file
+			     (&interface->dev, &dev_attr_led_green));
 		toneport_update_led(&usbdev->dev);
 	}
 
@@ -223,7 +221,8 @@ void toneport_disconnect(struct usb_interface *interface)
 		return;
 	toneport = usb_get_intfdata(interface);
 
-	if (toneport->line6.usbdev->descriptor.idProduct != LINE6_DEVID_GUITARPORT) {
+	if (toneport->line6.usbdev->descriptor.idProduct !=
+	    LINE6_DEVID_GUITARPORT) {
 		device_remove_file(&interface->dev, &dev_attr_led_red);
 		device_remove_file(&interface->dev, &dev_attr_led_green);
 	}
-- 
1.6.5

