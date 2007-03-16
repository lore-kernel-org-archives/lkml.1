Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXCPByv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXCPByv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXCPByv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:54:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2768 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751019AbXCPByt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:54:49 -0400
Date: Thu, 15 Mar 2007 21:54:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB Keyboard
In-Reply-To: <Pine.LNX.4.61.0703151736070.5767@chaos.analogic.com>
Message-ID: <Pine.LNX.4.44L0.0703152148390.25583-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:

> It's not the same hardware and all the machines that I tried that
> have keyboards end up WORKING with the USB keyboard as well!  But
> Dmitry Torokhov was right! I just burned a CD with all three modules,
> and the keyboard works! I didn't bother to check the DEBUG messages.

Congratulations.  Sometimes these problems have easy solutions.  :-)

> It's interesting that the "wrong" module loaded fine with no warnings
> that it might not be the correct one!

There's no warning because the driver doesn't know anything is wrong.  
Even though it may not find any devices to manage when it first gets 
loaded, there's nothing to prevent you adding, for example, a PC-card with 
a USB controller on it at some later time.

That's true in general for most Linux drivers.  (The ones that aren't
platform-specific, anyway.)  They don't look for devices to manage at load
time; instead the driver core calls their probe() routine later on.  
Consequently drivers can't tell at load time whether there will be any
useful work for them to do.

Alan Stern

