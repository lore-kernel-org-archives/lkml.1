Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYDBBIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYDBBIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 21:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYDBBIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 21:08:14 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48583 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYDBBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 21:08:13 -0400
Date: Tue, 1 Apr 2008 21:08:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove __KERNEL__ tests of unexported headers under
 asm-generic/.
Message-ID: <alpine.LFD.1.00.0804011959020.28479@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  just another directory's worth of cleanup ...


 include/asm-generic/bitops.h       |    4 ----
 include/asm-generic/futex.h        |    3 ---
 include/asm-generic/memory_model.h |    2 --
 include/asm-generic/page.h         |    2 --
 include/asm-generic/rtc.h          |    3 ---
 5 files changed, 14 deletions(-)

diff --git a/include/asm-generic/bitops.h b/include/asm-generic/bitops.h
index 15e6f25..c9f369c 100644
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -17,8 +17,6 @@
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>

-#ifdef __KERNEL__
-
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif
@@ -32,6 +30,4 @@
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>

-#endif /* __KERNEL__ */
-
 #endif /* _ASM_GENERIC_BITOPS_H */
diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
index f422df0..81644fd 100644
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_GENERIC_FUTEX_H
 #define _ASM_GENERIC_FUTEX_H

-#ifdef __KERNEL__
-
 #include <linux/futex.h>
 #include <asm/errno.h>
 #include <asm/uaccess.h>
@@ -56,4 +54,3 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 }

 #endif
-#endif
diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index 52226e1..ae060c6 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_MEMORY_MODEL_H
 #define __ASM_MEMORY_MODEL_H

-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__

 #if defined(CONFIG_FLATMEM)
@@ -81,6 +80,5 @@ extern unsigned long page_to_pfn(struct page *page);
 #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */

 #endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */

 #endif
diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index a96b5d9..14db733 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_GENERIC_PAGE_H
 #define _ASM_GENERIC_PAGE_H

-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__

 #include <linux/compiler.h>
@@ -21,6 +20,5 @@ static __inline__ __attribute_const__ int get_order(unsigned long size)
 }

 #endif	/* __ASSEMBLY__ */
-#endif	/* __KERNEL__ */

 #endif	/* _ASM_GENERIC_PAGE_H */
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index dd1bed8..be4af00 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -12,8 +12,6 @@
 #ifndef __ASM_RTC_H__
 #define __ASM_RTC_H__

-#ifdef __KERNEL__
-
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
@@ -213,5 +211,4 @@ static inline int set_rtc_pll(struct rtc_pll_info *pll)
 	return -EINVAL;
 }

-#endif /* __KERNEL__ */
 #endif /* __ASM_RTC_H__ */

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
