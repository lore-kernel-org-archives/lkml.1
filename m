Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZI2B4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZI2B4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZI2B4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:56:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbZI2B4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:56:04 -0400
Date: Mon, 28 Sep 2009 21:56:07 -0400
From: Dirk Hohndel <hohndel@infradead.org>
To: Jin Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [PATCH] trivial fix of a very frequent spelling mistake
Message-ID: <20090929015607.GA18220@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

something-bility is spelled as something-blity
so a grep for 'blit' would find these lines

I broke this one out from the rest as it actually changes
the output of a kernel message - so it could in theory
change the behavior of tools that parse that ouput

Jeff, can you sign-off / NAK this, please?

Signed-off-by: Dirk Hohndel <hohndel@infradead.org>
---
 drivers/ata/pata_ali.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index fc9c5d6..1432dc9 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -290,7 +290,7 @@ static void ali_warn_atapi_dma(struct ata_device *adev)
 
 	if (print_info && adev->class == ATA_DEV_ATAPI && !ali_atapi_dma) {
 		ata_dev_printk(adev, KERN_WARNING,
-			       "WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled\n");
+			       "WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled\n");
 		ata_dev_printk(adev, KERN_WARNING,
 			       "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
 	}
-- 
1.6.2.5

