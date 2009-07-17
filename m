Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbZGQKL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbZGQKL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934360AbZGQKL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:11:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49822 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934354AbZGQKL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:11:26 -0400
Message-ID: <4A604E46.5050903@cn.fujitsu.com>
Date: Fri, 17 Jul 2009 18:11:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] ftrace: add tracepoint for timer event
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We can monitor timer's lifecycle and behaviors by these tracepoint. 

Following tracepoints are introduced as ingo's suggestion in
	http://marc.info/?l=linux-kernel&m=123791899529128&w=2

for timer:
trace_timer_init()
trace_timer_start()
trace_timer_expire()
trace_timer_cancel()

for hrtimer:
trace_hrtimer_init()
trace_hrtimer_start()
trace_hrtimer_expire()
trace_hrtimer_cancel()

for itimer:
itimer_state
itimer_expire()

Changlog from latest patchset:
1: ours patches are base on Anton Blanchard's patch which can been found
   at:
   	http://marc.info/?l=linux-kernel&m=124331396919301&w=2
   but this patch is can't apply on Ingo's tip tree, so we rebase this
   patch against latest tip tree

2: fix those patches address Thomas's comment
