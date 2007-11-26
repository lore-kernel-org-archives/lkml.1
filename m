Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXKZWSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXKZWSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXKZWRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:17:53 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2031 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754433AbXKZWRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:17:52 -0500
Date: Mon, 26 Nov 2007 17:17:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Raymano Garibaldi <raymano@faunos.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
In-Reply-To: <1618816c0711261043nfa61e63m59d242fbbd6a8d6@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711261713280.14778-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Raymano Garibaldi wrote:

> > Wait a minute.  You're saying that  USB Persist worked under 2.6.21
> > because it wasn't available?  That makes no sense.  Besides, if you
> > don't like USB Persist under 2.6.23, you can always eliminate it by
> > turning off CONFIG_USB_PERSIST.
> >
> 
> I have tried this. Simply turning off CONFIG_USB_PERSIST doesn't work.
> In this case the USB drive file system is unmounted on resume, even if
> the drive remained plugged in during suspend.

Something about this doesn't sound right.

When you have CONFIG_USB_PERSIST enabled, do you remember to turn on 
the Persist feature for the root fs device by writing a "1" to the 
device's power/persist file in sysfs?

Can you try building a kernel with CONFIG_USB_PERSIST and 
CONFIG_USB_DEBUG both enabled, and post the dmesg log from immediately 
after resuming?

Alan Stern

