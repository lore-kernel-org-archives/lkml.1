Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYA0G5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYA0G5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYA0G5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:57:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYA0G5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:57:47 -0500
Date: Sun, 27 Jan 2008 07:57:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] [KGDB] core code cleanups
Message-ID: <20080127065734.GA29514@elte.hu>
References: <479A5C35.6040605@windriver.com> <20080125222836.GA24708@elte.hu> <20080126220106.4c1c2d5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220106.4c1c2d5b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > thanks Jason, i have applied your cleanups to x86.git.
> 
> I don't recall having actually seen the kgdb patches recently.  Have 
> they had a suitable level of review?

it was posted three months ago to lkml (the upteenth time) and we picked 
it up into x86.git a month ago. KGDB has been problem-free in x86.git 
ever since.

> In particular, as the plan is to migrate all kgdb-enabled 
> architectures onto the generic kgdb core (yes?), have the owners of 
> the eligible architectures actually taken a look at what we'll be 
> asking of them?

at least as far as x86.git went the arch impact was refreshingly small. 
There was some feedback that was addressed by Jason. (If any feedback is 
still unaddressed then let us know - or if there are any new comments 
i'm sure they will be addressed prompty - please keep the comments 
coming!)

As more architectures enable support for KGDB, any specific objections 
can and should be addressed on that level. (That's how we did it for 
genirq and dynticks and that went far better than "address all 
architecture concerns at once" - which delays merges forever. We'd still 
be discussing irq flows versus flat irqs and clockevents versus drivers 
if we did it like that.)

	Ingo
