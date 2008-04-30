Return-Path: <linux-kernel-owner+w=401wt.eu-S934162AbYD3WUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbYD3WUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933503AbYD3WUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:20:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34295 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761886AbYD3WUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:20:08 -0400
Date: Thu, 1 May 2008 00:19:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430221936.GA27292@elte.hu>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430.142137.236846072.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430.142137.236846072.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> > linux-next does little to address our two largest (IMO) problems: 
> > inadequate review and inadequate response to bug and regression 
> > reports. But those problems are harder to fix..
> 
> This is all about positive and negative reinforcement.
> 
> The people who sit and git bisect their lives away to get the 
> regressions fixed need more positive reinforcement.  And the people 
> who stick these regressions into the tree need more negative 
> reinforcement.

What we need is not 'negative reinforcement'. That is just nasty, open 
warfare between isolated parties, expressed in a politically correct 
way.

The core problem is that every maintainer has his own subjective, 
assymetric view and experience about this matter: to him his own tree is 
almost problem-free and most problems are very easy to fix, while other 
problems in other trees are nuisance that should never have been put 
upstream.

Also, people get defensive when their regressions gets pointed out in 
anything but the most respectful and casual manner.

For example, how on earth do i tell you that during the v2.6.24 merge 
window, half of all x86 test-machines for me and others were broken 
because they had no networking, for more than a week in a row? Are you 
surprised about this (true) experience we had? Do you feel insulted? Do 
you feel unfairly handled and slandered?

The same goes in the other direction as well - you were just hit by 
scheduler tree related regressions that were only triggered on your 
128-way sparc64, but not on our 64way x86 and smaller boxes.

The thing is, what we really need is more cooperation and earlier 
integration - more people actually testing linux-next occasionally to 
see how things will look like in the next merge window.

linux-next doing build tests is fine, but the nasty regressions that 
will hit your box can only be solved if _you_ boot linux-next at least 
once before the merge window opens. The regressions that will hit my box 
can only be avoided if i test your tree.

hm? And can we please somehow talk about this without flaming each other 
in the process?

	Ingo
