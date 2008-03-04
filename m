Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbYCDTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbYCDTzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbYCDTxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:53:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764846AbYCDTxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:53:12 -0500
Date: Tue, 4 Mar 2008 11:51:46 -0800
From: Greg KH <greg@kroah.com>
To: Dirk Eibach <eibach@gdsys.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-ID: <20080304195146.GA6237@kroah.com>
References: <20080303162827.GB11592@kroah.com> <47CCF42F.3090306@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CCF42F.3090306@gdsys.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 08:03:11AM +0100, Dirk Eibach wrote:
> greg@kroah.com wrote:
> > On Mon, Mar 03, 2008 at 10:07:41AM -0500, Alan Stern wrote:
> >> On Mon, 3 Mar 2008, Dirk Eibach wrote:
> >>
> >>> From: Dirk Eibach <eibach@gdsys.de>
> >>>
> >>> The usb configuration data for the Silabs CP2101 usb to uart bridge 
> >>> controller can be customized:
> >>> - Vendor ID
> >>> - Product ID
> >>> - Power Descriptor
> >>> - Release Number
> >>> - Serial Number
> >>> - Product Description String
> >>>
> >>> Silabs provides a windows-only tool to do that.
> >>> Since we use linux-only machines in our production-environment, we have no 
> >>> proper way to customize the chips for our purpose.
> >>> So I added sysfs configuration support to the linux driver.
> >> Surely this sort of thing is better done in userspace, with libusb.
> > 
> > I agree, any reason why you have not tried that?  Adding files like
> > "vendor_id" to an interface directory in sysfs could cause a lot of
> > people to get very confused, very quickly :)
> 
> Greg, any reason why you didn't suggest using libusb in your first mail ;) ?

My appologies, I totally forgot about it at the moment.  It's usually my
first question when confronted with a new driver, not a patch to an
existing one.

> I have not used libusb yet, but looking at the api it seems to be just
> what I need. I had heard about libusb before, but never really had a
> look at it. So thanks for your advice, Alan. I will implement this
> stuff in userspace.
> 
> On the other hand it would a little bit sad, if Silabs windows tool
> would stay the only way to setup for all other people. I cannot see
> how I could spread the userspace tool the way it would be spread if it
> was in the kernel.  Maybe someone has an idea on that.

Just get it added to all of the distros, that shouldn't be that hard, I
think almost all of them let you request a package to be added.

thanks,

greg k-h
