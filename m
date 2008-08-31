Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbYHaNRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbYHaNRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbYHaNPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:15:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44049 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbYHaNPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:15:03 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: add forgotten gc_idx_lebs component
Date: Sun, 31 Aug 2008 17:52:43 +0300
Message-Id: <1220194366-12731-10-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0947 (UTC) FILETIME=[7DF64EB0:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

We add this component at other similar places, but not in this
one.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/find.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/find.c b/fs/ubifs/find.c
index 9fc55ae..e045c8b 100644
--- a/fs/ubifs/find.c
+++ b/fs/ubifs/find.c
@@ -243,7 +243,7 @@ int ubifs_find_dirty_leb(struct ubifs_info *c, struct ubifs_lprops *ret_lp,
 		int lebs, rsvd_idx_lebs = 0;
 
 		spin_lock(&c->space_lock);
-		lebs = c->lst.empty_lebs;
+		lebs = c->lst.empty_lebs + c->idx_gc_cnt;
 		lebs += c->freeable_cnt - c->lst.taken_empty_lebs;
 
 		/*
-- 
1.5.4.1

