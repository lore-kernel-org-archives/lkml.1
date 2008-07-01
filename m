Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYGAJ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYGAJ2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYGAJ2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:28:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYGAJ2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:28:34 -0400
Date: Tue, 1 Jul 2008 11:28:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080701092820.GA31309@elte.hu>
References: <20080610214544.GA14824@damson.getinternet.no> <20080618103006.GF15255@elte.hu> <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com> <20080626120202.GH29619@elte.hu> <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> > or perhaps we could include it in tip/master right now as well, if 
> > you did another branch that excluded the files below. That would 
> > make merging a lot easier - and we could do a second phase in 
> > v2.6.27-rc1. Hm?
> 
> I don't think we really need to resolve conflicts at all. What we can 
> do is simply to re-run the scripts against tip/master whenever you 
> want the update.

ok, lets do it that way.

> Also, by the way: Can -tip now be cloned with --shared to save space 
> as long as I only have branches with references to commits in 
> tip/master? Or is this still to be considered unsafe?

it's unsafe if we ever rewind a commit that you rely on later, and 
git-gc zaps it from tip.git?

i think it would be better to not rely on that yet. The overwhelming 
majority of activities in tip.git are append-only, but the integration 
branches (which are included in tip/master) get regenerated frequently. 
If you base on a topic branch itself (say tip/x86/nmi) - that should be 
pretty stable.

	Ingo
