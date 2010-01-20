Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225Ab0ATUUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0ATUUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962Ab0ATUUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:20:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53504 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754101Ab0ATUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:20:47 -0500
Date: Wed, 20 Jan 2010 15:20:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: linux-kernel@vger.kernel.org, <linux-geode@lists.infradead.org>,
       <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
 (which 2.6.26 did not see) on Geode LX/CS5536.
In-Reply-To: <20100120200125.GO24305@caffeine.csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.44L0.1001201515520.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Lennart Sorensen wrote:

> So the only difference is that now it happens 3 times instead of 2.
> Once each for ehci, ohci and amd5536udc.

Okay, this means that something else is affecting the IRQ line.

> Interestingly the number of interrupts listed in /proc/interrupts is
> exactly 300000.

That's probably because the kernel disabled the IRQ after 100000 
unhandled interrupts, and re-enabled it each time a new device was
registered for that IRQ.

> That's a lot of interrupts for a system that was just booted.

Yep.

> Hmm, I just tried booting 2.6.26 again, and now it too is failing.
> I think my box just broke.  Aghhh!
> 
> So I think that means there is no problem, I just have to go get
> another box.  I hate hardware problems. :)

Or you could just stop using USB on the old box.  :-)

Alan Stern

