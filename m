Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYKDQgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYKDQgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYKDQg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:36:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46805 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756511AbYKDQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:36:26 -0500
Date: Tue, 4 Nov 2008 11:36:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>
cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081104161708.GA32570@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811041134090.3614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Norbert Preining wrote:

> On Di, 04 Nov 2008, Alan Stern wrote:
> > > - First booting Vista, then RE-booting (not turning it off in the
> > >   meantime) into linux gives me that device and everything works.
> > 
> > By "it", did you mean the laptop or the modem?
> 
> I meant: 
> - first booting vista, then re-booting ... the device shows up (and is
>   functional)
> 
> - booting from off state the device does not show up and cannot be
>   switched on using /sys/devices/platform/sony-laptop/wwanpower
>   (although the behaviour that it can be switched on using the above
>   sysfs file is documented)
> 
> > No.  I'm interested in seeing the usbmon output for when the modem is
> > first detected by the USB subsystem.  During a normal boot this will 
> > happen before you can start usbmon.
> > 
> > If you can't boot with the modem off, then try this instead: Unload 
> > ehci-hcd, uhci-hcd, and ohci-hcd, then start up usbmon (copy the 0u 
> > file) and reload whichever driver the modem attaches to.
> 
> Ok, I will recompile my kernel with USB as modules and do the above. Is
> there a way to tell the kernel not to load any device drivers/modules
> (probably overriding modprobe in some way)?

You can add entries to /etc/modprobe.d/blacklist.  But for temporary 
testing, it might be easiest simply to rename the module files 
themselves (under /lib/modules/.../kernel/drivers/usb/host) so that the 
hotplug system can't find them.

Alan Stern

