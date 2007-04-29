Return-Path: <linux-kernel-owner+w=401wt.eu-S1161113AbXD2U61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113AbXD2U61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXD2U61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:58:27 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:49445 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161113AbXD2U6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:58:25 -0400
Message-id: <15356615225989227@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 8/21] Char: cyclades, mark cyy_init_card as __devinit, not __init
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:58:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, mark cyy_init_card as __devinit, not __init

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 289b6204e150db7f487f53c227318b950b29d863
tree 5772496b7ff3f5c7daa36f507d3f8012d5fa4023
parent af4b7e8923a0ea9ca7427667977500484a3ca661
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 20:46:40 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:47:04 +0200

 drivers/char/cyclades.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 7a15300..738903d 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4651,8 +4651,8 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo,
 
 /* initialize chips on Cyclom-Y card -- return number of valid
    chips (which is number of ports/4) */
-static unsigned short __init
-cyy_init_card(void __iomem * true_base_addr, int index)
+static unsigned short __devinit cyy_init_card(void __iomem *true_base_addr,
+		int index)
 {
 	unsigned int chip_number;
 	void __iomem *base_addr;
