Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbYCJHaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbYCJHaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYCJHaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:30:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58708 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYCJH37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:29:59 -0400
Message-ID: <47D4E35A.2090907@cn.fujitsu.com>
Date: Mon, 10 Mar 2008 16:29:30 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: annotate cgroup_init_subsys with __init
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is called by cgroup_init() and cgroup_init_early() only,
which are annotated with __init.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e9c2fb0..8d833b6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2388,7 +2388,7 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	return 0;
 }
 
-static void cgroup_init_subsys(struct cgroup_subsys *ss)
+static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
 	struct list_head *l;
-- 1.5.4.rc3 
