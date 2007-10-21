Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXJURbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXJURbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXJURay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:30:54 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:48339 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXJURaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:30:52 -0400
Message-ID: <471B8CAC.2070904@linux.vnet.ibm.com>
Date: Sun, 21 Oct 2007 23:00:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: menage@google.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, vatsa@linux.vnet.ibm.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fixing the warning in cgroup.c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Removing the unused variable root.

kernel/cgroup.c: In function ‘proc_cgroupstats_show’:
kernel/cgroup.c:2405: warning: unused variable ‘root’

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Index: linux-git/kernel/cgroup.c
===================================================================
--- linux-git.orig/kernel/cgroup.c      2007-10-21 08:49:15.000000000 +0530
+++ linux-git/kernel/cgroup.c   2007-10-21 22:24:13.000000000 +0530
@@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_opera
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
        int i;
-       struct cgroupfs_root *root;

        seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
        mutex_lock(&cgroup_mutex);


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

