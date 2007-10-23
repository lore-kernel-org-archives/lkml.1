Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbXJWWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbXJWWjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXJWWgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44184 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbXJWWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:46 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, menage@google.com
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 9/12] cgroup: kill unused variable
Message-Id: <20071023223644.308971F81B4@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:44 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5987dcc..3fe21e1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_operations = {
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
 	int i;
-	struct cgroupfs_root *root;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
 	mutex_lock(&cgroup_mutex);
