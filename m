Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbXDOCLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbXDOCLH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 22:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXDOCLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 22:11:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3253 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753096AbXDOCLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 22:11:06 -0400
Date: Sat, 14 Apr 2007 22:11:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthias Andree <matthias.andree@gmx.de>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.21-rc6 USB Keyboard hangs (EHCI/UHCI/HID)
In-Reply-To: <20070414163319.GA17102@merlin.emma.line.org>
Message-ID: <Pine.LNX.4.44L0.0704142203560.11828-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007, Matthias Andree wrote:

> I arrived at the computer today, to find khubd in D state again, but
> unfortunately, it does not show up in Alt-SysRq-T output. Do kernel
> threads show up there at all? 2.6.18.8-0.1 with SUSE patches on openSUSE
> 10.2.

As far as I know, all tasks including kernel threads should show up.  They 
certainly do on my machine.  However you're the second person to report 
that khubd doesn't appear after getting stuck in a D state.

Clearly something strange is going on.  I wish I knew what it was...

> I had stopped usbmon before however, so I don't know what the events
> have been leading to this lockup. Sorry. I'll leave usbmon running now.

Something else you can do is turn on CONFIG_USB_DEBUG and then check the
dmesg log for anything significant.

Alan Stern

