Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbZCTS74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbZCTS74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbZCTS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:59:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961AbZCTS7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:59:45 -0400
Date: Fri, 20 Mar 2009 19:59:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
Message-ID: <20090320185917.GB6224@elte.hu>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > > ---
> > >  scripts/Kbuild.include |    5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > Doesnt fully work:
> > 
> > arch/x86/kernel/entry_32.S:346: Error: unknown pseudo-op: `.cfi_signal_frame'
> > arch/x86/kernel/entry_32.S:394: Error: unknown pseudo-op: `.cfi_signal_frame'
> > arch/x86/kernel/entry_32.S:519: Error: unknown pseudo-op: `.cfi_signal_frame'
> > arch/x86/kernel/entry_32.S:614: Error: unknown pseudo-op: `.cfi_signal_frame'
> > arch/x86/kernel/entry_32.S:685: Error: unknown pseudo-op: `.cfi_signal_frame'
> > arch/x86/kernel/entry_32.S:754: Error: unknown pseudo-op: `.cfi_signal_frame'
> > 
> > config attached. Distcc driven build.
> 
> Same config works fine here. Do you have different 
> compilers/binutils on your distcc cluster ? I tripped over this 
> distcc feature in the past, that's why I have switched to iceccc.

the distcc binutils is different from the host build environment 
binutils and compiler. This always worked fine - can we preserve it?

	Ingo
