Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023Ab0ATUzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0ATUzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0ATUzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:55:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab0ATUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:55:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device run-time PM
Date: Wed, 20 Jan 2010 21:55:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <201001180129.55219.rjw@sisk.pl> <20100120025147.GA20979@kroah.com>
In-Reply-To: <20100120025147.GA20979@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001202155.37062.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010, Greg KH wrote:
> On Mon, Jan 18, 2010 at 01:29:55AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM / Runtime: Add sysfs switch for disabling device run-time PM
> > 
> > Add new device sysfs attribute, power/runtime, allowing the user
> > space to block the run-time power management of the device.  If this
> > attribute is set to "disabled", the driver of the device won't be
> > able to enable run-time power management for it (without breaking the
> > rules).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/power.h   |    4 +
> >  drivers/base/power/runtime.c |  107 +++++++++++++++++++++++++++++++++----------
> >  drivers/base/power/sysfs.c   |   46 ++++++++++++++++++
> >  include/linux/pm.h           |    1 
> >  include/linux/pm_runtime.h   |   11 +---
> >  5 files changed, 139 insertions(+), 30 deletions(-)
> 
> You forgot to also add an entry into Documentation/ABI/ for when you
> add/change a sysfs file :)

There's no description for /sys/devices/.../power/wakeup in there too and
that one has been present for quite some time already.

I'd prefer adding them both in a separate patch if you don't mind.

Rafael
