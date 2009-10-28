Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZJ1OQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZJ1OQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZJ1OQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:16:06 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:33313 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbZJ1OQF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:16:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAMzq50pGGN1W/2dsb2JhbACBT9h4hD8EgWE
Date: Wed, 28 Oct 2009 10:11:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: GeunSik Lim <leemgs1@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Jesper Juhl <jj@chaosbits.net>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
	v2,headers to Dual BSD/GPL
Message-ID: <20091028141105.GA20031@Krystal>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com> <20091026073048.GC8162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20091026073048.GC8162@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:53:31 up 71 days, 43 min,  2 users,  load average: 0.55, 0.44,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * GeunSik Lim <leemgs1@gmail.com> wrote:
> 
> > On Mon, Oct 26, 2009 at 11:08 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> > > * From: "Wu Fengguang" <fengguang.wu@intel.com>
> > > Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,headers to Dual BSD/GPL
> > >
> > >
> > >> On Sun, Oct 25, 2009 at 05:03:52AM +0800, Jesper Juhl wrote:
> > >>> On Fri, 23 Oct 2009, Mathieu Desnoyers wrote:
> > >>>
> > >>> > (updated email for Jesper Juhl)
> > >>> >
> > >>> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > >>> > > Hi,
> > >>> > >
> > >>> > > I would like to re-license the tracepoint.c/marker.c files from GPL to:
> > >>> > >
> > >>> > > * Dual LGPL v2.1/GPL v2 license.
> > >>> > >
> > >>> > > And re-license tracepoint.h/marker.h to:
> > >>> > >
> > >>> > > * Dual BSD/GPL v2 license.
> > >>> > >
> > >>> > > The goal is to allow sharing code between the kernel tracer and UST
> > >>> > > (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint
> > >>> > > and marker headers might need to be included by proprietary or BSD
> > >>> > > applications, hence the dual BSD/GPL v2 license for these two.
> > >>> > >
> > >>> > > I currently have the OK from Kosaki Motohiro for Fujitsu contributions,
> > >>> > > which includes Zhao Lei and Lai Jiangshan.
> > >>> > >
> > >>> > > The missing approvals for Dual LGPL v2.1/GPL v2 relicensing are:
> > >>> > >
> > >>> > > For tracepoint.c:
> > >>> > >
> > >>> > > Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > >>> > >
> > >>> > > For marker.c:
> > >>> > >
> > >>> > > "Robert P. J. Day" <rpjday@mindspring.com>
> > >>> > > Adrian Bunk <bunk@stusta.de>
> > >>> > > Harvey Harrison <harvey.harrison@gmail.com>
> > >>> >
> > >>> > Jesper Juhl <jj@chaosbits.net>
> > >>> >
> > >>>
> > >>> I don't think I have enough significant changes in there to actually
> > >>> require my approval for relicensing, but since you ask; I personally
> > >>> do not have a problem with that file being Dual LGPL v2.1/GPL v2
> > >>> licensed.
> > >>
> > >> Me too.
> > >>
> > >> Thanks,
> > >> Fengguang
> > >
> > > Me too.
> > >
> > > Thanks,
> > > Zhaolei
> > 
> > Sorry for the late reply. Why do we need a different license to GPLV2
> > sources that  contributors submitted.?  As Mathieu mentioned, I think
> > that  GPLV2 based some sources needs  to be relicense  to  trace
> > non-GPL applications
> > for some developers and some companies.
> > 
> > In real, Some open source  like QT, MySQL is licensed using dual
> > license for business strategy. tracepoint.c/marker.c file is GPLv2
> > currently.
> > 
> > Can  we re-distribute with dual license (e.g: bsd/gplv2 or lgpl
> > 2.1/gplv2)   about some source of linux kernel source? I think that
> > linux kernel source is GPLv2 only. Frankly speaking, I am not know
> > exactly about  legal issues of your questions.
> 
> Yes, the legality of such relicensing is questionable as that code was 
> never developed outside of the kernel but as part of the kernel.
> 
> But i also disagree with it on a technical level: code duplication is 
> _bad_. Why does the code have to be duplicated in user-space like that? 
> I'd like Linux tracing code to be in the kernel repo. Why isnt this done 
> properly, as part of the kernel project - to make sure it all stays in 
> sync?
> 

Hi Ingo,

I would like to know more about what role you think a kernel vDSO can
have in static instrumentation of user-space applications.

Basically, static instrumentation has to be declared in the
application. In the current Ftrace scheme (same for LTTng), probes have
to be specifically built for each instrumentation site (this is the
purpose of TRACE_EVENT). Given this has to be integrated with the
application build/link phases, I do not see the gain in doing static
instrumentation through a vDSO.

Data extraction is a separate topic though, and could possibly benefit
from being done from within the kernel. However, the tracer
implementations for kernel vs user-space contexts will differ due to
locking which has to be done slightly differently in both contexts (e.g.
RCU read-side cannot be used from a vDSO). If we find a way to keep the
difference between the kernel and user-space implementation to a
minimum, which can be expressed using preprocessor macros, maybe it
could be worth it. But in any case, I think it will be useful to
prototype this in a stand-alone userspace library first and get it in
the hand of users ASAP. Then we can compare and decide which is the
optimal technical solution.

Technical aspect aside, I'm concerned about your attitude of blocking
progress of competitive technical solutions through licensing arguments.
It is not really helping global progress here. I'd much prefer to
discuss on a technical ground and not mix that with licensing goo.

Thanks,

Mathieu

> So for those two grounds i cannot give my permission for this 
> relicensing, sorry.
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
