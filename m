Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459Ab0ATUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0ATUN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424Ab0ATUN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:13:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37655 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754395Ab0ATUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:13:24 -0500
Date: Wed, 20 Jan 2010 15:13:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       <linux-geode@lists.infradead.org>, USB list <linux-usb@vger.kernel.org>,
       <linux-pci@vger.kernel.org>
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
 (which 2.6.26 did not see) on Geode LX/CS5536.
In-Reply-To: <20100120194201.GN24305@caffeine.csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.44L0.1001201509510.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Lennart Sorensen wrote:

> On Wed, Jan 20, 2010 at 11:37:07AM -0500, Alan Stern wrote:
> > It's true that the USB controllers appear to be the only devices using
> > IRQ 5.  But your startup log shows that only two of the three
> > controllers have an associated driver.  Maybe the third controller is
> > generating the unwanted interrupts?
> 
> Could be.  But I never saw the problem with 2.6.26.  That's puzzling me.
> 
> Now I think the 3rd controller may be a client mode interface on the
> Geode LX, which I certainly don't use if it has such a thing.
> 
> I know what EHCI and OHCI mean.  I don't know what UDC is.  I see mention
> of UDC under USB gadget support.  I will try enabling that driver and
> see what it does.

"UDC" stands for "USB Device Controller".  It is for use in device
mode, as opposed to host mode (i.e., you could plug that controller
into a regular PC and then use the Geode as a USB peripheral).

It's possible that some change in the PCI setup is allowing that 
controller to generate interrupts whereas before it didn't.  Or this 
could be a total red herring.

Alan Stern

