Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZGCK0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZGCK0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZGCK03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:26:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:37433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbZGCK02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:26:28 -0400
Date: Fri, 3 Jul 2009 12:26:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Horst Schirmeier <horst@schirmeier.com>, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: missing value 2 for randomize-va-space
In-Reply-To: <20090703102431.GC32128@elte.hu>
Message-ID: <alpine.LNX.2.00.0907031225420.4994@wotan.suse.de>
References: <20090702152338.GU26384@quickstop.soohrt.org> <alpine.LNX.2.00.0907030109191.4994@wotan.suse.de> <20090703000523.GX26384@quickstop.soohrt.org> <alpine.LNX.2.00.0907031200560.4994@wotan.suse.de> <20090703102431.GC32128@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009, Ingo Molnar wrote:

> > > > >      There a few legacy applications out there (such as some ancient
> > > > 
> > > > ... would you please fix this typo/grammo as well? (There a few ...)
> > > > 
> > > > >      versions of libc.so.5 from 1996) that assume that brk area starts
> > > > 
> > > > Also, the text itself doesn't seem to be super-clear ... namely, it 
> > > > describes what CONFIG_COMPAT_BRK is about, but doesn't really clarify how 
> > > > exactly does this correlate with randomize_va_space == 2. Would you mind 
> > > > also fixing this bit?
> > > 
> > > I hope I didn't misread the sources :-)  Opinions?
> > > 
> > > ---
> > > 
> > > The documentation for /proc/sys/kernel/* does not mention the possible
> > > value 2 for randomize-va-space yet.  While being there, doing some
> > > reformatting, fixing grammar problems and clarifying the correlations
> > > between randomize-va-space, kernel parameter "norandmaps" and the
> > > CONFIG_COMPAT_BRK option.
> > >                                                     
> > > Signed-off-by: Horst Schirmeier <horst@schirmeier.com>
> > 
> > Acked-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > Ingo, will you take this through your tree?
> > 
> > > 
> > > ---
> > >  Documentation/sysctl/kernel.txt |   30 +++++++++++++++++-------------
> > >  1 files changed, 17 insertions(+), 13 deletions(-)
> 
> This could go to your or Randy's docs tree, right? (would be fine by 
> me)

Sure, I basically just wanted your ACK, as you were the last one touching 
the respective code.

I will queue it, thanks.

-- 
Jiri Kosina
SUSE Labs
