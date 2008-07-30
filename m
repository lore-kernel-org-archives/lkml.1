Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbYG3A6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbYG3A6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbYG3Azk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbYG3Azi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=S539epLX+NVac1hZsNuIYIkF6pfasaMKIrj1e9f8hswIkGDwWgH0nVdCwAvtaawFP9
         RNSxtHE+1L6M0jr/NXayjV5v7L2DUah4eSjuha9AWAES9QYB4hq3vbyrAcl5H4bc0w4u
         oVtfL0bgukAe1bCbkY6sB4GLStqTXWx8PxXF0=
Subject: [PATCH 10/24] m32r: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:22 -0700
Message-Id: <1217379322.23389.121.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
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
1.6.0.rc1.154.ge3fc


