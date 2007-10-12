Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXJLGva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXJLGva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXJLGvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:51:22 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1075 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbXJLGvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:51:22 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] add missing parenthesis in cfe_writeblk() macro
Date: Fri, 12 Oct 2007 08:51:16 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120851.17600.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing parenthesis in cfe_writeblk() macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-mips/fw/cfe/cfe_api.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-mm1-a/include/asm-mips/fw/cfe/cfe_api.h	2007-10-12 08:25:46.000000000 +0200
+++ linux-2.6.23-mm1-b/include/asm-mips/fw/cfe/cfe_api.h	2007-10-12 08:37:42.000000000 +0200
@@ -154,7 +154,7 @@ int64_t cfe_getticks(void);
 #define cfe_readblk(a, b, c, d)		__cfe_readblk(a, b, c, d)
 #define cfe_setenv(a, b)		__cfe_setenv(a, b)
 #define cfe_write(a, b, c)		__cfe_write(a, b, c)
-#define cfe_writeblk(a, b, c, d		__cfe_writeblk(a, b, c, d)
+#define cfe_writeblk(a, b, c, d)	__cfe_writeblk(a, b, c, d)
 #endif				/* CFE_API_IMPL_NAMESPACE */

 int cfe_close(int handle);
