Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYFZMsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYFZMsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYFZMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:30:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbYFZMaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:30:25 -0400
Date: Thu, 26 Jun 2008 14:30:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: How linux-staging is released (was Re:
	linux-staging/linux-next merge/build errors)
Message-ID: <20080626123009.GO29619@elte.hu>
References: <20080621124017.ec3b0a51.sfr@canb.auug.org.au> <20080621071956.GB2765@kroah.com> <1214053209.3223.220.camel@lappy.programming.kicks-ass.net> <20080621175003.GC14786@kroah.com> <1214071343.3223.249.camel@lappy.programming.kicks-ass.net> <20080621215059.GD15341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621215059.GD15341@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Sat, Jun 21, 2008 at 08:02:22PM +0200, Peter Zijlstra wrote:
> > The point was that for some people being carried by distos is upstream
> > enough.
> > 
> > So I would discourage distros form picking up this tree.
> 
> I wouldn't, as some of the drivers work just fine on some arches, but 
> not all, that is why they are not in mainline yet (the network drivers 
> in there right now are an example of this.)

.. and it's all source code, so it's not really different to distros 
than a number of other patches they regularly pick up. If there's too 
much mess there's always the option to look into the fine source code 
and fix things up.

If a driver ended up not mattering at all in the long run then nobody 
will ever fix it up - and we dont even care that much - it's almost as 
if it didnt even exist.

The other alternative is much more harmful: vendors release binary-only 
drivers. That only works on x86 and they are utterly unfixable as well 
and have a lot of other disadvantages.

So we really have to balance the natural desire for pure upstream 
drivers against the real dangers of vendors doing bin-only modules just 
for the convenience of distribution.

... all in one: kudos Greg for doing the linux-staging tree! :-) It will 
help a lot.

	Ingo
