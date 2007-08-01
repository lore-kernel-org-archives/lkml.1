Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbXHAM07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbXHAM07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762158AbXHAM0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:26:51 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4193 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195AbXHAM0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:26:50 -0400
Date: Wed, 1 Aug 2007 14:27:03 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801113759.GA12523@elte.hu>
Message-ID: <Pine.LNX.4.64.0708011422000.1817@scrub.home>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801113759.GA12523@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> * Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > [...] the increase in code size:
> > 
> > 2.6.22:
> >    text    data     bss     dec     hex filename
> >   10150      24    3344   13518    34ce kernel/sched.o
> > 
> > recent git:
> >    text    data     bss     dec     hex filename
> >   14724     228    2020   16972    424c kernel/sched.o
> > 
> > That's i386 without stats/debug. [...]
> 
> that's without CONFIG_SMP, right? :-) On SMP they are about net break 
> even:
> 
>      text    data     bss     dec     hex filename
>     26535    4173      24   30732    780c kernel/sched.o-2.6.22
>     28378    2574      16   30968    78f8 kernel/sched.o-2.6.23-git

That's still quite an increase in some rather important code paths and 
it's not just the code size, but also code complexity which is important 
- a major point I tried to address in my review.

> (plus a further ~1.5K per CPU data reduction which is not visible here) 

That's why I mentioned the increased runtime memory usage...

bye, Roman
