Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXGaTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXGaTSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXGaTSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:18:35 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3001 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXGaTSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:18:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 52] include/asm-m32r/thread_info.h: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 21:18:33 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312118.34417.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-m32r/thread_info.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/include/asm-m32r/thread_info.h	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/include/asm-m32r/thread_info.h	2007-07-31 15:08:17.000000000 +0200
@@ -100,9 +100,8 @@ static inline struct thread_info *curren
 	({							\
 		struct thread_info *ret;			\
 	 							\
-	 	ret = kmalloc(THREAD_SIZE, GFP_KERNEL);		\
-	 	if (ret)					\
-	 		memset(ret, 0, THREAD_SIZE);		\
+	 	ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
+								\
 	 	ret;						\
 	 })
 #else
