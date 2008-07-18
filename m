Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYGRAM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYGRAM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbYGRAKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:12092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761023AbYGRAKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QCOE+wiKDbFWKEyoEXqycQ8yD0A2PeLw8A2muXFUpAnH8fckW98WA82RprRxWLeKxl
         pFSUzMtZm7gdQdCWTU1KsCAA8dXHke5nns/FifRdtmyRyLEBbMSsoOKqdoPuY5VEfIh8
         /RXqoVI8AIHb0QASMVeurfVFrJX3cD0h/VD5Y=
Subject: [PATCH 09/20] m32r: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hirokazu Takata <takata@linux-m32r.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:39 -0700
Message-Id: <1216339779.6029.120.camel@brick>
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
1.5.6.3.569.ga9185


