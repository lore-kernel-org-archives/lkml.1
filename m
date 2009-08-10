Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZHJIr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZHJIr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZHJIr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:47:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:46625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZHJIrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:47:25 -0400
Date: Mon, 10 Aug 2009 08:46:40 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249872797-1314-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249872797-1314-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Subject: [tip:core/iommu] IA64: Remove NULL flush_write_buffers
Message-ID: <tip-be02ff9940c0106dea1470462401a07c5d52e086@git.kernel.org>
Git-Commit-ID: be02ff9940c0106dea1470462401a07c5d52e086
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 08:46:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be02ff9940c0106dea1470462401a07c5d52e086
Gitweb:     http://git.kernel.org/tip/be02ff9940c0106dea1470462401a07c5d52e086
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 10 Aug 2009 11:53:11 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 09:34:58 +0200

IA64: Remove NULL flush_write_buffers

flush_write_buffers() in dma-mapping-common.h was removed so we
can remove NULL flush_write_buffers() in IA64.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
Cc: davem@davemloft.net
LKML-Reference: <1249872797-1314-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/include/asm/dma-mapping.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index f91829d..8d3c79c 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -44,7 +44,6 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 #define get_dma_ops(dev) platform_dma_get_ops(dev)
-#define flush_write_buffers()
 
 #include <asm-generic/dma-mapping-common.h>
 
