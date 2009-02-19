Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZBSFy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZBSFy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 00:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZBSFyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 00:54:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZBSFyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 00:54:18 -0500
Message-ID: <499CF419.6060504@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 13:54:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: various documentation fixes and updates
References: <499CBFDF.1070503@cn.fujitsu.com> <499CED75.9030907@oracle.com> <499CF10C.1010104@cn.fujitsu.com> <499CF229.9040904@oracle.com>
In-Reply-To: <499CF229.9040904@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Li Zefan wrote:
>>>>  If a cpuset has its 'cpus' modified, then each task in that cpuset
>>>>  will have its allowed CPU placement changed immediately.  Similarly,
>>>> -if a tasks pid is written to a cpusets 'tasks' file, in either its
>>>> -current cpuset or another cpuset, then its allowed CPU placement is
>>>> -changed immediately.  If such a task had been bound to some subset
>>>> -of its cpuset using the sched_setaffinity() call, the task will be
>>>> -allowed to run on any CPU allowed in its new cpuset, negating the
>>>> -affect of the prior sched_setaffinity() call.
>>>> +if a tasks pid is written to another cpusets 'tasks' file, then its
>>>         task's pid                      cpuset's
>>>
>> Paul Jackson is the original author of this document, and he once said he
>> doesn't like to use foo's but is used to use foos, so I think I'm not
>> going to correct them all through this doc, at least not in this patch. :)
> 
> I'll fix them then, unless Paul Menage et al disagree.
> 

That would be greate. I'll be frustrated if I have to read through the
whole doc to find out those incorrect foos.


