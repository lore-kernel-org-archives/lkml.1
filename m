Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbYCBXVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbYCBXVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYCBXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:21:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:60621 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYCBXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Yx2BvxYekQzkhPTxd+sUgrLcCGW8L3qkYeo+zW7L21WgkXC4u+aVC9EbCTbITzlgxF6E7M/nJV5ZaUUSVfuAplzMtJuP02UZmy5fTN1OaPvLeqBv9XHya9wjIdGHm+Z0koTrYa0P736yn4pdOSTWLInsx7T2bpnszcfpmlDhugc=
Subject: [PATCH 4/3] saa7146: remaining checkpatch errors
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 15:21:44 -0800
Message-Id: <1204500104.23005.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

space after comma and placement of * in function declaration.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Apparently I still had a little bit of energy left for this file.

 drivers/media/common/saa7146_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 7d44bb3..3b5c030 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -145,7 +145,7 @@ EXPORT_SYMBOL_GPL(saa7146_wait_for_debi_done);
 /* this is videobuf_vmalloc_to_sg() from videobuf-dma-sg.c
    make sure virt has been allocated with vmalloc_32(), otherwise the BUG()
    may be triggered on highmem machines */
-static struct scatterlist* vmalloc_to_sg(unsigned char *virt, int nr_pages)
+static struct scatterlist *vmalloc_to_sg(unsigned char *virt, int nr_pages)
 {
 	struct scatterlist *sglist;
 	struct page *pg;
@@ -189,7 +189,7 @@ void *saa7146_vmalloc_build_pgtable(struct pci_dev *pci, long length, struct saa
 		goto err_free_slist;
 
 	pt->nents = pages;
-	slen = pci_map_sg(pci,pt->slist,pt->nents,PCI_DMA_FROMDEVICE);
+	slen = pci_map_sg(pci, pt->slist, pt->nents, PCI_DMA_FROMDEVICE);
 	if (!slen)
 		goto err_free_pgtable;
 
-- 
1.5.4.3.409.g8811



