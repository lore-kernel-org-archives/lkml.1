Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZKDHSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZKDHSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZKDHSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:18:20 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39347 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZKDHSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:18:18 -0500
Message-ID: <4AF12A3A.5050200@ct.jp.nec.com>
Date: Wed, 04 Nov 2009 16:16:10 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] sched: remove time_sync_thresh declaration
References: <4AF129C8.3030008@ct.jp.nec.com>
In-Reply-To: <4AF129C8.3030008@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

time_sync_thresh had been removed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/sched.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f18102c..754b3de 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -171,8 +171,6 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 }
 #endif
 
-extern unsigned long long time_sync_thresh;
-
 /*
  * Task state bitmask. NOTE! These bits are also
  * encoded in fs/proc/array.c: get_task_state().
-- 
1.6.3.3

