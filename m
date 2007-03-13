Return-Path: <linux-kernel-owner+w=401wt.eu-S1030756AbXCMQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030756AbXCMQa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030766AbXCMQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:30:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49947 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030756AbXCMQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:30:25 -0400
Date: Tue, 13 Mar 2007 12:30:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <4af2d03a0703130913n3f51a3ffiec6e498c56a34826@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703131225390.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Jiri Slaby wrote:

> On 3/13/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > I don't see anything in the UHCI snapshots to explain the difference in
> > behavior.  One thing that stands out is the other, low-speed device (a
> > mouse?) -- in the bad kernel dump its driver was running and in the good
> > kernel dump its driver wasn't.
> 
> There weren't any changes neither in HW config nor in modules, just
> reverted, compiled, installed, rebooted. Mouse is HID user too, so I
> don't know what was wrong with that.

Odd...

> > Can you get another pair of usbmon logs, starting from before you plug in
> > the keyboard?  Don't bother with the UHCI snapshots for now.
> 
> So, do you mean rmmod uhci_hcd, unplug the keyboard, modprobe
> uhci_hcd, start usbmon, plug the keyboard, press numlock, stop usbmon,
> post it?

Yes.  In fact, let's be safe and unplug _both_ the mouse and the keyboard.  
Then after starting usbmon, plug in only the keyboard.

> I'm away from the box till Sat, anyway.

Okay, no rush.

Alan Stern

