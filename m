Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYE2Vv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYE2Vv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbYE2Vuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:50:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:52349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbYE2Vuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:50:51 -0400
Date: Thu, 29 May 2008 14:47:06 -0700
From: Greg KH <gregkh@suse.de>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Message-ID: <20080529214706.GA3277@suse.de>
References: <20080529212110.GA2870@suse.de> <200805292327.45561.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805292327.45561.laurent.pinchart@skynet.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:27:45PM +0200, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Thursday 29 May 2008, Greg KH wrote:
> > Matthew Garrett (1):
> >       USB: Firmware loader driver for USB Apple iSight camera
> 
> Sorry not to have spotted this sooner, but I don't like this one. Why do we 
> need a specific kernel driver when a userspace tool (fxload) exists to 
> perform the same task, especially when the tool handles udev integration 
> nicely ? The Apple iSight uses an EZ-USB chipset. If we really want a kernel 
> driver for that it should probably be made more generic to handle all 
> EZ-USB-based devices.

Well, perhaps because no one did this kind of integration before?  :)

I'll take this driver out later, if the infrastructure is put into
place, and some kind of driver package is created for the distros to use
to implement this.

But until then, the easiest way to get this hardware working for users
is a tiny kernel firmware loader just like this one.  If you think we
should turn it into something for all ezusb devices, that's also a
possiblity.

thanks,

greg k-h
