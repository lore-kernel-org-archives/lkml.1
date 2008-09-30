Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYI3Hom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYI3Hom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYI3HmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:08 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18987 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYI3HmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:03 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: correct condition to eliminate unecessary assignment
Date: Tue, 30 Sep 2008 12:19:17 +0300
Message-Id: <1222766358-21886-22-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:37.0897 (UTC) FILETIME=[F8782D90:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/tnc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index e0878a4..d27fd91 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1600,7 +1600,7 @@ out:
 	 * An enormous hole could cause bulk-read to encompass too many
 	 * page cache pages, so limit the number here.
 	 */
-	if (bu->blk_cnt >= UBIFS_MAX_BULK_READ)
+	if (bu->blk_cnt > UBIFS_MAX_BULK_READ)
 		bu->blk_cnt = UBIFS_MAX_BULK_READ;
 	/*
 	 * Ensure that bulk-read covers a whole number of page cache
-- 
1.5.4.1

