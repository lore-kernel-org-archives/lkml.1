Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbXLQTsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbXLQTsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761497AbXLQTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:07 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3040 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761408AbXLQTcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:32:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/macintosh/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:39 -0800
Message-Id: <1197919875-5288-40-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/macintosh/smu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index d409f67..8ba4938 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -12,7 +12,7 @@
  *  - maybe add timeout to commands ?
  *  - blocking version of time functions
  *  - polling version of i2c commands (including timer that works with
- *    interrutps off)
+ *    interrupts off)
  *  - maybe avoid some data copies with i2c by directly using the smu cmd
  *    buffer and a lower level internal interface
  *  - understand SMU -> CPU events and implement reception of them via
@@ -179,7 +179,7 @@ static irqreturn_t smu_db_intr(int irq, void *arg)
 		/* CPU might have brought back the cache line, so we need
 		 * to flush again before peeking at the SMU response. We
 		 * flush the entire buffer for now as we haven't read the
-		 * reply lenght (it's only 2 cache lines anyway)
+		 * reply length (it's only 2 cache lines anyway)
 		 */
 		faddr = (unsigned long)smu->cmd_buf;
 		flush_inval_dcache_range(faddr, faddr + 256);
-- 
1.5.3.7.949.g2221a6

