Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYKTFqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYKTFqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYKTFqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:46:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:32479 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYKTFqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:46:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=iJ5oHUL4SRKg8/AwkSlIev6x7KOD4aPF1e67tCTzqB5n87oYL4l6PP9AJgXKTl1p/1
         pYrrNdH+zCIZ085+m8EXpcTV2ZjIQnaIk+puBo+ADQhZpJBwV8seWwPYYUbTRYCfbIMw
         TTmceubPq2yHkTzahGOWgDxZHZyxOqvYgbu5s=
To: <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/3] ide: make IDE_AFLAG_.. numbering continuous again
Date: Thu, 20 Nov 2008 06:41:22 +0100
Message-Id: <1227159683-2487-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
References: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 include/linux/ide.h |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index fb81060..efd95e9 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -473,53 +473,53 @@ enum {
 
 	/* ide-cd */
 	/* Drive cannot eject the disc. */
-	IDE_AFLAG_NO_EJECT		= (1 << 3),
+	IDE_AFLAG_NO_EJECT		= (1 << 1),
 	/* Drive is a pre ATAPI 1.2 drive. */
-	IDE_AFLAG_PRE_ATAPI12		= (1 << 4),
+	IDE_AFLAG_PRE_ATAPI12		= (1 << 2),
 	/* TOC addresses are in BCD. */
-	IDE_AFLAG_TOCADDR_AS_BCD	= (1 << 5),
+	IDE_AFLAG_TOCADDR_AS_BCD	= (1 << 3),
 	/* TOC track numbers are in BCD. */
-	IDE_AFLAG_TOCTRACKS_AS_BCD	= (1 << 6),
+	IDE_AFLAG_TOCTRACKS_AS_BCD	= (1 << 4),
 	/*
 	 * Drive does not provide data in multiples of SECTOR_SIZE
 	 * when more than one interrupt is needed.
 	 */
-	IDE_AFLAG_LIMIT_NFRAMES		= (1 << 7),
+	IDE_AFLAG_LIMIT_NFRAMES		= (1 << 5),
 	/* Saved TOC information is current. */
-	IDE_AFLAG_TOC_VALID		= (1 << 9),
+	IDE_AFLAG_TOC_VALID		= (1 << 6),
 	/* We think that the drive door is locked. */
-	IDE_AFLAG_DOOR_LOCKED		= (1 << 10),
+	IDE_AFLAG_DOOR_LOCKED		= (1 << 7),
 	/* SET_CD_SPEED command is unsupported. */
-	IDE_AFLAG_NO_SPEED_SELECT	= (1 << 11),
-	IDE_AFLAG_VERTOS_300_SSD	= (1 << 12),
-	IDE_AFLAG_VERTOS_600_ESD	= (1 << 13),
-	IDE_AFLAG_SANYO_3CD		= (1 << 14),
-	IDE_AFLAG_FULL_CAPS_PAGE	= (1 << 15),
-	IDE_AFLAG_PLAY_AUDIO_OK		= (1 << 16),
-	IDE_AFLAG_LE_SPEED_FIELDS	= (1 << 17),
+	IDE_AFLAG_NO_SPEED_SELECT	= (1 << 8),
+	IDE_AFLAG_VERTOS_300_SSD	= (1 << 9),
+	IDE_AFLAG_VERTOS_600_ESD	= (1 << 10),
+	IDE_AFLAG_SANYO_3CD		= (1 << 11),
+	IDE_AFLAG_FULL_CAPS_PAGE	= (1 << 12),
+	IDE_AFLAG_PLAY_AUDIO_OK		= (1 << 13),
+	IDE_AFLAG_LE_SPEED_FIELDS	= (1 << 14),
 
 	/* ide-floppy */
 	/* Avoid commands not supported in Clik drive */
-	IDE_AFLAG_CLIK_DRIVE		= (1 << 19),
+	IDE_AFLAG_CLIK_DRIVE		= (1 << 15),
 	/* Requires BH algorithm for packets */
-	IDE_AFLAG_ZIP_DRIVE		= (1 << 20),
+	IDE_AFLAG_ZIP_DRIVE		= (1 << 16),
 	/* Supports format progress report */
-	IDE_AFLAG_SRFP			= (1 << 22),
+	IDE_AFLAG_SRFP			= (1 << 17),
 
 	/* ide-tape */
-	IDE_AFLAG_IGNORE_DSC		= (1 << 23),
+	IDE_AFLAG_IGNORE_DSC		= (1 << 18),
 	/* 0 When the tape position is unknown */
-	IDE_AFLAG_ADDRESS_VALID		= (1 <<	24),
+	IDE_AFLAG_ADDRESS_VALID		= (1 <<	19),
 	/* Device already opened */
-	IDE_AFLAG_BUSY			= (1 << 25),
+	IDE_AFLAG_BUSY			= (1 << 20),
 	/* Attempt to auto-detect the current user block size */
-	IDE_AFLAG_DETECT_BS		= (1 << 26),
+	IDE_AFLAG_DETECT_BS		= (1 << 21),
 	/* Currently on a filemark */
-	IDE_AFLAG_FILEMARK		= (1 << 27),
+	IDE_AFLAG_FILEMARK		= (1 << 22),
 	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 28),
+	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 23),
 
-	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 29),
+	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 24),
 };
 
 /* device flags */
-- 
1.6.0.4

