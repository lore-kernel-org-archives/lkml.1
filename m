Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZABLbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZABLbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZABLbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:31:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43610 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbZABLbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:31:40 -0500
Date: Fri, 2 Jan 2009 12:31:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
	modules (take 4)
Message-ID: <20090102113115.GA3027@elte.hu>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain> <ada63l0qmba.fsf@cisco.com> <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231181136.GA4382@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231181136.GA4382@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > I guess I could make a sparse rule for this, but nobody seems to run 
> > or care about sparse anyway. Sad.
> 
> There is some increased janitorial effort recently. Try to grep for 
> [Ss]+parse in the shortlog for the last couple of months.

in the x86 space there's a lot of Sparse activity as well: a number of 
developers do systematic runs of Sparse and keep the tree Sparse-clean.

The moment this spreads to a critical mass of subsystems we can start 
automating it. (as i was able to automate the checking of -Werr builds on 
x86, with arbitrary random .config's)

	Ingo
