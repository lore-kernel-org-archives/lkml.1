Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYJUFLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYJUFLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYJUFL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:11:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46386 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYJUFLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:11:25 -0400
Date: Tue, 21 Oct 2008 16:11:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>
Subject: [PATCH] cgroup: remove unused variable
Message-Id: <20081021161120.8a0d00df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/scratch/sfr/next/kernel/cgroup.c: In function 'cgroup_tasks_start':
/scratch/sfr/next/kernel/cgroup.c:2107: warning: unused variable 'i'

Introduced in commit cc31edceee04a7b87f2be48f9489ebb72d264844 "cgroups:
convert tasks file to use a seq_file with shared pid array".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 046c160..35eebd5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2104,7 +2104,7 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
+
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
