Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYCVRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYCVRv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYCVRvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:51:20 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:38348 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754681AbYCVRvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:51:19 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/1] Arch-x86: pgtable, document pde bits
Date: Sat, 22 Mar 2008 18:50:22 +0100
Message-Id: <1206208222-9671-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of pde bits weren't documented, add the short description to them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-x86/pgtable.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..986204a 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -4,13 +4,13 @@
 #define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
-#define _PAGE_BIT_PRESENT	0
-#define _PAGE_BIT_RW		1
-#define _PAGE_BIT_USER		2
-#define _PAGE_BIT_PWT		3
-#define _PAGE_BIT_PCD		4
-#define _PAGE_BIT_ACCESSED	5
-#define _PAGE_BIT_DIRTY		6
+#define _PAGE_BIT_PRESENT	0	/* is present */
+#define _PAGE_BIT_RW		1	/* writeable */
+#define _PAGE_BIT_USER		2	/* userspace addressable */
+#define _PAGE_BIT_PWT		3	/* page write through */
+#define _PAGE_BIT_PCD		4	/* page cache disabled */
+#define _PAGE_BIT_ACCESSED	5	/* was accessed (raised by CPU) */
+#define _PAGE_BIT_DIRTY		6	/* was written to (raised by CPU) */
 #define _PAGE_BIT_FILE		6
 #define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
 #define _PAGE_BIT_PAT		7	/* on 4KB pages */
-- 
1.5.4.1

