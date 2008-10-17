Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYJQXPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYJQXPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbYJQXNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:13:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbYJQXNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:13:16 -0400
Date: Fri, 17 Oct 2008 16:09:44 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081017230944.GA15344@suse.de>
References: <20081017220027.GA3659@kroah.com> <alpine.LFD.2.00.0810171544320.3438@nehalem.linux-foundation.org> <20081017230011.GA14185@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081017230011.GA14185@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 04:00:11PM -0700, Greg KH wrote:
> On Fri, Oct 17, 2008 at 03:47:58PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 17 Oct 2008, Greg KH wrote:
> > >
> > > Here is the big batch of USB patches for your 2.6-git tree.
> > 
> > I really wish I were to get the occasional _clean_ pull for a change.
> > 
> > f*ck me, but why do people keep adding more and more warnings, and 
> > apparently not even bother to write clean code? The merge window is no 
> > excuse for badly written crap.
> > 
> >   drivers/usb/host/ehci-hcd.c: In function ‘ehci_hcd_init’:
> >   drivers/usb/host/ehci-hcd.c:1115: warning: label ‘err_debug’ defined but not used
> 
> Why am I not seeing that warning here?
> 
> ah, because I have debugging for USB enabled in my configuration, sorry
> about that, I should have caught that.  That's the problem with doing a
> 'make allyesconfig' as a test build, I need to make it random at times
> to catch things like this.

In looking at that file closer, I can just remove all of the #ifdef
DEBUG options there, as there is no problem with them being always
built.  The rest of the #ifdef mess in there is due to platform/hardware
configurations trying to share a common EHCI core.

thanks,

greg k-h
