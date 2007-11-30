Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbXK3SAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbXK3SAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXK3SAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:00:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbXK3SAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:00:36 -0500
Date: Fri, 30 Nov 2007 19:00:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130180002.GB19571@elte.hu>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu> <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
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
> > 
> > and the patches dont even build on 64-bit x86:
> > 
> > kernel/module.c: In function 'load_module':
> > kernel/module.c:1989: error: '__per_cpu_offset' undeclared (first use in this function)
> > kernel/module.c:1989: error: (Each undeclared identifier is reported only once
> > kernel/module.c:1989: error: for each function it appears in.)
> > 
> > config below. I'm dropping the patches for now. (again, this might be my 
> > mismerge)
> 
> Right. The above is a result of your missing a cleanup patch from mm 
> that fixes the module issue. Again running mm will take care of all of 
> these things.

you mean this single patch:

 modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch

that's the only patch i missed AFAICS.

	Ingo
