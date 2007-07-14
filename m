Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbXGNBJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbXGNBJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761097AbXGNBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:09:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60664 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759396AbXGNBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:09:17 -0400
Date: Sat, 14 Jul 2007 03:08:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
Message-ID: <20070714010850.GA3565@stusta.de>
References: <46955BB1.20200@windriver.com> <20070711224327.9B0ED4D0555@magilla.localdomain> <20070711160335.8705f742.akpm@linux-foundation.org> <alpine.LFD.0.999.0707111640030.20061@woody.linux-foundation.org> <20070711165308.551f0c6c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070711165308.551f0c6c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 04:53:08PM -0700, Andrew Morton wrote:
> On Wed, 11 Jul 2007 16:40:29 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Wed, 11 Jul 2007, Andrew Morton wrote:
> > >
> > > OK, thanks.  So I ended up with the below as a probably-2.6.23 thing:
> > > ...
> > > +AFLAGS		+= $(call as-option, -gdwarf)
> > 
> > "-gdwarf2?"
> > 
> 
> yep, that's what the kgdb tree was using - I'll fix it up.

Since even gcc 3.2 already supports -gdwarf-2, you can drop
the as-option check.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

