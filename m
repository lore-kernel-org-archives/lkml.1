Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYHMIrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYHMIrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYHMIju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46405 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYHMIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:48 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: correct spelling of "thrice".
Date: Wed, 13 Aug 2008 13:17:52 +0300
Message-Id: <1218622675-28853-24-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:04.0519 (UTC) FILETIME=[0AFCF570:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/budget.c |    4 ++--
 fs/ubifs/find.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 323d83a..1540981 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -263,7 +263,7 @@ int ubifs_calc_min_idx_lebs(struct ubifs_info *c)
 
 	idx_size = c->old_idx_sz + c->budg_idx_growth + c->budg_uncommitted_idx;
 
-	/* And make sure we have trice the index size of space reserved */
+	/* And make sure we have thrice the index size of space reserved */
 	idx_size = idx_size + (idx_size << 1);
 
 	/*
@@ -388,7 +388,7 @@ static int can_use_rp(struct ubifs_info *c)
  * This function makes sure UBIFS has enough free eraseblocks for index growth
  * and data.
  *
- * When budgeting index space, UBIFS reserves trice as more LEBs as the index
+ * When budgeting index space, UBIFS reserves thrice as many LEBs as the index
  * would take if it was consolidated and written to the flash. This guarantees
  * that the "in-the-gaps" commit method always succeeds and UBIFS will always
  * be able to commit dirty index. So this function basically adds amount of
diff --git a/fs/ubifs/find.c b/fs/ubifs/find.c
index c70c767..adee7b5 100644
--- a/fs/ubifs/find.c
+++ b/fs/ubifs/find.c
@@ -290,7 +290,7 @@ int ubifs_find_dirty_leb(struct ubifs_info *c, struct ubifs_lprops *ret_lp,
 		idx_lp = idx_heap->arr[0];
 		sum = idx_lp->free + idx_lp->dirty;
 		/*
-		 * Since we reserve trice as more space for the index than it
+		 * Since we reserve thrice as much space for the index than it
 		 * actually takes, it does not make sense to pick indexing LEBs
 		 * with less than, say, half LEB of dirty space. May be half is
 		 * not the optimal boundary - this should be tested and
-- 
1.5.4.1

