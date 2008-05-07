Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbYEGRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbYEGRa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbYEGR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:29:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:25426 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbYEGR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MRHTnQv0Jxr6+I7V8l20uLw2DenWxMlWZmvZd40aw1tUnQ8WR7WO9LkEAl0PTbCOBZ2Fd4BDBad6O+xQ02skRCQLzdkbfS6Dxb3EZ04+FQBix1Z6pdvdeuy/Jyww9ql3B/3C7oYicMNAn/GZ4MG8SBeFAaYIizC9R4Cb2vxWObo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/6] ide: remove commented out code from ide_config_drive_speed()
Date: Wed, 7 May 2008 19:40:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071940.46190.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -739,9 +739,6 @@ int ide_config_drive_speed(ide_drive_t *
 	int error = 0;
 	u8 stat;
 
-//	while (HWGROUP(drive)->busy)
-//		msleep(50);
-
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
 		hwif->dma_ops->dma_host_set(drive, 0);
