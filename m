Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXHAPIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXHAPIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbXHAPIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:08:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933378AbXHAPIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:08:04 -0400
Date: Wed, 1 Aug 2007 17:07:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801150742.GA23670@elte.hu>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011511530.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > Please also send me the output of this script:
> > 
> >   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> Send privately.

thanks. Just to make sure, while you said that your TSC was off on that 
laptop, the bootup log of yours suggests a working TSC:

  Time: tsc clocksource has been installed.

and still your fl.c testcases produces the top output that you've 
reported in your first mail? If so then this could be a regression. Or 
did you turn off the tsc manually via notsc? (or was it with a different 
.config or on a different machine)? Please help us figure this out 
exactly, we dont want a real regression go unnoticed.

If you can reproduce that problem with a working TSC then please 
generate a second cfs-debug-info.sh snapshot _while_ your fl+l workload 
is running and send that to me (i'll reply back to it publicly). Thanks,

	Ingo
