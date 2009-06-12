Return-Path: <linux-kernel-owner+w=401wt.eu-S1764516AbZFLOBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764516AbZFLOBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZFLOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:00:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZFLOAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:00:52 -0400
Date: Fri, 12 Jun 2009 16:00:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck for mainline
Message-ID: <20090612140046.GI32105@elte.hu>
References: <20090612132443.GA24002@damson.ad.medicalresearch.no> <84144f020906120657j31fb3e82t2da251d31db6ba92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020906120657j31fb3e82t2da251d31db6ba92@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Linus,
> 
> On Fri, Jun 12, 2009 at 4:31 PM, Vegard Nossum<vegard.nossum@gmail.com> wrote:
> > Please consider pulling the kmemcheck tree;
> >
> > kmemcheck is a feature which can (at run-time) detect some uses of
> > uninitialized memory within the kernel, similarly to what Valgrind's memcheck
> > does for userspace programs. We also have the ability to find use-after-free
> > errors and leaks of uninitialized data to userspace, both with a false-
> > positive rate of zero.
> >
> > kmemcheck is self-contained in the sense that when CONFIG_KMEMCHECK=n, it has
> > no effect on the compiled kernel whatsoever. Our code has lived in the -tip
> > tree and been in -next for over a year, and has the acks of x86 and slab
> > maintainers (Ingo and Pekka). Inclusion in mainline would lower the threshold
> > for building and running kmemcheck-enabled kernels, which would also
> > hopefully increase testing coverage of the rest of the kernel code.
> 
> I hope I didn't burn all my karma for this merge window with the slab
> early boot patches but:
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> for this pull request.

+1

I've been testing kmemcheck in -tip for 1.5 years meanwhile and in 
terms of maintenance overhead it was never troublesome to have 
around.

	Ingo
