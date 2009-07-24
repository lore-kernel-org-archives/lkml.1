Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGXUTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGXUTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZGXUTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:19:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZGXUTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:19:08 -0400
Message-ID: <4A6A1775.2050907@redhat.com>
Date: Fri, 24 Jul 2009 16:20:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 	breakpoints
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>	 <1248111537.15751.9341.camel@twins> <c62985530907201422i3f18813at7f6028e4be68d48f@mail.gmail.com>
In-Reply-To: <c62985530907201422i3f18813at7f6028e4be68d48f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2009/7/20, Peter Zijlstra <a.p.zijlstra@chello.nl>:
>> On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
>>> This adds the support for kernel hardware breakpoints in perfcounter.
>>> It is added as a new type of software counter and can be defined by
>>> using the counter number 5 and by passsing the address of the
>>> breakpoint to set through the config attribute.
>> This seems to be IP based breakpoints. Are there plans for data based
>> breakpoints as well? In that case we might want to think about the
>> namespace issue, we cannot both call them breakpoint/bp etc.. ;-)
> 
> 
> Nop, by default these breakpoints trigger on READ/WRITE accesses, it's
> meant for data.
> The example in the changelog profiles the bkl accesses, not by tracing
> lock_kernel() or so...but by tracing the kernel_flag spinlock itself.
> 
> So it's the opposite, we may start thinking about naming issues
> against possible future plans
> for IP breakpoint :-)
> 
> But actually for the latter case, I would suggest Kprobe...

Yeah, after kprobes-based event tracer is supported on ftrace,
it is easy to set up IP breakpoints in the kernel.
(maybe, I need to enhance it for perfcounter.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

