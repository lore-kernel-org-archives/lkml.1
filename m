Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbXJ1Qu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbXJ1Qu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXJ1QuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:50:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2042 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750841AbXJ1QuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:50:15 -0400
Date: Sun, 28 Oct 2007 12:50:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Martin <oliver.martin@student.tuwien.ac.at>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: USB_SUSPEND needs SUSPEND?
In-Reply-To: <200710281435.31690.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0710281245130.28311-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Rafael J. Wysocki wrote:

> On Sunday, 28 October 2007 02:00, Oliver Martin wrote:
> > Hello,
> > 
> > it seems that there is some dependency missing for CONFIG_USB_SUSPEND.
> > When I compile a kernel without CONFIG_SUSPEND, USB suspend doesn't work
> > (or at least doesn't expose its interface to userspace).
> > /sys/bus/usb/devices/.../power doesn't exist, but it is there when I
> > enable CONFIG_SUSPEND. So should CONFIG_USB_SUSPEND depend on
> > CONFIG_SUSPEND (or something selected by CONFIG_SUSPEND)?
> > 
> > diff between the two configs follows, full config and dmesg for both
> > kernels is available at http://stud4.tuwien.ac.at/~e0626486/usb_suspend/
> > (though the dmesg diff doesn't seem to be all that interesting).

Actually I think the problem is the other way around.  /sys/.../power 
should exist whenever CONFIG_PM is defined, not just when 
CONFIG_SUSPEND is enabled.

Alan Stern

