Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXGPKCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXGPKCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbXGPJuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:50:10 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9295 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803AbXGPJse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:34 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, ak@suse.de
Subject: [PATCH 07/33] i386: enable sg chaining
Date: Mon, 16 Jul 2007 11:47:21 +0200
Message-Id: <11845792683787-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.rc2
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to do more on x86, there's no iommu to be worried about.

Cc: ak@suse.de
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
1.5.3.rc0.90.gbaa79

