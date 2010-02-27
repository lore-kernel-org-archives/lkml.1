Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968196Ab0B0Mrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:47:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33017 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968169Ab0B0Mrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:47:46 -0500
Date: Sat, 27 Feb 2010 13:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100227124710.GA21164@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <20100224182540.918b48b0.sfr@canb.auug.org.au>
 <20100227093948.GB31794@elte.hu>
 <201002271323.14402.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002271323.14402.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > Lets see.  Over the last 60 days, I have reported 37 build errors.  Of 
> > > these, 16 were reported against x86, 14 against ppc, 7 against other 
> > > archs.
> > 
> > So only 43% of them were even relevant on the platform that 95+% of the 
> > Linux testers use? Seems to support the points i made.
> 
> Well, I hope you don't mean that because the majority of bug reporters (vs 
> testers, the number of whom is unknown to me at least) use x86, we are free 
> to break the other architectures. ;-)

It means exactly that: just like we 'can' break compilation with gcc296, 
ancient versions of binutils, odd bootloaders, can break the boot via odd 
hardware, etc. When someone uses that architectures then the 'easy' bugfixes 
will actually flow in very quickly and without much fuss - and without 
burdening developers to consider cases they have no good ways to test. Why 
should rare architectures be more important than those other rare forms of 
Linux usage?

In fact those rare ways of building and booting the kernel i mentioned are 
probably used _more_ than half of the architectures that linux-next 
build-tests ...

So yes, of course _all_ bugs need fixing if there's enough capacity, but the 
process in general should be healthy, low-overhead and shouldnt concentrate on 
an irrelevant portion of Linux usage in such a prominent way.

Or, if it does, it should _first_ cover the other, much more burning areas of 
testing interest. All the while our _real_ bugreports are often rotting on 
bugzilla.kernel.org ...

Thanks,

	Ingo
