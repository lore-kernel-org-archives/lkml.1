Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYKEShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYKEShq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYKESfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:48774 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbYKESfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EAL9PGFMpQ6HU2Bolr06VPnXCZU1HF9jzaLAnrxkCnxANhABkrWj5KnLh4lXRluLp9
         EQQTzBgRYvdRbYr0xS/M87iTfWFwqc5lJjmPvjjLwuIm+UR9kazDL1tLi3nWiMfdO+Vc
         53cb6gQoCIJC2Dr3/Ba8EK1hwyqQ4L0v4aqhw=
Subject: [PATCH 07/10] m32r: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:29 -0800
Message-Id: <1225910129.5991.227.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-m32r/byteorder.h |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/asm-m32r/byteorder.h b/include/asm-m32r/byteorder.h
index 10b2c1d..a99896f 100644
--- a/include/asm-m32r/byteorder.h
+++ b/include/asm-m32r/byteorder.h
@@ -1,17 +1,14 @@
 #ifndef _ASM_M32R_BYTEORDER_H
 #define _ASM_M32R_BYTEORDER_H
 
-#include <asm/types.h>
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
 #if defined(__LITTLE_ENDIAN__)
-#  include <linux/byteorder/little_endian.h>
+# define __LITTLE_ENDIAN
 #else
-#  include <linux/byteorder/big_endian.h>
+# define __BIG_ENDIAN
 #endif
 
+#define __SWAB_64_THRU_32__
+
+#include <linux/byteorder.h>
+
 #endif /* _ASM_M32R_BYTEORDER_H */
-- 
1.6.0.3.756.gb776d


