Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYI3HqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYI3HqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYI3HmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59011 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYI3HmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:10 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: correct comment for commit_on_unmount
Date: Tue, 30 Sep 2008 12:19:11 +0300
Message-Id: <1222766358-21886-16-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:37.0709 (UTC) FILETIME=[F85B7DD0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cf078b5..dae1c62 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1465,12 +1465,9 @@ out:
  * commit_on_unmount - commit the journal when un-mounting.
  * @c: UBIFS file-system description object
  *
- * This function is called during un-mounting and it commits the journal unless
- * the "fast unmount" mode is enabled. It also avoids committing the journal if
- * it contains too few data.
- *
- * Sometimes recovery requires the journal to be committed at least once, and
- * this function takes care about this.
+ * This function is called during un-mounting and re-mounting, and it commits
+ * the journal unless the "fast unmount" mode is enabled. It also avoids
+ * committing the journal if it contains too few data.
  */
 static void commit_on_unmount(struct ubifs_info *c)
 {
-- 
1.5.4.1

