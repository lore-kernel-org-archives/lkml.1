Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXJVWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXJVWLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXJVWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:11:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53152 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXJVWLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:11:46 -0400
Subject: [PATCH] fix up cgroup warning
To: menage@google.com
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 22 Oct 2007 15:11:43 -0700
Message-Id: <20071022221143.545A9EEC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just noticed this in mainline:

kernel/cgroup.c: In function `proc_cgroupstats_show':
kernel/cgroup.c:2405: warning: unused variable `root'


---

 linux-2.6.git-dave/kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-warning kernel/cgroup.c
--- linux-2.6.git/kernel/cgroup.c~cgroup-warning	2007-10-22 15:10:20.000000000 -0700
+++ linux-2.6.git-dave/kernel/cgroup.c	2007-10-22 15:10:20.000000000 -0700
@@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_opera
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
 	int i;
-	struct cgroupfs_root *root;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
 	mutex_lock(&cgroup_mutex);
diff -L +2405 -puN /dev/null /dev/null
_
