Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYGUTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYGUTW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYGUTWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:22:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33760 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbYGUTWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:22:46 -0400
Date: Mon, 21 Jul 2008 21:21:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cl@linux-foundation.org,
       davem@davemloft.net, Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080721192138.GA27672@elte.hu>
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI> <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu> <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com> <20080721100627.GA5953@2ka.mipt.ru> <20080721105051.GA5830@elte.hu> <20080721112515.GA4777@2ka.mipt.ru> <20080721115555.GA24176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721115555.GA24176@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > I could try run tests with netconsole deactivated, if you think 
> > > that's a worthwile line of probing this problem. (although that 
> > > would make me do blind tests in essence - having kernel log output 
> > > is really essential.)
> > 
> > Let's try this way first. If system will continue to crash, we will 
> > add some debug options in various pathes. Existing reports do not 
> > contain enough information unfortunately, so we will not lose too 
> > much.
> 
> ok. I've turned off netconsole - 8 successful bootups in a row so far. 
> The box is a slow booter/builder with an 8 kernels/hour test 
> throughput, so if everything goes fine we should have meaningful 
> results in about 10 hours.
> 
> ( there are other, faster testboxes in -tip testing with 33 kernels/hour 
>   build+boot throughput where we'd have to wait only 2 hours - but as 
>   per Murphy's law they dont trigger this bug ;-)

70 bootups with netconsole turned off, and not a single crash so far.

So it's now a strong likelyhood that this crash is a combination of 
e1000e+netconsole.

	Ingo
