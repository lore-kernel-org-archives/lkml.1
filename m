Return-Path: <linux-kernel-owner+w=401wt.eu-S1760490AbZFJWHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490AbZFJWHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZFJWHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:07:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZFJWHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:07:44 -0400
Date: Thu, 11 Jun 2009 00:07:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cleanups for v2.6.31
Message-ID: <20090610220737.GA11411@elte.hu>
References: <20090610211240.GA1425@elte.hu> <alpine.LFD.2.01.0906101500200.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906101500200.6847@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 10 Jun 2009, Ingo Molnar wrote:
> 
> > 
> > Please pull the latest x86-cleanups-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus
> 
> Just checking - these are all independent and it doesn't much 
> matter which order I pull in, right?

Yes - each is -git based and independent. To make sure i also built 
each one before sending, and also booted the ones i wanted to 
double-check (about half of them).

> That way I can go through the easy ones first, which helps me get 
> around to the ones I decide I want to think about more later.

Yeah. Any order should be fine and if there are conflicts they 
should be straightforward.

Any unreasonably heavy conflict was resolved by merging topics into 
a single entity. This happened for one of the branches: the IRQ bits 
i sent started out as x86/apic - the the scope of the changes 
increased on the way.

No unreasonable mixing of topics happened in this cycle - the topic 
separation worked out fine, due to increased attention we spent on 
making it happen and due to the unification activities winding down 
(finally! :-).

	Ingo
