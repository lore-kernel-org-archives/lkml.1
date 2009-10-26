Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbZJZNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbZJZNpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZJZNpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:45:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZJZNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:45:53 -0400
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
 v2,headers to Dual BSD/GPL
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, GeunSik Lim <leemgs1@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
In-Reply-To: <20091026113103.GA27494@elte.hu>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal>
	 <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
	 <20091026015357.GA6033@localhost>
	 <023001ca55e1$436e38e0$808410ac@zhaoleiwin>
	 <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
	 <20091026073048.GC8162@elte.hu>
	 <20091026101737.34697439@lxorguk.ukuu.org.uk>
	 <20091026113103.GA27494@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 09:45:56 -0400
Message-Id: <1256564756.26028.254.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:31 +0100, Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > Can  we re-distribute with dual license (e.g: bsd/gplv2 or lgpl
> > > > 2.1/gplv2)   about some source of linux kernel source? I think that
> > > > linux kernel source is GPLv2 only. Frankly speaking, I am not know
> > > > exactly about  legal issues of your questions.
> > > 
> > > Yes, the legality of such relicensing is questionable as that code was 
> > > never developed outside of the kernel but as part of the kernel.
> > 
> > We have lots of dual licensed code in the kernel. [...]
> 
> Correct, but that that common case for dual licensing is when it was a 
> work existing outside of Linux, licensed differently - and it's a common 
> courtesy to keep any GPL-compatible licenses when such code goes into 
> the kernel.
> 
> This is a different case though. This is about code which was written 
> within Linux, was licensed under the kernel's license (GPLv2), written 
> and modified by many people - and now it's proposed to be extracted 
> under a new license - which license it never had before.
> 
> > [...] The copy in kernel may well only act as GPLv2 but the copy 
> > outside has other licences (Linus for example relicensed some of his 
> > early locking primitive/atomic bits for the Mozilla folks)
> 
> That's a more clear-cut case: it's for something independent-looking, 
> written from scratch by a single person (Linus) and that person gave the 
> second license. (it's also rather trivial wrappers around atomic 
> instructions and hence most of it might even be not copyrightable)

Yes, and new changes to the code in the kernel would also need written
permission to stay covered under the dual license. There's been a few
times I fixed a bug in some piece of code and later been asked by the
owner of said code if I was OK with my change being dual licensed.
Otherwise they would not be able to use it.

I agree, dual licensing in the kernel can be an administrative pain :-p

One that Mathieu will need to do ;-)

> > > So for those two grounds i cannot give my permission for this 
> > > relicensing, sorry.
> > 
> > One comment here - and one to be careful of for relicensing purposes. 
> > In most parts of the world if you were paid by an employer to produce 
> > the code that the request relates to then the rights to it belong 
> > solely to the employer. Permission (or refusal) from the code author 
> > may well be meaningless because such permission must come from the 
> > employer and right owner in question (so IBM, Red Hat etc) in those 
> > cases and not the author.
> 
> Of course - if performed as hire for work in the US. And there's 
> jurisdictions where work performed outside of work hours might still be 
> the copyright of the author's. (There's even jurisdictions where only 
> natural born persons may have copyright ownership, never corporations.) 
> So it's safest to ask for both. IMHO it's a complex, "ask your lawyer" 
> issue. I am not a lawyer.

True, I did not take into account for those working in Holland, Hungary
or Japan. But I did give the list of people that touched the code to
Legal, so I'm assuming that they did check it out.

-- Steve


