Return-Path: <linux-kernel-owner+w=401wt.eu-S935342AbXGMGrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342AbXGMGrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933813AbXGMGrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:47:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59791 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933651AbXGMGrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:47:17 -0400
Date: Fri, 13 Jul 2007 08:47:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: Linux 2.6.22.1
Message-ID: <20070713064751.GA3492@stusta.de>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <1184307380.8943.7.camel@roc-desktop> <20070713061617.GA24317@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070713061617.GA24317@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:16:17PM -0700, Greg KH wrote:
> On Fri, Jul 13, 2007 at 02:16:20PM +0800, Bryan Wu wrote:
> > On Fri, 2007-07-13 at 02:35 +0800, Nish Aravamudan wrote:
> > > On 7/10/07, Greg KH <greg@kroah.com> wrote: 
> > > > We (the -stable team) are announcing the release of the 2.6.22.1
> > > kernel. 
> > > > It contains a security fix for SCTP that somehow forgot to be added
> > > to 
> > > > the 2.6.22 kernel (was already released in the 2.6.21.y releases). 
> > > > Thanks to Patrick McHardy for noticing the mistake. 
> > > > 
> > > > I'll also be replying to this message with a copy of the patch
> > > between 
> > > > 2.6.22 and 2.6.22.1 
> > > > 
> > > > The updated 2.6.22.y git tree can be found at: 
> > > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> > > 
> > > Can you please also update
> > > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> > > 
> > > ? Maybe make that update part of whatever process you use to push out 
> > > the 2.6.Y trees, as I've had to ask for this more than once now?
> > > 
> > 
> > Could you please open http:// git-pull? I was blocked by company's
> > firewall except http method -:((.
> 
> That is up to the kernel.org admins, but last time I checked, I think it
> was enabled already.  Can you pull anything else from kernel.org with
> http but not this tree?

I found the problem and (ab)used my kstable group rights to fix it:

objects/info/alternates of linux-2.6.22.y.git contained
  /home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/objects
instead of
  /pub/scm/linux/kernel/git/torvalds/linux-2.6.git/objects

This seems to exist on git.kernel.org but not on www.kernel.org, 
explaining why the http method didn't work.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

