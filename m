Return-Path: <linux-kernel-owner+w=401wt.eu-S934809AbZKYRMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbZKYRMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934796AbZKYRMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:12:52 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:57477 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424AbZKYRMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vgUWDCxalm/eTvIekMzxwfsLgOF9pqYOw8FllA/I3dFFObCzBaE8P7GMuGoXe11tRx
         mIYSz1fnHxhwm0pUkC8dS5bpjrI3Pzqw/9g9EH9WIftNo5BoyojJ6Vvwu4QoFeKuJTld
         LBL5/TCqWPaq2YBAWbui93PSdUxoJONjuohe4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:12:11 +0100
Message-Id: <20091125171211.5446.594.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 81/86] pata_via: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: add 32-bit PIO support

There shouldn't be any problems with it as IDE via82cxxx host driver
has been using 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -420,7 +420,7 @@ static struct scsi_host_template via_sht
 };
 
 static struct ata_port_operations via_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.cable_detect	= via_cable_detect,
 	.set_piomode	= via_set_piomode,
 	.set_dmamode	= via_set_dmamode,
