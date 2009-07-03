Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbZGCKYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbZGCKYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZGCKYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:24:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbZGCKYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:24:34 -0400
Date: Fri, 3 Jul 2009 12:24:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Horst Schirmeier <horst@schirmeier.com>, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: missing value 2 for randomize-va-space
Message-ID: <20090703102431.GC32128@elte.hu>
References: <20090702152338.GU26384@quickstop.soohrt.org> <alpine.LNX.2.00.0907030109191.4994@wotan.suse.de> <20090703000523.GX26384@quickstop.soohrt.org> <alpine.LNX.2.00.0907031200560.4994@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907031200560.4994@wotan.suse.de>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> 
> [ added Ingo to CC ]
> 
> On Fri, 3 Jul 2009, Horst Schirmeier wrote:
> 
> > On Fri, 03 Jul 2009, Jiri Kosina wrote:
> > > >      There a few legacy applications out there (such as some ancient
> > > 
> > > ... would you please fix this typo/grammo as well? (There a few ...)
> > > 
> > > >      versions of libc.so.5 from 1996) that assume that brk area starts
> > > 
> > > Also, the text itself doesn't seem to be super-clear ... namely, it 
> > > describes what CONFIG_COMPAT_BRK is about, but doesn't really clarify how 
> > > exactly does this correlate with randomize_va_space == 2. Would you mind 
> > > also fixing this bit?
> > 
> > I hope I didn't misread the sources :-)  Opinions?
> > 
> > ---
> > 
> > The documentation for /proc/sys/kernel/* does not mention the possible
> > value 2 for randomize-va-space yet.  While being there, doing some
> > reformatting, fixing grammar problems and clarifying the correlations
> > between randomize-va-space, kernel parameter "norandmaps" and the
> > CONFIG_COMPAT_BRK option.
> >                                                     
> > Signed-off-by: Horst Schirmeier <horst@schirmeier.com>
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Ingo, will you take this through your tree?
> 
> > 
> > ---
> >  Documentation/sysctl/kernel.txt |   30 +++++++++++++++++-------------
> >  1 files changed, 17 insertions(+), 13 deletions(-)

This could go to your or Randy's docs tree, right? (would be fine by 
me)

	Ingo
