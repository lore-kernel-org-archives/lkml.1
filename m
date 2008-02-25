Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYBYNqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYBYNqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYBYNqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:46:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbYBYNqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:46:07 -0500
Date: Mon, 25 Feb 2008 14:45:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225134549.GA4481@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225113235.GC32450@cs181133002.pp.htv.fi> <20080225115022.GA16376@elte.hu> <20080225122526.GE32450@cs181133002.pp.htv.fi> <20080225125707.GA27202@elte.hu> <20080225131202.GF32450@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225131202.GF32450@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> > so if an arguably sane testing method "only" works on x86 then the 
> > right solution is to fix the other architectures to be sanely 
> > testable too.
> 
> If you want to fix them I won't stop you...
> 
> Until they are fixed I'm staying at using the defconfigs.

As i said it before, it's totally senseless to add zillions of 
defconfigs to x86. The two that are there should be enough for a 
sniff-test - and much more than that has to be done to ensure that a 
patch doesnt break anything. Not even a 100 defconfigs would match 
proper randconfig coverage.

according to one particular arbitrary piece of metrics [1], ~99.15% of 
our testers use x86 - and the oopses collected on kerneloops.org show a 
similar proportion.

> > I've seen architectures that were build-tested for the _first time_ 
> > at around 2.6.24-rc8...
> 
> That can't be true.
> 
> Can you name what architectures you think of and why you think noone 
> tried to compile them before?

sorry, s/build-tested/boot-tested.

there's been only 6 commits to arch/v850 between v2.6.23 and v2.6.24.
None of them seems to suggest that anyone ever tested v850 in the last
year or so.

	Ingo

[1] http://smolt.fedoraproject.org
