Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXAXLcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXAXLcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXAXLcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:32:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56742 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbXAXLcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:32:12 -0500
Date: Wed, 24 Jan 2007 11:42:38 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH] libata: trivial stuff
Message-ID: <20070124114238.67d65fdf@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Readability/typos etc

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c	2007-01-22 16:26:50.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c	2007-01-22 16:47:01.000000000 +0000
@@ -775,7 +775,7 @@
 		 * really a timeout event, adjust error mask and
 		 * cancel frozen state.
 		 */
-		if (qc->err_mask == AC_ERR_TIMEOUT && host_stat & ATA_DMA_ERR) {
+		if (qc->err_mask == AC_ERR_TIMEOUT && (host_stat & ATA_DMA_ERR)) {
 			qc->err_mask = AC_ERR_HOST_BUS;
 			thaw = 1;
 		}
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-core.c linux-2.6.20-rc4-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-core.c	2007-01-22 16:26:50.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/libata-core.c	2007-01-24 00:13:00.000000000 +0000
@@ -1295,7 +1295,7 @@
 	if (ap->ops->post_internal_cmd)
 		ap->ops->post_internal_cmd(qc);
 
-	if (qc->flags & ATA_QCFLAG_FAILED && !qc->err_mask) {
+	if ((qc->flags & ATA_QCFLAG_FAILED) && !qc->err_mask) {
 		if (ata_msg_warn(ap))
 			ata_dev_printk(dev, KERN_WARNING,
 				"zero err_mask for failed "
@@ -2516,7 +2506,7 @@
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		dev = &ap->device[i];
 
-		/* don't udpate suspended devices' xfer mode */
+		/* don't update suspended devices' xfer mode */
 		if (!ata_dev_ready(dev))
 			continue;
 

