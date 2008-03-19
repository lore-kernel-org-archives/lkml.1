Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYCSX1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYCSX1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbYCSWBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:01:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761172AbYCSWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:01:15 -0400
Date: Wed, 19 Mar 2008 11:06:35 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 3/3] PM: New suspend and hibernation callbacks for
	PCI bus type
Message-ID: <20080319180635.GA5296@kroah.com>
References: <200803170020.55473.rjw@sisk.pl> <200803170025.16149.rjw@sisk.pl> <20080319005508.GD8298@kroah.com> <200803191424.49443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803191424.49443.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 02:24:48PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 19 of March 2008, Greg KH wrote:
> > On Mon, Mar 17, 2008 at 12:25:15AM +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Implement new suspend and hibernation callbacks for the PCI busi type.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  drivers/pci/pci-driver.c |  497 ++++++++++++++++++++++++++++++++++++++++++-----
> > >  include/linux/pci.h      |    2 
> > >  2 files changed, 453 insertions(+), 46 deletions(-)
> > 
> > Hm, that's a lot of code added.  What additional functionality did we
> > just get?
> 
> The possibility to handle suspend/hibernation in a more flexible way, provided
> that the drivers define the new callbacks.

So, we're going to have to now convert all drivers, right?  Nice, I can
always use a bump up in the "number of patches submited" numbers :)

thanks,

greg k-h
