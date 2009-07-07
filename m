Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZGGQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZGGQDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZGGQDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:03:41 -0400
Received: from www.tglx.de ([62.245.132.106]:52997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbZGGQDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:03:40 -0400
Date: Tue, 7 Jul 2009 18:03:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ftrace: add tracepoint for itimer
In-Reply-To: <20090707140600.GA5178@Krystal>
Message-ID: <alpine.LFD.2.00.0907071739330.19480@localhost.localdomain>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6F9.3080100@cn.fujitsu.com> <20090706133108.GA7082@Krystal> <alpine.LFD.2.00.0907062117590.19480@localhost.localdomain> <20090707140600.GA5178@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

On Tue, 7 Jul 2009, Mathieu Desnoyers wrote:
> > Err, where is this an action or a call ? Care to look at the call site
> > of this tracepoint. It's at the end of do_setitimer() and records the
> > _state_ of the itimer _after_ the syscall was handled.
> > 
> 
> Hrm, right. The patch context misled me. I thought it was at the end of
> it_real_fn(), but it's actually in do_setitimer().
> 
> OK, looking at it from it's actual context, it makes perfect sense to
> name it that way.
> 
> And it could even be used as-is to iterate on all timers at trace start
> as we do in this tracer I won't name. ;-)

:)

> BTW, I was merely pointing out the risk of a name clash here. And I
> had to refer to the tree where this piece of code exists to support the
> point. My intent was not to advertise anything.

While I really do not care much about potential name clashes with out
of tree code, looking at your wrong analysis of the patch and your
mentioning of that unnamed tracer triggered my rant button :)

       tglx
