Return-Path: <linux-kernel-owner+w=401wt.eu-S935685AbXFFUaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935685AbXFFUaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbXFFUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:30:03 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4527 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110AbXFFUaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:30:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: norsk5@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] edac i5000 parenthesis balance fix
Date: Wed, 6 Jun 2007 22:29:50 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706062229.52662.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch balances parenthesis in i5000 edac code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/edac/i5000_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux-2.6.22-rc4-mm1-a/drivers/edac/i5000_edac.c linux-2.6.22-rc4-mm1-b/drivers/edac/i5000_edac.c
--- linux-2.6.22-rc4-mm1-a/drivers/edac/i5000_edac.c	2007-06-06 12:32:19.000000000 +0200
+++ linux-2.6.22-rc4-mm1-b/drivers/edac/i5000_edac.c	2007-06-06 14:49:27.000000000 +0200
@@ -279,7 +279,7 @@
 #define MTR_DRAM_BANKS(mtr)		((((mtr) >> 5) & 0x1) ? 8 : 4)
 #define MTR_DRAM_BANKS_ADDR_BITS(mtr)	((MTR_DRAM_BANKS(mtr) == 8) ? 3 : 2)
 #define MTR_DIMM_RANK(mtr)		(((mtr) >> 4) & 0x1)
-#define MTR_DIMM_RANK_ADDR_BITS(mtr)	((MTR_DIM_RANKS(mtr) ? 2 : 1)
+#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIM_RANKS(mtr) ? 2 : 1)
 #define MTR_DIMM_ROWS(mtr)		(((mtr) >> 2) & 0x3)
 #define MTR_DIMM_ROWS_ADDR_BITS(mtr)	(MTR_DIMM_ROWS(mtr) + 13)
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
