Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbYG3A53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbYG3A53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbYG3Azf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbYG3Aze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ouTbdoKo6AgQWsebEBPV/FCA4wCChYp0vLN+hxjd9yTEXwXFRP6jdD7nCNpUyMykye
         anp/C2b1u2E2J1kAITvq6JC40AxLQKPGrBgflxwOw4PD7sg6oG4BVkBjAiUfkvDuHYYA
         wXef66OeDXomUQpaZ8OO1Yq5VJjrYm2iByFkU=
Subject: [PATCH 07/24] frv: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:20 -0700
Message-Id: <1217379320.23389.118.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-frv/byteorder.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/asm-frv/byteorder.h b/include/asm-frv/byteorder.h
index 411bec3..cb197c3 100644
--- a/include/asm-frv/byteorder.h
+++ b/include/asm-frv/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
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
 
 #endif /* _ASM_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


