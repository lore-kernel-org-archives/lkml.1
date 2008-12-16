Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758436AbYLPWX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbYLPWX2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYLPWXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:23:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYLPWXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:23:17 -0500
Date: Tue, 16 Dec 2008 23:23:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: linux-next: Tree for December 11
Message-ID: <20081216222305.GJ14787@elte.hu>
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au> <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com> <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com> <20081216210834.GM14787@elte.hu> <f19298770812161421r77a10575ia956e59a52d7efb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770812161421r77a10575ia956e59a52d7efb2@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Wed, Dec 17, 2008 at 00:08, Ingo Molnar <mingo@elte.hu> wrote:
> 
> >>
> >> The warning can also be reproduced in qemu, so it was easy to bisect.
> >>
> >> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> >> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> >> Date:   Tue Sep 30 20:50:27 2008 +1000
> >>
> >>     sched: improve preempt debugging
> >>
> >>     This patch helped me out with a problem I recently had....
> >>
> >>     Basically, when the kernel lock is held, then preempt_count
> >> underflow does not
> >>     get detected until it is released which may be a long time (and arbitrarily,
> >>     eg at different points it may be rescheduled). If the bkl is released at
> >>     schedule, the resulting output is actually fairly cryptic...
> >>
> >>     With any other lock that elevates preempt_count, it is illegal to schedule
> >>     under it (which would get found pretty quickly). bkl allows scheduling with
> >>     preempt_count elevated, which makes underflows hard to debug.
> >>
> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>
> >> I understand that not this particular commit is buggy, but at least
> >> I've got someone to add to the CC. ;)
> >>
> >> Also the author's e-mail looks suspicious.
> >
> > Suspicious in what way?
> 
> Does not appear in signed-off-by.

yes, because i applied and tested it through before Nick was comfortable 
with signing off on it.

	Ingo
