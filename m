Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZHJNcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZHJNcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZHJNcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:32:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZHJNcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:32:07 -0400
Date: Mon, 10 Aug 2009 15:29:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@sig21.net>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810132923.GA4418@elte.hu>
References: <20090807170942.GB9177@sig21.net> <87k51cgdt8.fsf@basil.nowhere.org> <20090810122731.GA5863@sig21.net> <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810125651.GB6082@sig21.net>
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


* Johannes Stezenbach <js@sig21.net> wrote:

> On Mon, Aug 10, 2009 at 02:32:28PM +0200, Andi Kleen wrote:
> > > > The appended patch should remove the warning. Can you please test it?
> > > 
> > > It works (no more warning), but I feel I'm better off using "lapic"
> > 
> > Thanks for testing.
> > 
> > > because it enables thermal monitoring and performance counters.
> > 
> > When the BIOS doesn't enable it then force enabling lapic might not work.
> > 
> > This could cause either boot failures (obvious) or more subtle 
> > problems like SMM doing something unexpected. Just saying that 
> > if you have strange problems later first try disabling this 
> > option again.
> 
> Thanks for the heads-up.  I remember I tried to use oprofile in 
> the past on this machine and was disappointed that it only got the 
> timer event.  I'll keep lapic for now unless I see signs of 
> instability.

What's the output of something like 'perf stat true', and does 'perf 
top' output something - i.e. do perfcounters work in general? Once 
you get to that stage and it works then it should be fine.

	Ingo
