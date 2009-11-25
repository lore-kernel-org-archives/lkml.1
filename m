Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbZKYRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbZKYRLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933671AbZKYRLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbZKYRLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PYkw1tXpS3GbQnhrK5V9TZw5p8Ug/fhiQU8MHnptx/AHd0mdow1yI2mgGhLjaDAMYn
         H+1iiKGOUvkoNJOJanJACsnJNSZ1CgJea0O7Lbiszv6xXjhxEJ1ReFeofyG7RH4adz0Z
         YyLa1f8Sw06vXIzl0T6CWqf4xAv7Sw8UYT63k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:39 +0100
Message-Id: <20091125171039.5446.68680.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 69/86] pata_scc: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_scc: add 32-bit PIO support

There shouldn't be any problems with it as IDE scc_pata host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_scc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_scc.c
===================================================================
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -966,7 +966,7 @@ static struct scsi_host_template scc_sht
 };
 
 static struct ata_port_operations scc_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 
 	.set_piomode		= scc_set_piomode,
 	.set_dmamode		= scc_set_dmamode,
