Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYERSl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYERSl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYERSiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYERSiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S39L4jANxFtX4757x0hrIlPVM5NfmBvYOS3sfxgyhumAWJOv5I/bB0xrEHkWfcT/QzvC5YyPbGUiDOxROWmbssuQgE9lL9XtHXmhBLF+gTJECKrmBPSzI3gjUKN38ImCBvQimq1tMSkBSl5uWfo3H7cKrNjY0y9OfLJt6QXjzHo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:49 +0200
Message-Id: <20080518185549.5636.40698.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/40] ide-tape: remove superfluous error message from idetape_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_dma_off() prints info about DMA being disabled.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -842,7 +842,6 @@ static ide_startstop_t idetape_pc_intr(i
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-tape: The tape wants to issue more "
 				"interrupts in DMA mode\n");
-		printk(KERN_ERR "ide-tape: DMA disabled, reverting to PIO\n");
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
