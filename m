Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYBRJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYBRJaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYBRJaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:30:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45578 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYBRJaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:30:06 -0500
Date: Mon, 18 Feb 2008 10:29:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Coding style fixes for
	arch/x86/kernel/cpu/centaur.c
Message-ID: <20080218092944.GA26521@elte.hu>
References: <20080217233023.26764dc9@paolo-desktop> <20080218025645.GB30201@elte.hu> <4d8e3fd30802180048o39790aedwde2ef1cbb009363e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30802180048o39790aedwde2ef1cbb009363e@mail.gmail.com>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> >  /*
> > - *     Set up an actual MCR
> > + * Set up an actual MCR
> >   */
> 
> This was not highlighted by checkpatch.pl, right? The same applies for 
> a few other "fix" you did on some comments.

correct - it's not fixes, just bringing it in line with the common 
comment style we use. The file was using lots of inconsistent comment 
styles.

> [...]
> >  {
> > -       u32 mem = ramtop();
> >         u32 root = power2(mem);
> > +       u32 mem = ramtop();
> 
> Can you please explain the rationale behind this change?

it's a bug :) It got pointed out by Joe Perches and i fixed it. (the 
size check would have caught it too)

> > -               E2MMX = 1<<19,
> > -               EAMD3D = 1<<20,
> > -       };
> 
> I see why you did the cleanup but I think even this part was not
> catched by checkpatch.pl

yes, as i said:

> > Some of them are real CodingStyle problems, some of them are just 
> > arbitrary taste details.

checkpatch.pl is a helper tool which highlights some of the clear 
problem - but when we clean up files we try to make it appear consistent 
in all its details. My patch was a demonstration of what else can be 
fixed in a file until it's really clean looking in its entirety.

	Ingo
