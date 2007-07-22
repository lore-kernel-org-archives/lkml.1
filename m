Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbXGVPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbXGVPWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXGVPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:22:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5056 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXGVPWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Hod8zwzxRN1rTu7hhLlOcCgbDi8YTe+Io81L0bDHbJy154q//TMxsUBwmeNTTI4aziWpBuy9gC56HeFqT/0lpubRbJARRHfSwxAr9QH2o7ul37r2Gdn8TKC8B8+skt6fJSLnDYlJ2h6t9m+796Q9gzp8/Culoqwum4t/SIszVpg=
Message-ID: <46A37595.2010305@googlemail.com>
Date: Sun, 22 Jul 2007 17:19:49 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-scsi@vger.kernel.org
Subject: [PATCH] drivers/scsi/g_NCR5380.c - "NCR53C400_PSEUDO_DMA" is not
 defined 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

got this warning with current git :

...

In file included from drivers/scsi/g_NCR5380_mmio.c:9:
drivers/scsi/g_NCR5380.c:559:5: warning: "NCR53C400_PSEUDO_DMA" is not defined

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
---

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 880f70d..607336f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -556,7 +556,7 @@ generic_NCR5380_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 }
 #endif
 
-#if NCR53C400_PSEUDO_DMA
+#ifdef NCR53C400_PSEUDO_DMA
 
 /**
  *	NCR5380_pread		-	pseudo DMA read
