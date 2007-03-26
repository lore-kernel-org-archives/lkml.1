Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXCZKLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXCZKLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXCZKLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:11:13 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:38035 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXCZKLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:11:10 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="32577228:sNHT28012838"
Subject: [PATCH -mm] Blackfin arch: cleanup cache header file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:11:42 +0800
Message-Id: <1174903902.32691.64.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

According to Paul's review, this patch cleanup the
include/asm-blackfin/cache.h comments.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 include/asm-blackfin/cache.h |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/include/asm-blackfin/cache.h
===================================================================
--- linux-2.6.orig/include/asm-blackfin/cache.h
+++ linux-2.6/include/asm-blackfin/cache.h
@@ -1,13 +1,21 @@
+/*
+ * include/asm-blackfin/cache.h
+ */
 #ifndef __ARCH_BLACKFIN_CACHE_H
 #define __ARCH_BLACKFIN_CACHE_H
 
-/* bytes per L1 cache line */
-#define        L1_CACHE_SHIFT  5	/* BlackFin loads 32 bytes for cache */
-#define        L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
+/*
+ * Bytes per L1 cache line
+ * Blackfin loads 32 bytes for cache
+ */
+#define L1_CACHE_SHIFT	5
+#define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-/* For speed we do need to align these ...MaTed---*/
-/*  But include/linux/cache.h does this for us if we DO not define ...MaTed---*/
-#define __cacheline_aligned	/***** maybe no need this   Tony *****/
+/*
+ * Don't make __cacheline_aligned and
+ * ____cacheline_aligned defined in include/linux/cache.h
+ */
+#define __cacheline_aligned
 #define ____cacheline_aligned
 
 /*
_

Thanks
-Bryan
