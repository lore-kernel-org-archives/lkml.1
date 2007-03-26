Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXCZUru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXCZUru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXCZUru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:47:50 -0400
Received: from eazy.amigager.de ([213.239.192.238]:40746 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbXCZUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:47:49 -0400
Date: Mon, 26 Mar 2007 22:47:44 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070326204744.GA24762@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oneukum@suse.de>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070326185900.GA27068@dose.home.local> <Pine.LNX.4.44L0.0703261617110.4848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0703261617110.4848-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 16:28:34 -0400, Alan Stern wrote:
> On Mon, 26 Mar 2007, Tino Keitel wrote:
> 
> > Attached is a dmesg output with CONFIG_USB_DEBUG and CONFIG_USB_SUSPEND
> > enabled.
> > 
> > There are no messages from the iPod because, well, nothing happens when
> > I plug it in. I tried it 3 times.
> 
> I don't understand.  The dmesg log you attached shows the iPod was
> detected and recognized as scsi5 (sdc).  Then some time later (can't tell
> how much later because you don't have CONFIG_PRINTK_TIME set) it was
> unplugged and plugged back in.  The second time it was detected and
> recognized as scsi6 (also sdc).  And then the log ends.

Not in the attached dmesg output from the above mail. There are not
iPod related messages it it, but I plugged it in 2 times. I rebootet
with the same kernel version without CONFIG_USB_SUSPEND right after
this and the iPod was recognized at the first try.

> 
> Why do you say there are no messages from the iPod?  Grepping for "iPod"
> in the log shows that the string appears 4 times.  If nothing happened
> when you plugged it in, how could the computer have known the device was
> an iPod?
> 
> >  The strange thing is: when I trigger
> > a suspend or shutdown, 
> 
> You mean you suspend or shutdown the computer?  Or the iPod?

The computer.

> 
> >  then the "Do not disconnect" message shows up on
> > the iPod, which means that the computer regognized it as a storage
> > device.
> 
> What's so strange about that?  Isn't that exactly what's supposed to 
> happen?

Well, it isn't recognized by a normal running system, only during
shutdown/suspend.

Regards,
Tino
