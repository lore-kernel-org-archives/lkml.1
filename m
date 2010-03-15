Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0COBpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:45:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58829 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab0COBpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:45:08 -0400
Message-ID: <4B9D915A.6080101@cn.fujitsu.com>
Date: Mon, 15 Mar 2010 09:46:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>	 <1267710847.10871.102.camel@gandalf.stny.rr.com>	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>	 <4B95AE4E.6060700@cn.fujitsu.com>	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>	 <4B95C2AF.7010508@cn.fujitsu.com>	 <1268446049.4471.787.camel@gandalf.stny.rr.com> <1268502976.4471.798.camel@gandalf.stny.rr.com>
In-Reply-To: <1268502976.4471.798.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2010-03-12 at 21:07 -0500, Steven Rostedt wrote:
>> On Tue, 2010-03-09 at 11:38 +0800, Li Zefan wrote:
>>
>>> The segfault is from userspace. This is a segfault I just got:
>>>
>>> ftrace_stack_ma[14989]: segfault at fe2e ip 00000000004474c0 sp 00007fffb97e38c0 error 4 in bash[400000+d1000]
>> Li and Lai,
>>
>> Thanks a lot for reporting all this, and writing the ftrace_stress_test.
>> I've fixed all the bugs that it has reported (to my knowledge) and after
>> a little more testing I will soon be sending a patch series out.
> 
> Li,
> 
> I ran your test for 13 hours on three different machines. I did not hit
> any more errors. Although I see a lockdep warning (not a locking problem
> but the WARN_ON in fork.c is triggering). I'll look into that on Monday.
> 

As I said in the offline mail, this warning is caused by global trace_clock,
and I sent a fix sometime ago:

http://lkml.org/lkml/2009/12/21/4

> Please take the new patches that Ingo just pushed to Linus, if you find
> any more bugs, please let me know right away.
> 

Thanks for the fixes!

