Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbXENAqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbXENAqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 20:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbXENAqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 20:46:15 -0400
Received: from nn7.de ([85.214.94.156]:50955 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875AbXENAqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 20:46:14 -0400
Subject: Re: converting appletouch to usb autosuspend...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
In-Reply-To: <200705122247.44795.s0348365@sms.ed.ac.uk>
References: <1178995886.4168.10.camel@localhost>
	 <200705122247.44795.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 14 May 2007 02:46:10 +0200
Message-Id: <1179103570.26132.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 22:47 +0100, Alistair John Strachan wrote:
> On Saturday 12 May 2007 19:51:26 Soeren Sonnenburg wrote:
> > Dear all,
[...]
> > While we are at it usb related powerhogs on this macbook pro are
> > uhci_hcd (usb keyboard) and usb_hcd_poll_rh_status (rh_timer_func)
> > too...
> 
> I've found that hci_usb also hogs power on the Macbook; blacklisting this 
> module cuts down HZ considerably. I also found appletouch consumed ticks, 

I guess without loading appletouch ? Then there really is something in
there that needs to be fixed..

> just as you did.

What did you use instead of hci_usb then ? usbkbd ? This won't give you
the special keys etc...

> uhci_hcd then drops to noise; my Macbook's sitting on 10W with the backlight 
> on minimum, which is about what it can manage in OS X on maximum life 
> settings.

Thats quite some improvement... 

Soeren.
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
