Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbYHEU2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbYHEU2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYHEU2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:28:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:44012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYHEU2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:28:34 -0400
Date: Tue, 5 Aug 2008 13:26:21 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080805202621.GA27489@kroah.com>
References: <20080805112747.2c3c4650@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com> <20080805183845.GA11375@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 04:15:32PM -0400, Press, Jonathan wrote:
> On Tue, Aug 05, 2008 at 02:34:26PM -0400, Press, Jonathan wrote:
> > You're right...I am not talking about blocking at all -- which may be
> a
> > further indication that I am missing the specific point of this
> thread.
> > 
> > But be that as it may...  I don't want to have to use more than one
> > interface to get all the events I am interested in.  I want to
> register
> > as a client and listen, and get everything I need from the same place.
> 
> That's an implementation issue, not a requirement.  If it's a
> requirement, it sure is a lazy one :)
> 
> 
> [JON PRESS]  I wouldn't call it lazy, actually.  It's more like
> "economical" or "ergonomic" -- or, dare I say it -- "user-friendly."  In
> this case, the users are the AV vendors who will have to write to the
> API that will come out of this spec.  We will be more inclined to
> appreciate the SDK (for want of a better term) if it covers all the
> bases, rather than force us to go elsewhere for some of our
> requirements.  When we write SDKs, we try to make sure that our users
> will find whatever they need.

But realize that you are adding an overhead on us, the kernel community,
to make your life easier.  We are the ones that are taking our time to
review and comment on this code.  We are the ones who will have to live
with this code for forever, and maintain it over the lifetime of linux.
So far, you all have shown no willingness to give anything back to us at
all.

In fact, I'd go so far as to say you have been openly hostile, violating
our copyright and license by shipping closed source kernel modules,
making our users have huge problems when we can not support them if they
happen to have the misfortune of using your product, and creating code
that pokes directly into the kernel in ways we explicily do not want to
have happen (syscall hooking, walking symbol tables, etc.)

So please remember, that you should be the ones going out of your way to
be nice to us, as you are coming from a huge deficit here that you all
need to make up from.

> > Also, it seems to me that for my purposes, close is discrete enough.
> It
> > tells me that there is now something out there that should be looked
> at.
> 
> So, if you hook glibc to catch all calls to close, is that sufficient?
> 
> [JON PRESS]  Let's see...I'm going to use inotify for some events, glibc
> for others, and this API for the rest.  Would you really want to write
> an application like that?

Think of it as a way to justify your huge prices :)

thanks,

greg k-h
