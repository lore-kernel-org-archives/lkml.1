Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYAXWdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYAXWdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYAXWcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:21 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52041 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbYAXWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:20 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 3/9] bfs: coding style cleanup in fs/bfs/bfs.h
Date: Fri, 25 Jan 2008 01:32:02 +0300
Message-Id: <1201213928-18183-4-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up errors found by checkpatch.pl.

Before the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/bfs.h | grep total
total: 2 errors, 0 warnings, 57 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/bfs.h | grep total
total: 0 errors, 0 warnings, 57 lines checked

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/bfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index ac7a8b1..090b96e 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -16,8 +16,8 @@ struct bfs_sb_info {
 	unsigned long si_freei;
 	unsigned long si_lf_eblk;
 	unsigned long si_lasti;
-	unsigned long * si_imap;
-	struct buffer_head * si_sbh;		/* buffer header w/superblock */
+	unsigned long *si_imap;
+	struct buffer_head *si_sbh;		/* buffer header w/superblock */
 };
 
 /*
-- 
1.5.3

