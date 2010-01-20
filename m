Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297Ab0ATW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0ATW4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457Ab0ATW4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:56:31 -0500
Received: from kroah.org ([198.145.64.141]:60838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab0ATW42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:56:28 -0500
Date: Wed, 20 Jan 2010 14:50:27 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM / Runtime: Add sysfs switch for disabling
 device run-time PM
Message-ID: <20100120225027.GB31280@kroah.com>
References: <201001180129.55219.rjw@sisk.pl>
 <20100120025147.GA20979@kroah.com>
 <201001202155.37062.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001202155.37062.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 09:55:36PM +0100, Rafael J. Wysocki wrote:
> On Wednesday 20 January 2010, Greg KH wrote:
> > On Mon, Jan 18, 2010 at 01:29:55AM +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > Subject: PM / Runtime: Add sysfs switch for disabling device run-time PM
> > > 
> > > Add new device sysfs attribute, power/runtime, allowing the user
> > > space to block the run-time power management of the device.  If this
> > > attribute is set to "disabled", the driver of the device won't be
> > > able to enable run-time power management for it (without breaking the
> > > rules).
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  drivers/base/power/power.h   |    4 +
> > >  drivers/base/power/runtime.c |  107 +++++++++++++++++++++++++++++++++----------
> > >  drivers/base/power/sysfs.c   |   46 ++++++++++++++++++
> > >  include/linux/pm.h           |    1 
> > >  include/linux/pm_runtime.h   |   11 +---
> > >  5 files changed, 139 insertions(+), 30 deletions(-)
> > 
> > You forgot to also add an entry into Documentation/ABI/ for when you
> > add/change a sysfs file :)
> 
> There's no description for /sys/devices/.../power/wakeup in there too and
> that one has been present for quite some time already.
> 
> I'd prefer adding them both in a separate patch if you don't mind.

That's fine with me, as long as you add them :)

thanks,

greg k-h
