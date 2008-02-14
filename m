Return-Path: <linux-kernel-owner+w=401wt.eu-S934365AbYBNFTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365AbYBNFTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764984AbYBNFOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:7923 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763589AbYBNFOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YA3wzSm654SjR/kYlb34IitRZ04khapVUPVPho2XZAdJj1GGXzirEjl4aTVMqKhE69+WZqrkatKNLZTbEsBWELDrZfbNMcy/rlh9PgSc0qatKKJegnbfCbCOG8gwrCpV616NIDufgdcNCJ94aZ7mM6nOOjWdkn0g5tcEPdlyBzw=
Subject: [PATCH 09/11] ata: fix sparse warning in pata_marvell.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:29 -0800
Message-Id: <1202966069.2748.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata/pata_marvell.c:88:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/pata_marvell.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 9afc8a3..a81f25d 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -85,8 +85,8 @@ static int marvell_cable_detect(struct ata_port *ap)
 
 static void marvell_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, marvell_pre_reset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, marvell_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 /* No PIO or DMA methods needed for this device */
-- 
1.5.4.1.1278.gc75be


