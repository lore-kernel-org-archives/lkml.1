Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYLVTQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYLVTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYLVTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:15:26 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:19066 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbYLVTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:15:24 -0500
Subject: [PATCH 03/27] drivers/net: fix sparse warning: returning void-valued
	expression
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:15:17 +0100
Message-ID: <20081222191517.11807.20718.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

  drivers/net/niu.c:8850:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/niu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 022866d..a4b6913 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -8847,7 +8847,7 @@ static u64 niu_pci_map_page(struct device *dev, struct page *page,
 static void niu_pci_unmap_page(struct device *dev, u64 dma_address,
 			       size_t size, enum dma_data_direction direction)
 {
-	return dma_unmap_page(dev, dma_address, size, direction);
+	dma_unmap_page(dev, dma_address, size, direction);
 }
 
 static u64 niu_pci_map_single(struct device *dev, void *cpu_addr,

