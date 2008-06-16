Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbYFPHIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYFPHIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYFPHIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:08:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61975 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbYFPHIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:08:45 -0400
Message-ID: <4856111B.4000106@cn.fujitsu.com>
Date: Mon, 16 Jun 2008 15:07:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] introduce task cgroup v2
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <1213598394.16944.85.camel@twins>	 <20080616155630.78A9.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1213599882.16944.90.camel@twins>
In-Reply-To: <1213599882.16944.90.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-06-16 at 15:59 +0900, KOSAKI Motohiro wrote:
>> Hi Peter,
>>
>>>> # mount -t cgroup -o task none /dev/cgroup
>>>> # mkdir /dev/cgroup/foo
>>>> # cd /dev/cgroup/foo
>>>> # ls 
>>>> notify_on_release  task.max_tasks  task.nr_tasks  tasks
>>>> # echo 100 > task.max_tasks
>>>> # echo $$ > tasks
>>>> # fork_bomb 1000 &  <- try create 1000 process
>>>> # pgrep fork_bomb | wc -l
>>>> 98
>>> fwiw I think the name sucks!
>>> cgroups are about grouping tasks, so what's a task cgroup?
>> Sorry, my english skill is very low.
>> I hope restrict number of tasks.
>>
>> Do you have any name idea?
> 
> Sadly I suck at naming too ;-(
> 
> perhaps task_limit controller, or nr_tasks controller.
> 
> We should preferably pick one that transfers to most other rlimit like
> controls.
> 

We have memrlimit in -mm currently, which controls address space.
