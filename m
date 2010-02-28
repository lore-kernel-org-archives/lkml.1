Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031486Ab0B1Hvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:51:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031462Ab0B1Hvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:51:46 -0500
Date: Sun, 28 Feb 2010 08:51:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100228075105.GC14205@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
 <20100228071405.GA14205@elte.hu>
 <20100228183725.80915681.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228183725.80915681.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Sun, 28 Feb 2010 08:14:05 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > > [...]  As long as that's the case, linux-next should build on them too.
> > 
> > No, and IMO linux-next is clearly over-interpreting this bit. Linux is not 
> > supposed to build on all architectures. Maybe that's a core bit of a 
> > misunderstanding (on either my or on sfr's side) and it should be clarified 
> > ...
> 
> Well, we have no real problem then.  The only architectures for which a 
> failure will stop new stuff getting into linux-next are the ones I 
> personally build while constructing the tree (x86, ppc and sparc).  Once 
> something is in linux-next, even if it causes a build failure overnight, I 
> am loath to remove it again as it can cause pain for Andrew (who bases -mm 
> on linux-next).

Ok - very good. This has apparently been relaxed some time ago, i know 
linux-next used to be more stringent.

> I will still report such failures (if I have time to notice them - I mostly 
> hope that architecture maintainers will have a glance over the build results 
> themselves) and others do as well but such failures do not generally cause 
> any actions on my part (except in rare cases I may actually fix the problem 
> or put a provided fix patch in linux-next).

Yeah. Plus it's never black and white - sometimes a rare arch will show some 
real crappiness in a commit. So we want to know all bugs.

> I would like to add arm to the mix of the architectures I build during 
> construction, but there is no wide ranging config that builds for arm and 
> building a few of the configs would just end up taking too much time.

Yeah, ARM is clearly important from a usage share POV IMHO, and it's also 
actively driving many areas of interest.

It's also a bit difficult to keep ARM going because there's so many 
non-standardized hw variants of ARM, so i'm sure the ARM folks will appreciate 
us not breaking them ...

( Alas, ARM doesnt tend to be a big problem, at least as far as the facilities 
  i'm concerned about go: it has implemented most of the core kernel 
  infrastructures so there's few if any 'self inflicted' breakages that i can 
  remember. )

> Thanks for clarifying.

Thanks,

	Ingo
