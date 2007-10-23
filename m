Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbXJWXr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbXJWXr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXJWXrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:47:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33000
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbXJWXrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:47:48 -0400
Date: Tue, 23 Oct 2007 16:48:14 -0700 (PDT)
Message-Id: <20071023.164814.39161306.davem@davemloft.net>
To: jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org
Subject: [SPARC64]: SG build fix.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jens could you queue up this obvious typo build fix
for me?

Thanks!

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index b70324e..efd5dff 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -234,7 +234,7 @@ unsigned long prepare_sg(struct scatterlist *sg, int nents)
 	dma_sg->dma_length = dent_len;
 
 	if (dma_sg != sg) {
-		dma_sg = next_sg(dma_sg);
+		dma_sg = sg_next(dma_sg);
 		dma_sg->dma_length = 0;
 	}
 
