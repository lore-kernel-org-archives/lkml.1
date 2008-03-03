Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYCCQaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYCCQaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYCCQaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:30:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41604 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYCCQaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:30:09 -0500
Date: Mon, 3 Mar 2008 08:28:28 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dirk Eibach <eibach@gdsys.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-ID: <20080303162827.GB11592@kroah.com>
References: <47CBC465.9070909@gdsys.de> <Pine.LNX.4.44L0.0803031006510.3456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803031006510.3456-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:07:41AM -0500, Alan Stern wrote:
> On Mon, 3 Mar 2008, Dirk Eibach wrote:
> 
> > From: Dirk Eibach <eibach@gdsys.de>
> > 
> > The usb configuration data for the Silabs CP2101 usb to uart bridge 
> > controller can be customized:
> > - Vendor ID
> > - Product ID
> > - Power Descriptor
> > - Release Number
> > - Serial Number
> > - Product Description String
> > 
> > Silabs provides a windows-only tool to do that.
> > Since we use linux-only machines in our production-environment, we have no 
> > proper way to customize the chips for our purpose.
> > So I added sysfs configuration support to the linux driver.
> 
> Surely this sort of thing is better done in userspace, with libusb.

I agree, any reason why you have not tried that?  Adding files like
"vendor_id" to an interface directory in sysfs could cause a lot of
people to get very confused, very quickly :)

thanks,

greg k-h
