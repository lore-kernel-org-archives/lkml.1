Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYENXzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYENXzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYENXzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:55:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52512 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239AbYENXzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:55:35 -0400
Date: Wed, 14 May 2008 16:49:09 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080514234909.GA20084@kroah.com>
References: <20080514221519.GA6575@kroah.com> <20080514232722.GA12314@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514232722.GA12314@srcf.ucam.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:27:22AM +0100, Matthew Garrett wrote:
> On Wed, May 14, 2008 at 03:15:19PM -0700, Greg KH wrote:
> 
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL, HID_QUIRK_IGNORE },
> >  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
> 
> Hm. How is the IRCONTROL4 handled? Is the protocol completely different?

I know nothing about that device, sorry.  I think it is a totally
different protocol from what I can tell looking at the code.

> > +	  Say Y here if you want to use a Apple USB remote control.  This
> > +	  device is traditionally inside an Intel Apple Mac Mini, but might
> > +	  show up in other places.
> 
> Minor nit, but it's supported on all the desktop Intel Macs and not just 
> the Mini.

Ah, didn't realize that, nice to know, we should have a wider userbase
then :)

thanks,

greg k-h
