Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbXLaVGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbXLaVGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 16:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXLaVG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 16:06:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49712 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751809AbXLaVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 16:06:27 -0500
Date: Mon, 31 Dec 2007 16:06:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
cc: Marin Mitov <mitov@issp.bas.bg>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.24-rc3-mm1: usb mouse doesn't work
In-Reply-To: <20071123051955.GA28946@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0712311605170.10555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007, Kirill A. Shutemov wrote:

> On [Thu, 22.11.2007 21:51], Alan Stern wrote:
> > On Thu, 22 Nov 2007, Marin Mitov wrote:
> > 
> > > > > > I've had some strangenesses with USB lately.  Sometimes running `lsusb'
> > > > > > makes the USB system notice a newly attached device.
> > > > >
> > > > > No. But I have new messages in dmesg:
> > > > >
> > > > > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> > > > > uhci_hcd 0000:00:1d.2: FGR not stopped yet!
> > > > > uhci_hcd 0000:00:1d.1: FGR not stopped yet!
> > > > > uhci_hcd 0000:00:1d.0: FGR not stopped yet!
> > > > >
> > > > > > Is that "FGR not stopped yet!" messgae new behaviour?
> > > > >
> > > > > It is a new message since 2.6.24-rc3. I have never try -mm tree before.
> > > >
> > > > These messages could indicate a timing problem.  You can see the code
> > > > that writes the messages near the end of wakeup_rh() in
> > > > drivers/usb/host/uhci-hcd.c.
> > > >
> > > > The message gets written if the controller hardware hasn't turned off a
> > > > particular bit after a 4-us delay.  If the udelay() function wasn't
> > > > working right, it could cause this problem.
> > > 
> > > udelay() _is_ OK for 2.6.24-rc3, so it is not the cause of the problem
> > 
> > But is it OK for 2.6.24-rc3-mm1?  Kirill said specifically that 
> > 2.6.24-rc3 does not display the message but 2.6.24-rc3-mm1 does.
> 
> How can I test it?

Any progress?  How about more recent kernels?

Alan Stern

