Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0CICXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:23:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab0CICXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:23:18 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=vBuxYLiXmMVWtuyWSrcA:9 a=0JIdunr9MwjPsyyAHI8xpiT0YvwA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B95AE4E.6060700@cn.fujitsu.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 21:23:14 -0500
Message-ID: <1268101394.10871.1861.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 10:11 +0800, Li Zefan wrote:
> Steven Rostedt wrote:
> > On Mon, 2010-03-08 at 15:32 +0800, Li Zefan wrote:

> > This sounds like the compiler may have screwed up again. Can you compile
> > with this patch and see if it catches anything?
> > 
> 
> But I was using a x86_64 machine, and this patch won't do anything on
> x86_64?

I wonder if this issue has crept to x86_64. What kind of dump do you
get? And if this segfault is in the kernel, could you see (using gdb on
a vmlinux) if any of the stack frame setups look peculiar?

Thanks,

-- Steve



