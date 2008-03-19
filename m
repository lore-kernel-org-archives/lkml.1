Return-Path: <linux-kernel-owner+w=401wt.eu-S938738AbYCSVtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938738AbYCSVtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758907AbYCSUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:18:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57549 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbYCSUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:18:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH 3/3] PM: New suspend and hibernation callbacks for PCI bus type
Date: Wed, 19 Mar 2008 14:24:48 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
References: <200803170020.55473.rjw@sisk.pl> <200803170025.16149.rjw@sisk.pl> <20080319005508.GD8298@kroah.com>
In-Reply-To: <20080319005508.GD8298@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803191424.49443.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Greg KH wrote:
> On Mon, Mar 17, 2008 at 12:25:15AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Implement new suspend and hibernation callbacks for the PCI busi type.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-driver.c |  497 ++++++++++++++++++++++++++++++++++++++++++-----
> >  include/linux/pci.h      |    2 
> >  2 files changed, 453 insertions(+), 46 deletions(-)
> 
> Hm, that's a lot of code added.  What additional functionality did we
> just get?

The possibility to handle suspend/hibernation in a more flexible way, provided
that the drivers define the new callbacks.

> Are we going to have to create a noirq version for every driver and bus
> type now?

No, we aren't.  The PCI and platform bus types already have the noirq callbacks
implemented (they are called _late and _early, but that's the same
essentially).

Thanks,
Rafael
