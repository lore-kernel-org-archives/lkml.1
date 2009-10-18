Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZJRWtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZJRWtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZJRWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:49:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:55995 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755440AbZJRWtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:49:22 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX1+T9tUlmP2TQk+w7e27bZ015UMxRRE++X3VCCfhyl
	uw+EaMNfU3VSc1
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/1] Make totalhigh_pages of consistent type.
Date: Mon, 19 Oct 2009 00:49:28 +0200
Message-Id: <1255906168-19279-2-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255906168-19279-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <1255906168-19279-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 include/linux/highmem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 211ff44..ab2cc20 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -46,7 +46,7 @@ void kmap_flush_unused(void);
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
-#define totalhigh_pages 0
+#define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
 static inline void *kmap(struct page *page)
-- 
1.6.4.3

