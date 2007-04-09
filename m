Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbXDIO4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbXDIO4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbXDIOz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:55:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48809 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933814AbXDIOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:55:35 -0400
Date: Mon, 9 Apr 2007 10:55:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthias Andree <matthias.andree@gmx.de>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.21-rc6 USB Keyboard hangs (EHCI/UHCI/HID)
In-Reply-To: <20070409142941.GA8178@merlin.emma.line.org>
Message-ID: <Pine.LNX.4.44L0.0704091052060.3561-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007, Matthias Andree wrote:

> Please Cc: me on replies, as I read linux-kernel sporadically and am not
> subscribed to linux-usb-devel at all.
> 
> Greetings,
> 
> I have seen my USB keyboard drivers lock up several times now with my M$
> Natural Ergonomic Keyboard, both on SUSE 10.2's current kernel as well
> as 2.6.21-rc6 today. I don't ever recall this happen with older SUSE
> 10.0 kernels. The keyboard is connected to a USB2.0 hub with single
> transaction translator (at least that's what FreeBSD 6.2 says), which is
> connected to a via root hub.
> 
> Symptoms are that the keyboard LEDs go off and no further input is
> impossible (I'm typing this into a PS/2 keyboard). Replugging does not
> help. Trying to unload ehci-hcd hangs modprobe, and additionally I've
> got a stuck khubd (not sure if that's related), else no logging.
> 
> I'm rebuilding the kernel with HID/USB debugging cranked up to see if I
> can get some detail out of the situation. Any specific kernel debugging
> options that might help me debug this further?

It would help to see a trace from usbmon showing what happens during a 
lockup.  You can find the instructions in the kernel source file 
Documentation/usb/usbmon.txt.

To help keep the trace simple, try to avoid plugging any other USB devices
into that hub or any other high-speed USB devices into the computer.

Also, it might help to see a stack trace of khubd (Alt-SysRq-T) when it 
gets stuck.

Alan Stern

