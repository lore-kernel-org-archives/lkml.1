Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZBHPLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZBHPLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 10:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZBHPLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 10:11:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32792 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZBHPLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 10:11:38 -0500
Date: Sun, 8 Feb 2009 16:11:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Collins <paul@burly.ondioline.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud
	(timekeeping_suspended)
Message-ID: <20090208151122.GB5314@elte.hu>
References: <87prihcepl.fsf@burly.wgtn.ondioline.org> <87k58nda87.fsf@burly.wgtn.ondioline.org> <874oz5pmvd.fsf@burly.wgtn.ondioline.org> <200902081439.31548.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902081439.31548.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Sunday 08 February 2009, Paul Collins wrote:
> > Paul Collins <paul@burly.ondioline.org> writes:
> > 
> > > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > >
> > >> On Wednesday 21 January 2009, Paul Collins wrote:
> > >>> Got a couple of these on a PowerBook running 2.6.29-rc2 either during
> > >>> suspend or resume -- it's hard to tell.  (The suspend message is
> > >>> timestamped in syslog with the time I resumed, so I guess it was
> > >>> buffered along with the subsequent "Badness" messages.)
> > >>
> > >> Please check if the patch from http://lkml.org/lkml/2009/1/13/144 fixes the
> > >> problem for you.
> > >
> > > It does not fix the problem.
> > 
> > I'm also getting this warning since 2.6.28.1, which incorporated commit
> > 1c5745aa380efb6417b5681104b007c8612fb496 ("sched_clock: prevent
> > scd->clock from moving backwards, take #2") as commit
> > e268dcdd404f4558cdd24c8ecede3e064df8fa33, this being the patch that
> > introduced the WARN_ON(timekeeping_suspended) check.
> 
> Hm, I thought the timekeeping suspend problem was fixed in this commit.  Ingo?

Thomas? :-)

	Ingo
