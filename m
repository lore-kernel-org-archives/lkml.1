Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774Ab0ARRSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0ARRSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859Ab0ARRSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:1825 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab0ARRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Zvt8gHXWchmMnr3510OPNA3fNXLZbXK8+zBsVTsNHVvMW3oPs15nvzr+R6wIZzFBUA
         hvLiwN9t8dKKUqEsN8dnwUmjlff3mI72Jxfho8jYafVL+C5GH4eOtibmTGOjQ93m7hBH
         yVUOTFzOyGAlz20cFBdeL7fmSSx02kVthkpzo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:16:46 +0100
Message-Id: <20100118171646.14623.91955.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 20/64] pata_serverworks: fix error message
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: fix error message

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -306,7 +306,7 @@ static int serverworks_fixup_osb4(struct
 		pci_dev_put(isa_dev);
 		return 0;
 	}
-	printk(KERN_WARNING "ata_serverworks: Unable to find bridge.\n");
+	printk(KERN_WARNING DRV_NAME ": Unable to find bridge.\n");
 	return -ENODEV;
 }
 
