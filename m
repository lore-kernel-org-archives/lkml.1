Return-Path: <linux-kernel-owner+w=401wt.eu-S935147AbXEVTvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147AbXEVTvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759998AbXEVTvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:51:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbXEVTvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:51:45 -0400
Date: Tue, 22 May 2007 15:51:35 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the -stable cycle
Message-ID: <20070522195135.GG12157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Chris Wright <chrisw@sous-sol.org>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522193538.GA885@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 12:35:38PM -0700, Greg Kroah-Hartman wrote:
 > On Tue, May 22, 2007 at 03:04:08PM -0400, Jeff Garzik wrote:
 > >  Greg KH wrote:
 > > > What's wrong with the current sysfs way of adding new device ids without
 > > > touching the kernel?  Devices described above was the very reason we
 > > > added that functionality, so users would not have to constantly update
 > > > their kernel.  The distros provide userspace tools that enable these ids
 > > > to be added and at boot time, everything "just works" properly.
 > > 
 > >  I haven't found a single distro that (a) makes it trivial to add PCI IDs at 
 > >  install time, and then (b) ensures those PCI IDs remain persistent for each 
 > >  boot.  We are not at all to the "just works" stage yet.
 > 
 > Well, SuSE handles this just fine, but I do notice that RHEL 5 disables
 > the new_id stuff entirely, so I can see why you might get this
 > impression :)

That's news to me.  I didn't even realise it was possible to disable this.
Pointer?

 > I'm just trying to point out that the new_id sysfs stuff is there
 > explicitly for this very reason, as people were demanding that (Dell
 > being the major company behind it.)

Theres more to this than just PCI IDs though.
ac97 ID updates, usb id updates, etc, etc.
We have many different forms of what are fundamentally, the same thing.

	Dave

-- 
http://www.codemonkey.org.uk
