Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYI3HnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYI3HnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYI3Hlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:41:53 -0400
Received: from smtp.nokia.com ([192.100.122.233]:41731 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYI3Hlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:41:49 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: fix commentary
Date: Tue, 30 Sep 2008 12:19:09 +0300
Message-Id: <1222766358-21886-14-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:37.0272 (UTC) FILETIME=[F818CF80:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Znode may refer both data nodes and indexing nodes

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/ubifs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index c3ac5a8..49b06c9 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -707,8 +707,8 @@ struct ubifs_jhead {
  * struct ubifs_zbranch - key/coordinate/length branch stored in znodes.
  * @key: key
  * @znode: znode address in memory
- * @lnum: LEB number of the indexing node
- * @offs: offset of the indexing node within @lnum
+ * @lnum: LEB number of the target node (indexing node or data node)
+ * @offs: target node offset within @lnum
  * @len: target node length
  */
 struct ubifs_zbranch {
-- 
1.5.4.1

