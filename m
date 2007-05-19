Return-Path: <linux-kernel-owner+w=401wt.eu-S1764482AbXESXlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764482AbXESXlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXESXlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:41:12 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:44852 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbXESXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:41:11 -0400
Date: Sun, 20 May 2007 01:41:02 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070519234338.27317.98027.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/block/z2ram: Remove TRUE/FALSE defines
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defines of TRUE and FALSE
  * not used in the file
  * the file is not included somewhere else

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Not compile-tested (don't have an Amiga-crosscompiler), but it is trivial.
Diffed against Linus' git-tree.


diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 7cc2685..2abf94c 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -44,9 +44,6 @@
 extern int m68k_realnum_memory;
 extern struct mem_info m68k_memory[NUM_MEMINFO];
 
-#define TRUE                  (1)
-#define FALSE                 (0)
-
 #define Z2MINOR_COMBINED      (0)
 #define Z2MINOR_Z2ONLY        (1)
 #define Z2MINOR_CHIPONLY      (2)
