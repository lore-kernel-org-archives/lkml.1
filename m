Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZK0S7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZK0S7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZK0S7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:59:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62522 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZK0S6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=j8665tXk5fn5ohoBNl78U1j2aoxrwm1y87Gil3hMdtzaxN2j72+6uu/dnkTeiyolI8
         Cark/wlPYBYggfAXJmjIIgB4+uBfUy4uL4t6V7c5CF/fgI9MIc9YLaguEVBk5GH17h8q
         K3K3fze0QUoKkeJXAPl5bmNtts1KdQNVR+I6I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] pata_rdc: MWDMA0 is unsupported
Date: Fri, 27 Nov 2009 19:53:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <200911271953.41860.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MWDMA0 timings cannot be met with the PIIX based controller
programming interface.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_rdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_rdc.c
===================================================================
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -244,7 +244,7 @@ static struct ata_port_info rdc_port_inf
 
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
-	.mwdma_mask	= ATA_MWDMA2,
+	.mwdma_mask	= ATA_MWDMA12_ONLY,
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &rdc_pata_ops,
 };
