Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYA1WIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYA1WIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYA1WI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:08:27 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52117 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbYA1WIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:08:18 -0500
Date: Tue, 29 Jan 2008 00:08:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [2.6 patch] unexport ide_dma_on
Message-ID: <20080128220844.GG8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_dma_on can be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
38b0717b827649511b15fbef6f98c891eda835ff 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 5bf3203..15f8c6a 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -474,8 +474,6 @@ void ide_dma_on(ide_drive_t *drive)
 	drive->hwif->dma_host_set(drive, 1);
 }
 
-EXPORT_SYMBOL(ide_dma_on);
-
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_dma_setup	-	begin a DMA phase

