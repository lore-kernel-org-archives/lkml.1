Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbXJBLFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbXJBLFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXJBLFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:05:44 -0400
Received: from www.tglx.de ([62.245.132.106]:44341 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbXJBLFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:05:43 -0400
Date: Tue, 2 Oct 2007 13:05:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <200710021248.06050.ak@suse.de>
Message-ID: <alpine.LRH.0.999.0710021250510.23586@www.tglx.de>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org
 > <200710021121.36443.ak@suse.de> <47021F83.4070609@garzik.org>
 <200710021248.06050.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Andi Kleen wrote:
> On Tuesday 02 October 2007 12:37:55 Jeff Garzik wrote:
> > Andi Kleen wrote:
> > > On Tuesday 02 October 2007 11:17:02 Thomas Gleixner wrote:
> > >>> This is also a good time to warn about the fact that we're doing the x86 
> > >>> merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
> > >>> have pending patches for the next series that touch arch/i386 or x86-64, 
> > >>> you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
> > >>> keepers of the merge scripts, and will help you prepare..
> > > 
> > > 
> > > Yes I have ~100 patches for arch/x86_64, arch/i386
> > > 
> > > Should I just drop them?
> > 
> > Why don't you work with Thomas and Ingo to make sure everything is in 
> > sync and prepped for 2.6.24?
> 
> The easiest way to do that would be to first merge all the queued and
> collected patches from the last months. Once they are in people
> can then create whatever mess they like.
> 
> The other way round  (adapting 100+ patches to a possibly completely
> different tree) will be a huge amount of work which I am
> frankly not very motivated to do because I think it's quite unnecessary. 
> 
> I would probably just push the work back to all the patch submitters -- that is 
> what I meant with dropping the patches.

I picked up your queue at

	ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/current.tar.gz

and converted it with the fixup script to:

	http://www.tglx.de/~tglx/patches-ak.tar.bz2

Hope that helps,

	tglx
