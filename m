Return-Path: <linux-kernel-owner+w=401wt.eu-S938522AbXGSN6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938522AbXGSN6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934794AbXGSNsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:48629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764216AbXGSNsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:51 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: rpjday@mindspring.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [20/48] i386: replace hard-coded constant with appropriate macro from kernel.h
Message-Id: <20070719134849.D1C6514E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Robert P.  J.  Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-i386/uaccess.h
===================================================================
--- linux.orig/include/asm-i386/uaccess.h
+++ linux/include/asm-i386/uaccess.h
@@ -581,7 +581,7 @@ long __must_check __strncpy_from_user(ch
  * If there is a limit on the length of a valid string, you may wish to
  * consider using strnlen_user() instead.
  */
-#define strlen_user(str) strnlen_user(str, ~0UL >> 1)
+#define strlen_user(str) strnlen_user(str, LONG_MAX)
 
 long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
