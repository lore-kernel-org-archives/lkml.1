Return-Path: <linux-kernel-owner+w=401wt.eu-S934134AbXHLKVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbXHLKVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbXHLKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:21:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37422 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbXHLKVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:21:25 -0400
Date: Sun, 12 Aug 2007 14:23:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] run_rebalance_domains: s/SCHED_IDLE/CPU_IDLE/
Message-ID: <20070812102357.GA525@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rebalance_domains(SCHED_IDLE) looks strange (typo?), change it to CPU_IDLE.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/sched.c~	2007-08-09 19:59:27.000000000 +0400
+++ t/kernel/sched.c	2007-08-12 14:15:37.000000000 +0400
@@ -3090,7 +3090,7 @@ static void run_rebalance_domains(struct
 			if (need_resched())
 				break;
 
-			rebalance_domains(balance_cpu, SCHED_IDLE);
+			rebalance_domains(balance_cpu, CPU_IDLE);
 
 			rq = cpu_rq(balance_cpu);
 			if (time_after(this_rq->next_balance, rq->next_balance))

