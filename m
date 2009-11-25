Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZKYRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZKYRF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbZKYRFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:05:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:28023 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbZKYRFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S/WUboJGtEGF8eCuxoK4M4ebZm0F/qyVsNYf82ODlen9+111oGJWQos3ZuTSNmCHn0
         FOTEkaBBnREY9JRUh77VpzVqAfs6iJu6paZTC7sgD90gf4zFYZxLBHuHfLaBdjgxiidd
         LQBkJv3JT/y4ZxCSxh7JmYJohtkZ7Ztwuk3tE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:43 +0100
Message-Id: <20091125170443.5446.99167.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 20/86] pata_cmd64x: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: add 32-bit PIO support

There shouldn't be any problems with it as IDE cmd64x host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -270,7 +270,7 @@ static struct scsi_host_template cmd64x_
 };
 
 static const struct ata_port_operations cmd64x_base_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.set_piomode	= cmd64x_set_piomode,
 	.set_dmamode	= cmd64x_set_dmamode,
 };
