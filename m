Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0BVM1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:27:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50207 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0BVM1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LoYM9i/Wui+Eg/kkb8qY0WaXRbI47wYQ4ZLmS4QdIXRScntsOYrfh3PWFJhq3EGoPQ
         cK8To2kBdjv251Y/2sd4ysVtwiS3ju/qfThCNyy9GcCdhGx1StYYSX+F2tFMKz6VvB6U
         CThn/kVhyetMocIVJOMN+knh5CRsm2Q6uVrTo=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 2/8] cdrom: adjoined pointer asterisks to data names
Date: Mon, 22 Feb 2010 13:26:32 +0100
Message-Id: <1266841598-19662-2-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed "foo * bar" should be "foo *bar" coding style errors.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index f803426..2088868 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -344,11 +344,11 @@ static const char *mrw_address_space[] = { "DMA", "GAA" };
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
 /* Not-exported routines. */
-static int open_for_data(struct cdrom_device_info * cdi);
-static int check_for_audio_disc(struct cdrom_device_info * cdi,
-			 struct cdrom_device_ops * cdo);
+static int open_for_data(struct cdrom_device_info *cdi);
+static int check_for_audio_disc(struct cdrom_device_info *cdi,
+			 struct cdrom_device_ops *cdo);
 static void sanitize_format(union cdrom_addr *addr,
-		u_char * curr, u_char requested);
+		u_char *curr, u_char requested);
 static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 		     unsigned long arg);
 
@@ -1021,7 +1021,7 @@ err:
 }
 
 static
-int open_for_data(struct cdrom_device_info * cdi)
+int open_for_data(struct cdrom_device_info *cdi)
 {
 	int ret;
 	struct cdrom_device_ops *cdo = cdi->ops;
@@ -1130,8 +1130,8 @@ clean_up_and_return:
 /* This code is similar to that in open_for_data. The routine is called
    whenever an audio play operation is requested.
 */
-static int check_for_audio_disc(struct cdrom_device_info * cdi,
-				struct cdrom_device_ops * cdo)
+static int check_for_audio_disc(struct cdrom_device_info *cdi,
+				struct cdrom_device_ops *cdo)
 {
         int ret;
 	tracktype tracks;
@@ -1485,7 +1485,7 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 
 static
 void sanitize_format(union cdrom_addr *addr,
-		     u_char * curr, u_char requested)
+		     u_char *curr, u_char requested)
 {
 	if (*curr == requested)
 		return;                 /* nothing to be done! */
-- 
1.7.0

