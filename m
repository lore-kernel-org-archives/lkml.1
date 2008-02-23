Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYBWRjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYBWRjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760473AbYBWRio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:38:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:23524 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760399AbYBWRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JYkaLhTFS7UmmMOE/qsIc1T+Ydd4q1XBlF5jzLmKvvlxKveH4dasEZXjv8gLDKzyFbcbqg9tebGODGoeDEGWhenpvI72yuJ2YsoTn9bR+diVJsXkjCpr7AFlN3rUhOj9o+ojvO/od2uiCCb/0qjldM6vpfQltRQrOPLmjAA6Sis=
Date: Sat, 23 Feb 2008 18:38:36 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 5/6] IDE: Coding Style fixes to drivers/ide/ide-floppy.c
Message-ID: <20080223183836.09cb53ff@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/ide-floppy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5f133df..cea77e0 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -396,7 +396,7 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 }
 
 /* The usual interrupt handler called during a packet command. */
-static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
+static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -1602,7 +1602,7 @@ static struct block_device_operations idefloppy_ops = {
 	.ioctl		= idefloppy_ioctl,
 	.getgeo		= idefloppy_getgeo,
 	.media_changed	= idefloppy_media_changed,
-	.revalidate_disk= idefloppy_revalidate_disk
+	.revalidate_disk = idefloppy_revalidate_disk
 };
 
 static int ide_floppy_probe(ide_drive_t *drive)
-- 
1.5.4.2.316.gf7a7

