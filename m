Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZJaPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZJaPSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 11:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbZJaPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 11:18:24 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46062 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757827AbZJaPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 11:18:24 -0400
Date: Sat, 31 Oct 2009 11:18:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <nut-upsuser@lists.alioth.debian.org>, <bruce.w.allan@intel.com>,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?]
 [tested 3 different UPS']
In-Reply-To: <alpine.DEB.2.00.0910310429410.10116@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0910311115301.7118-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Justin Piszcz wrote:

> Hello,
> 
> SUMMARY: P55 Chipset/USB has issues with UPS' (broken pipe on 3 diff UPS')
> WORKAROUND: Buy/use PCI USB card if you want to use nut/connect a UPS.
> NOTES: All other USB (non-UPS) devices seem to function without any
>         problems.
> 
> On Thu, 29 Oct 2009, Justin Piszcz wrote:
> 
> > Problem: When I migrated from a DG965WH -> DP55KG motherboard, there were 
> > quite a bit of issues, host still does not reboot without special flags, e.g. 
> > reboot=a, the NIC driver is broken with the in-kernel version (the one on 
> > e1000.sourceforge) fixes that and finally my UPS USB has driver stale 
> > problems, with two issues already relating to the HW/drivers themselves it 
> > would not be unrealistic to speculate that there could be an issue with the 
> > USB chipset/driver with this P55 motherboard.
> 
> --
> 
> Tried another APC 1500VA UPS, same problem occurs, different cable/port etc.
> 
> Problem appears to be the Intel P55KG / USB Chipset in the way that it 
> handles usbhid-raw devices as CD/USB sticks/kbd/mouse/etc do not appear to 
> be affected.
> 
> So far all other USB devices work fine, with the exception of UPS', I 
> have tested two APC 1500VA (one an RS the other an XS), in addition I also 
> have a 'BELKIN 1200VA UPS with AVR' from a long time ago, the same
> problem occurs.

...

> A bit frustrated, I popped in a PCI card with 4 external USBs, and now no
> more errors:

We might learn something by comparing two usbmon logs for the same UPS 
device, one plugged into a USB port on the motherboard and the other 
plugged into an add-on card.

Alan Stern

