Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbZKYRKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbZKYRKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbZKYRJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:09:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbZKYRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:09:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ow1LwQZH8zakijkS2hyJLtNJ8t4I1EdCdJoGtt6EUhiAsQgDj4iKHFzudTk2nbK+PO
         SmfcxoscWX6bNui1tenaMRWWI8GY+2ebkjdtCKd5MA8PgusTNQofHzgdw62nb1LdCOZ8
         H67WT+j++DV4fOoBqWkw2u+0wsDzRJeXQpAYI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:18 +0100
Message-Id: <20091125170918.5446.7331.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 58/86] pata_pdc2027x: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc2027x: add 32-bit PIO support

There shouldn't be any problems with it as IDE pdc202xx_new host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc2027x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_pdc2027x.c
===================================================================
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -133,7 +133,7 @@ static struct scsi_host_template pdc2027
 };
 
 static struct ata_port_operations pdc2027x_pata100_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.check_atapi_dma	= pdc2027x_check_atapi_dma,
 	.cable_detect		= pdc2027x_cable_detect,
 	.prereset		= pdc2027x_prereset,
