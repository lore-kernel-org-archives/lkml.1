Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYESH46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYESH46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYESH4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:56:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbYESH4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:56:49 -0400
Message-ID: <48313277.1030105@cn.fujitsu.com>
Date: Mon, 19 May 2008 15:55:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Subject: remove used member(struct rcu_data::rcu_tasklet)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Since softirq works for rcu reclaimer, rcu_tasklet is unused now.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index e1cdf19..4270de6 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -82,7 +82,6 @@ struct rcu_data {
 	spinlock_t	lock;		/* Protect rcu_data fields. */
 	long		completed;	/* Number of last completed batch. */
 	int		waitlistcount;
-	struct tasklet_struct rcu_tasklet;
 	struct rcu_head *nextlist;
 	struct rcu_head **nexttail;
 	struct rcu_head *waitlist[GP_STAGES];


