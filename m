Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbXGHCRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbXGHCRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 22:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXGHCRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 22:17:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3563 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754759AbXGHCRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 22:17:35 -0400
Date: Sat, 7 Jul 2007 22:17:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tim Hull <thully@umich.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: MacBook makes whining noise when usb-uhci active
In-Reply-To: <9a7c669e0707071551v2705320dn876ad208fa60a537@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707072210470.10912-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007, Tim Hull wrote:

> [1.] One line summary of the problem: MacBook makes whining noise when
> usb-uhci loaded.

I assume you mean uhci-hcd.  usb-uhci is part of Linux 2.4, not 2.6.

> [2.] Full description of the problem/report: On my MacBook (first generation
> Core Duo 1.83GHz), I can hear a faint whining noise that becomes audible
> when usb-uhci is loaded and remains audible except when the USB ports are in
> use (i.e. the noise temporarily stops when I'm copying music to my iPod).

You have a USB keyboard, right?  So the ports are always in use -- 
unless you unplug the keyboard.

> This problem occurs on both 2.6.21  and 2.6.22-rc7, but does not occur on
> 2.6.18.  Unloading usb-uhci when booted in 2.6.22-rc7 makes the whining
> noise stop, but the system is useless in this state for obvious reasons.
> The same whine does occur in OS X that occurs in 2.6.22-rc7 (though it does
> NOT occur in 2.6.18)

I don't know what's causing the noise.  Maybe something operating at 
the UHCI controller's 1000-Hz frame rate is coupling to a speaker 
connection.

Anyway it's clearly a hardware problem, even if it is triggered by 
something in software.  About all I can suggest is to surround the 
MacBook with something sound-absorbent.  (Not very helpful, I agree.)

Alan Stern

