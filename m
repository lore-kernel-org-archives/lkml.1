Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab0CNQz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:55:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab0CNQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:55:55 -0400
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=IkcTkHD0fZMA:10 a=cEzFX_PQ7OMZniYf3OAA:9 a=VoQrNfTcw6ZnWBMj67kF11Ktc7MA:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100313053733.GD3704@hack>
References: <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere> <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>
	 <4B95C2AF.7010508@cn.fujitsu.com>
	 <1268446049.4471.787.camel@gandalf.stny.rr.com>
	 <20100313053733.GD3704@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 12:55:51 -0400
Message-ID: <1268585751.13400.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 13:37 +0800, Américo Wang wrote:
> On Fri, Mar 12, 2010 at 09:07:29PM -0500, Steven Rostedt wrote:
> >
> >Americo,
> >
> >I still do not know why the function graph tracer is making your system
> >unusable. I'll look more into that when I get a chance. So far, I have
> >not had any issues on any of my boxes.
> >
> 
> Oh, in fact, I just tried 2 x86_64 machines, both of them have this
> problem.
> 
> Sorry that I don't have much time to do bisect, the last kernel that
> I tried is 2.6.32-rc6, it is bad too. I will try some older kernels
> if I have time.

It may be a config problem. I'll analyze your config again and see if I
can find something with it. But this will need to wait till next week.

Thanks,

-- Steve



