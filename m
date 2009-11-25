Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbZKYRJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbZKYRJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932859AbZKYRI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbZKYRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KHD6UOj97s0zwxLVL7npAjCuqpe1rs//KJvooJdXkVO4gLreAC1FyBGoysx7Gv4zjp
         UWfen1Fs90Ce1SYSY9uFJ1TDgRJ5BOzTtofKGMUBb/w5paUv5yAbUyRbg/x8UkDJ2GeG
         /UZj+VdHFoHjmgzj/wAyTTnrZMiUZU6iBjXAw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:08:16 +0100
Message-Id: <20091125170816.5446.67530.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 50/86] pata_legacy: use PIO mask defines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_legacy: use PIO mask defines

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_legacy.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -817,29 +817,29 @@ static struct ata_port_operations winbon
 };
 
 static struct legacy_controller controllers[] = {
-	{"BIOS",	&legacy_port_ops, 	0x1F,
+	{"BIOS",	&legacy_port_ops, 	ATA_PIO4,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
-	{"Snooping", 	&simple_port_ops, 	0x1F,
+	{"Snooping", 	&simple_port_ops, 	ATA_PIO4,
 			0,			0,			NULL },
-	{"PDC20230",	&pdc20230_port_ops,	0x7,
+	{"PDC20230",	&pdc20230_port_ops,	ATA_PIO2,
 			ATA_FLAG_NO_IORDY,
 			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,	NULL },
-	{"HT6560A",	&ht6560a_port_ops,	0x07,
+	{"HT6560A",	&ht6560a_port_ops,	ATA_PIO2,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
-	{"HT6560B",	&ht6560b_port_ops,	0x1F,
+	{"HT6560B",	&ht6560b_port_ops,	ATA_PIO4,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
-	{"OPTI82C611A",	&opti82c611a_port_ops,	0x0F,
+	{"OPTI82C611A",	&opti82c611a_port_ops,	ATA_PIO3,
 			0,			0,			NULL },
-	{"OPTI82C46X",	&opti82c46x_port_ops,	0x0F,
+	{"OPTI82C46X",	&opti82c46x_port_ops,	ATA_PIO3,
 			0,			0,			NULL },
-	{"QDI6500",	&qdi6500_port_ops,	0x07,
+	{"QDI6500",	&qdi6500_port_ops,	ATA_PIO2,
 			ATA_FLAG_NO_IORDY,
 			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,    qdi_port },
-	{"QDI6580",	&qdi6580_port_ops,	0x1F,
+	{"QDI6580",	&qdi6580_port_ops,	ATA_PIO4,
 			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
-	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
+	{"QDI6580DP",	&qdi6580dp_port_ops,	ATA_PIO4,
 			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
-	{"W83759A",	&winbond_port_ops,	0x1F,
+	{"W83759A",	&winbond_port_ops,	ATA_PIO4,
 			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,
 								winbond_port }
 };
