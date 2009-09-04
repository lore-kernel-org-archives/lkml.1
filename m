Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZIDORa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZIDORa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZIDOR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:17:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56626 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756812AbZIDOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:17:27 -0400
Date: Fri, 4 Sep 2009 10:17:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <alan@linux.intel.com>
Subject: Re: WARNINGs in usb-serial.c
In-Reply-To: <E1MjTrP-0004S3-6B@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0909041014490.3008-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009, Miklos Szeredi wrote:

> On Thu, 3 Sep 2009, Greg KH wrote:
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
> Nope, it doesn't seem to help.  Still got the same warnings with the
> patched kernel (latest git + ghk tree + usbserial patches).

What were you doing when these warnings appeared?

Do you want to try some debugging?  Add a line saying

#define DEBUG

near the beginning of the usb-serial.c source file, before all the 
#include lines.

Alan Stern

