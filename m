Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbXGPWIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbXGPWIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbXGPWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:08:03 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43445 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbXGPWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:08:00 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 16 Jul 2007 18:06:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Force erroneous inclusions of compiler-*.h files to be
 errors.
Message-ID: <Pine.LNX.4.64.0707161801560.12661@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace worthless comments with actual preprocessor errors when
including the wrong versions of the compiler.h files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 include/linux/compiler-gcc.h   |    4 +++-
 include/linux/compiler-gcc3.h  |    4 +++-
 include/linux/compiler-gcc4.h  |    4 +++-
 include/linux/compiler-intel.h |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 03ec231..4590df2 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
+#endif

 /*
  * Common definitions for all gcc versions go here.
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index a9e2863..66af0be 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
+#endif

 /* These definitions are for GCC v3.x.  */
 #include <linux/compiler-gcc.h>
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index a03e939..03ce2dd 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc4.h> directly, include <linux/compiler.h> instead."
+#endif

 /* These definitions are for GCC v4.x.  */
 #include <linux/compiler-gcc.h>
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index b769961..2851a7f 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-intel.h> directly, include <linux/compiler.h> instead."
+#endif

 #ifdef __ECC

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
