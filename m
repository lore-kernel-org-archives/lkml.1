Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYBAXZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYBAXZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbYBAXY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:24:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760314AbYBAXY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:24:57 -0500
Date: Sat, 2 Feb 2008 00:24:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
Message-ID: <20080201232415.GB30387@elte.hu>
References: <200801272229.48955.rjw@sisk.pl> <20080201124702.GA31321@elte.hu> <200802011542.42483.rjw@sisk.pl> <200802020019.25599.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802020019.25599.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Friday, 1 of February 2008, Rafael J. Wysocki wrote:
> > On Friday, 1 of February 2008, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > The below fixes it for me..
> > > > 
> > > > ---
> > > >  - restore the old wakeup mechanism
> > > >  - fix break usage in do_each_thread() { } while_eac_thread().
> > > >  - fix the hotplug switch stmt, a fall-through case was broken.
> > > 
> > > thanks Peter, i've picked your fix up. I hope this solves the problem 
> > > for Rafael too.
> > 
> > No, it doesn't, unfortunately.  Actually, it breaks things even more, as
> > suspend now hangs (probably deadlocks) while disabling the nonboot CPU.
> 
> For some obscure reason, I'm no longer able to reproduce the problem 
> with the Peter's patch and I think it's correct.  You can add
> 
> Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> to it.

Great! I sent the fix to Linus with your Tested-by line. Thanks Rafael 
for all the testing!

	Ingo
