Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYECTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYECTmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYECTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:42:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39386 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYECTmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:42:12 -0400
Date: Sat, 3 May 2008 21:41:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix rebuild of wakeup.bin
Message-ID: <20080503194149.GC25097@elte.hu>
References: <20080501010516.DD2FE26FA05@magilla.localdomain> <20080501093107.GA2392@uranus.ravnborg.org> <200805011248.53295.rjw@sisk.pl> <20080503180612.GD5292@elte.hu> <20080503181503.GB17990@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503181503.GB17990@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, May 03, 2008 at 08:06:12PM +0200, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > Add wakeup.lds to list af targets to avoid rebuilding wakeup.bin - 
> > > > from Roland McGrath.
> > > 
> > > Thanks for fixing this!
> > > 
> > > Ingo, please merge.
> > 
> > applied - thanks all!
> 
> Just a note - I do not think this solves the problem Daniel has 
> reported with respect to first build of -next. I am awaiting more data 
> before I can analyse it further.

yeah, i suspected that - that appears to be a race of some sort, i.e. a 
missing dependency coupled with parallelizable rules, not an over-eager 
dependency as fixed by this patch, right?

	Ingo
