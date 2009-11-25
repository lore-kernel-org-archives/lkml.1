Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbZKYRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbZKYRI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932528AbZKYRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbZKYRIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Gmhg+ulKQXhkOjy17fp6/Um4xVDTfqENJL8jln2unezaoP57NtVSINK+syThckNWVJ
         b46TNNb7tSrcEzwgYFy+Y66ZnMB0jAEiRj0z3D/RUw74N2d60hDP4Sgh+Fr7AXLrz8fr
         LHMOcd2bzBtRT5zzQ1XyP5Cw6Xr9vsPJ98ELU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:33 +0100
Message-Id: <20091125170733.5446.10355.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 44/86] pata_jmicron: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_jmicron: add 32-bit PIO support

There shouldn't be any problems with it as IDE jmicron host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_jmicron.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_jmicron.c
===================================================================
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -112,7 +112,7 @@ static struct scsi_host_template jmicron
 };
 
 static struct ata_port_operations jmicron_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.prereset		= jmicron_pre_reset,
 };
 
