Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbXEYLbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbXEYLbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXEYLbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:31:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbXEYLbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:31:33 -0400
Date: Fri, 25 May 2007 13:31:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525113124.GA31976@elte.hu>
References: <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525112600.GA27007@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > please send me your current sched-clock.c, i'll redo any remaining 
> > > cleanups.
> > 
> > It needs at least one new preliminary patch (to add on_cpu_single);
> > please get the series from 
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches-2.6.22-rc2-git7-070525-1.tar.gz
> > You need at least tsc-unstable upto paravirt-add-a-sched_clock-paravirt
> > for everything

> i'm looking at the other things now.

your queue does not apply cleanly here:

 Applying patch patches/paravirt-add-a-sched_clock-paravirt_op

 patching file arch/i386/kernel/sched-clock.c
 Hunk #5 FAILED at 148.
 1 out of 5 hunks FAILED -- rejects in file arch/i386/kernel/sched-clock.c

could you please just send me your current sched-clock.c? (that's what 
i'm interested in) I'll deal with the on_cpu_single() dependency. 
Thanks,

	Ingo
