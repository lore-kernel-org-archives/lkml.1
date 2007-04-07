Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXDGBBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXDGBBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 21:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXDGBBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 21:01:04 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:45563 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964796AbXDGBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 21:01:03 -0400
Date: Sat, 7 Apr 2007 02:54:58 +0200
To: linux-kernel@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net
Subject: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
Message-ID: <20070407005458.GA18985@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have an usb  touchscreen (egalax variety) that works with
the 2.6.18 kernel supplied by debian.

It fails when I compile 2.6.21-rc5-mm4, tuned to the machine
in question.  Unlike the debian kernel, this kernel don't use
modules in order to save boot time.

The strange thing is, 2.6.21-rc5-mm4 recognizes the device.
dmesg says things like 
usb 3-2: Manufacturer: eGalac Inc.
usb 3-2: Product: USB TouchController

and a lot more. Unlike 2.6.18, it never gets around to say
"usbcore: registered new driver usbtouchscreen"
which seems to indicate a problem.
usbcore registers several other drivers, such as usbserial and pl2303
that makes the gps work. It also registers other drivers like
usb-storage,usbfs,hub,libusual,hiddev,usbhid.  But not usbtouchscreen.
I believe I have turned on every config option for usb touchscreen,
this should not be missing.

Is there something wrong, or could there be a seemingly unrelated option
that I need to turn on?

Helge Hafting

