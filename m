Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0CFTIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 14:08:09 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:58437 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0CFTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 14:08:08 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [mtd, nandsim] Fix typo: struct nandsin_geometry
Date: Sat, 06 Mar 2010 20:08:00 +0100
Message-ID: <87aaul1d67.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, this embedded struct (together with nandsim_regs) could as well
remain nameless...

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/mtd/nand/nandsim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 7281000..803ae12 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -312,7 +312,7 @@ struct nandsim {
 	union ns_mem buf;
 
 	/* NAND flash "geometry" */
-	struct nandsin_geometry {
+	struct nandsim_geometry {
 		uint64_t totsz;     /* total flash size, bytes */
 		uint32_t secsz;     /* flash sector (erase block) size, bytes */
 		uint pgsz;          /* NAND flash page size, bytes */
-- 
1.5.6.5

