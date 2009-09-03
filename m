Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbZICVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbZICVW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbZICVW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:22:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39166 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbZICVW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:22:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: WARNINGs in usb-serial.c
Date: Thu, 3 Sep 2009 23:24:01 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, alan@linux.intel.com,
       stern@rowland.harvard.edu
References: <E1MjD4A-0002wi-KL@pomaz-ex.szeredi.hu> <20090903183637.GA5140@suse.de>
In-Reply-To: <20090903183637.GA5140@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909032324.01311.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Greg KH wrote:
> On Thu, Sep 03, 2009 at 04:13:34PM +0200, Miklos Szeredi wrote:
> > I get the following warnings in 2.6.31-rc.  A lot of them:
> > 
> > WARNING: at drivers/usb/serial/usb-serial.c:414 serial_write_room+0x59/0x6e [usbserial]()
> > WARNING: at drivers/usb/serial/usb-serial.c:401 serial_write+0x77/0x9d [usbserial]()
> > 
> > This is a huawei-3565 modem.
> > 
> > The messages don't seem to hurt, but there's lot of trouble with this
> > gadget.  Sometimes it just doesn't work after a while and a reboot is
> > needed.  Sometimes it hangs the kernel after suspend, etc.  Not sure
> > if this is related to the warnings...
> 
> {sigh}
> 
> The tty layer changes are being a pain here :(
> 
> Alan Stern posted a set of patches to the linux-usb list to hopefully
> address stuff like this, is there any way you could test them out to see
> if they help or not?

Do you have a pointer to the patches, please?  I need it for the regression list.

Rafael
