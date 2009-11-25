Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbZKYRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbZKYRGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbZKYRGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759248AbZKYRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Hxtn2Pr+6gm+uXRdsv1npLu9ydhX2ae2TPTWKfhoVyG3nEOIVRdzat/26XeXvIkXUq
         MMRFbXqPe9qdetX6+99dwbAdyy++frvVyfBtbdvIzuQ1bVyM3Hzpbo1+3EilFG8JxKcp
         b6pITfMEo8VdI+PkM241G69WDFToTGS9HEFOg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:00 +0100
Message-Id: <20091125170600.5446.70691.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 31/86] pata_hpt37x: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_hpt37x: add 32-bit PIO support

There shouldn't be any problems with it as IDE hpt366 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt37x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_hpt37x.c
===================================================================
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -579,7 +579,7 @@ static struct scsi_host_template hpt37x_
  */
 
 static struct ata_port_operations hpt370_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.bmdma_stop	= hpt370_bmdma_stop,
 
@@ -604,7 +604,7 @@ static struct ata_port_operations hpt370
  */
 
 static struct ata_port_operations hpt372_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.bmdma_stop	= hpt37x_bmdma_stop,
 
