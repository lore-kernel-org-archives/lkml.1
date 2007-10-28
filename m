Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXJ1Scj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXJ1Scj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXJ1Scb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:32:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbXJ1Scb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:32:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB_SUSPEND needs SUSPEND?
Date: Sun, 28 Oct 2007 19:48:36 +0100
User-Agent: KMail/1.9.5
Cc: Oliver Martin <oliver.martin@student.tuwien.ac.at>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0710281245130.28311-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0710281245130.28311-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281948.37588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 October 2007 17:50, Alan Stern wrote:
> On Sun, 28 Oct 2007, Rafael J. Wysocki wrote:
> 
> > On Sunday, 28 October 2007 02:00, Oliver Martin wrote:
> > > Hello,
> > > 
> > > it seems that there is some dependency missing for CONFIG_USB_SUSPEND.
> > > When I compile a kernel without CONFIG_SUSPEND, USB suspend doesn't work
> > > (or at least doesn't expose its interface to userspace).
> > > /sys/bus/usb/devices/.../power doesn't exist, but it is there when I
> > > enable CONFIG_SUSPEND. So should CONFIG_USB_SUSPEND depend on
> > > CONFIG_SUSPEND (or something selected by CONFIG_SUSPEND)?
> > > 
> > > diff between the two configs follows, full config and dmesg for both
> > > kernels is available at http://stud4.tuwien.ac.at/~e0626486/usb_suspend/
> > > (though the dmesg diff doesn't seem to be all that interesting).
> 
> Actually I think the problem is the other way around.  /sys/.../power 
> should exist whenever CONFIG_PM is defined, not just when 
> CONFIG_SUSPEND is enabled.

Agreed.
