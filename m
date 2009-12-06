Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbZLFRHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbZLFRHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbZLFRHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:07:24 -0500
Received: from mail001.aei.ca ([206.123.6.130]:49815 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917AbZLFRHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:07:23 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] 2.6.32 - Sddr-09 SM reader resets endlessly
Date: Sun, 6 Dec 2009 12:07:19 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-crc; KDE/4.3.4; x86_64; ; )
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912052347400.22968-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912052347400.22968-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912061207.19519.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 December 2009 23:51:37 Alan Stern wrote:
> On Sat, 5 Dec 2009, Ed Tomlinson wrote:
> 
> > On Saturday 05 December 2009 16:34:26 Alan Stern wrote:
> > > On Sat, 5 Dec 2009, Andries E. Brouwer wrote:
> > > 
> > > > > Andries, do you have any idea what's going on?  Evidently this device 
> > > > > doesn't accept the protocol used by the sddr09 driver.
> > > > 
> > > > Hi Alan,
> > > > 
> > > > Sorry, no - I have no memory and worked on these USB drivers
> > > > years ago. Forgot all details. Also my last sddr09 device broke
> > > > some time ago.
> > > > 
> > > > Looking at my old files I do not see the Vendor Id 0781, so maybe
> > > > this is a device I never encountered.
> > > > These old files also discuss some trickery with multi-lun devices
> > > > where the driver needed depends on the lun. This is not a reader
> > > > of multiple types of card?
> > > > 
> > > > Many of my SM readers worked with either sddr09 or sddr55.
> > > > Does the unusual devices section today say that such a device
> > > > needs sddr09?
> > > > 
> > > > Found a 2.6.31 source tree. Yes,
> > > > 
> > > > UNUSUAL_DEV(  0x0781, 0x0200, 0x0000, 0x9999,
> > > >                 "Sandisk",
> > > >                 "ImageMate SDDR-09",
> > > >                 US_SC_SCSI, US_PR_EUSB_SDDR09, usb_stor_sddr09_init,
> > > >                 0),
> > > > 
> > > > Is it known who added this? Is 0208 in the interval of known devices
> > > > for which sddr09 works?
> > > 
> > > The entry was added before 2.5.0 (more than 7 years ago), and I can't 
> > > tell who added it.  And the entry doesn't say anything about DPCM 
> > > (multiple-LUN trickery).
> > > 
> > > Ed, it looks like you're out of luck.  Unless you can figure out the 
> > > vendor-specific protocol used by that device, and modify the sddr09 
> > > driver to support it, you won't be able to use the device under Linux.
> > > 
> > > Or am I completely off base?  Did it used to work with an earlier
> > > kernel?  If it did, can you get a usbmon trace of it?
> > 
> > This is a regression.  The device works fine in 2.6.31 something
> > in .32 breaks it.
> 
> Okay, that's new information.  Can you post a usbmon trace from 2.6.31?

Alan/Andries,

I rebooted as far back as .29.  I still get the resets.  Looks like the HW is at fault with
the faults starting when I booted .32 (guess Murphy wanted some fun).  In any case, 
looks like there is not much more than can be (or needs to be) done here.

Thanks & sorry for the noise,
Ed
