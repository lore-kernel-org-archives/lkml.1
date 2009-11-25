Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbZKYRWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbZKYRWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932219AbZKYRWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:22:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbZKYRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RidtuAWqngRI6lLC3DAGss0oRSVgPxIHA+rhseI4p//BQUqNcu7cI5oFTL5yXle6XV
         B2Ei+DHaKgPpWt0geTA6O6FggvTL4ysVL8lOlyCfhNcrZLLToY2Ad41gOWeBjWI0vY+G
         ocWDoedRkEqLhoxUbMjixwrUg+zTUejaJhm8w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:07 +0100
Message-Id: <20091125170607.5446.33065.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 32/86] pata_hpt3x2n: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_hpt3x2n: add 32-bit PIO support

There shouldn't be any problems with it as IDE hpt366 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt3x2n.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_hpt3x2n.c
===================================================================
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -335,7 +335,7 @@ static struct scsi_host_template hpt3x2n
  */
 
 static struct ata_port_operations hpt3x2n_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.bmdma_stop	= hpt3x2n_bmdma_stop,
 	.qc_issue	= hpt3x2n_qc_issue,
