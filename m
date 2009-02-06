Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbZBFPqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbZBFPqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbZBFPqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:46:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBFPqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:46:09 -0500
Date: Fri, 6 Feb 2009 16:45:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [linux-next][PATCH] revert headers_check fix: ia64, fpu.h
Message-ID: <20090206154539.GP18368@elte.hu>
References: <20090206164546.6291.KOSAKI.MOTOHIRO@jp.fujitsu.com> <3f9a31f40902060053x18dacf58u40c739ab89f13860@mail.gmail.com> <20090206180957.6294.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090206145556.GH18368@elte.hu> <1233934141.3209.20.camel@localhost.localdomain> <20090206153315.GD13758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206153315.GD13758@n2100.arm.linux.org.uk>
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


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Feb 06, 2009 at 08:59:01PM +0530, Jaswinder Singh Rajput wrote:
> > On Fri, 2009-02-06 at 15:55 +0100, Ingo Molnar wrote:
> > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > 
> > > > > > Index: b/arch/ia64/include/asm/fpu.h
> > > > > > ===================================================================
> > > > > > --- a/arch/ia64/include/asm/fpu.h
> > > > > > +++ b/arch/ia64/include/asm/fpu.h
> > > > > > @@ -6,7 +6,7 @@
> > > > > >  *     David Mosberger-Tang <davidm@hpl.hp.com>
> > > > > >  */
> > > > > >
> > > > > > -#include <linux/types.h>
> > > > > > +#include <asm/types.h>
> > > > > >
> > > > > 
> > > > > No , we do not even need asm/types.h
> > > > > 
> > > > > Subject: [PATCH] Neither asm/types.h nor linux/types.h is not required
> > > > > for arch/ia64/include/asm/fpu.h
> > > > > 
> > > > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > > 
> > > > ok. I confirmed.
> > > > 	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > 
> > > Thanks.
> > > 
> > > Jaswinder, mind adding these tags to the commit and sending a pull request 
> > > with all fixes?
> > 
> > The following changes since commit 0b86a4e34d885e734a4c4e46293376f3f1c639eb:
> >   Ingo Molnar (1):
> >         Merge branch 'core/header-fixes' of git://git.kernel.org/.../jaswinder/linux-2.6-tip into core/header-fixes
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes
> > 
> > Jaswinder Singh Rajput (2):
> >       Neither asm/types.h nor linux/types.h is required for arch/ia64/include/asm/fpu.h
> >       make linux/types.h as assembly safe
> 
> I continue to disagree with the need for the second patch.

But have not replied to my mail about that so far.

Why is it wrong to make types.h an assembly-invariant? It is positively 
helpful for mixed-mode headers and has no downsides whatsoever.

	Ingo
