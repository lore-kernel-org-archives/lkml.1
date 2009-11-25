Return-Path: <linux-kernel-owner+w=401wt.eu-S934788AbZKYRMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788AbZKYRMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934745AbZKYRMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:12:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:30269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934760AbZKYRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jHYOnjkONdVjzZKFO/LGMQlSeb2FouXjn4K8oZLN8wUmGU8llVHDasppy+bVMdAFxJ
         BemnS0Cy7XZF0QWVrcunqy2BWDQfrLxPbW6AXjFRRjbCFJ5lwS7cdpRDVYiuIpCiS6x6
         K3dNWHUbqyI9U3xW0NeRGrGFfUg7qzWzZfkhk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:11:55 +0100
Message-Id: <20091125171155.5446.41850.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 79/86] pata_triflex: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_triflex: add 32-bit PIO support

There shouldn't be any problems with it as IDE triflex host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_triflex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_triflex.c
===================================================================
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -179,7 +179,7 @@ static struct scsi_host_template triflex
 };
 
 static struct ata_port_operations triflex_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.bmdma_start 	= triflex_bmdma_start,
 	.bmdma_stop	= triflex_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
