Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZKYREP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZKYREP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbZKYREN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbZKYREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HkgyPB0kZws5dVEt8/C24dvvppHLAX/EHdJZKC5QYLScUkaovn94hSgNqSN7v4AA1u
         5rcpvzwsI5wyuiVY6rMPX/dOHHOGHNP3WIGLilUT087Q4Y2vXLMMKP8mtvfZrv/C7U+F
         DMsZiA1VFYJH7Jt7mqfATa9borS4IhDgBIWiY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:30 +0100
Message-Id: <20091125170330.5446.53045.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 10/86] pata_atiixp: add MWDMA0 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: add MWDMA0 support

There shouldn't be any problems with it as IDE atiixp host driver
has been allowing MWDMA0 mode for last two years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -207,7 +207,7 @@ static int atiixp_init_one(struct pci_de
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
-		.mwdma_mask = ATA_MWDMA12_ONLY,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &atiixp_port_ops
 	};
