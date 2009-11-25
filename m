Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZKYRGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZKYRGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbZKYRGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254AbZKYRGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=yCi9j44bBwZBh0YFOO2Ke3wwMGvzXWJzok9oIadiEXPHDzYfeKJqIuBqtbfLzaWbop
         sHnpWZhXQL+h8qI1Tr3OdU0SW34I7wxmN/HYe94O+uaJktrEY/ckQ7oSaPaI2Evee2Og
         g2EuZUdrfmX3Ga6fEEISfDs/LGMywOeHPgP6c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:05:25 +0100
Message-Id: <20091125170525.5446.41554.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 26/86] pata_cs5535: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5535: add 32-bit PIO support

There shouldn't be any problems with it as IDE cs5535 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5535.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -161,7 +161,7 @@ static struct scsi_host_template cs5535_
 };
 
 static struct ata_port_operations cs5535_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.cable_detect	= cs5535_cable_detect,
 	.set_piomode	= cs5535_set_piomode,
 	.set_dmamode	= cs5535_set_dmamode,
