Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbZASNEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbZASNEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760478AbZASNDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:03:15 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:46104 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760815AbZASNDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VCr4FB7cd1O7t7w4mcyz85JT6JbLLQ/eVFrnhcYAG8K9dRl8rOeGYzv8OGhEiohVXn
         gG412nwF/iYgDT2aSbZTHmw9LWm5vtAiahXnq9n7xO1pvQmKY2UD86bU/uVa4kEy76RM
         DOvANRxv1OO/1moLj12khBEww+POwKpaDrnko=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:36 +0100
Message-Id: <20090119130336.24745.7606.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/6] ide: fix comments in ide_config_drive_speed()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix comments in ide_config_drive_speed()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -369,18 +369,15 @@ int ide_config_drive_speed(ide_drive_t *
 	 * but for some reason these don't work at
 	 * this point (lost interrupt).
 	 */
-        /*
-         * Select the drive, and issue the SETFEATURES command
-         */
-	disable_irq_nosync(hwif->irq);
-	
+
 	/*
 	 *	FIXME: we race against the running IRQ here if
 	 *	this is called from non IRQ context. If we use
 	 *	disable_irq() we hang on the error path. Work
 	 *	is needed.
 	 */
-	 
+	disable_irq_nosync(hwif->irq);
+
 	udelay(1);
 	SELECT_DRIVE(drive);
 	SELECT_MASK(drive, 1);
