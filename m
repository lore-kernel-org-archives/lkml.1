Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0CIDhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:37:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab0CIDha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:37:30 -0500
Message-ID: <4B95C2AF.7010508@cn.fujitsu.com>
Date: Tue, 09 Mar 2010 11:38:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-15?Q?Am=E9rico_?= =?ISO-8859-15?Q?Wang?= 
	<xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>	 <1267710847.10871.102.camel@gandalf.stny.rr.com>	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>	 <4B95AE4E.6060700@cn.fujitsu.com> <1268101394.10871.1861.camel@gandalf.stny.rr.com>
In-Reply-To: <1268101394.10871.1861.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2010-03-09 at 10:11 +0800, Li Zefan wrote:
>> Steven Rostedt wrote:
>>> On Mon, 2010-03-08 at 15:32 +0800, Li Zefan wrote:
> 
>>> This sounds like the compiler may have screwed up again. Can you compile
>>> with this patch and see if it catches anything?
>>>
>> But I was using a x86_64 machine, and this patch won't do anything on
>> x86_64?
> 
> I wonder if this issue has crept to x86_64. What kind of dump do you
> get? And if this segfault is in the kernel, could you see (using gdb on
> a vmlinux) if any of the stack frame setups look peculiar?
> 

The segfault is from userspace. This is a segfault I just got:

ftrace_stack_ma[14989]: segfault at fe2e ip 00000000004474c0 sp 00007fffb97e38c0 error 4 in bash[400000+d1000]
