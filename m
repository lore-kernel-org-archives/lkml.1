Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZAARpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZAARpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZAARpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:45:39 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2273 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756176AbZAARpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:45:38 -0500
Date: Thu, 1 Jan 2009 12:45:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't be
   unplugged safely
In-Reply-To: <495CFE38.6070603@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0901011243400.32126-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2009, Alexander E. Patrakov wrote:

> Yan Li wrote:
> > Hello List,
> > 
> > By default CONFIG_USB_SUSPEND is not enabled and today I got bite by
> > this when I got a new WDC My Book hard drive. I have no way to unplug
> > it safely, according to it's manual, with a kernel that doesn't have
> > CONFIG_USB_SUSPEND=y.
> > 
> > On it's manual read "you should unplug and remove the device only when
> > the light is off." On Linux unmounting it won't turn it's light off
> > and I can feel it's motor is still running.  The only way to unplug it
> > properly on a Linux system, as to my knowledge, is to echo `suspend'
> > to `/sys/bus/usb/devices/$DEV/power/level'. And one has to have
> > CONFIG_USB_SUSPEND=y to do this.
> > 
> > On Windows and Mac OS, `safely remove this device' function effectly
> > turns it into `suspend' mode, and it's light off.
> 
> You have obviously tested only Windows XP, because Vista doesn't cut the 
> power for at least some USB devices.

Yan never said that Windows cuts any power; he only said that the light 
turns off.  This is accomplished by disabling the USB port, not by 
cutting power.

> And congratulations for obtaining a 
> Vista-incompatible hard drive (of course, joking).
> 
> BTW, does the "eject /dev/$DEV" command help?

I wouldn't expect it to help, since it doesn't disable the port or put 
the device into suspend mode.

Alan Stern

