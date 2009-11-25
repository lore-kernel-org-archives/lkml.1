Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbZKYRLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbZKYRLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933582AbZKYRLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39574 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbZKYRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MNNrMrDSeV4hUEmgsp2e4UROzq1F595L+5eWtWZazwsUJJttrN7jo7QZpw3vgoEwVE
         WXB0a8Qck+2zGnm/yJW0leOhPvgeKJkr6aR9yBlf/FsrWEHKNbcRw5eQn+MpwxBGx9b6
         kDbBgoBkLo4wN5yafcrzTvV77QE0+cwSKUKDs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:32 +0100
Message-Id: <20091125171032.5446.61591.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 68/86] pata_sc1200: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sc1200: add 32-bit PIO support

There shouldn't be any problems with it as IDE sc1200 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sc1200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_sc1200.c
===================================================================
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -208,7 +208,7 @@ static struct scsi_host_template sc1200_
 };
 
 static struct ata_port_operations sc1200_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.qc_prep 	= ata_sff_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue,
 	.qc_defer	= sc1200_qc_defer,
