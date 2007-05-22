Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXEVW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXEVW44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXEVW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:56:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbXEVW4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:56:47 -0400
Date: Tue, 22 May 2007 18:56:40 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the -stable cycle
Message-ID: <20070522225640.GG22628@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Chris Wright <chrisw@sous-sol.org>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com> <20070522195135.GG12157@redhat.com> <20070522221718.GC2302@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522221718.GC2302@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 03:17:18PM -0700, Greg Kroah-Hartman wrote:

 > >  > >  I haven't found a single distro that (a) makes it trivial to add PCI IDs at 
 > >  > >  install time, and then (b) ensures those PCI IDs remain persistent for each 
 > >  > >  boot.  We are not at all to the "just works" stage yet.
 > >  > 
 > >  > Well, SuSE handles this just fine, but I do notice that RHEL 5 disables
 > >  > the new_id stuff entirely, so I can see why you might get this
 > >  > impression :)
 > > 
 > > That's news to me.  I didn't even realise it was possible to disable this.
 > > Pointer?
 > 
 > Jon Masters told me this last week at FreedomHEC, so I don't have a
 > pointer to the patch that disables it, sorry.

Either there's some miscommunication, or bonghits.

(18:54:00:davej@gelk:kernel-2.6.18)$ kdiff vanilla/drivers/pci/pci-driver.c linux-2.6.18.noarch/drivers/pci/pci-driver.c 
(18:54:10:davej@gelk:kernel-2.6.18)$ 

And as there's no CONFIG option other than CONFIG_HOTPLUG (which we obviously enable)
I don't see any reason why this wouldn't be enabled in RHEL5.
(And I think mdomsch would have probably had a fit if he found out we were
 disabling it, but that's another story ;-)

 > > Theres more to this than just PCI IDs though.
 > > ac97 ID updates, usb id updates, etc, etc.
 > 
 > USB ids also can be added through sysfs :)

oh cool, I had missed that.

	Dave

-- 
http://www.codemonkey.org.uk
