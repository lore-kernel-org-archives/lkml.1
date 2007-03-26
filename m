Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbXCZVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbXCZVPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXCZVPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:15:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48884 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753380AbXCZVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:15:54 -0400
Date: Mon, 26 Mar 2007 17:15:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Oliver Neukum <oneukum@suse.de>, <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod
 doesn't work
In-Reply-To: <20070326204744.GA24762@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0703261712340.7079-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Tino Keitel wrote:

> > > There are no messages from the iPod because, well, nothing happens when
> > > I plug it in. I tried it 3 times.
> > 
> > I don't understand.  The dmesg log you attached shows the iPod was
> > detected and recognized as scsi5 (sdc).  Then some time later (can't tell
> > how much later because you don't have CONFIG_PRINTK_TIME set) it was
> > unplugged and plugged back in.  The second time it was detected and
> > recognized as scsi6 (also sdc).  And then the log ends.
> 
> Not in the attached dmesg output from the above mail. There are not
> iPod related messages it it, but I plugged it in 2 times. I rebootet
> with the same kernel version without CONFIG_USB_SUSPEND right after
> this and the iPod was recognized at the first try.

Sorry, I was reading the wrong file before!  :-(

The lack of messages from the iPod seems to indicate that the hub isn't
working right.  You could try plugging the iPod into a different hub or
directly into the computer.  Or maybe into a different port of that hub.

Alan Stern

