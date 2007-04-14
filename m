Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXDNVUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXDNVUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXDNVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:20:15 -0400
Received: from gw.goop.org ([64.81.55.164]:59526 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbXDNVUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:13 -0400
Message-Id: <20070414204923.447804915@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:41:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/28] revert account-for-module-percpu-space-separately-from-kernel-percpu
Content-Disposition: inline; filename=revert-mm-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-i386/percpu.h |   10 ----------
 1 file changed, 10 deletions(-)

===================================================================
--- a/include/asm-i386/percpu.h
+++ b/include/asm-i386/percpu.h
@@ -4,16 +4,6 @@
 #ifndef __ASSEMBLY__
 #include <asm-generic/percpu.h>
 #else
-
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
 
 /*
  * PER_CPU finds an address of a per-cpu variable.

-- 

