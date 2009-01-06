Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZAFWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZAFWXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZAFWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:48 -0500
Received: from kroah.org ([198.145.64.141]:51255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755960AbZAFWNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/60] swiotlb: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:48 -0800
Message-Id: <1231279939-32728-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7f5e21b..c2a4e64 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -647,7 +647,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	 * the damage, or panic when the transfer is too big.
 	 */
 	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
-	       "device %s\n", size, dev ? dev->bus_id : "?");
+	       "device %s\n", size, dev ? dev_name(dev) : "?");
 
 	if (size > io_tlb_overflow && do_panic) {
 		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
-- 
1.6.0.4

