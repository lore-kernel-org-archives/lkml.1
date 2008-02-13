Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbYBMVmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbYBMVmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763692AbYBMVas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:48 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47519 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763655AbYBMVap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:45 -0500
Date: Wed, 13 Feb 2008 23:30:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Cliff Wickman <cpw@sgi.com>, David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cgroup_enable_task_cg_lists() static
Message-ID: <20080213213029.GF3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global cgroup_enable_task_cg_lists() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a9d039842fb8c3170e63d2eba3301cf9865a864e diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4766bb6..0317f79 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1704,7 +1704,7 @@ static void cgroup_advance_iter(struct cgroup *cgrp,
  * The tasklist_lock is not held here, as do_each_thread() and
  * while_each_thread() are protected by RCU.
  */
-void cgroup_enable_task_cg_lists(void)
+static void cgroup_enable_task_cg_lists(void)
 {
 	struct task_struct *p, *g;
 	write_lock(&css_set_lock);

