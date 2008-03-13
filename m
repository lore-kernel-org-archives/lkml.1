Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYCMPNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYCMPNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYCMPNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:13:33 -0400
Received: from eazy.amigager.de ([213.239.192.238]:48384 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYCMPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:13:31 -0400
Date: Thu, 13 Mar 2008 16:14:03 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080313151403.GA5667@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20080312224411.GB2290@dose.home.local> <Pine.LNX.4.44L0.0803131049510.4474-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803131049510.4474-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:59:26 -0400, Alan Stern wrote:
> On Wed, 12 Mar 2008, Tino Keitel wrote:
> 
> > On Wed, Mar 12, 2008 at 17:44:56 -0400, Alan Stern wrote:
> > 
> > [...]
> > 
> > > Tino, it would help to see a kernel log showing what happened during 
> > > the suspend, resume, and failure of hidmon.  It would help even more if 
> > > you test under a kernel with CONFIG_USB_DEBUG enabled.
> > 
> > A full kernel log is available at http://tikei.de/dmesg
> > 
> > > 
> > > Even if you can't reproduce the problem, do you have the complete 
> > > kernel log from before?
> > > 
> > > Is it possible that this is really a problem with the LCD device, not 
> > > with the kernel?  I ask because if the device was working properly then 
> > > unplugging and replugging the USB cable should do a complete reset.
> > 
> > I did the following:
> > 
> > - suspended the computer
> > 
> > - switched off the LCD
> 
> And switched it back on at some point?

Err, yes, right after resume.

> 
> > - resumed the computer
> > 
> > - tried to use hidmon, got the error
> > 
> > - unplugged the LCD
> > 
> > - plugged in the LCD
> > 
> > - tried to use hidmon again, got the error again
> > 
> > - suspended the computer
> > 
> > - resumed the computer
> > 
> > - tried to use hidmon again, and it worked
> > 
> > Note that I didn't switch off the LCD during the second suspend, in the
> > case that matters.
> 
> Well, this isn't what your log shows.
> 
> According to the log, you booted the computer on March 10 and about 12 
> minutes later started getting those -110 errors on the LCD device.  

Uh, it looks like I just didn't noticed that.

> Then you suspended the computer with no apparent problem.
> 
> Two days later you suspended three more times, and the the LCD monitor
> was disconnected during the third suspend.  When it came back, you

What log message do you refer to here?

> started getting the errors again.
> 
> Next you unplugged and replugged the hub into which the LCD was 
> connected.  Again there was another -110 error.  Finally you suspended 
> and resumed.
> 
> To me that makes it look like the LCD's problems have no connection at
> all with suspend/resume.

Well, it seems to be "fixed" by a suspend/resume cycle. Do you have a
hint how I could try to fix it without suspend/resume, to test if it is
really the LCD's fault?

Regards,
Tino
