Return-Path: <linux-kernel-owner+w=401wt.eu-S1031166AbXEALD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031166AbXEALD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031663AbXEALD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:03:58 -0400
Received: from 1wt.eu ([62.212.114.60]:2461 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031166AbXEALDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:03:51 -0400
Date: Tue, 1 May 2007 13:00:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-ID: <20070501110023.GY943@1wt.eu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org> <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain> <Pine.LNX.4.61.0705011202510.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705011202510.18504@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:12:36PM +0200, Jan Engelhardt wrote:
> 
> On May 1 2007 05:16, Robert P. J. Day wrote:
> >
> >on the other hand, the features removal file contains the following:
> >
> >...
> >What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
> >When:   November 2005
> >...
> >
> >in other words, the PCMCIA ioctl feature *has* been listed as obsolete
> >for quite some time, and is already a *year and a half* overdue for
> >removal.
> >
> >in short, it's annoying to take the position that stuff can't be
> >deleted without warning, then turn around and be reluctant to remove
> >stuff for which *more than ample warning* has already been given.
> >doing that just makes a joke of the features removal file, and makes
> >you wonder what its purpose is in the first place.
> >
> >a little consistency would be nice here, don't you think?
> 
> I think this could raise their attention...
> 
> init/Makefile
> obj-y += obsolete.o
> 
> init/obsolete.c:
> static __init int obsolete_init(void)
> {
> 	printk("\e[1;31m""
> 
> The following stuff is gonna get removed \e[5;37m SOON: \e[0m
> 	- cardmgr
> 	- foobar
> 	- bweebol
> 
> ");
> 	schedule_timeout(3 * HZ);
> 	return;
> }
> 
> static __exit void obsolete_exit(void) {}

There's something I like here : the fact that all features are centralized
and not hidden in the noise. Clearly we need some standard inside the kernel
to manage obsolete code as well as we currently do by hand.

Willy

