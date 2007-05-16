Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbXEPIih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbXEPIih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761441AbXEPIeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:15 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6621 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761435AbXEPIeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:06 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 8/19] i386: enable sg chaining
Date: Wed, 16 May 2007 10:32:22 +0200
Message-Id: <11793043542485-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to do more on x86, there's no iommu to be worried about.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-i386/scatterlist.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
index d7e45a8..bd5164a 100644
--- a/include/asm-i386/scatterlist.h
+++ b/include/asm-i386/scatterlist.h
@@ -10,6 +10,8 @@ struct scatterlist {
     unsigned int	length;
 };
 
+#define ARCH_HAS_SG_CHAIN
+
 /* These macros should be used after a pci_map_sg call has been done
  * to get bus addresses of each of the SG entries and their lengths.
  * You should only work with the number of sg entries pci_map_sg
-- 
1.5.2.rc1

