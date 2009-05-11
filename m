Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZEKMtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZEKMtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZEKMtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:49:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:39580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbZEKMtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:49:14 -0400
Date: Mon, 11 May 2009 12:48:40 GMT
From: tip-bot for Jiri Slaby <jirislaby@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, jirislaby@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, jirislaby@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1241769638-27301-1-git-send-email-jirislaby@gmail.com>
References: <1241769638-27301-1-git-send-email-jirislaby@gmail.com>
Subject: [tip:core/iommu] dma-mapping.h: mark DMA_nBITS_MASK as deprecated
Message-ID: <tip-0802bbd72dbc0e285799258efbf99e2e822ad8cb@git.kernel.org>
Git-Commit-ID: 0802bbd72dbc0e285799258efbf99e2e822ad8cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 12:48:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0802bbd72dbc0e285799258efbf99e2e822ad8cb
Gitweb:     http://git.kernel.org/tip/0802bbd72dbc0e285799258efbf99e2e822ad8cb
Author:     Jiri Slaby <jirislaby@gmail.com>
AuthorDate: Fri, 8 May 2009 10:00:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 14:45:43 +0200

dma-mapping.h: mark DMA_nBITS_MASK as deprecated

Mark them deprecated so that 3rd party vendors get notified about that
before their modules break by removing those macros later.

[ Impact: trigger cleanups by emitting deprecation messages ]

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yanghy@cn.fujitsu.com
Cc: akpm@linux-foundation.org
LKML-Reference: <1241769638-27301-1-git-send-email-jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/dma-mapping.h |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 8083b6a..6bf3339 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -63,24 +63,26 @@ struct dma_map_ops {
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
+typedef u64 DMA_DEPRECATED __deprecated;
+
 /*
  * NOTE: do not use the below macros in new code and do not add new definitions
  * here.
  *
  * Instead, just open-code DMA_BIT_MASK(n) within your driver
  */
-#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
-#define DMA_48BIT_MASK	DMA_BIT_MASK(48)
-#define DMA_47BIT_MASK	DMA_BIT_MASK(47)
-#define DMA_40BIT_MASK	DMA_BIT_MASK(40)
-#define DMA_39BIT_MASK	DMA_BIT_MASK(39)
-#define DMA_35BIT_MASK	DMA_BIT_MASK(35)
-#define DMA_32BIT_MASK	DMA_BIT_MASK(32)
-#define DMA_31BIT_MASK	DMA_BIT_MASK(31)
-#define DMA_30BIT_MASK	DMA_BIT_MASK(30)
-#define DMA_29BIT_MASK	DMA_BIT_MASK(29)
-#define DMA_28BIT_MASK	DMA_BIT_MASK(28)
-#define DMA_24BIT_MASK	DMA_BIT_MASK(24)
+#define DMA_64BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(64)
+#define DMA_48BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(48)
+#define DMA_47BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(47)
+#define DMA_40BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(40)
+#define DMA_39BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(39)
+#define DMA_35BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(35)
+#define DMA_32BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(32)
+#define DMA_31BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(31)
+#define DMA_30BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(30)
+#define DMA_29BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(29)
+#define DMA_28BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(28)
+#define DMA_24BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(24)
 
 #define DMA_MASK_NONE	0x0ULL
 
