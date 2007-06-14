Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXFNWTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXFNWTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbXFNWQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:16:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35402 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757638AbXFNWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:16:29 -0400
Date: Fri, 15 Jun 2007 00:16:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] drivers/ide/ide-dma.c: unexport ide_set_dma
Message-ID: <20070614221642.GD3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ide_set_dma no longer has any modular user.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/ide/ide-dma.c.old	2007-06-14 23:52:30.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/ide/ide-dma.c	2007-06-14 23:52:38.000000000 +0200
@@ -847,8 +847,6 @@
 	return rc;
 }
 
-EXPORT_SYMBOL_GPL(ide_set_dma);
-
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 void ide_dma_lost_irq (ide_drive_t *drive)
 {

