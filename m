Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZBSFle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZBSFle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 00:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZBSFl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 00:41:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZBSFlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 00:41:25 -0500
Message-ID: <499CF10C.1010104@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 13:41:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: various documentation fixes and updates
References: <499CBFDF.1070503@cn.fujitsu.com> <499CED75.9030907@oracle.com>
In-Reply-To: <499CED75.9030907@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  If a cpuset has its 'cpus' modified, then each task in that cpuset
>>  will have its allowed CPU placement changed immediately.  Similarly,
>> -if a tasks pid is written to a cpusets 'tasks' file, in either its
>> -current cpuset or another cpuset, then its allowed CPU placement is
>> -changed immediately.  If such a task had been bound to some subset
>> -of its cpuset using the sched_setaffinity() call, the task will be
>> -allowed to run on any CPU allowed in its new cpuset, negating the
>> -affect of the prior sched_setaffinity() call.
>> +if a tasks pid is written to another cpusets 'tasks' file, then its
> 
>         task's pid                      cpuset's
> 

Paul Jackson is the original author of this document, and he once said he
doesn't like to use foo's but is used to use foos, so I think I'm not
going to correct them all through this doc, at least not in this patch. :)

>> +allowed CPU placement is changed immediately.  If such a task had been
>> +bound to some subset of its cpuset using the sched_setaffinity() call,
>> +the task will be allowed to run on any CPU allowed in its new cpuset,
>> +negating the affect of the prior sched_setaffinity() call.
> 
>                 effect
> 

Will fix.

>> + - via the cpuset file system directly, using the various cd, mkdir, echo,
>> +   cat, rmdir commands from the shell, or there equivalent from C.
> 
>                                              their

Will fix.

>> -mount -t cgroup -ocpuset X /dev/cpuset
>> +mount -t cgroup -ocpuset,noprefix X /dev/cpuset
> 
> I'm used to "-o options_list"... I guess either is OK.
> 

Actually I'm used to "-o opt" too.

Thanks for the review!


