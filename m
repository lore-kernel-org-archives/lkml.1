Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZJZHbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZJZHbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZJZHbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:31:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbZJZHbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:31:10 -0400
Date: Mon, 26 Oct 2009 08:30:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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
Message-ID: <20091026073048.GC8162@elte.hu>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* GeunSik Lim <leemgs1@gmail.com> wrote:

> On Mon, Oct 26, 2009 at 11:08 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> > * From: "Wu Fengguang" <fengguang.wu@intel.com>
> > Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,headers to Dual BSD/GPL
> >
> >
> >> On Sun, Oct 25, 2009 at 05:03:52AM +0800, Jesper Juhl wrote:
> >>> On Fri, 23 Oct 2009, Mathieu Desnoyers wrote:
> >>>
> >>> > (updated email for Jesper Juhl)
> >>> >
> >>> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> >>> > > Hi,
> >>> > >
> >>> > > I would like to re-license the tracepoint.c/marker.c files from GPL to:
> >>> > >
> >>> > > * Dual LGPL v2.1/GPL v2 license.
> >>> > >
> >>> > > And re-license tracepoint.h/marker.h to:
> >>> > >
> >>> > > * Dual BSD/GPL v2 license.
> >>> > >
> >>> > > The goal is to allow sharing code between the kernel tracer and UST
> >>> > > (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint
> >>> > > and marker headers might need to be included by proprietary or BSD
> >>> > > applications, hence the dual BSD/GPL v2 license for these two.
> >>> > >
> >>> > > I currently have the OK from Kosaki Motohiro for Fujitsu contributions,
> >>> > > which includes Zhao Lei and Lai Jiangshan.
> >>> > >
> >>> > > The missing approvals for Dual LGPL v2.1/GPL v2 relicensing are:
> >>> > >
> >>> > > For tracepoint.c:
> >>> > >
> >>> > > Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> >>> > >
> >>> > > For marker.c:
> >>> > >
> >>> > > "Robert P. J. Day" <rpjday@mindspring.com>
> >>> > > Adrian Bunk <bunk@stusta.de>
> >>> > > Harvey Harrison <harvey.harrison@gmail.com>
> >>> >
> >>> > Jesper Juhl <jj@chaosbits.net>
> >>> >
> >>>
> >>> I don't think I have enough significant changes in there to actually
> >>> require my approval for relicensing, but since you ask; I personally
> >>> do not have a problem with that file being Dual LGPL v2.1/GPL v2
> >>> licensed.
> >>
> >> Me too.
> >>
> >> Thanks,
> >> Fengguang
> >
> > Me too.
> >
> > Thanks,
> > Zhaolei
> 
> Sorry for the late reply. Why do we need a different license to GPLV2
> sources that  contributors submitted.?  As Mathieu mentioned, I think
> that  GPLV2 based some sources needs  to be relicense  to  trace
> non-GPL applications
> for some developers and some companies.
> 
> In real, Some open source  like QT, MySQL is licensed using dual
> license for business strategy. tracepoint.c/marker.c file is GPLv2
> currently.
> 
> Can  we re-distribute with dual license (e.g: bsd/gplv2 or lgpl
> 2.1/gplv2)   about some source of linux kernel source? I think that
> linux kernel source is GPLv2 only. Frankly speaking, I am not know
> exactly about  legal issues of your questions.

Yes, the legality of such relicensing is questionable as that code was 
never developed outside of the kernel but as part of the kernel.

But i also disagree with it on a technical level: code duplication is 
_bad_. Why does the code have to be duplicated in user-space like that? 
I'd like Linux tracing code to be in the kernel repo. Why isnt this done 
properly, as part of the kernel project - to make sure it all stays in 
sync?

So for those two grounds i cannot give my permission for this 
relicensing, sorry.

	Ingo
