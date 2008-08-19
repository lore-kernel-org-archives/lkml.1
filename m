Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYHSAuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYHSAuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYHSAsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbYHSAsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BPk5pRgk0JsqaKhdUYlhU8w9cc2zWc9D/OA7kGfm/VJT5lSXTHlWvszSBoN85VdTvu
         ef0TS4I1qMCikTWC82aVKPAY3JIL9+cZDKNGN+5HPfAAGsllerwT6j5YkDtE2R6gZx9k
         xjwl5kmie66+VPwU3N10VbHYj61NJhuEA3Guo=
Subject: [PATCH 07/23] h8300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:04 -0700
Message-Id: <1219106884.17033.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/h8300/include/asm/byteorder.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/h8300/include/asm/byteorder.h b/arch/h8300/include/asm/byteorder.h
index 36e597d..465b7af 100644
--- a/arch/h8300/include/asm/byteorder.h
+++ b/arch/h8300/include/asm/byteorder.h
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
1.6.0.274.g8aacc


