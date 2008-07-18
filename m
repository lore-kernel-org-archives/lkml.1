Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbYGRAMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbYGRAMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbYGRAKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbYGRAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HFMVtIc/cQMD+JUtF9rGEa2eVQdhpolZ08NTQxo2e0W+Qke+AYqccOkunOuuOLR++A
         z+AHGPEhoRTGvC2nBej9rkz/J8ehfQ0061Edn9mfO/oi5IyQ96zTap0fdsWi06npIM+N
         Ii7zEy49y1yjl30r761TxSo9hNjSjYbPYfdkM=
Subject: [PATCH 07/20] h8300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:38 -0700
Message-Id: <1216339778.6029.118.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-h8300/byteorder.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/asm-h8300/byteorder.h b/include/asm-h8300/byteorder.h
index 36e597d..465b7af 100644
--- a/include/asm-h8300/byteorder.h
+++ b/include/asm-h8300/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _H8300_BYTEORDER_H
 #define _H8300_BYTEORDER_H
 
-#include <asm/types.h>
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _H8300_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


