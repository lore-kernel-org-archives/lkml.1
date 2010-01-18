Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285Ab0ARRVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0ARRVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274Ab0ARRU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:20:57 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0ARRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pVNUOwRvRBp3E6fG+CRnthkr5BkP8v31406RbL5vxmI7vNBcCXyucA8QV/VmjM2Wbz
         6oas2pKp/Xsucm6Kz7jFvnEL9ndHsnl1+FiexFEo2EykO6RV/NvnX102kImYDVq4i6b9
         pt/UFvJbKCcmAzBsU6bELmPS52iMI7OGfAjwY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:19:44 +0100
Message-Id: <20100118171944.14623.92267.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 40/64] ide: add SATA cable detection support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add SATA cable detection support

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -231,7 +231,7 @@ u8 eighty_ninty_three(ide_drive_t *drive
 	u16 *id = drive->id;
 	int ivb = ide_in_drive_list(id, ivb_list);
 
-	if (hwif->cbl == ATA_CBL_PATA40_SHORT)
+	if (hwif->cbl == ATA_CBL_SATA || hwif->cbl == ATA_CBL_PATA40_SHORT)
 		return 1;
 
 	if (ivb)
