Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbXLUDYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbXLUDYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXLUDYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:24:00 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:54279 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXLUDX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:23:59 -0500
Date: Thu, 20 Dec 2007 22:23:58 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mbx: Fix up duplicate defines in reg_bits.h
Message-ID: <20071221032358.GD8535@fattire.cabal.ca>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise patch gets horribly confused and falls over applying
the diff. Not sure why these were being defined twice.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
---
Well, we can get it fixed for -git1, I respun the patch-2.6.24-rc6 diff
with git diff -p v2.6.23..HEAD and applied it to a pristine linux-2.6.23
tree without issue.

cheers,
	Kyle

 drivers/video/mbx/reg_bits.h |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/video/mbx/reg_bits.h b/drivers/video/mbx/reg_bits.h
index 5f14b4b..8dc4283 100644
--- a/drivers/video/mbx/reg_bits.h
+++ b/drivers/video/mbx/reg_bits.h
@@ -540,30 +540,6 @@
 #define DINTRE_HBLNK1_EN	(1 << 1)
 #define DINTRE_HBLNK0_EN	(1 << 0)
 
-/* DINTRS - Display Interrupt Status Register */
-#define DINTRS_CUR_OR_S		(1 << 18)
-#define DINTRS_STR2_OR_S	(1 << 17)
-#define DINTRS_STR1_OR_S	(1 << 16)
-#define DINTRS_CUR_UR_S		(1 << 6)
-#define DINTRS_STR2_UR_S	(1 << 5)
-#define DINTRS_STR1_UR_S	(1 << 4)
-#define DINTRS_VEVENT1_S	(1 << 3)
-#define DINTRS_VEVENT0_S	(1 << 2)
-#define DINTRS_HBLNK1_S		(1 << 1)
-#define DINTRS_HBLNK0_S		(1 << 0)
-
-/* DINTRE - Display Interrupt Enable Register */
-#define DINTRE_CUR_OR_EN	(1 << 18)
-#define DINTRE_STR2_OR_EN	(1 << 17)
-#define DINTRE_STR1_OR_EN	(1 << 16)
-#define DINTRE_CUR_UR_EN	(1 << 6)
-#define DINTRE_STR2_UR_EN	(1 << 5)
-#define DINTRE_STR1_UR_EN	(1 << 4)
-#define DINTRE_VEVENT1_EN	(1 << 3)
-#define DINTRE_VEVENT0_EN	(1 << 2)
-#define DINTRE_HBLNK1_EN	(1 << 1)
-#define DINTRE_HBLNK0_EN	(1 << 0)
-
 
 /* DLSTS - display load status register */
 #define DLSTS_RLD_ADONE	(1 << 23)
-- 
1.5.3.6

