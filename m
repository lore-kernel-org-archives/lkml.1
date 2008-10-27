Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYJ0SOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYJ0SOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYJ0SOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:14:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYJ0SOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:14:09 -0400
Date: Mon, 27 Oct 2008 19:11:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, lethal@linux-sh.org,
       paulus@samba.org, benh@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [GIT PULL] s390 updates for 2.6.28-rc1
Message-ID: <20081027181103.GH3046@elte.hu>
References: <20081024105049.GC4620@osiris.boeblingen.de.ibm.com> <20081024113724.GA21375@elte.hu> <1225045593.14057.11.camel@localhost> <20081027115146.GE5631@elte.hu> <1225110750.15777.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225110750.15777.10.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Mon, 2008-10-27 at 12:51 +0100, Ingo Molnar wrote:
> > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > On Fri, 2008-10-24 at 13:37 +0200, Ingo Molnar wrote:
> > > > * Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > 
> > > > > The s390 vdso preparation patch "arch_setup_additional_pages argument" 
> > > > > touches other architectures (x86, sh and powerpc):
> > > > > 
> > > > > arch_setup_additional_pages currently gets two arguments, the binary 
> > > > > format descripton and an indication if the process uses an executable 
> > > > > stack or not. The second argument is not used by anybody, it could be 
> > > > > removed without replacement.
> > > > 
> > > > hm, this is the first time i've seen this change,
> > > 
> > > The code is relatively new and I planned it for the merge window for 
> > > 2.6.29. I still have to nag our performance team to do some tests 
> > > with it.
> > 
> > okay, then i'm confused, the subject line says v2.6.28:
> > 
> >     [GIT PULL] s390 updates for 2.6.28-rc1
> > 
> > (i have still no objections to those small x86 bits.)
> 
> Yeah, that was a misunderstanding between Heiko and me. I planned it 
> for 2.6.29 and didn't tell him about it before I left for vacation. 
> Heiko just went ahead and added it the 2.6.28-rc1 pull request.

ah, that's the happy variant.

> > it's just a historic/quirky connection (non-executable stack was 
> > the first and biggest step towards a more flexible address space 
> > layout) - you were correct to have it cleaned up.
> 
> Ok, thanks. Less confused now.

maybe someone gets interested in cleaning up those bits. Our ASRL-fu 
is still a bit ... random all around.

	Ingo
