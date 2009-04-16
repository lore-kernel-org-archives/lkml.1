Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZDPH6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZDPH6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZDPH6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:58:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52882 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZDPH6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:58:14 -0400
Date: Thu, 16 Apr 2009 09:56:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416075651.GB4507@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <200904161130.28129.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904161130.28129.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thu, 16 Apr 2009 04:17:49 am H. Peter Anvin wrote:
> > Linus Torvalds wrote:
> > "build fix" is valid and proper use: it tells that it
> > fixes a compilation error, which succinctly communicates both the
> > priority of the fix and how it needs to be validated.
> 
> Side note: I really prefer to see the compile error output in this 
> case: great for googling.  It annoys me when people skip this.
> 
> Anyway, Impact: had lead me to think harder about my messages than 
> the free-form commit style did.  Perhaps it's too rigid, but it 
> helped.

btw., and i think this is the crux of the matter, Rusty was quite 
sceptic about impact lines in the beginning, and did not like them 
_at all_. We had discussions (months ago) about it with Rusty and he 
had a similar position to other "read only" participants in this 
thread.

And i can tell it from the other side of the fence: Rusty's trees 
were very nice before, but they became _even_ nicer after he started 
using impact lines. It was very noticeable.

Impact lines are intentionally rigid - but all 'forced' measures 
(like signed-off lines, or a title, or other patch submission 
standards) are rigid in a way and they elicit an initial backlash 
from people who have never adhered to them before.

Impact lines have most of their effects on the people who _write_ 
them: contributors and first-hop maintainers. Their role becomes 
informative as the hops increase - and they might even become 
annoyingly meaningless and verbose as the hop count reaches Linus 
;-)

	Ingo
