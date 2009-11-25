Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbZKYRD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbZKYRD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZKYRDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:03:55 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbZKYRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=yCq5drH1kCGVkeLUJgEVYBbOi9d6XGU4x/XGyrhTcHflPUOpoqdni0I7KCUkuI+FpN
         aA2HziwYz5zPuqC6BECM5f95aIauQuWrlIXObFx/BICnrjFCaE/Ej8TLL1MHCmHgXN/b
         1d6jORxnVvImGAKclIUsxJI2QsvGR1LJ0qBqw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:15 +0100
Message-Id: <20091125170315.5446.61323.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 08/86] pata_atiixp: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: add 32-bit PIO support

There shouldn't be any problems with it as IDE atiixp host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -206,7 +206,7 @@ static struct scsi_host_template atiixp_
 };
 
 static struct ata_port_operations atiixp_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.qc_prep 	= ata_sff_dumb_qc_prep,
 	.bmdma_start 	= atiixp_bmdma_start,
