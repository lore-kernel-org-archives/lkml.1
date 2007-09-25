Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbXIYJra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbXIYJra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbXIYJrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:47:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXIYJrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:47:22 -0400
Date: Tue, 25 Sep 2007 11:47:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925094712.GA29138@elte.hu>
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <1190711858.13861.10.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190711858.13861.10.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2007-09-25 at 11:13 +0200, Ingo Molnar wrote:
> 
> > > [...] Latencies of up to 336ms hit me during the recompile (make -j3), 
> > > with nothing else running. Since reboot, latencies are, so far, very 
> > > very nice. [...]
> > 
> > 'very very nice' == 'best ever' ? :-)
> 
> Yes.  Very VERY nice feel.

cool :-)

Maybe there's more to come: if we can get CONFIG_FAIR_USER_SCHED to work 
properly then your Xorg will have a load-independent 50% of CPU time all 
to itself. (Group scheduling is quite impressive already: i can log in 
as root without feeling _any_ effect from a perpetual 'hackbench 100' 
running as uid mingo. Fork bombs no more.) Will the Amarok gforce plugin 
like that CPU time splitup? (or is most of the gforce overhead under 
your user uid?)

it could also work out negatively, _sometimes_ X does not like being too 
high prio. (weird as that might be.) So we'll see.

	Ingo
