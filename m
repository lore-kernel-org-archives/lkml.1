Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZK0S6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZK0S6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZK0S6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:58:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51786 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZK0S6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=AbiihI3q2/u5IzjNAduBeDWV3v/ud1CXEeqmLpzsHB/ZLqWFF4MKTU7akjx9dl7lrW
         jQwuyFcKqzkudi8tcOipNqAvOI04M3IJ5EjA9A1EubSRpg7copqn7xHQq5EkKpzijVB6
         AXzrXQxlI5WHdZkVVDs9Nrm8M80ws14BfhvOE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] pata_oldpiix: MWDMA0 is unsupported
Date: Fri, 27 Nov 2009 19:53:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <200911271953.35241.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MWDMA0 timings cannot be met with the PIIX based controller
programming interface.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_oldpiix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -198,7 +198,7 @@ static int oldpiix_init_one (struct pci_
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.port_ops	= &oldpiix_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
