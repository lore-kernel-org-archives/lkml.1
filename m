Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbXKNOJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbXKNOJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXKNOJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:09:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXKNOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:09:30 -0500
Date: Wed, 14 Nov 2007 15:08:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114140847.GA11489@elte.hu>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <20071113085514.3414aa52.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113085514.3414aa52.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> > (and this is in no way directed at the networking folks - it holds 
> > for all of us. I have one main complaint about networking: the 
> > separate netdev list is a bad idea - networking regressions should 
> > be discussed and fixed on lkml, like most other subsystems are. Any 
> > artificial split of the lk discussion space is bad.)
> 
> but here I disagree.  LKML is already too busy and noisy. Major 
> subsystems need their own discussion areas.

That's a stupid argument. We lose much more by forced isolation of 
discussion than what we win by having less traffic! It's _MUCH_ easier 
to narrow down information (by filter by threads, by topics, by people, 
etc.) than it is to gobble information together from various fractured 
sources. We learned it _again and again_ that isolation of kernel 
discussions causes bad things.

In fact this thread is the very example: David points out that on netdev 
some of those bugs were already discussed and resolved. Had it been all 
on lkml we'd all be aware of it.

this is a single kernel project that is released together as one 
codebase, so a central place of discussion is obvious and common-sense.

so please stop this "too busy and too noisy" nonsense already. It was 
nonsense 10 years ago and it's nonsense today. In 10 years the kernel 
grew from a 1 million lines codebase to an 8 million lines codebase, so 
what? Deal with it and be intelligent about filtering your information 
influx instead of imposing a hard pre-filtering criteria that restricts 
intelligent processing of information.

	Ingo
