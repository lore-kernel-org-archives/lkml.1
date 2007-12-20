Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbXLTB7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbXLTB7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbXLTBiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:38:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbXLTBe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=K/n+ohoGlHBg3eol+XLMz1cslDP+QNxyEzTs/KKWvQ5j0UOMBLeX8eSiEPsQfsNezeKm9lAu+fR3RCjtwH5HGIIGRXWqToyH1iertpQvvOP5XugGKTOHuiHqjzd67PRyRPWB7AGD8Oo+sNsdK2q3laQMRgSXOYw5A8ol6WW5624=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 24/63] ide-cd: add IDE_CD_CAPABILITIES define
Date: Thu, 20 Dec 2007 02:10:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200210.55780.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While at it remove stale/incorrect comment.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2559,11 +2559,13 @@ void ide_cdrom_release_real (struct cdro
 		CDROM_STATE_FLAGS(drive)->toc_valid = 0;
 }
 
+#define IDE_CD_CAPABILITIES \
+	(CDC_CLOSE_TRAY | CDC_OPEN_TRAY | CDC_LOCK | CDC_SELECT_SPEED | \
+	 CDC_SELECT_DISC | CDC_MULTI_SESSION | CDC_MCN | CDC_MEDIA_CHANGED | \
+	 CDC_PLAY_AUDIO | CDC_RESET | CDC_DRIVE_STATUS | CDC_CD_R | \
+	 CDC_CD_RW | CDC_DVD | CDC_DVD_R | CDC_DVD_RAM | CDC_GENERIC_PACKET | \
+	 CDC_MO_DRIVE | CDC_MRW | CDC_MRW_W | CDC_RAM)
 
-
-/****************************************************************************
- * Device initialization.
- */
 static struct cdrom_device_ops ide_cdrom_dops = {
 	.open			= ide_cdrom_open_real,
 	.release		= ide_cdrom_release_real,
@@ -2576,14 +2578,7 @@ static struct cdrom_device_ops ide_cdrom
 	.get_mcn		= ide_cdrom_get_mcn,
 	.reset			= ide_cdrom_reset,
 	.audio_ioctl		= ide_cdrom_audio_ioctl,
-	.capability		= CDC_CLOSE_TRAY | CDC_OPEN_TRAY | CDC_LOCK |
-				CDC_SELECT_SPEED | CDC_SELECT_DISC |
-				CDC_MULTI_SESSION | CDC_MCN |
-				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
-				CDC_DRIVE_STATUS | CDC_CD_R |
-				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MRW |
-				CDC_MRW_W | CDC_RAM,
+	.capability		= IDE_CD_CAPABILITIES,
 	.generic_packet		= ide_cdrom_packet,
 };
 
