Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZJAHmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZJAHmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZJAHmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:42:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbZJAHmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:42:22 -0400
Date: Thu, 1 Oct 2009 09:42:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: michael@ellerman.id.au, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
	perf_counter rename
Message-ID: <20091001074201.GA6300@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com> <1253584591.7103.197.camel@pasglop> <20090922072834.GA25470@elte.hu> <1253606415.7103.216.camel@pasglop> <1253620332.10476.4.camel@concordia> <20090923124420.GA5525@elte.hu> <1253747995.6110.5.camel@concordia> <20090924121423.GB12262@elte.hu> <1253798755.16237.4.camel@concordia> <20090925095841.8578073a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925095841.8578073a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Thu, 24 Sep 2009 23:25:55 +1000 Michael Ellerman <michael@ellerman.id.au> wrote:
> >
> > Give me a day or two, I should be able to add a per-branch setting for
> > who to send mails to without too much trouble.
> 
> In the mean time I don't now if someone has pointed you at these today:
> 
> http://kisskb.ellerman.id.au/kisskb/branch/12/

That's an upstream warning.

-tip supports fail-on-build-warnings build mode (for the whole kernel) 
via the CONFIG_ALLOW_WARNINGS .config setting. So if you do allnoconfig 
builds, make sure you turn on CONFIG_ALLOW_WARNINGS=y to get the same 
build behavior as with Linus's tree.

	Ingo
