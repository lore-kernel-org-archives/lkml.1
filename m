Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXLVGxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXLVGxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXLVGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:53:16 -0500
Received: from [212.12.190.44] ([212.12.190.44]:44976 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751012AbXLVGxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:53:15 -0500
From: Al Boldi <a1426z@gawab.com>
To: David Brownell <david-b@pacbell.net>, jengelh@computergmbh.de
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Date: Sat, 22 Dec 2007 09:51:57 +0300
User-Agent: KMail/1.5
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
References: <200712211630.03426.a1426z@gawab.com> <200712220806.24730.a1426z@gawab.com> <20071222061919.A5B1D1915EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20071222061919.A5B1D1915EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712220951.57634.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> > > The driver stacks are independent of each other, except for common
> > > data structures like what's in the <linux/usb/ch9.h> header file.  I
> > > think there's no real point, other than history, to having both sides
> > > share the same menu.
> >
> > They aren't.
>
> How can you say that, when you showed (right above!!) that they are???
> Sure, there are submenus too.  But they're clearly in the same menu.

Well, in that case even if you moved them to the upper level, then they would 
still be in the same menu, if that's what you mean.

> >	USB Gadget Support is in its own sub-menu.  And strictly
> > speaking, Host-side USB should be too, but some people may feel that
> > this would be nesting it too deep, and so it unfolds in the same menu.
>
> Which is why my suggestion was to have them both move up a level, with
> host and peripheral side menus nested normally:
>
> 	Device Drivers:
> 		...
> 		[ ] HID devices
> 		< > Host side USB
> 		< > Peripheral side USB
> 		< > MMC/SD/SDIO card support
> 		[ ] LED support
> 		...
>
> That way both host and peripheral side support would have their own
> menu, and that pointless nesting would be reduced.

You mean:
 		[ ] Host side USB
 		[ ] Peripheral side USB

Right?

All this does is loose the USB menu, which was used to group them and to 
un-clutter the Device Drivers menu.  Note:  They would still be sharing the 
same menu, only this time it's the Device Drivers menu.

I guess it's a judgment call.  Let's see what others think.


Thanks!

--
Al

