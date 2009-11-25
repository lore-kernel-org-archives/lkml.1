Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbZKYRJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbZKYRJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932935AbZKYRJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:09:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZKYRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:09:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rmCQiUkpVX5iobCxDk4+gYGFWH1zNj8WG14otrGyQgOwMT+5Cdo8HAw7U0CgGb+m95
         nrk96hKX6lhd17wPGLFQFofYxWKmdKzV0hAumcliGa4ab7A2wkAo8R0E3uL5arS1KDPP
         tr8nuGZWJ7Y4a3vGKh4ZHmLtmoI+W5Lz0jil8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:08:48 +0100
Message-Id: <20091125170848.5446.51732.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 54/86] pata_ns87415: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ns87415: add 32-bit PIO support

There shouldn't be any problems with it as IDE ns87415 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ns87415.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_ns87415.c
===================================================================
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -300,7 +300,7 @@ static u8 ns87560_bmdma_status(struct at
 #endif		/* 87560 SuperIO Support */
 
 static struct ata_port_operations ns87415_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 
 	.check_atapi_dma	= ns87415_check_atapi_dma,
 	.bmdma_setup		= ns87415_bmdma_setup,
