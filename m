Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbXJ0Oui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbXJ0Oui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJ0Oub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:50:31 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48737 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ0Oua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:50:30 -0400
Message-ID: <47235033.7060908@tiscali.nl>
Date: Sat, 27 Oct 2007 16:50:27 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix 'and' typos in drivers/block/pktcdvd.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two 'and' typos

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a8130a4..9cd6ba2 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2202,11 +2202,11 @@ static int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
 		return ret;
 	}
 
-	if (!buf[6] & 0x40) {
+	if (!(buf[6] & 0x40)) {
 		printk(DRIVER_NAME": Disc type is not CD-RW\n");
 		return 1;
 	}
-	if (!buf[6] & 0x4) {
+	if (!(buf[6] & 0x4)) {
 		printk(DRIVER_NAME": A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
