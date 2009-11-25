Return-Path: <linux-kernel-owner+w=401wt.eu-S934750AbZKYRQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbZKYRQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbZKYRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:16:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933772AbZKYRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wSwhfBAIe6PaEOLFSEsaNbE+1VJUiXuMDIoVfVM5rIVNUpjw1xvFfAzRpBWRFTRFjA
         GIqoMfnZD2hHPol24FD8KgLt7542i5IyJCGQOCToHB2t2llCaApsYYhadiMPezHK0T8l
         RbvhCB7EEYAXEyqPvyu72GcQWHwfZav6TkU4M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:53 +0100
Message-Id: <20091125171053.5446.22658.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 71/86] pata_sch: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sch: add 32-bit PIO support

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_sch.c
===================================================================
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -76,7 +76,7 @@ static struct scsi_host_template sch_sht
 };
 
 static struct ata_port_operations sch_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= ata_cable_unknown,
 	.set_piomode		= sch_set_piomode,
 	.set_dmamode		= sch_set_dmamode,
