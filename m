Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbYFMHS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbYFMHS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYFMHSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:18:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYFMHSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:18:48 -0400
Date: Fri, 13 Jun 2008 09:18:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: fix comment formatting in
	asm-generic/pgtable.h:__ptep_modify_prot_
Message-ID: <20080613071800.GA11976@elte.hu>
References: <patchbomb.1212192268@localhost> <20080602111339.GB18586@elte.hu> <4843EF6A.20305@goop.org> <200806030946.00434.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806030946.00434.rusty@rustcorp.com.au>
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

> > -	/* Get the current pte state, but zero it out to make it
> > -	   non-present, preventing the hardware from asynchronously
> > -	   updating it. */
> > +	/*
> > +	 * Get the current pte state, but zero it out to make it
> > +	 * non-present, preventing the hardware from asynchronously
> > +	 * updating it.
> > +	 */
> 
> Since there is debate over whether winged comments are a feature, I'm 
> not sure this can be termed a "fix".

Well, if you compare the two variants above Jeremy's solution looks 
visually more pleasing, so yes it is an improvement and a fix.

( And it's even very obvious in this case, the vertical line gives a
  clear delineation of the information and separates it from the code
  sections. )

Also, according to Documentation/CodingStyle:

| The preferred style for long (multi-line) comments is:
|
|        /*
|         * This is the preferred style for multi-line
|         * comments in the Linux kernel source code.
|         * Please use it consistently.
|         *
|         * Description:  A column of asterisks on the left side,
|         * with beginning and ending almost-blank lines.
|         */

arch/x86 and include/asm-x86 follows that rule. (And we'd follow it even 
if the issue was typographically debatable [which it isnt] because 
consistency is visual rule #0 )

	Ingo
