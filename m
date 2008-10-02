Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYJBJcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYJBJcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYJBJch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:32:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47725 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYJBJch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:32:37 -0400
Date: Thu, 2 Oct 2008 11:32:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/31] cpumask: Documentation
Message-ID: <20081002093213.GB4190@elte.hu>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <200810010849.46874.rusty@rustcorp.com.au> <20081001091325.GA12503@elte.hu> <200810021036.29054.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810021036.29054.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> > IMHO, an infrastructure change of this magnitude should absolutely 
> > be done via the Git space. This needs a ton of testing and needs 
> > bisection, a real Git track record, etc.
> 
> Not yet.  Committing untested patches into git is the enemy of 
> bisection; if one of my patches breaks an architecture, they lose the 
> ability to bisect until its fixed.  If it's a series of patches, we 
> can go back and fix it.

while the initial series might be rebased once or twice, beyond the 1-2 
days of initial integration and testing i dont think that's true, and 
i'm doing up to 3-4 bisections a day just fine, on an append-mostly 
tree.

if you have trouble turning a Git tree into a bisectable tree then your 
testing-fu is not strong enough ;-)

[ the only plausible danger is to architectures that are not used by 
  testers all that much (so that breakages can linger a lot longer 
  unnoticed) - but why should the other 99% of Linux users be put at a 
  disadvantage for them. ]

	Ingo
