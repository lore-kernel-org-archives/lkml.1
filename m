Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbXFIVVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbXFIVVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbXFIVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:20:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4161 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754739AbXFIVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:20:58 -0400
Date: Sat, 9 Jun 2007 17:20:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert de Rooy <robert.de.rooy@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       <Joel.Becker@oracle.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
In-Reply-To: <4669D608.2070505@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0706091716590.30086-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Robert de Rooy wrote:

> Alan Stern wrote:
> > Robert, it would help somewhat if you could build a kernel with 
> > CONFIG_USB_DEBUG turned on and post the dmesg log showing what happens 
> > when you plug in one of those non-working devices.
> >   
> Sorry, yes I should have done that before...

Unfortunately you posted the system log file instead of the dmesg log, 
and your syslogd was configured not to retain debug-level messages.

> > Yes, in principle Linux can be made to switch over to full speed when 
> > high speed fails.  But there are limitations: The switchover would work 
> > only for devices plugged directly into the computer, not for devices 
> > plugged into a high-speed hub.  And some Linux systems (not regular 
> > PCs) have EHCI implementations that don't allow such a switch -- or 
> > if they do, I'm not aware of how to accomplish it.
> >   
> Interesting, I have a USB 2.0 hub, but have not tried it, mainly because 
> I need to find a power supply for it first.
> But regardless if the hub works as USB 2.0 or 1.1, it could be that 
> another hub behaves differently, just like I have one USB 2.0 memory key 
> that still works as such.

You did not understand my point.  Regardless of how the hub behaves,
there is no way to tell it that a device plugged into a particular port
should not be allowed to run at high speed.

Alan Stern

