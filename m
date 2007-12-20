Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbXLTBi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbXLTBi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbXLTBeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbXLTBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xRsC6zJbhYkxf0IL2F/IMysYypS321CYCf1s7noyjtFfHzY2BcZitLvlVWrX5HwMSInEkdwBbCI8irtqpxfZ3e9sTt12uBSe3mDHygMHE7tjtEz/4byZt1mR3B9B4rCdIPTb2ILUpBbqQRayCYKag+CQvwDeje9XEg3Lx74LQuw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 17/63] ide-cd: remove unused defines from ide-cd.h
Date: Thu, 20 Dec 2007 02:05:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200205.10565.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.h |   10 ----------
 1 file changed, 10 deletions(-)

Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -49,16 +49,6 @@
 #endif
 #define SECTORS_PER_FRAME	(CD_FRAMESIZE >> SECTOR_BITS)
 #define SECTOR_BUFFER_SIZE	(CD_FRAMESIZE * 32)
-#define SECTORS_BUFFER		(SECTOR_BUFFER_SIZE >> SECTOR_BITS)
-#define SECTORS_MAX		(131072 >> SECTOR_BITS)
-
-#define BLOCKS_PER_FRAME	(CD_FRAMESIZE / BLOCK_SIZE)
-
-/* special command codes for strategy routine. */
-#define PACKET_COMMAND        4315
-#define REQUEST_SENSE_COMMAND 4316
-#define RESET_DRIVE_COMMAND   4317
-
 
 /* Configuration flags.  These describe the capabilities of the drive.
    They generally do not change after initialization, unless we learn
