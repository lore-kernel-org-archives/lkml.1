Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbZLJD0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbZLJD0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbZLJD0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:26:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758872AbZLJD0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:26:47 -0500
Message-ID: <4B206A18.2030607@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 11:25:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf sched: Add max delay time snapshot
References: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> When we have a maximum latency reported for a task, we need a
> convenient way to find the matching location to the raw traces
> or to perf sched map that shows where the task has been eventually
> scheduled in. This gives a pointer to retrieve the events that occured
> during this max latency.
> 

Then, we can cooperate with ftrace's data to know what the cpu is
doing at that time.

Reviewed-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Thanks,
Xiao
