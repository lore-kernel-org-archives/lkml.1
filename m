Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466Ab0ATQhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0ATQhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317Ab0ATQhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:37:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35395 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752108Ab0ATQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:37:08 -0500
Date: Wed, 20 Jan 2010 11:37:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: linux-kernel@vger.kernel.org, <linux-geode@lists.infradead.org>,
       <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
 (which 2.6.26 did not see) on Geode LX/CS5536.
In-Reply-To: <20100120154005.GB24307@caffeine.csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.44L0.1001201134270.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Lennart Sorensen wrote:

> I am working on upgrading from 2.6.26 to 2.6.32 on our router, and I am
> now seeing some strange IRQ errors on boot when the EHCI and OHCI drivers
> load for USB.  2.6.26 never complained.  It appears to be working just
> fine with both kernels, but the errors are rather concerning to see.
> Perhaps I have to fix something in the PCI setup of the system.

...

> So the only devices on IRQ5 are the USB controllers, unless there is
> some junk on the LPC bus generating an IRQ 5 (if there is I can certainly
> mask that).

It's true that the USB controllers appear to be the only devices using
IRQ 5.  But your startup log shows that only two of the three
controllers have an associated driver.  Maybe the third controller is
generating the unwanted interrupts?

Alan Stern

