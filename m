Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXEXRqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXEXRqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXEXRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:46:17 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4309 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXEXRqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:46:17 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: maintainers@chelsio.com
Subject: [PATCH] chelsio parenthesis fix
Date: Thu, 24 May 2007 19:46:14 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241946.15114.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Balanance parenthesis in chelsio header file.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/chelsio/suni1x10gexp_regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux-2.6.22-rc2-mm1-a/drivers/net/chelsio/suni1x10gexp_regs.h linux-2.6.22-rc2-mm1-b/drivers/net/chelsio/suni1x10gexp_regs.h
--- linux-2.6.22-rc2-mm1-a/drivers/net/chelsio/suni1x10gexp_regs.h  2007-05-19 06:06:17.000000000 +0200
+++ linux-2.6.22-rc2-mm1-b/drivers/net/chelsio/suni1x10gexp_regs.h  2007-05-24 18:18:17.000000000 +0200
@@ -105,7 +105,7 @@
 #define mSUNI1x10GEXP_REG_RXXG_EXACT_MATCH_ADDR_LOW(filterId) (0x204A + mSUNI1x10GEXP_MAC_FILTER_OFFSET(filterId))
 #define mSUNI1x10GEXP_REG_RXXG_EXACT_MATCH_ADDR_MID(filterId) (0x204B + mSUNI1x10GEXP_MAC_FILTER_OFFSET(filterId))
 #define mSUNI1x10GEXP_REG_RXXG_EXACT_MATCH_ADDR_HIGH(filterId)(0x204C + mSUNI1x10GEXP_MAC_FILTER_OFFSET(filterId))
-#define mSUNI1x10GEXP_REG_RXXG_EXACT_MATCH_VID(filterId)      (0x2062 + mSUNI1x10GEXP_MAC_VID_FILTER_OFFSET(filterId)
+#define mSUNI1x10GEXP_REG_RXXG_EXACT_MATCH_VID(filterId)      (0x2062 + mSUNI1x10GEXP_MAC_VID_FILTER_OFFSET(filterId))
 #define SUNI1x10GEXP_REG_RXXG_EXACT_MATCH_ADDR_0_LOW                     0x204A
 #define SUNI1x10GEXP_REG_RXXG_EXACT_MATCH_ADDR_0_MID                     0x204B
 #define SUNI1x10GEXP_REG_RXXG_EXACT_MATCH_ADDR_0_HIGH                    0x204C
