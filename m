Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXAXTHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXAXTHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbXAXTHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:07:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33557 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932224AbXAXTHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:07:22 -0500
Date: Wed, 24 Jan 2007 14:07:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florin Iucha <florin@iucha.net>
cc: Jiri Kosina <jikos@jikos.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>, Adrian Bunk <bunk@stusta.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: heavy nfs[4]] causes fs badness Was: 2.6.20-rc4: known unfixed
 regressions (v2)
In-Reply-To: <20070124030447.GH11860@iucha.net>
Message-ID: <Pine.LNX.4.44L0.0701241404400.4368-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Florin Iucha wrote:

> > It would be nice to learn exactly why the keyboard stopped working.  Try
> > using the usbmon facility (instructions in Documentation/usb/usbmon.txt)
> > to see what happens when you type on the dead keyboard.  Be sure to turn
> > on CONFIG_USB_DEBUG as well.  And also check /proc/interrupts; each time
> > you hit a key the USB controller should get an interrupt.
> 
> Attached is the output from usbmon, unfortunately this kernel did not
> have CONFIG_USB_DEBUG set.  This is kernel 2.6.20-rc5.
> 
> So, the bus sees some traffic when the keyboard is used, but gdm does
> not receive any keystrokes.

So it's possible that the USB drivers are working correctly but the 
keystrokes are getting lost somewhere in the X server.  Can you switch to 
a VT (or kill the X server entirely) and see if the keyboard works then?

Alan Stern

