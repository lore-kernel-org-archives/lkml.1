Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275Ab0BZQMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:12:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46046 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965238Ab0BZQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:12:52 -0500
Date: Fri, 26 Feb 2010 11:12:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
In-Reply-To: <20100226001621.GA6060@xanatos>
Message-ID: <Pine.LNX.4.44L0.1002261111330.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Sarah Sharp wrote:

> > at this point, rmmod xhci doesn't even work anymore, I get stuff during
> > / around the rmmod like:
> > 
> > Feb 25 23:34:24 tonkachi kernel: [  230.133711] xhci_hcd 0000:02:00.0:
> > remove, state 1
> 
> Aw, man, it looks like your xHCI disconnected from the bus.  Something
> was seriously wrong with the hardware.

Why do you say that?  Isn't this exactly the sort of thing you expect 
to see in the log when xhci-hcd is unloaded?

Alan Stern

