Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbXJWGgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbXJWGgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXJWGgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:36:08 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:47713 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXJWGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:36:07 -0400
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: build fix
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071023153536K.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 23 Oct 2007 15:35:36 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/common/dmabounce.c: In function 'dma_map_sg':
arch/arm/common/dmabounce.c:445: error: implicit declaration of function 'sg_page'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/arm/common/dmabounce.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 9d371e4..52fc6a8 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -29,6 +29,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/list.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cacheflush.h>
 
-- 
1.5.2.4

