Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbYGRALo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbYGRALo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933502AbYGRAKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761151AbYGRAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dZgHfLM4y5dyQMR+tEYpd+4d1SWPeA6Gdru0Wm89fLEmS/aXz7QuzuamnxVbAgdtH/
         hCbQiVtNL7xdkBPtd46gjfxaFlR5JS8AN/dOEewCxc0Kc9mQsg7td/js+TS/fPpeTLP3
         4FhygSKlBe2pcvCqSb2SDes5R69bwJkDhr1OY=
Subject: [PATCH 06/20] frv: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:37 -0700
Message-Id: <1216339778.6029.117.camel@brick>
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
1.5.6.3.569.ga9185


