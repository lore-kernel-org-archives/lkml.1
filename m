Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0CMCHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:07:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab0CMCHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:07:32 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=tcELkqsd59R4Hq9tiooA:9 a=XbPSTbfnZV9Yn_hZtdhx6dNlQQcA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B95C2AF.7010508@cn.fujitsu.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>
	 <4B95C2AF.7010508@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Mar 2010 21:07:29 -0500
Message-ID: <1268446049.4471.787.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 11:38 +0800, Li Zefan wrote:

> The segfault is from userspace. This is a segfault I just got:
> 
> ftrace_stack_ma[14989]: segfault at fe2e ip 00000000004474c0 sp 00007fffb97e38c0 error 4 in bash[400000+d1000]

Li and Lai,

Thanks a lot for reporting all this, and writing the ftrace_stress_test.
I've fixed all the bugs that it has reported (to my knowledge) and after
a little more testing I will soon be sending a patch series out.

Just wanted to say thanks again, your efforts have helped out
tremendously!

Americo,

I still do not know why the function graph tracer is making your system
unusable. I'll look more into that when I get a chance. So far, I have
not had any issues on any of my boxes.

-- Steve


