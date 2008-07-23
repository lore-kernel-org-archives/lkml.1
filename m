Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYGWSu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYGWSu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYGWSuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:50:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29899 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYGWSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=GQggtlPyzufCW/qknXlpgsiPnm8I9tWFXPhuj8BUsn7L3d0hS/U+7EGYh7VgTPNQAp
         Yf5PJLB6pbYccg6ciY4tNQNNbzLJ5+SQ8iE8h8VsXet0zwyU+6m1HB8OcjBPpJrk/Jci
         GNK7AdZIPp0StZQC7nEkEuYCk6hCY3QiHa8uc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/7] libata: WIN_* -> ATA_CMD_*
Date: Wed, 23 Jul 2008 20:41:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807232041.42750.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/libata-scsi.c
===================================================================
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -398,7 +398,7 @@ int ata_cmd_ioctl(struct scsi_device *sc
 	scsi_cmd[0] = ATA_16;
 
 	scsi_cmd[4] = args[2];
-	if (args[0] == WIN_SMART) { /* hack -- ide driver does this too... */
+	if (args[0] == ATA_CMD_SMART) { /* hack -- ide driver does this too */
 		scsi_cmd[6]  = args[3];
 		scsi_cmd[8]  = args[1];
 		scsi_cmd[10] = 0x4f;
