Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYJ3H1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYJ3H1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYJ3H0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:26:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYJ3H0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:26:31 -0400
Message-ID: <490960F6.5060603@cn.fujitsu.com>
Date: Thu, 30 Oct 2008 15:23:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: change sched_debug's mode to 0444
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/sched_debug is read-only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index ad958c1..5ae1776 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -319,7 +319,7 @@ static int __init init_sched_debug_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("sched_debug", 0644, NULL, &sched_debug_fops);
+	pe = proc_create("sched_debug", 0444, NULL, &sched_debug_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
-- 
1.5.4.rc3

