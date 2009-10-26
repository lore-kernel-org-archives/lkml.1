Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZJZUVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZJZUVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZJZUVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:21:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39918 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbZJZUVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:21:37 -0400
Date: Mon, 26 Oct 2009 21:21:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       GeunSik Lim <leemgs1@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
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
       Michel Dagenais <michel.dagenais@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
	v2,headers to Dual BSD/GPL
Message-ID: <20091026202113.GF24682@elte.hu>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com> <20091026073048.GC8162@elte.hu> <4AE5A17D.5020202@polymtl.ca> <20091026071832.36405c9a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026071832.36405c9a@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 26 Oct 2009 09:17:49 -0400
> Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca> wrote:
> 
> > Ingo Molnar wrote:
> > > 
> > > But i also disagree with it on a technical level: code duplication
> > > is _bad_. Why does the code have to be duplicated in user-space
> > > like that? I'd like Linux tracing code to be in the kernel repo.
> > > Why isnt this done properly, as part of the kernel project - to
> > > make sure it all stays in sync?
> > > 
> > 
> > If you mean that this code should solely be used inside the kernel,
> > then what you propose technically does not work. There is a very high
> > cost to accessing kernel code from userspace. 
> 
> yeah 100 cycles is insanely high, that's at least the equivalent of... 
> say one cache miss.

That too - plus 'being in the kernel repo' does not mean it has to run 
in kernel mode. It could be a vdso feature or a library in tools/. I'm 
quite sure it's a mistake to ad-hoc export the current tracepoint.c code 
to user-space without having it all under the same maintenance envelope.

	Ingo
