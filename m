Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXHBOcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXHBOcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXHBOcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:32:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45538 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755548AbXHBOcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:32:22 -0400
Date: Thu, 2 Aug 2007 10:32:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Engraf <david.engraf@netcom.eu>
cc: linux-pci@atrey.karlin.mff.cuni.cz, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
In-Reply-To: <46B1844B.8090007@netcom.eu>
Message-ID: <Pine.LNX.4.44L0.0708021009460.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, David Engraf wrote:

> This would be solution too, but what if someone uses the uhci controller
> and don't want the
> ehci. So a single Kconfig flag wouldn't be enough, we have to add 3
> flags for uchi, ohci and
> ehci. I think this maybe a little bit difficult when configuring the kernel.
> The best solution would be when we could use the CONFIG_USB_xxxx_HCD
> flag, but it
> seems that some hardware has problems when we disable the handoff and
> let the BIOS
> control the usb controller. Do you know any of this hardware?

The email messages are hidden in the depths of the linux-usb-devel 
archives.  Maybe you can find them by checking the Git history for 
drivers/usb/host/pci-quirks.c, finding the dates for patches that 
affected the handoff code, and then searching through the archives near 
those dates.

IIRC the problems arose on some MIPS machines.  And I don't think the 
problem involved letting the firmware manage the USB controller; I 
think the problem came when the controller driver tried to do the 
handoff later on.

Alan Stern

