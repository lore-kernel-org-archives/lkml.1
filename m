Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZBIMXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZBIMXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZBIMXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:23:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZBIMXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:23:41 -0500
Date: Mon, 9 Feb 2009 13:23:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090209122308.GH17782@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain> <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com> <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain> <20090205191907.GA27422@elte.hu> <1233886017.3463.26.camel@localhost.localdomain> <20090206022025.GA8317@elte.hu> <1233929922.3209.6.camel@localhost.localdomain> <20090206172453.GB11299@uranus.ravnborg.org> <1234072234.26182.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234072234.26182.2.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Fri, 2009-02-06 at 18:24 +0100, Sam Ravnborg wrote:
> > > 
> > > Is this safe OR we can make it more safer:
> > > 
> > > Subject: [PATCH] make linux/types.h as assembly safe
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  include/linux/types.h |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/types.h b/include/linux/types.h
> > > index 712ca53..c30973a 100644
> > > --- a/include/linux/types.h
> > > +++ b/include/linux/types.h
> > > @@ -1,6 +1,7 @@
> > >  #ifndef _LINUX_TYPES_H
> > >  #define _LINUX_TYPES_H
> > >  
> > > +#ifndef __ASSEMBLY__
> > >  #ifdef	__KERNEL__
> > >  
> > >  #define DECLARE_BITMAP(name,bits) \
> > > @@ -212,5 +213,5 @@ struct ustat {
> > >  };
> > >  
> > >  #endif	/* __KERNEL__ */
> > > -
> > > +#endif /*  __ASSEMBLY__ */
> > >  #endif /* _LINUX_TYPES_H */
> > 
> > This is wrong...
> > We should include the assumed assembly safe asm/types.h
> > outside the __ASEMBLY__ ifdef.
> > 
> 
> The following changes since commit f6c727813e03ce0f58d73808da8c9a6bc227249e:
>   Ingo Molnar (1):
>         Merge branch 'core/header-fixes' of git://git.kernel.org/.../jaswinder/linux-2.6-tip into core/header-fixes
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes
> 
> Jaswinder Singh Rajput (1):
>       unconditionally include asm/types.h from linux/types.h
> 
>  include/linux/types.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Pulled into tip:core/header-fixes, thanks Jaswinder!

	Ingo
