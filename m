Return-Path: <linux-kernel-owner+w=401wt.eu-S935217AbXEVTkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217AbXEVTkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934804AbXEVTjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:39:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44914 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934786AbXEVTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:39:48 -0400
Date: Tue, 22 May 2007 12:35:38 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522193538.GA885@kroah.com>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46533EA8.7020602@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 03:04:08PM -0400, Jeff Garzik wrote:
>  Greg KH wrote:
> > What's wrong with the current sysfs way of adding new device ids without
> > touching the kernel?  Devices described above was the very reason we
> > added that functionality, so users would not have to constantly update
> > their kernel.  The distros provide userspace tools that enable these ids
> > to be added and at boot time, everything "just works" properly.
> 
>  I haven't found a single distro that (a) makes it trivial to add PCI IDs at 
>  install time, and then (b) ensures those PCI IDs remain persistent for each 
>  boot.  We are not at all to the "just works" stage yet.

Well, SuSE handles this just fine, but I do notice that RHEL 5 disables
the new_id stuff entirely, so I can see why you might get this
impression :)

> > So, because of that, I don't really see a need to be adding new device
> > ids to the -stable tree.
> 
>  Maybe you are just not seeing all the developers that keep bringing this 
>  up??

This is the second time it has occurred that I know of.

>  Really, it is just silly to think that one-line PCI IDs patches will cause 
>  any harm at all, and it should be self-evident that there is clear potential 
>  to HELP Linux users.  That's why we're all here, right?

I'm not disagreeing that it will help a set of users, or that it will
cause any harm at all.  It's just currently outside the scope for what
we defined -stable as, and it will slightly increase the workload that
Chris and I have in keeping up with these patches.

So, if there is an overwhelming majority of people that strongly feel
that this is a good thing, fine, we can try it out.

I'm just trying to point out that the new_id sysfs stuff is there
explicitly for this very reason, as people were demanding that (Dell
being the major company behind it.)

thanks,

greg k-h
