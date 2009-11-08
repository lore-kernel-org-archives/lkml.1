Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZKHNIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZKHNIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZKHNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:08:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:59196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZKHNIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:08:18 -0500
Date: Sun, 8 Nov 2009 13:07:24 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       guichaz@yahoo.fr, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <4AE6A513.6010100@cn.fujitsu.com>
References: <4AE6A513.6010100@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, no_hz: Remove unused rq->last_tick_seen field
Message-ID: <tip-d8c80ce091f6ead6710bc71b58f2c32e5bf855e4@git.kernel.org>
Git-Commit-ID: d8c80ce091f6ead6710bc71b58f2c32e5bf855e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8c80ce091f6ead6710bc71b58f2c32e5bf855e4
Gitweb:     http://git.kernel.org/tip/d8c80ce091f6ead6710bc71b58f2c32e5bf855e4
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 27 Oct 2009 15:45:23 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 13:17:47 +0100

sched, no_hz: Remove unused rq->last_tick_seen field

In 15934a37324f32e0fda633dc7984a671ea81cd75,
field last_tick_seen is added to struct rq.
But it is unused now.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>
LKML-Reference: <4AE6A513.6010100@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f849212..23e3535 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -534,7 +534,6 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
-	unsigned long last_tick_seen;
 	unsigned char in_nohz_recently;
 #endif
 	/* capture load from *all* tasks on this cpu: */
