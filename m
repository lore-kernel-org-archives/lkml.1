Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYGXKng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYGXKng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYGXKnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:43:21 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:38707 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbYGXKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:43:20 -0400
Message-ID: <48885A7F.80106@miraclelinux.com>
Date: Thu, 24 Jul 2008 19:33:35 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC][PATCH][0/3] introduce rlimit cgroup
References: <488722DF.9080003@miraclelinux.com> <20080724150557.8697.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080724150557.8697.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.7.24.103109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Nakagawa-san,
> 
>> Hello,
>>
>> I think existing rlimit interface isn't useful.
> 
> Why it isn't useful?
 > Please explain your motivation.
 >

Hi Kosaki-san,

I am sorry about lacking of explaination in my previous post.
I think setrlimit system call interface isn't useful.
Because it cannot set rlimit from other process.

>> So I created rlimit interface on cgroup.
>> Do you think this is a proper way todo it? (or Is there any similar methods already?)
>
> your rlimit controller is merely setting process rlimit to each task in the group.
>

To set rlimit from other processes is my original intention.
For I do not see a way to do it, please let me know if there were any exists.

 > So, it isn't almost people required action.

What is most people required action?

> At least, I don't think useful.
> 
>> # cat /dev/cgroup/rlimit.limits
>> Number  Limit                  Soft Limit       Hard Limit       Unit
>> 0       Max cpu time           unlimited        unlimited         ms
>> 1       Max file size          unlimited        unlimited         bytes
>> 2       Max data size          unlimited        unlimited         bytes
>> 3       Max stack size         8388608          unlimited         bytes
>> 4       Max core file size     0                unlimited         bytes
>> 5       Max resident set       unlimited        unlimited         bytes
>> 6       Max processes          16300            16300             processes
>> 7       Max open files         1024             1024              files
>> 8       Max locked memory      32768            32768             bytes
>> 9       Max address space      unlimited        unlimited         bytes
>> 10      Max file locks         unlimited        unlimited         locks
>> 11      Max pending signals    16300            16300             signals
>> 12      Max msgqueue size      819200           819200           bytes
>> 13      Max nice priority       0                0
>> 14      Max realtime priority   0                0
>> 15      Max realtime timeout    unlimited        unlimited        us
>> # echo "1 100000000 200000000" > /dev/cgroup/rlimit.limits
>> # cat /proc/zero > /tmp/hoge
> 
> in general, A complex setting file is thought as ugly.
> Why can't separate it?
> 

I agree.

thanks.

