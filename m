Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZBPANz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZBPANz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZBPAMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:17 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51372 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbZBPAMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NbcvpCLLGUp6zN0aEOVo2wgMeJm6j5ymWoZJPnxgsULesBJdbTVa3nwaQqp3lJAXFl
         ON99Qe20NMRgB+y7qDcXdRl46GQkk7ewJ3imFCYvheCa0GL1ci8xg9eXv7mHR4QcNlEg
         dvF3mKXeNJG2rkRKQ7iFWPI1X8AY2+j8tXR78=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:13:42 +0100
Message-Id: <20090216001342.27491.2921.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/20] ide-cd: remove dead code from cdrom_decode_status()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: remove dead code from cdrom_decode_status()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -316,12 +316,6 @@ static int cdrom_decode_status(ide_drive
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
-	if (rq == NULL) {
-		printk(KERN_ERR PFX "%s: missing rq in %s\n",
-				drive->name, __func__);
-		return 1;
-	}
-
 	ide_debug_log(IDE_DBG_RQ, "stat: 0x%x, good_stat: 0x%x, cmd[0]: 0x%x, "
 				  "rq->cmd_type: 0x%x, err: 0x%x",
 				  stat, good_stat, rq->cmd[0], rq->cmd_type,
