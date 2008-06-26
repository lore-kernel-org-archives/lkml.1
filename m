Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYFZPwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYFZPwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYFZPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:52:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752711AbYFZPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:52:27 -0400
Date: Thu, 26 Jun 2008 11:52:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25 - problem in 2.6.26-rc8 again
In-Reply-To: <20080626153740.GG4486@ics.muni.cz>
Message-ID: <Pine.LNX.4.44L0.0806261147030.3104-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Lukas Hejtmanek wrote:

> Hello,
> 
> I have another USB problem with Lenovo T61 Thinkpad.
> 
> I'm using kernel 2.6.26-rc8. I do use CONFIG_USB_SUSPEND.
> 
> If I attach USB disk (using EHCI driver), the disk is found and it is working.
> If I remove the disk, undock the laptop, dock the laptop again and plug the
> disk, the disk is not found at all until I remove and reinsert the EHCI
> driver.
> 
> I noticed that if I do not unplug the disk berofe undocking, it works after
> docking back.

What happens if instead of reloading ehci-hcd, you unplug and replug
the disk?

What happens if you undock with the disk plugged in, then unplug the 
disk, then dock the laptop, and then plug in the disk?

> any ideas?

What does usbmon reveal when you dock the laptop again and then plug in
the disk (see Documentation/usb/usbmon.txt)?

Can you provide a comparable usbmon log for 2.6.25?

Did the problem go away at any time between 2.6.26-rc1 and -rc8?

Alan Stern

