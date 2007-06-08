Return-Path: <linux-kernel-owner+w=401wt.eu-S970084AbXFHQoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970084AbXFHQoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969789AbXFHQmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:42:13 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25233 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S969577AbXFHQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:42:12 -0400
Date: Fri, 08 Jun 2007 10:45:11 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 5/6] driver edac i5000 define typo
Message-ID: <46698797.gPsgEJihEQE/hfwn%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Marisuz Kozlowski <m.kozlowski@tuxland.pl>

Found a typo in one of the #defines in the driver

MTR_DIM_RANKS --> MTR_DIMM_RANK


Signed-off-by:	Marisuz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---
 i5000_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/i5000_edac.c
@@ -279,7 +279,7 @@
 #define MTR_DRAM_BANKS(mtr)		((((mtr) >> 5) & 0x1) ? 8 : 4)
 #define MTR_DRAM_BANKS_ADDR_BITS(mtr)	((MTR_DRAM_BANKS(mtr) == 8) ? 3 : 2)
 #define MTR_DIMM_RANK(mtr)		(((mtr) >> 4) & 0x1)
-#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIM_RANKS(mtr) ? 2 : 1)
+#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIMM_RANK(mtr) ? 2 : 1)
 #define MTR_DIMM_ROWS(mtr)		(((mtr) >> 2) & 0x3)
 #define MTR_DIMM_ROWS_ADDR_BITS(mtr)	(MTR_DIMM_ROWS(mtr) + 13)
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
