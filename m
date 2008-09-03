Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYICJj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYICJj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYICJiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:38:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:44245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYICJiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:38:20 -0400
Subject: [PATCH 6/8] PowerPC: Use <asm-generic/statfs.h>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1220275314.2982.83.camel@pmac.infradead.org>
References: <1220275314.2982.83.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:38:17 +0100
Message-Id: <1220434697.2985.66.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/powerpc/include/asm/statfs.h |   54 -------------------------------------
 1 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/include/asm/statfs.h b/arch/powerpc/include/asm/statfs.h
index 6702402..5244834 100644
--- a/arch/powerpc/include/asm/statfs.h
+++ b/arch/powerpc/include/asm/statfs.h
@@ -1,60 +1,6 @@
 #ifndef _ASM_POWERPC_STATFS_H
 #define _ASM_POWERPC_STATFS_H
 
-/* For ppc32 we just use the generic definitions, not so simple on ppc64 */
-
-#ifndef __powerpc64__
 #include <asm-generic/statfs.h>
-#else
-
-#ifndef __KERNEL_STRICT_NAMES
-#include <linux/types.h>
-typedef __kernel_fsid_t	fsid_t;
-#endif
-
-/*
- * We're already 64-bit, so duplicate the definition
- */
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
 
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
-#endif /* ! __powerpc64__ */
 #endif
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



