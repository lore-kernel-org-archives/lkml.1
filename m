Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYCMO7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYCMO7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYCMO73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:59:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57835 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752371AbYCMO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:59:28 -0400
Date: Thu, 13 Mar 2008 10:59:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <20080312224411.GB2290@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0803131049510.4474-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Tino Keitel wrote:

> On Wed, Mar 12, 2008 at 17:44:56 -0400, Alan Stern wrote:
> 
> [...]
> 
> > Tino, it would help to see a kernel log showing what happened during 
> > the suspend, resume, and failure of hidmon.  It would help even more if 
> > you test under a kernel with CONFIG_USB_DEBUG enabled.
> 
> A full kernel log is available at http://tikei.de/dmesg
> 
> > 
> > Even if you can't reproduce the problem, do you have the complete 
> > kernel log from before?
> > 
> > Is it possible that this is really a problem with the LCD device, not 
> > with the kernel?  I ask because if the device was working properly then 
> > unplugging and replugging the USB cable should do a complete reset.
> 
> I did the following:
> 
> - suspended the computer
> 
> - switched off the LCD

And switched it back on at some point?

> - resumed the computer
> 
> - tried to use hidmon, got the error
> 
> - unplugged the LCD
> 
> - plugged in the LCD
> 
> - tried to use hidmon again, got the error again
> 
> - suspended the computer
> 
> - resumed the computer
> 
> - tried to use hidmon again, and it worked
> 
> Note that I didn't switch off the LCD during the second suspend, in the
> case that matters.

Well, this isn't what your log shows.

According to the log, you booted the computer on March 10 and about 12 
minutes later started getting those -110 errors on the LCD device.  
Then you suspended the computer with no apparent problem.

Two days later you suspended three more times, and the the LCD monitor
was disconnected during the third suspend.  When it came back, you
started getting the errors again.

Next you unplugged and replugged the hub into which the LCD was 
connected.  Again there was another -110 error.  Finally you suspended 
and resumed.

To me that makes it look like the LCD's problems have no connection at
all with suspend/resume.

Alan Stern

