Return-Path: <linux-kernel-owner+w=401wt.eu-S376218AbXECQeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376218AbXECQeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376223AbXECQeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:34:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37085 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S376218AbXECQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:34:43 -0400
Date: Thu, 3 May 2007 18:34:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Olaf Hering <olh@suse.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux1394-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       krh@redhat.com
Subject: Re: [git pull] New firewire stack
Message-ID: <20070503163442.GK3531@stusta.de>
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au> <46399BDE.4040605@s5r6.in-berlin.de> <20070503114854.GA12731@suse.de> <4639E3FC.8060107@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4639E3FC.8060107@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:30:36PM +0200, Stefan Richter wrote:
> Olaf Hering wrote:
> > On Thu, May 03, Stefan Richter wrote:
> > 
> >> 	ieee1394-old
> > 
> > Noone will seriously ship two firewire stacks, so that cant be the
> > issue (for distributors). 
> 
> I don't actively watch distributions, but I believe there are frequently
> alternative drivers shipped.  How much sense that makes for FireWire is
> another question.
> 
> > Once there is a way to easily switch between kernel releases, I'm ok
> > with whatever module names you pick. 
> 
> It may actually be easier to let problem reporters (who cannot or don't
> want to compile kernels) compare between different kernel releases,
> rather than to ask them to compare between different stacks on top of
> the same kernel.  Still, it potentially reduces the testers base.
> 
> Adrian wrote:
> | An advantage of changing the names is that they are now prefixed.
> 
> Is the opportunity to clean up module names compelling enough, vs. (the
> wish for) minimized trouble with scripts which refer to module names?
>...

How big is the trouble actually?

We have never and cannot guarantee stable module names (think of e.g. 
PATA, e100 or sky2/skge), so changed names are always possible when 
upgrading kernels.

Module aliases can solve many issues.

And sometimes it might even be an advantage that different drivers for 
the same hardware get different names (consider especially PATA).

Not changing the module names also has the problem that the old code 
must be removed from the kernel tree before the new one can be added
since two different modules with the same names could easily cause 
trouble - consider a user first compiling and installing the one 
modular, and then compiling and installing the other one modular (e.g. 
due to problems with the one he tried first). Which module will now be 
loaded by modprobe?

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

