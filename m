Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYHQRSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYHQRSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYHQRRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:17:31 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:30781 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYHQRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dL3nBEIm/HxYpz9o9na+l3fBtJiaiIynIB66tVtefHvpSazC5H0iBbQmTsKGyEigD3
         qPJZ36yWx6ytAr/PZ6FZZUVneU5vk/Nz0PIBCjcshNP1lMZXF63oW0lWl2dzICh5ex9c
         5CqA9U2Wyb7VG+jUZDjz+UB2Tw4V1k6o4QnJA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 19:15:08 +0200
Message-Id: <20080817171508.27943.34869.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] ide-disk: remove stale init_idedisk_capacity() documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -375,20 +375,6 @@ static void idedisk_check_hpa(ide_drive_
 	}
 }
 
-/*
- * Compute drive->capacity, the full capacity of the drive
- * Called with drive->id != NULL.
- *
- * To compute capacity, this uses either of
- *
- *    1. CHS value set by user       (whatever user sets will be trusted)
- *    2. LBA value from target drive (require new ATA feature)
- *    3. LBA value from system BIOS  (new one is OK, old one may break)
- *    4. CHS value from system BIOS  (traditional style)
- *
- * in above order (i.e., if value of higher priority is available,
- * reset will be ignored).
- */
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
