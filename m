Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXJXGaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXJXGaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbXJXG3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:29:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754699AbXJXG3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:29:54 -0400
Date: Tue, 23 Oct 2007 23:29:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: menage@google.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       vatsa@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fixing the warning in cgroup.c
Message-Id: <20071023232938.34102e7a.akpm@linux-foundation.org>
In-Reply-To: <471B8CAC.2070904@linux.vnet.ibm.com>
References: <471B8CAC.2070904@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 23:00:20 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Removing the unused variable root.
> 
> kernel/cgroup.c: In function ‘proc_cgroupstats_show’:
> kernel/cgroup.c:2405: warning: unused variable ‘root’

ERROR: Invalid UTF-8
#3: 
kernel/cgroup.c: In function proc_cgroupstats_show:

ERROR: Invalid UTF-8
#4: 
kernel/cgroup.c:2405: warning: unused variable root

total: 2 errors, 0 warnings, 7 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.



Please use LANG=C so gcc doesn't do this.

> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> 
> Index: linux-git/kernel/cgroup.c
> ===================================================================
> --- linux-git.orig/kernel/cgroup.c      2007-10-21 08:49:15.000000000 +0530
> +++ linux-git/kernel/cgroup.c   2007-10-21 22:24:13.000000000 +0530
> @@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_opera
>  static int proc_cgroupstats_show(struct seq_file *m, void *v)
>  {
>         int i;
> -       struct cgroupfs_root *root;
> 
>         seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
>         mutex_lock(&cgroup_mutex);

your email client is converting tabs to spaces.
