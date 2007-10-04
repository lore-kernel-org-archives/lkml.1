Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbXJDLeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbXJDLeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbXJDL24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:56 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:36419 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbXJDL23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:29 -0400
Message-Id: <20071004112830.875676045@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 23/34] Get rid of ARCH_KMALLOC_MINALIGN.
Content-Disposition: inline; filename=023-arch-align.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

slab cache debugging code has been changed so that we always get a
minimum alignment of the alignment of a 64-integer. Since this is
8 on s390/s390x there is no need of ARCH_KMALLOC_MINALIGN anymore.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/cache.h |    2 --
 1 file changed, 2 deletions(-)

Index: quilt-2.6/include/asm-s390/cache.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/cache.h
+++ quilt-2.6/include/asm-s390/cache.h
@@ -14,8 +14,6 @@
 #define L1_CACHE_BYTES     256
 #define L1_CACHE_SHIFT     8
 
-#define ARCH_KMALLOC_MINALIGN	8
-
 #define __read_mostly __attribute__((__section__(".data.read_mostly")))
 
 #endif

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

