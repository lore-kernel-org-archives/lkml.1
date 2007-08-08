Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbXHHK7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbXHHK7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXHHK73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:59:29 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:46327 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbXHHK72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cYgzpzMXptn+KAZY0QvV/emhRT51PWzTPkVKTvO7eYUuZ3rCqUtsu/usFgMyQG7IIToTvYmTdqx43HvCNS2o8OH0Lxd/g7APrrvn4u+F+QfQ3M/ne3mjRAooC9jFu922fMeeX5JpRaJW/lQ0S7DMNHLIKxgnwfNwVIDAQLGJMic=
Message-ID: <c70ff3ad0708080359m1dae4fbes6955d38b1da51323@mail.gmail.com>
Date: Wed, 8 Aug 2007 13:59:26 +0300
From: "saeed bishara" <saeed.bishara@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: [PATCH] use sg helper function in DMA mapping documentation
Cc: "saeed bishara" <saeed.bishara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Saeed Bishara <saeed.bishara@gmail.com>
---
 DMA-mapping.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)


--- a/Documentation/DMA-mapping.txt     2007-08-08 12:51:07.000000000 +0300
+++ b/Documentation/DMA-mapping.txt     2007-08-08 12:50:02.000000000 +0300
@@ -514,7 +514,7 @@
        int i, count = pci_map_sg(dev, sglist, nents, direction);
        struct scatterlist *sg;

-       for (i = 0, sg = sglist; i < count; i++, sg++) {
+       for_each_sg(sglist, sg, count, i) {
                hw_address[i] = sg_dma_address(sg);
                hw_len[i] = sg_dma_len(sg);
        }
