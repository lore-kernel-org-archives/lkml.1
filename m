Return-Path: <linux-kernel-owner+w=401wt.eu-S935864AbXEVWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864AbXEVWUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761808AbXEVWUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:20:21 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49005 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbXEVWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:20:19 -0400
Date: Tue, 22 May 2007 15:17:18 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522221718.GC2302@kroah.com>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com> <20070522195135.GG12157@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522195135.GG12157@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 03:51:35PM -0400, Dave Jones wrote:
> On Tue, May 22, 2007 at 12:35:38PM -0700, Greg Kroah-Hartman wrote:
>  > On Tue, May 22, 2007 at 03:04:08PM -0400, Jeff Garzik wrote:
>  > >  Greg KH wrote:
>  > > > What's wrong with the current sysfs way of adding new device ids without
>  > > > touching the kernel?  Devices described above was the very reason we
>  > > > added that functionality, so users would not have to constantly update
>  > > > their kernel.  The distros provide userspace tools that enable these ids
>  > > > to be added and at boot time, everything "just works" properly.
>  > > 
>  > >  I haven't found a single distro that (a) makes it trivial to add PCI IDs at 
>  > >  install time, and then (b) ensures those PCI IDs remain persistent for each 
>  > >  boot.  We are not at all to the "just works" stage yet.
>  > 
>  > Well, SuSE handles this just fine, but I do notice that RHEL 5 disables
>  > the new_id stuff entirely, so I can see why you might get this
>  > impression :)
> 
> That's news to me.  I didn't even realise it was possible to disable this.
> Pointer?

Jon Masters told me this last week at FreedomHEC, so I don't have a
pointer to the patch that disables it, sorry.

>  > I'm just trying to point out that the new_id sysfs stuff is there
>  > explicitly for this very reason, as people were demanding that (Dell
>  > being the major company behind it.)
> 
> Theres more to this than just PCI IDs though.
> ac97 ID updates, usb id updates, etc, etc.

USB ids also can be added through sysfs :)

> We have many different forms of what are fundamentally, the same thing.

That's why we tried to have the same userspace interface in sysfs for
them all.  We have PCI, USB, and USB-Serial already covered this way, if
people want more, we can add them too, it's not that hard.

thanks,

greg k-h
