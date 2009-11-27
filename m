Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZK0MKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZK0MKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZK0MKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:10:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZK0MKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:10:34 -0500
Date: Fri, 27 Nov 2009 13:10:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alex Custov <alex.custov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: touchscreen wirh 2.6.26
In-Reply-To: <39840bc80911270403q83c16efy872cc1f72a0344ee@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0911271308270.6953@wotan.suse.de>
References: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>  <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz> <39840bc80911270403q83c16efy872cc1f72a0344ee@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, Alex Custov wrote:

> >> I have Acer T230H on Debian Lenny with 2.6.26.8 manually complied
> >> kernel. The problem is that this is a multitouch monitor and it seems
> >> that it doesn't work at all (even single touches). All things under
> >> "Drivers => Input device support => Touchscreens" are enabled in kernel
> >> (as modules). Is this type of monitor supported, or I should upgrade to
> >> a newer kernel? Thanks.
> >
> > How is the touchscreen conntected to system? Is it USB? If so, what is the
> > vendor and product ID? (lsusb will tell).
> 
> Hi. Thanks for answer. I've already found the /dev device it has - it
> is /dev/usb/hiddev0. Yes, it is USB connected. I did "cat
> /dev/usb/hiddev0" and touched some points on the screen, it seems that
> it works (I got some binary data from 'cat'). Now I will try to add
> the corresponding section to the xorg.conf to let it work in X.

It might not be that trivial -- /dev/usb/hiddev0 gives you only 
more-or-less raw HID data, but they have still to be interpreted somehow 
to make sense.

If the device is implementing some vendor-specific (or device-specific) 
protocol, then the data you see coming through hiddev0 might not be useful 
at all directly in X.

Repeating from my previous mail -- please provide the idVendor/idProduct 
(found by lsusb -v) for this device. It might be supported in later 
kernels, but without this information, it's impossible to tell.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
