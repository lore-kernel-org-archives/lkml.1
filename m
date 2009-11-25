Return-Path: <linux-kernel-owner+w=401wt.eu-S934709AbZKYRMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbZKYRMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbZKYRMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:12:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409AbZKYRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=li4QRigXX5CnAfa9yV1VNqOc6DeG4I6Zci+VzRyAo9XA4O1yd8RuGKEV0xSxh6hZ6/
         ThUPIy44IVZG9sbY0u3B/aGTr/yGIlloCX45i1g6Mu5H0qiRHO3tzwodArXrB7EuoKUj
         h4M60zhzxxXLx4CJog87yPPvVaGoynH/9Fkdw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:11:39 +0100
Message-Id: <20091125171139.5446.21161.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 77/86] pata_sis: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sis: add 32-bit PIO support

There shouldn't be any problems with it as IDE sis5513 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sis.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_sis.c
===================================================================
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -504,14 +504,14 @@ static struct scsi_host_template sis_sht
 };
 
 static struct ata_port_operations sis_133_for_sata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.set_piomode		= sis_133_set_piomode,
 	.set_dmamode		= sis_133_set_dmamode,
 	.cable_detect		= sis_133_cable_detect,
 };
 
 static struct ata_port_operations sis_base_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.prereset		= sis_pre_reset,
 };
 
