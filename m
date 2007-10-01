Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXJAHPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXJAHPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXJAHOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:14:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbXJAHOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:14:53 -0400
Date: Mon, 1 Oct 2007 09:14:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] MTD: fix cfi_interleave() build errors
Message-ID: <20071001071437.GA15051@elte.hu>
References: <20071001045037.GA10564@elte.hu> <20071001050145.GA12925@elte.hu> <1191221671.2905.637.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191221671.2905.637.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2007-10-01 at 07:01 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > FYI, the attached .config fails with the build errors below. Kernel is 
> > > latest 2.6.23-git. Found via make randconfig.
> > 
> > the quick fix below resolves these build failures. (i guess it might be 
> > cleaner/safer to solve this via excluding this .config combination via 
> > Kconfig rules, but that looks too involved for now.)
> 
> This is already fixed in my tree; it just wasn't worth pushing for 
> 2.6.23.

MTD is the only code in the tree at the moment that breaks "make 
randconfig" tests (after ~2000 random rebuilds) - and those tests _are_ 
immensely useful, they catch a lot of build breakage in the scheduler 
git tree for example, before i push it out. So if possible it would be 
nice to have this in .23.

	Ingo
