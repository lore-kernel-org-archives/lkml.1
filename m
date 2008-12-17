Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757378AbYLQQof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYLQQof (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYLQQmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:42:13 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65182 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752047AbYLQQmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:05 -0500
Message-Id: <20081217164036.475086811@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 17 Dec 2008 17:36:36 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 1/8] crypto: testmgr - Correct comment about deflate parameters
Content-Disposition: inline; filename=crypto-testmgr-correct-deflate-windowbits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

The comment for the deflate test vectors says the winbits parameter is 11,
while the deflate module actually uses -11 (a negative window bits parameter
enables the raw deflate format instead of the zlib format).
Correct this, to avoid confusion about the format used.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -8349,7 +8349,7 @@ struct comp_testvec {
 
 /*
  * Deflate test vectors (null-terminated strings).
- * Params: winbits=11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
+ * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2

-- 
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

