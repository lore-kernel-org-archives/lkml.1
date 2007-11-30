Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbXK3Sfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbXK3Sfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761214AbXK3Sff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:35:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760527AbXK3Sfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:35:34 -0500
Date: Fri, 30 Nov 2007 19:35:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130183512.GA8985@elte.hu>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu> <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com> <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 30 Nov 2007, Ingo Molnar wrote:
> 
> > you mean this single patch:
> > 
> >  modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
> > 
> > that's the only patch i missed AFAICS.
> 
> That is a pretty uncritical one. Then there is the fix of the zero 
> address handling in modules.c, the fixup for the use of __per_cpu_xx 
> variables in modules.c. etc.

you again talk about modules.c but my test kernel that crashes has no 
modules at all.

> It would be best to test against mm since there are core changes here 
> that will have to wait to the next merge period.

if you treat testing and review efforts like that they might have to 
wait even longer :-( "My stuff is there somewhere amongst 1415 -mm 
patches. Thank you for your interest and buzz off already."

	Ingo
