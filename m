Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbXGMTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbXGMTxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbXGMTxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:53:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35489 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXGMTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:53:07 -0400
Date: Fri, 13 Jul 2007 12:52:21 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: Linux 2.6.22.1
Message-ID: <20070713195221.GC20092@kroah.com>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <1184307380.8943.7.camel@roc-desktop> <20070713061617.GA24317@kroah.com> <20070713064751.GA3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713064751.GA3492@stusta.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 08:47:51AM +0200, Adrian Bunk wrote:
> On Thu, Jul 12, 2007 at 11:16:17PM -0700, Greg KH wrote:
> > On Fri, Jul 13, 2007 at 02:16:20PM +0800, Bryan Wu wrote:
> > > On Fri, 2007-07-13 at 02:35 +0800, Nish Aravamudan wrote:
> > > > On 7/10/07, Greg KH <greg@kroah.com> wrote: 
> > > > > We (the -stable team) are announcing the release of the 2.6.22.1
> > > > kernel. 
> > > > > It contains a security fix for SCTP that somehow forgot to be added
> > > > to 
> > > > > the 2.6.22 kernel (was already released in the 2.6.21.y releases). 
> > > > > Thanks to Patrick McHardy for noticing the mistake. 
> > > > > 
> > > > > I'll also be replying to this message with a copy of the patch
> > > > between 
> > > > > 2.6.22 and 2.6.22.1 
> > > > > 
> > > > > The updated 2.6.22.y git tree can be found at: 
> > > > >
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> > > > 
> > > > Can you please also update
> > > > 
> > > >  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> > > > 
> > > > ? Maybe make that update part of whatever process you use to push out 
> > > > the 2.6.Y trees, as I've had to ask for this more than once now?
> > > > 
> > > 
> > > Could you please open http:// git-pull? I was blocked by company's
> > > firewall except http method -:((.
> > 
> > That is up to the kernel.org admins, but last time I checked, I think it
> > was enabled already.  Can you pull anything else from kernel.org with
> > http but not this tree?
> 
> I found the problem and (ab)used my kstable group rights to fix it:
> 
> objects/info/alternates of linux-2.6.22.y.git contained
>   /home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/objects
> instead of
>   /pub/scm/linux/kernel/git/torvalds/linux-2.6.git/objects
> 
> This seems to exist on git.kernel.org but not on www.kernel.org, 
> explaining why the http method didn't work.

Odd, thanks for fixing that, it was "interesting" to create that tree
and it took me a few tries as I forgot to clone it right when Linus
released so I had to reset the HEAD back to the v2.6.22 release
changeset.

thanks,

greg k-h
