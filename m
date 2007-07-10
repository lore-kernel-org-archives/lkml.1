Return-Path: <linux-kernel-owner+w=401wt.eu-S1764448AbXGJJcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764448AbXGJJcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764225AbXGJJ27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:28:59 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:20400 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762264AbXGJJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:47 -0400
Message-Id: <20070710093118.952355099@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:45 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/16] Remove volatile from atomic_t
Content-Disposition: inline; filename=010-atomic.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Follow i386/x86_64 and remove 'volatile' from atomic_t.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/include/asm-s390/atomic.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/atomic.h
+++ quilt-2.6/include/asm-s390/atomic.h
@@ -24,7 +24,7 @@
  */
 
 typedef struct {
-	volatile int counter;
+	int counter;
 } __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
@@ -141,7 +141,7 @@ static __inline__ int atomic_add_unless(
 
 #ifdef __s390x__
 typedef struct {
-	volatile long long counter;
+	long long counter;
 } __attribute__ ((aligned (8))) atomic64_t;
 #define ATOMIC64_INIT(i)  { (i) }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

