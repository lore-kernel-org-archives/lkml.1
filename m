Return-Path: <linux-kernel-owner+w=401wt.eu-S1763187AbYBLQZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763187AbYBLQZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761227AbYBLQY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:24:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56258 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbYBLQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:24:55 -0500
Date: Tue, 12 Feb 2008 17:24:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212162408.GB17947@elte.hu>
References: <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212161152.GA3281@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Anyways the slight risk of the other CPUs eventually recovering would 
> seem a acceptable trade off versus not being able to use the debugger 
> to debug the system with hanging CPUs.

see? There's the difference between us. The initial merge of KGDB does 
not want to include policies for nuances that pose an "acceptable slight 
risk".

Had we done it, you could have (rightfully in that case, i have to say) 
complained about that "slight but real danger" of a debugger activating 
without waiting for all CPUs to respond.

> A possible compromise between my and your position on this would be 
> also having an option for this, with default to off (although I would 
> expect that would be a inconvenient default for many people)

yes, i said this the first time you mentioned this issue that while it's 
all no big deal, it could perhaps be a sensible (but default-off) 
layered-on option for later. But the initial merge is for obvious stuff 
and it does not want to do such things.

	Ingo
