Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZKYRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZKYRYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbZKYRGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:21 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41135 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbZKYRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ms/LVbyP1cuzGeIzai2hjCmbGCD+FlorFXAHMhtPdCh9AI/wMTtxyVJ68+zCyMuTQa
         blu5GsjlORQPgbmu+4grUymrILtmELBfFQu8Jy1Onr180+778HIjht7y4pBG6E0/sOAA
         Zgyw+dxyMukb3a4OqBrgW5E/XOYx7Deoo+/0E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:05:39 +0100
Message-Id: <20091125170539.5446.88568.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 28/86] pata_cypress: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cypress: add 32-bit PIO support

There shouldn't be any problems with it as IDE cy82c693 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cypress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cypress.c
===================================================================
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -114,7 +114,7 @@ static struct scsi_host_template cy82c69
 };
 
 static struct ata_port_operations cy82c693_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= cy82c693_set_piomode,
 	.set_dmamode	= cy82c693_set_dmamode,
