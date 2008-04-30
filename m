Return-Path: <linux-kernel-owner+w=401wt.eu-S934354AbYD3Wfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354AbYD3Wfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760478AbYD3Wfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:35:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52292 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbYD3Wfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:35:30 -0400
Date: Thu, 1 May 2008 00:35:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430223509.GA31547@elte.hu>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430.142137.236846072.davem@davemloft.net> <20080430221936.GA27292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430221936.GA27292@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> What we need is not 'negative reinforcement'. That is just nasty, open 
> warfare between isolated parties, expressed in a politically correct 
> way.

in more detail: any "negative reinforcement" should be on the 
_technical_ level, i.e. when changes are handled - not at the broad tree 
level.

Sure, there are exceptions, etc. - but by the time stuff goes upstream 
it's too late and we've got to fix stuff instead of trying to push back 
on each other.

by earlier integration (= linux-next) we can do the pushback much 
earlier, in a much more granular, much more technical in a much less 
personal way: "hey Ingo, your new sched-dizzy-blah patch broke stuff 
here, zap it" or "hey Dave, that socket-foo rewrite just broke things 
here, zap it".

git-revert _kind of_ makes that possible too, but people still feel too 
personal about reverts - they take it as intrusion into their subsystem 
and regard it as an attack against their competence as a maintainer.

and this is all so typical btw.: the most effective measure against 
human warfare is for people to see each other and to talk to each other.

[ That's one reason why i am so worried about mailing list isolation.
  People get more distant, they mean less to each other, work less with
  each other => Linux suffers. I do accept that for some people lkml is
  simply too noisy - but i think the cure is worse than the disease. ]

	Ingo
