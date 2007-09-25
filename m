Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbXIYKCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbXIYKCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXIYKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:02:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:59923 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751540AbXIYKCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:02:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bJVILtGGb0S18Ol+W4kg/TtzAwzgNJDWqH+oTpg
	Wd1wh23w6wRKCr
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070925094712.GA29138@elte.hu>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
	 <1190709207.11226.6.camel@Homer.simpson.net>
	 <20070925091331.GA22905@elte.hu>
	 <1190711858.13861.10.camel@Homer.simpson.net>
	 <20070925094712.GA29138@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 12:02:07 +0200
Message-Id: <1190714527.31115.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 11:47 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2007-09-25 at 11:13 +0200, Ingo Molnar wrote:
> > 
> > > > [...] Latencies of up to 336ms hit me during the recompile (make -j3), 
> > > > with nothing else running. Since reboot, latencies are, so far, very 
> > > > very nice. [...]
> > > 
> > > 'very very nice' == 'best ever' ? :-)
> > 
> > Yes.  Very VERY nice feel.
> 
> cool :-)
> 
> Maybe there's more to come: if we can get CONFIG_FAIR_USER_SCHED to work 
> properly then your Xorg will have a load-independent 50% of CPU time all 
> to itself. (Group scheduling is quite impressive already: i can log in 
> as root without feeling _any_ effect from a perpetual 'hackbench 100' 
> running as uid mingo. Fork bombs no more.) Will the Amarok gforce plugin 
> like that CPU time splitup? (or is most of the gforce overhead under 
> your user uid?)

I run everything as root (naughty me), so I'd have to change my evil
ways to reap the benefits.  (I'll do that to test, but it's unlikely to
ever become a permanent habit here)  Amarok/Gforce will definitely like
the user split as long as latency is low.  Visualizations are not only
bandwidth hungry, they're extremely latency sensitive.

	-Mike

