Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZENNwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZENNwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZENNwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:52:00 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:43793 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbZENNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:52:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAHALe5C0pMQW1W/2dsb2JhbACBUIEwzTeEAgU
Date: Thu, 14 May 2009 09:51:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v4] ftrace: add a tracepoint for
	__raise_softirq_irqoff()
Message-ID: <20090514135159.GA23866@Krystal>
References: <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal> <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com> <20090514124013.GC21241@Krystal> <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:51:49 up 75 days, 10:18,  3 users,  load average: 0.91, 0.66,
	0.51
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 14 May 2009, Mathieu Desnoyers wrote:
> > > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > 
> > > This patch is modified from Mathieu Desnoyers' patch. The original patch
> > > can be found here: 
> > > 	http://marc.info/?l=linux-kernel&m=123791201816245&w=2
> > > This tracepoint can trace the time stamp when softirq action is raised. 
> > > 
> > > Changelog for v1 -> v2: 
> > > 1: Use TRACE_EVENT instead of DEFINE_TRACE
> > > 2: Move the tracepoint from raise_softirq_irqoff() to
> > >    __raise_softirq_irqoff()
> > > 
> > > Changelog for v2 -> v3: 
> > > Move the definition of __raise_softifq_irqoff() to .c file when
> > > CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
> > > 
> > > Changelog for v3 -> v4: 
> > > 1: Come back to v2, and use forward declarations to avoid
> > >    recursive includes as Mathieu's suggestion
> > > 2: Modifiy the tracepoint name
> > > 3: Add comments for this tracepoint
> > > 
> > 
> > This is a step in the right direction, but please see my email to Lai
> > about the fact that this assumes correct and undocumented include
> > dependencies in kernel/trace/events.c. Not explicitely stating the
> > include dependencies is a build error waiting to happen.
> > 
> > Including interrupt.h under a ifdef would allow keeping track of
> > TRACE_EVENT specific build dependencies neatly on a per header basis.
> 
> This is all moot, the events.c file no longer exists and as not an issue.
> 

OK, thanks for the update :)

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
