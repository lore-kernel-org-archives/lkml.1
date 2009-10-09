Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZJIJ1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZJIJ1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760310AbZJIJ1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:27:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760238AbZJIJ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:27:39 -0400
Date: Fri, 9 Oct 2009 11:26:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091009092648.GA18894@elte.hu>
References: <20091003103441.GA10874@elte.hu> <20091004191729.GA20203@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004191729.GA20203@merkur.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, Oct 03, 2009 at 12:34:41PM +0200, Ingo Molnar wrote:
> > 
> > Sam,
> > 
> > that arch-cache thing introduced in:
> > 
> >  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > 
> > isnt working very well in my experience.
> > 
> > 1) it's a nuisance in cross-builds (it broke several cross-build scripts 
> >    of mine)
>
> On the contrary it has helped me big time on my cross builds. [...]

Could you please try to do that without hurting the existing scripting 
and existing workflow of other people?

> No need to script is all to remember to set the correct ARCH + 
> CROSS_COMPILE settings.

Then put your new state into the .config instead of this stupid 
include/generated/ extra state that is a _big_ regression over v2.6.31 
in terms of cross-build usability.

	Ingo
