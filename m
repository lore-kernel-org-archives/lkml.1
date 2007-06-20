Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbXFTOGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbXFTOGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXFTOGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:06:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56432 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753762AbXFTOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:06:10 -0400
Date: Wed, 20 Jun 2007 10:06:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: Jiri Kosina <jikos@jikos.cz>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
In-Reply-To: <46790A61.5070107@mandic.com.br>
Message-ID: <Pine.LNX.4.44L0.0706201003490.3311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Renato S. Yamane wrote:

> Alan Stern wrote:
> > Does the mouse work correctly, even with ehci-hcd loaded?
> 
> Yes.
> And sorry, but I don't have any other USB2.0 device to test.
> I try with my cel phone (Motorola V3i) in this night (GMT-3).
> 
> > If it does then don't worry about the -71 error.  It appears to be 
> > transient and it's not necessarily fatal.
> 
> In my dmesg today, I see this:
> usb 1-1: can't set config #1, error -71

That error is more serious.

> When I remove and input (again) my Mouse, I see this in /var/log/messages:
> 
> kernel: usb 1-1: USB disconnect, address 3
> kernel: usb 1-1: new low speed USB device using uhci_hcd and address 4
> kernel: usb 1-1: configuration #1 chosen from 1 choice
> kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye? as 
> /class/input/input8
> kernel: input: USB HID v1.00 Mouse [Microsoft Microsoft 3-Button Mouse 
> with IntelliEye?] on usb-0000:00:1d.0-1

This is a low-level hardware error.  It indicates that communication 
over the USB cable isn't working right.  The fact that it occurs 
sometimes but not at other times indicates that some of the hardware 
components may be not-quite within spec.

Have you tried using that mouse on a different computer?  How about 
using a different USB mouse on your computer?

Alan Stern

