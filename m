Return-Path: <linux-kernel-owner+w=401wt.eu-S935337AbXG2UCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935337AbXG2UCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935451AbXG2UB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:01:28 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:43282 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935559AbXG2UB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:01:27 -0400
Date: Sun, 29 Jul 2007 23:01:26 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix runtogether printk's in cmd64x IDE driver
Message-ID: <Pine.SOC.4.64.0707292257150.10801@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple of runtogether printks in cmd64x.c IDE driver by adding 
proper newlines.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 19633c5..0e3b5de 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -475,11 +475,11 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 		switch (rev) {
 		case 0x07:
 		case 0x05:
-			printk("%s: UltraDMA capable", name);
+			printk("%s: UltraDMA capable\n", name);
 			break;
 		case 0x03:
 		default:
-			printk("%s: MultiWord DMA force limited", name);
+			printk("%s: MultiWord DMA force limited\n", name);
 			break;
 		case 0x01:
 			printk("%s: MultiWord DMA limited, "

-- 
Meelis Roos (mroos@linux.ee)
