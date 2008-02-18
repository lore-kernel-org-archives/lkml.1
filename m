Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYBRFxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYBRFxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYBRFvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:51:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbYBRFvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:51:23 -0500
Message-ID: <47B91C89.4080508@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 13:50:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH 7/7] cgroup: remove dead code in cgroup_get_rootdir()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 71cf961..879a056 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -926,7 +926,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	if (!inode)
 		return -ENOMEM;
 
-	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_op = &cgroup_dir_inode_operations;
 	/* directories start off with i_nlink == 2 (for "." entry) */
-- 
1.5.4.rc3

