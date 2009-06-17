Return-Path: <linux-kernel-owner+w=401wt.eu-S1765608AbZFQOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765608AbZFQOTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZFQOTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:19:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:35689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZFQOTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:19:22 -0400
Date: Wed, 17 Jun 2009 14:18:43 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A35DD5B.9050106@cn.fujitsu.com>
References: <4A35DD5B.9050106@cn.fujitsu.com>
Subject: [tip:sched/urgent] sched: Remove unneeded __ref tag
Message-ID: <tip-fd5e1b5dbaa8b4aacc0e251d74182eda37062194@git.kernel.org>
Git-Commit-ID: fd5e1b5dbaa8b4aacc0e251d74182eda37062194
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 14:18:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd5e1b5dbaa8b4aacc0e251d74182eda37062194
Gitweb:     http://git.kernel.org/tip/fd5e1b5dbaa8b4aacc0e251d74182eda37062194
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 15 Jun 2009 13:34:19 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 16:08:04 +0200

sched: Remove unneeded __ref tag

Those two functions no longer call alloc_bootmmem_cpumask_var(),
so no need to tag them with __init_refok.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <4A35DD5B.9050106@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c        |    2 +-
 kernel/sched_cpupri.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8fb88a9..0056795 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7828,7 +7828,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		free_rootdomain(old_rd);
 }
 
-static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
+static int init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	gfp_t gfp = GFP_KERNEL;
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 7deffc9..e6c2517 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -152,7 +152,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
+int cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	gfp_t gfp = GFP_KERNEL;
 	int i;
