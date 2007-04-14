Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXDNQdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXDNQdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXDNQdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:33:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:51596 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753849AbXDNQdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:33:22 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX18dqyVKb4odmzuP0Jyv+YUS8OOSpanWiw0gd7/l5s
	jNYZqCMNSQHdH1
Date: Sat, 14 Apr 2007 18:33:19 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.21-rc6 USB Keyboard hangs (EHCI/UHCI/HID)
Message-ID: <20070414163319.GA17102@merlin.emma.line.org>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <20070409142941.GA8178@merlin.emma.line.org> <Pine.LNX.4.44L0.0704091052060.3561-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704091052060.3561-100000@iolanthe.rowland.org>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2007, Alan Stern wrote:

> On Mon, 9 Apr 2007, Matthias Andree wrote:
> 
> > Please Cc: me on replies, as I read linux-kernel sporadically and am not
> > subscribed to linux-usb-devel at all.
> > 
> > Greetings,
> > 
> > I have seen my USB keyboard drivers lock up several times now with my M$
> > Natural Ergonomic Keyboard, both on SUSE 10.2's current kernel as well
> > as 2.6.21-rc6 today. I don't ever recall this happen with older SUSE
> > 10.0 kernels. The keyboard is connected to a USB2.0 hub with single
> > transaction translator (at least that's what FreeBSD 6.2 says), which is
> > connected to a via root hub.
> > 
> > Symptoms are that the keyboard LEDs go off and no further input is
> > impossible (I'm typing this into a PS/2 keyboard). Replugging does not
> > help. Trying to unload ehci-hcd hangs modprobe, and additionally I've
> > got a stuck khubd (not sure if that's related), else no logging.
> > 
> > I'm rebuilding the kernel with HID/USB debugging cranked up to see if I
> > can get some detail out of the situation. Any specific kernel debugging
> > options that might help me debug this further?
> 
> It would help to see a trace from usbmon showing what happens during a 
> lockup.  You can find the instructions in the kernel source file 
> Documentation/usb/usbmon.txt.
> 
> To help keep the trace simple, try to avoid plugging any other USB devices
> into that hub or any other high-speed USB devices into the computer.
> 
> Also, it might help to see a stack trace of khubd (Alt-SysRq-T) when it 
> gets stuck.

I arrived at the computer today, to find khubd in D state again, but
unfortunately, it does not show up in Alt-SysRq-T output. Do kernel
threads show up there at all? 2.6.18.8-0.1 with SUSE patches on openSUSE
10.2.

I had stopped usbmon before however, so I don't know what the events
have been leading to this lockup. Sorry. I'll leave usbmon running now.

-- 
Matthias Andree
