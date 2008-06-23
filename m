Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbYFWRvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbYFWRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbYFWRvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:51:37 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58031 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080AbYFWRvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:51:36 -0400
Date: Mon, 23 Jun 2008 20:49:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] linux/kernel.h userspace header cleanup
Message-ID: <20080623174940.GL4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing from the bottom of this header is part of the 
kernel<->userspace ABI.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/kernel.h |    4 ++++
 1 file changed, 4 insertions(+)

c023fd63795380bceef9abc92c1d6fca91791de7 diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 792bf0a..2993b80 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -487,6 +487,8 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
+#ifdef __KERNEL__
+
 /* Force a compilation error if condition is true */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
@@ -506,4 +508,6 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#endif  /*  __KERNEL__  */
+
 #endif

