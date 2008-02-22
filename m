Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYBVUrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYBVUrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYBVUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:46:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:27328 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYBVUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ia1CaBNW+km1Gh5afTgTH8g7MDFt+bqE9KI2qbSj4T9Do/rYPxFnAi/Ll0z4y8peQRK2MQ1VBLtEIATYIeRHblB25yA1ZzSNbnuz+Yyy2e6PvPA8vg+6QJX116Teuph5pBholx0H9ijcCL/su+6pjEKrEiKpsfaAvzWki3ZGf/k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] qd65xx: remove commented out code
Date: Fri, 22 Feb 2008 21:58:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222158.24652.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/qd65xx.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -334,43 +334,6 @@ static void __init qd6580_port_init_devs
 	hwif->drives[1].drive_data = t2;
 }
 
-/*
- * qd_unsetup:
- *
- * called to unsetup an ata channel : back to default values, unlinks tuning
- */
-/*
-static void __exit qd_unsetup(ide_hwif_t *hwif)
-{
-	u8 config = hwif->config_data;
-	int base = hwif->select_data;
-	void *set_pio_mode = (void *)hwif->set_pio_mode;
-
-	if (hwif->chipset != ide_qd65xx)
-		return;
-
-	printk(KERN_NOTICE "%s: back to defaults\n", hwif->name);
-
-	hwif->selectproc = NULL;
-	hwif->set_pio_mode = NULL;
-
-	if (set_pio_mode == (void *)qd6500_set_pio_mode) {
-		// will do it for both
-		outb(QD6500_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-	} else if (set_pio_mode == (void *)qd6580_set_pio_mode) {
-		if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
-			outb(QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-			outb(QD6580_DEF_DATA2, QD_TIMREG(&hwif->drives[1]));
-		} else {
-			outb(hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-		}
-	} else {
-		printk(KERN_WARNING "Unknown qd65xx tuning fonction !\n");
-		printk(KERN_WARNING "keeping settings !\n");
-	}
-}
-*/
-
 static const struct ide_port_info qd65xx_port_info __initdata = {
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
