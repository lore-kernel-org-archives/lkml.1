Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbXJMRFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbXJMRFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbXJMRFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:05:34 -0400
Received: from quark.didntduck.org ([69.55.226.66]:47820 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXJMRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:05:32 -0400
X-Greylist: delayed 3574 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 13:05:31 EDT
Message-ID: <4710ECD9.2070600@didntduck.org>
Date: Sat, 13 Oct 2007 12:05:45 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: trivial header merges
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Merge 32/64-bit headers that simply redirect to asm-generic

Signed-off-by: Brian Gerst <bgerst@didntduck.org>
---
 include/asm-x86/cputime.h     |    6 +-----
 include/asm-x86/cputime_32.h  |    6 ------
 include/asm-x86/cputime_64.h  |    6 ------
 include/asm-x86/errno.h       |   14 +-------------
 include/asm-x86/errno_32.h    |    6 ------
 include/asm-x86/errno_64.h    |    6 ------
 include/asm-x86/resource.h    |   14 +-------------
 include/asm-x86/resource_32.h |    6 ------
 include/asm-x86/resource_64.h |    6 ------
 include/asm-x86/rtc.h         |    6 +-----
 include/asm-x86/rtc_32.h      |   10 ----------
 include/asm-x86/rtc_64.h      |   10 ----------
 include/asm-x86/sections.h    |    6 +-----
 include/asm-x86/sections_32.h |    7 -------
 include/asm-x86/sections_64.h |    7 -------
 15 files changed, 5 insertions(+), 111 deletions(-)
 delete mode 100644 include/asm-x86/cputime_32.h
 delete mode 100644 include/asm-x86/cputime_64.h
 delete mode 100644 include/asm-x86/errno_32.h
 delete mode 100644 include/asm-x86/errno_64.h
 delete mode 100644 include/asm-x86/resource_32.h
 delete mode 100644 include/asm-x86/resource_64.h
 delete mode 100644 include/asm-x86/rtc_32.h
 delete mode 100644 include/asm-x86/rtc_64.h
 delete mode 100644 include/asm-x86/sections_32.h
 delete mode 100644 include/asm-x86/sections_64.h

diff --git a/include/asm-x86/cputime.h b/include/asm-x86/cputime.h
index 87c37cf..6d68ad7 100644
--- a/include/asm-x86/cputime.h
+++ b/include/asm-x86/cputime.h
@@ -1,5 +1 @@
-#ifdef CONFIG_X86_32
-# include "cputime_32.h"
-#else
-# include "cputime_64.h"
-#endif
+#include <asm-generic/cputime.h>
diff --git a/include/asm-x86/cputime_32.h b/include/asm-x86/cputime_32.h
deleted file mode 100644
index 398ed7c..0000000
--- a/include/asm-x86/cputime_32.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __I386_CPUTIME_H
-#define __I386_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __I386_CPUTIME_H */
diff --git a/include/asm-x86/cputime_64.h b/include/asm-x86/cputime_64.h
deleted file mode 100644
index a07012d..0000000
--- a/include/asm-x86/cputime_64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __X86_64_CPUTIME_H
-#define __X86_64_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __X86_64_CPUTIME_H */
diff --git a/include/asm-x86/errno.h b/include/asm-x86/errno.h
index 9d511be..4c82b50 100644
--- a/include/asm-x86/errno.h
+++ b/include/asm-x86/errno.h
@@ -1,13 +1 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "errno_32.h"
-# else
-#  include "errno_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "errno_32.h"
-# else
-#  include "errno_64.h"
-# endif
-#endif
+#include <asm-generic/errno.h>
diff --git a/include/asm-x86/errno_32.h b/include/asm-x86/errno_32.h
deleted file mode 100644
index 969b343..0000000
--- a/include/asm-x86/errno_32.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _I386_ERRNO_H
-#define _I386_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/include/asm-x86/errno_64.h b/include/asm-x86/errno_64.h
deleted file mode 100644
index 3111821..0000000
--- a/include/asm-x86/errno_64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _X8664_ERRNO_H
-#define _X8664_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/include/asm-x86/resource.h b/include/asm-x86/resource.h
index 732410a..04bc4db 100644
--- a/include/asm-x86/resource.h
+++ b/include/asm-x86/resource.h
@@ -1,13 +1 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "resource_32.h"
-# else
-#  include "resource_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "resource_32.h"
-# else
-#  include "resource_64.h"
-# endif
-#endif
+#include <asm-generic/resource.h>
diff --git a/include/asm-x86/resource_32.h b/include/asm-x86/resource_32.h
deleted file mode 100644
index 6c1ea37..0000000
--- a/include/asm-x86/resource_32.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _I386_RESOURCE_H
-#define _I386_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/include/asm-x86/resource_64.h b/include/asm-x86/resource_64.h
deleted file mode 100644
index f40b406..0000000
--- a/include/asm-x86/resource_64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _X8664_RESOURCE_H
-#define _X8664_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/include/asm-x86/rtc.h b/include/asm-x86/rtc.h
index 1f0c98e..f71c3b0 100644
--- a/include/asm-x86/rtc.h
+++ b/include/asm-x86/rtc.h
@@ -1,5 +1 @@
-#ifdef CONFIG_X86_32
-# include "rtc_32.h"
-#else
-# include "rtc_64.h"
-#endif
+#include <asm-generic/rtc.h>
diff --git a/include/asm-x86/rtc_32.h b/include/asm-x86/rtc_32.h
deleted file mode 100644
index ffd0210..0000000
--- a/include/asm-x86/rtc_32.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _I386_RTC_H
-#define _I386_RTC_H
-
-/*
- * x86 uses the default access methods for the RTC.
- */
-
-#include <asm-generic/rtc.h>
-
-#endif
diff --git a/include/asm-x86/rtc_64.h b/include/asm-x86/rtc_64.h
deleted file mode 100644
index 18ed713..0000000
--- a/include/asm-x86/rtc_64.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _X86_64_RTC_H
-#define _X86_64_RTC_H
-
-/*
- * x86 uses the default access methods for the RTC.
- */
-
-#include <asm-generic/rtc.h>
-
-#endif
diff --git a/include/asm-x86/sections.h b/include/asm-x86/sections.h
index ae6c69d..2b8c516 100644
--- a/include/asm-x86/sections.h
+++ b/include/asm-x86/sections.h
@@ -1,5 +1 @@
-#ifdef CONFIG_X86_32
-# include "sections_32.h"
-#else
-# include "sections_64.h"
-#endif
+#include <asm-generic/sections.h>
diff --git a/include/asm-x86/sections_32.h b/include/asm-x86/sections_32.h
deleted file mode 100644
index 2dcbb92..0000000
--- a/include/asm-x86/sections_32.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _I386_SECTIONS_H
-#define _I386_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
diff --git a/include/asm-x86/sections_64.h b/include/asm-x86/sections_64.h
deleted file mode 100644
index c746d9f..0000000
--- a/include/asm-x86/sections_64.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _X8664_SECTIONS_H
-#define _X8664_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
-- 
1.5.3.GIT


