Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZKYRF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZKYRF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbZKYRF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:05:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:28023 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199AbZKYRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=i/GJS7s4v2araxMOSvEj960ezaiWdAA+k5d/4K4nCf7e8AuzXSV3e2u1el6xZf2MEX
         BLB9sS3WCyl6OtUShUSnf6uz4FNvE0cAWv6zK0aTK6eHqAQmaHSgIOZaYOZiPR2NqkE1
         1T6LqBPmalOEHMfr1gqZEuwppGktF5GOoycIM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:05:18 +0100
Message-Id: <20091125170518.5446.92173.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 25/86] pata_cs5530: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5530: add 32-bit PIO support

There shouldn't be any problems with it as IDE cs5530 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5530.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cs5530.c
===================================================================
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -165,7 +165,7 @@ static struct scsi_host_template cs5530_
 };
 
 static struct ata_port_operations cs5530_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.qc_prep 	= ata_sff_dumb_qc_prep,
 	.qc_issue	= cs5530_qc_issue,
