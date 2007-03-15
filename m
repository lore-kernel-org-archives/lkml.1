Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbXCOVZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbXCOVZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXCOVZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:25:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49751 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751693AbXCOVZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:25:45 -0400
Date: Thu, 15 Mar 2007 17:25:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB Keyboard
In-Reply-To: <d120d5000703151307w110c5258q6a4c53381e71e89c@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703151723350.2482-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Dmitry Torokhov wrote:

> On 3/15/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> > echo "Loading uhci-hcd.ko module"
> > insmod /lib/uhci-hcd.ko
> > echo "Loading ehci-hcd.ko module"
> > insmod /lib/ehci-hcd.ko
> 
> I don't see you loading OHCI and I thought AMD boxes used that flavor.

It depends on the chipset used for the motherboard.  Intel and VIA use 
UHCI, pretty much everyone else uses OHCI.

Dick, there's an even simpler way to debug this.  Install your special CD 
on a machine with an old-fashioned PS/2 keyboard and use that!

Alan Stern

