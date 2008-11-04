Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYKDPYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYKDPYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYKDPXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:23:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54599 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754920AbYKDPXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:23:47 -0500
Date: Tue, 4 Nov 2008 10:23:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>
cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081104093710.GC15846@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811041015010.2642-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Norbert Preining wrote:

> Hi Alan,
> 
> On Mo, 03 Nov 2008, Alan Stern wrote:
> > What happens if you leave the modem turned off until after Linux is 
> > running?  If it does not show up then a usbmon trace would be helpful 
> > (see Documentation/usb/usbmon.txt for instructions).
> 
> I can run usbmon, but I am not sure what you mean with "leave the modem
> turned off until after Linux is running".

I must have misunderstood your earlier message, where you wrote:

> Interestingly this device does disappear if I cold boot into linux.
> 
> So:
> - First booting Vista, then RE-booting (not turning it off in the
>   meantime) into linux gives me that device and everything works.

By "it", did you mean the laptop or the modem?

> If I start from turned off state of the laptop and boot into linux the
> device is not showing up. Is it that state you are interested in getting
> the usbmon output?

No.  I'm interested in seeing the usbmon output for when the modem is
first detected by the USB subsystem.  During a normal boot this will 
happen before you can start usbmon.

If you can't boot with the modem off, then try this instead: Unload 
ehci-hcd, uhci-hcd, and ohci-hcd, then start up usbmon (copy the 0u 
file) and reload whichever driver the modem attaches to.

Alan Stern

