Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbYEFASc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbYEFASc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbYEFASQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:18:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbYEFASP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:18:15 -0400
Date: Tue, 6 May 2008 02:17:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506001751.GA22499@elte.hu>
References: <8287f540805041818g534c4e02qaadb0e749c5f3439@mail.gmail.com> <20080505053935.GA15734@rhlx01.hs-esslingen.de> <20080505073030.GI3350@elte.hu> <20080506095122.860796f6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506095122.860796f6.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Mon, 5 May 2008 09:30:31 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Subject: irda: PNP support for drivers/net/irda/nsc-ircc.c
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Sat May 03 21:21:13 CEST 2008
> > 
> > x86.git testing found the following build failure in latest -git:
> > 
> >  drivers/built-in.o: In function `nsc_ircc_pnp_probe':
> >  nsc-ircc.c:(.text+0xdf1b6): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf1d4): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf1ee): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf237): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf24c): undefined reference to `pnp_get_resource'
> >  drivers/built-in.o:nsc-ircc.c:(.text+0xdf266): more undefined references to `pnp_get_resource' follow
> >  make: *** [.tmp_vmlinux1] Error 1
> 
> This was discovered in linux-next and a patch posted on March 28 ...

hm, i do searches on lkml before posting patches but i cannot do 
searches on _every_ mailing list where patches might show up. There's 
just 30 hours in a day ;-)

perhaps linux-next should propagate all add-on fix patches it is 
carrying against subsystem trees if they are still relevant to -git, 
once the subsystem tree goes to -git, and re-post them to lkml in that 
case, to avoid duplicative work? Once it's on lkml i think most 
subsystem maintainers will find any missing patches.

> I (and I assume Andrew) have been carrying them since then but noone 
> took them up.  I guess (as Andrew pointed out to me) I should have 
> pushed them.

yeah.

	Ingo
