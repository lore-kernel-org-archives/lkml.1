Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYIIQJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYIIQJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYIIQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:54 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58224 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYIIQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/2] x86: remove duplicated extern force_iommu
Date: Wed, 10 Sep 2008 00:49:47 +0900
Message-Id: <1220975388-8318-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220975388-8318-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220975388-8318-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both iommu.h and dma-mapping.h have extern force_iommu. The latter
doesn't need to do.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-x86/dma-mapping.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 8bb3108..9dd92b4 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -16,7 +16,6 @@ extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
-extern int force_iommu;
 
 struct dma_mapping_ops {
 	int             (*mapping_error)(struct device *dev,
-- 
1.5.4.2

