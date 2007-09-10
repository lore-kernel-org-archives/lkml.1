Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXIJSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXIJSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbXIJSqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:46:35 -0400
Received: from mail.fieldses.org ([66.93.2.214]:59672 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759871AbXIJSqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:46:34 -0400
Date: Mon, 10 Sep 2007 14:46:32 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dcache: trivial comment fix
Message-ID: <20070910184632.GF2947@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As it stands this comment is confusing, and not quite grammatical.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/dcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 678d39d..2bacdf6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1514,8 +1514,8 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
  * This forceful removal will result in ugly /proc output if
  * somebody holds a file open that got deleted due to a rename.
  * We could be nicer about the deleted file, and let it show
- * up under the name it got deleted rather than the name that
- * deleted it.
+ * up under the name it had before it was deleted rather than
+ * under the original name of the file that was moved on top of it.
  */
  
 /*
-- 
1.5.3

