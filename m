Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZKYRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZKYRFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbZKYRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:05:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:28023 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226AbZKYRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lRoXESyh23NAZCnnKrXLCKt80DXlHElkMJXGItLaeRlKhpZvf8Wnc6HSwGzDHumKdt
         VGSq0ZBX1OrEf4P/vr620tlWXX0KjDi9CNieMHe/7/clORxSBhXbkb3QixWbJ9vsuqVH
         teAGF172aUwioZiTUxMckAXvcIF1Yj5ewslyc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:05:04 +0100
Message-Id: <20091125170504.5446.71824.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 23/86] pata_cs5520: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5520: add 32-bit PIO support

There shouldn't be any problems with it as IDE cs5520 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5520.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cs5520.c
===================================================================
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -145,7 +145,7 @@ static struct scsi_host_template cs5520_
 };
 
 static struct ata_port_operations cs5520_port_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.qc_prep		= ata_sff_dumb_qc_prep,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= cs5520_set_piomode,
