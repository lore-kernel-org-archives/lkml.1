Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXDIWnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXDIWnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXDIWnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:43:13 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:46672 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753094AbXDIWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:43:12 -0400
Date: Tue, 10 Apr 2007 00:36:43 +0200
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
Message-ID: <20070409223643.GB2198@aitel.hist.no>
References: <20070407005458.GA18985@aitel.hist.no> <200704062237.13118.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704062237.13118.dtor@insightbb.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 10:37:12PM -0400, Dmitry Torokhov wrote:
> On Friday 06 April 2007 20:54, Helge Hafting wrote:
> > I have an usb  touchscreen (egalax variety) that works with
> > the 2.6.18 kernel supplied by debian.
> > 
> > It fails when I compile 2.6.21-rc5-mm4, tuned to the machine
> > in question.  Unlike the debian kernel, this kernel don't use
> > modules in order to save boot time.
> > 
> > The strange thing is, 2.6.21-rc5-mm4 recognizes the device.
> > dmesg says things like 
> > usb 3-2: Manufacturer: eGalac Inc.
> > usb 3-2: Product: USB TouchController
> > 
> > and a lot more. Unlike 2.6.18, it never gets around to say
> > "usbcore: registered new driver usbtouchscreen"
> > which seems to indicate a problem.
> > usbcore registers several other drivers, such as usbserial and pl2303
> > that makes the gps work. It also registers other drivers like
> > usb-storage,usbfs,hub,libusual,hiddev,usbhid.  But not usbtouchscreen.
> > I believe I have turned on every config option for usb touchscreen,
> > this should not be missing.
> > 
> > Is there something wrong, or could there be a seemingly unrelated option
> > that I need to turn on?
> 
> Please make sure that you have CONFIG_USB_TOUCHSCREEN turned on.
> 
Unfortunately, I have:
CONFIG_USB_TOUCHSCREEN=y
CONFIG_USB_TOUCHSCREEN_EGALAX=y

Anything else I may have missed?

Helge Hafting
