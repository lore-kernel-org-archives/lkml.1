Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbZKYRDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbZKYRDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbZKYRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:03:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbZKYRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:03:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XLee0aL0u4eRPQWuRfcdDdP3PWGpLpvr6Y1GDvKcgdogmvUrn+eCOBBAS0FeIc1Bcg
         A0xQ7uXDVf36+DgW3ul99PXiM/deQg4isYy5WZVJOOmsxurZj3eZRoHFxIDc7LbQg18b
         uF1A4dZ1j19yyst9BYIQ4yOua6joKUk0DuUGg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:02:39 +0100
Message-Id: <20091125170239.5446.26287.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 03/86] pata_artop: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: add 32-bit PIO support

There shouldn't be any problems with it as IDE aec62xx host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_artop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -312,7 +312,7 @@ static struct scsi_host_template artop_s
 };
 
 static struct ata_port_operations artop6210_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
@@ -321,7 +321,7 @@ static struct ata_port_operations artop6
 };
 
 static struct ata_port_operations artop6260_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= artop6260_cable_detect,
 	.set_piomode		= artop6260_set_piomode,
 	.set_dmamode		= artop6260_set_dmamode,
