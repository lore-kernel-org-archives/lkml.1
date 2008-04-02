Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbYDBSyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbYDBSyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbYDBSy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:54:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52720 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028AbYDBSy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:54:27 -0400
Date: Wed, 2 Apr 2008 21:54:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
Message-ID: <20080402185416.GG10816@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org> <18418.44094.156352.405647@cargo.ozlabs.ibm.com> <alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 07:50:28AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 2 Apr 2008, Paul Mackerras wrote:
> > Linus Torvalds writes:
> > 
> > > I think the dirstat continues to be fairly informative, with arch/ and 
> > > drivers dominating as usual. And within arch, a fair amount of the line 
> > > noise are all those defconfigs. I wish we had some saner way of handling 
> > > that
> > 
> > We (the arch maintainers) could try to do the bulk of the defconfig
> > updates at about -rc2 or -rc3 time, if you'd prefer.
> 
> Well, that part isn't the one that I think is bothersome - I just wonder 
> if the whole "defconfig" mess is worth keeping with the kernel at _all_.
>...

I have a trivial script that does "build all defconfigs", and it has 
resulted in me reporting and fixing dozens of bugs in 2.6.25
(and some regressions in gcc 4.3).

And I use it for verifying that patches don't break the compilation.

Different to randconfig builds the defconfigs allow me to cover most 
reasonable configurations with a script that takes only one day to run.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

