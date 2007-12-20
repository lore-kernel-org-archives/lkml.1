Return-Path: <linux-kernel-owner+w=401wt.eu-S1762441AbXLTB4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762441AbXLTB4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXLTBhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644AbXLTBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s3kBjKaK2ysRH4DxDwM+KZ9oUdLhAtTlNaHwmxtKvlY8yvgSdjfw1EyPiW8ntrSfHDoYsdUeEnbH6B3RsBk9rNR3cIVuCI+7huI/gp6SFxCMQ11hMMC2rzIco4UxCYhrJYArORwCXnDVEuDMx3ahVD3ScXAy+P82YGxWzYfs2fk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 30/63] ide-cd: remove NO_DOOR_LOCKING define
Date: Thu, 20 Dec 2007 02:15:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200215.17436.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    3 ---
 drivers/ide/ide-cd.h |    7 -------
 2 files changed, 10 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2834,9 +2834,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
 
-#if NO_DOOR_LOCKING
-	cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
-#endif
 	if ((drive->id->config & 0x0060) == 0x20)
 		cd->cd_flags |= IDE_CD_FLAG_DRQ_INTERRUPT;
 	cd->cd_flags |= IDE_CD_FLAG_NO_EJECT;
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -28,13 +28,6 @@
 #endif
 
 
-/* Turning this on will disable the door-locking functionality.
-   This is apparently needed for supermount. */
-
-#ifndef NO_DOOR_LOCKING
-#define NO_DOOR_LOCKING 0
-#endif
-
 /*
  * typical timeout for packet command
  */
