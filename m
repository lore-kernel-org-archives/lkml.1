Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252Ab0A2QEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0A2QEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658Ab0A2QD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:03:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0A2QDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:03:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jNQ6+ps7WMqB12jEp1vpnmMUUPbiDg4NcTsgWnko51OIilD59SHtfPzsd3XUw5J9B0
         G36ASBMMGwDyJIg6PZoSnB0cENGWi4pVX3LOVImh2L0xluLPQARIc2TnuhDxPgUaamso
         fgSsr/I+q/wIzIB6FbexaQm9ShYGTzBUIS5ag=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:03:40 +0100
Message-Id: <20100129160340.21495.2898.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 05/68] ata: enable XFER_PIO_SLOW mode in ata_timing table
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata: enable XFER_PIO_SLOW mode in ata_timing table

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata-timings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/ata-timings.c
===================================================================
--- a/drivers/ata/ata-timings.c
+++ b/drivers/ata/ata-timings.c
@@ -15,7 +15,7 @@
  */
 
 static const struct ata_timing ata_timing[] = {
-/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 0,  960,   0 }, */
+	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 0,  960,   0 },
 	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 0,  600,   0 },
 	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 0,  383,   0 },
 	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 0,  240,   0 },
