Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbZKYRHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbZKYRHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbZKYRHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:07:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbZKYRHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jDHZSsJH3ExRzXYxeDUNSK8tLPcZET5obeQK8LywMogQikuYmzCmCRzI5meoepewtT
         +EQb6sOAoWZw4Tzc3NWYG3j7LuzC+m50xwg6Prjl8duKHcFnlr5/EwqB7muMwqD5uFVZ
         fJPqaCPmCj6l/5BpnrYBQn1I2SCBM0dwMob5E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:21 +0100
Message-Id: <20091125170621.5446.10720.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 34/86] pata_it8213: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: add 32-bit PIO support

There shouldn't be any problems with it as IDE it8213 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -235,7 +235,7 @@ static struct scsi_host_template it8213_
 
 
 static struct ata_port_operations it8213_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= it8213_cable_detect,
 	.set_piomode		= it8213_set_piomode,
 	.set_dmamode		= it8213_set_dmamode,
