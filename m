Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbYEFPFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbYEFPFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYEFPFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:05:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37830 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbYEFPFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:05:01 -0400
Date: Tue, 6 May 2008 17:04:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
Message-ID: <20080506150432.GA31075@elte.hu>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805061435510.32567@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> > we have an strace/ptrace fix pending in x86.git - but that should 
> > not affect khelper.
> 
> No, it comes from your pmd_bad_v1/pmd_bad_v2 debug patch, which Linus 
> objected to, yet has crept into his tree nonetheless.

hm, the main objection was about whether to turn PAGE_SIZE from unsigned 
into signed though - and that we didnt do.

regarding the mm/memory.c changes you did - that's something i proposed 
before but didnt really feel positive about it because it affected every 
architecture.

lets sort it out.

> I looked back through the mails and logs on that, and disagree with 
> most of what was done there.  Here's my pending fix below, but I've 
> not yet tested whether it builds correctly on all relevant configs, 
> nor whether my pmd_huge does what's intended, nor written the 
> necessary comments, nor worked out the Cc list - I'm going out for a 
> short while, all those will follow later, this sent as a heads up to 
> relieve Jeff from bisecting.
> 
> Not-yet-Signed-off-by: Hugh Dickins <hugh@veritas.com>

i've thrown this into my queue to test it some more. I wont complain if 
it breaks :)

	Ingo
