Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZFNDCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZFNDCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 23:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZFNDCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 23:02:00 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:25088 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZFNDB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 23:01:59 -0400
Message-ID: <4A3467E6.6010907@oracle.com>
Date: Sat, 13 Jun 2009 20:00:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH] atomic_32.h: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A3467E7.009B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in atomic_32.h:

Warning(arch/x86/include/asm/atomic_32.h:265): No description found for parameter 'ptr'
Warning(arch/x86/include/asm/atomic_32.h:265): Excess function parameter 'v' description in '__atomic64_read'
Warning(arch/x86/include/asm/atomic_32.h:305): Excess function parameter 'old_val' description in 'atomic64_xchg'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/include/asm/atomic_32.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.30-git7.orig/arch/x86/include/asm/atomic_32.h
+++ linux-2.6.30-git7/arch/x86/include/asm/atomic_32.h
@@ -257,7 +257,7 @@ typedef struct {
 
 /**
  * atomic64_read - read atomic64 variable
- * @v: pointer of type atomic64_t
+ * @ptr: pointer of type atomic64_t
  *
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
@@ -294,7 +294,6 @@ atomic64_cmpxchg(atomic64_t *ptr, unsign
  * atomic64_xchg - xchg atomic64 variable
  * @ptr:      pointer to type atomic64_t
  * @new_val:  value to assign
- * @old_val:  old value that was there
  *
  * Atomically xchgs the value of @ptr to @new_val and returns
  * the old value.
