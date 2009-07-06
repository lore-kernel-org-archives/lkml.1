Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZGFJhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZGFJhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZGFJhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:37:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57671 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZGFJhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:37:00 -0400
Message-ID: <4A51C5C2.20802@cn.fujitsu.com>
Date: Mon, 06 Jul 2009 17:37:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] ftrace: add tracepoint for timer event
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
Add itimer's patch to monitor itimer's lifecycle and behaviors
