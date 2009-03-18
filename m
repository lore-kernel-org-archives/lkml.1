Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZCRQSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZCRQSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZCRQSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:18:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZCRQSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:18:34 -0400
Date: Wed, 18 Mar 2009 17:18:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse cleanup
Message-ID: <20090318161829.GC21331@elte.hu>
References: <1237314836.3212.10.camel@localhost.localdomain> <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu> <1237392355.12866.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237392355.12866.2.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-03-18 at 15:11 +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Wed, 2009-03-18 at 00:03 +0530, Jaswinder Singh Rajput wrote:
> > > > The following changes since commit 0ca0f16fd17c5d880dd0abbe03595b0c7c5b3c95:
> > > >   Ingo Molnar (1):
> > > >         Merge branches 'x86/apic', 'x86/asm', 'x86/cleanups', 'x86/debug', 'x86/kconfig', 'x86/mm', 'x86/ptrace', 'x86/setup' and 'x86/urgent'; commit 'v2.6.29-rc8' into x86/core
> > > > 
> > > > are available in the git repository at:
> > > > 
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core
> > > > 
> > > > Jaswinder Singh Rajput (1):
> > > >       x86: mpparse cleanup
> > > > 
> > > >  arch/x86/kernel/mpparse.c |  311 +++++++++++++++++++++------------------------
> > > >  1 files changed, 146 insertions(+), 165 deletions(-)
> > > > 
> > > 
> > > Complete diff:
> > > 
> > > Subject: [PATCH] x86: mpparse cleanup
> > > 
> > > Impact: cleanup
> > > 
> > > - fix various style problems
> > >   - fix header file issues
> > 
> > These are cleanups.
> > 
> > > Introduced helper functions:
> > > skip_entry, smp_reserve_bootmem, check_irq_src and check_slot
> > 
> > These are functional modifications. (the object code changes)
> > 
> 
> OK, removed cleanups, New pull request:
> 
> The following changes since commit 0ca0f16fd17c5d880dd0abbe03595b0c7c5b3c95:
>   Ingo Molnar (1):
>         Merge branches 'x86/apic', 'x86/asm', 'x86/cleanups', 'x86/debug', 'x86/kconfig', 'x86/mm', 'x86/ptrace', 'x86/setup' and 'x86/urgent'; commit 'v2.6.29-rc8' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core
> 
> Jaswinder Singh Rajput (1):
>       x86: mpparse introduced few helper functions
> 
>  arch/x86/kernel/mpparse.c |  261 +++++++++++++++++++++------------------------
>  1 files changed, 120 insertions(+), 141 deletions(-)

Looks good - pulled, thanks Jaswinder!

Would you be interested in resurrecting the more mechanic cleanups 
you did as well, on top of this patch?

They are still valuable, we just have to keep them separate from a 
potential breakage-causing change like the above one, so that if a 
tester bisects to it, we have an as single-purpose and focused 
commit to look at as possible.

	Ingo
