Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZJZLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZJZLbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZJZLbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:31:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbZJZLbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:31:23 -0400
Date: Mon, 26 Oct 2009 12:31:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: GeunSik Lim <leemgs1@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Jesper Juhl <jj@chaosbits.net>,
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
Message-ID: <20091026113103.GA27494@elte.hu>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com> <20091026073048.GC8162@elte.hu> <20091026101737.34697439@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026101737.34697439@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Can  we re-distribute with dual license (e.g: bsd/gplv2 or lgpl
> > > 2.1/gplv2)   about some source of linux kernel source? I think that
> > > linux kernel source is GPLv2 only. Frankly speaking, I am not know
> > > exactly about  legal issues of your questions.
> > 
> > Yes, the legality of such relicensing is questionable as that code was 
> > never developed outside of the kernel but as part of the kernel.
> 
> We have lots of dual licensed code in the kernel. [...]

Correct, but that that common case for dual licensing is when it was a 
work existing outside of Linux, licensed differently - and it's a common 
courtesy to keep any GPL-compatible licenses when such code goes into 
the kernel.

This is a different case though. This is about code which was written 
within Linux, was licensed under the kernel's license (GPLv2), written 
and modified by many people - and now it's proposed to be extracted 
under a new license - which license it never had before.

> [...] The copy in kernel may well only act as GPLv2 but the copy 
> outside has other licences (Linus for example relicensed some of his 
> early locking primitive/atomic bits for the Mozilla folks)

That's a more clear-cut case: it's for something independent-looking, 
written from scratch by a single person (Linus) and that person gave the 
second license. (it's also rather trivial wrappers around atomic 
instructions and hence most of it might even be not copyrightable)

> > So for those two grounds i cannot give my permission for this 
> > relicensing, sorry.
> 
> One comment here - and one to be careful of for relicensing purposes. 
> In most parts of the world if you were paid by an employer to produce 
> the code that the request relates to then the rights to it belong 
> solely to the employer. Permission (or refusal) from the code author 
> may well be meaningless because such permission must come from the 
> employer and right owner in question (so IBM, Red Hat etc) in those 
> cases and not the author.

Of course - if performed as hire for work in the US. And there's 
jurisdictions where work performed outside of work hours might still be 
the copyright of the author's. (There's even jurisdictions where only 
natural born persons may have copyright ownership, never corporations.) 
So it's safest to ask for both. IMHO it's a complex, "ask your lawyer" 
issue. I am not a lawyer.

	Ingo
