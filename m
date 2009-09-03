Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZICVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZICVqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZICVqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:46:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494AbZICVqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:46:45 -0400
Date: Thu, 3 Sep 2009 14:43:04 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, alan@linux.intel.com,
       stern@rowland.harvard.edu
Subject: Re: WARNINGs in usb-serial.c
Message-ID: <20090903214304.GA23020@suse.de>
References: <E1MjD4A-0002wi-KL@pomaz-ex.szeredi.hu>
 <20090903183637.GA5140@suse.de>
 <200909032324.01311.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909032324.01311.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 11:24:01PM +0200, Rafael J. Wysocki wrote:
> On Thursday 03 September 2009, Greg KH wrote:
> > On Thu, Sep 03, 2009 at 04:13:34PM +0200, Miklos Szeredi wrote:
> > > I get the following warnings in 2.6.31-rc.  A lot of them:
> > > 
> > > WARNING: at drivers/usb/serial/usb-serial.c:414 serial_write_room+0x59/0x6e [usbserial]()
> > > WARNING: at drivers/usb/serial/usb-serial.c:401 serial_write+0x77/0x9d [usbserial]()
> > > 
> > > This is a huawei-3565 modem.
> > > 
> > > The messages don't seem to hurt, but there's lot of trouble with this
> > > gadget.  Sometimes it just doesn't work after a while and a reboot is
> > > needed.  Sometimes it hangs the kernel after suspend, etc.  Not sure
> > > if this is related to the warnings...
> > 
> > {sigh}
> > 
> > The tty layer changes are being a pain here :(
> > 
> > Alan Stern posted a set of patches to the linux-usb list to hopefully
> > address stuff like this, is there any way you could test them out to see
> > if they help or not?
> 
> Do you have a pointer to the patches, please?  I need it for the regression list.

They were posted on the linux-usb mailing list, I'm still fighting my
patch queue to get them into my tree soon.

thanks,

greg k-h
