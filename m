Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXD2B1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXD2B1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXD2B1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:27:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXD2B1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:27:52 -0400
Date: Sat, 28 Apr 2007 18:23:38 -0700
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hans-J?rgen Koch <hjk@linutronix.de>,
       Bill Davidsen <davidsen@tmr.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070429012338.GA11147@suse.de>
References: <20070427224957.GA17967@kroah.com> <4633A6D7.3030806@tmr.com> <200704282203.31141.hjk@linutronix.de> <20070428211515.4e9fd8c5@the-village.bc.nu> <1177792297.7646.297.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177792297.7646.297.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 10:31:37PM +0200, Thomas Gleixner wrote:
> On Sat, 2007-04-28 at 21:15 +0100, Alan Cox wrote:
> > > > I have a political question, if I have a user space driver, is my kernel 
> > > > tainted or not? 
> > > 
> > > Surely not. By using the kernel's userspace interface, you create no
> > > "derived work" of the kernel. See COPYING in the root directory of the 
> > > kernel sources for details.
> > 
> > That only covers normal system calls - but I don't think thats what is
> > relevant, taints are for debug assistance not politics.
> > 
> > I think we should have a taint flag for UIO type drivers. Not for any
> > licensing or political reason but for the simple fact it means that there
> > may be other complexities to debugging - and not the same one as a binary
> > module. Probably we want the same marker for mmap /dev/mem too.
> 
> I agree, if we make it entirely clear that the flag is nonpolitical. 

Hm, I don't know, what makes this different from the fact that we can
mmap PCI device space today through the proc and sysfs entries?  That's
how X gets direct access to the hardware for a number of different
cards, and that's pretty much the same thing as the UIO interface is
doing.

Unless you think we should also use the same "taint" flag on those
accesses too, and if so, I have no objection.

thanks,

greg k-h
