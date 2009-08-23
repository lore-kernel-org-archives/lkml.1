Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZHWIxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZHWIxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 04:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZHWIxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 04:53:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbZHWIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 04:53:48 -0400
Date: Sun, 23 Aug 2009 10:53:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090823085331.GB7651@elte.hu>
References: <20090814134811.013873340@de.ibm.com> <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org> <20090822103252.GA32369@elte.hu> <20090822171540.1220f50d@skybase> <20090822153346.GA3313@elte.hu> <20090822222313.74b9619c@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822222313.74b9619c@skybase>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Sat, 22 Aug 2009 17:33:46 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > 
> > > > FYI, -tip arch-testing found that this commit broke the PowerPC 
> > > > build:
> > > > 
> > > > /home/mingo/tip/arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
> > > > /home/mingo/tip/arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void
> > > > /home/mingo/tip/arch/powerpc/kernel/time.c:791: error: 'return' with a value, in function returning void
> > > > make[2]: *** [arch/powerpc/kernel/time.o] Error 1
> > > > make[2]: *** Waiting for unfinished jobs....
> > > > make[1]: *** [arch/powerpc/kernel] Error 2
> > > 
> > > I overlooked a case in the powerpc version of read_persistent_lock.
> > > New patch:
> > 
> > the patches are already committed and this patch doesnt apply - mind 
> > sending a delta fix against tip:master:
> > 
> >  http://people.redhat.com/mingo/tip.git/README
> 
> Here we go:

applied, thanks! (i fixed the small detail checkpatch complained 
about)

Note, i've appended it to the timer tree for now - but for the 
lockdep bug we'll need another fix, and these two bugs will probably 
trigger a rebase. I'll leave it up to Thomas whether he wants to 
rebase the end result, once things have settled down.

	Ingo
