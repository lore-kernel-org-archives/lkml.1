Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbXJYWeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbXJYWeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbXJYWd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:33:56 -0400
Received: from alnrmhc14.comcast.net ([204.127.225.94]:40744 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXJYWdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:33:55 -0400
Date: Thu, 25 Oct 2007 18:33:54 -0400 (EDT)
From: Parag Warudkar <kernel-stuff@comcast.net>
X-X-Sender: parag@parag-desktop
Reply-To: kernel-stuff@comcast.net
To: Adam Baker <linux@baker-net.org.uk>
cc: rt2400-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
In-Reply-To: <200710252035.20546.linux@baker-net.org.uk>
Message-ID: <alpine.DEB.0.99.0710251826310.9840@parag-desktop>
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
 <200710252035.20546.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Oct 2007, Adam Baker wrote:

>
> Unfortunately Belkin have sold both RT73 and RT2500 devices with
> that USB ID. You don't say what distro you are runing or what version
> of RT2x00 it ships with but last time I checked with the git version of
> rt2x00 it tried to load both drivers but the rt2500 driver noticed it was the
> wrong hardware and shut down.

Like I said this did not work with 2.6.24-rc1 (latest git). My distro 
(Ubuntu 7.10) kernel 2.6.22-10 also has the same behavior.

> There are a few such devices but they are all cases where there are reliable
> reports of manufacturers shipping both device types with one USB ID. There
> are some cases where the alternate chipset with the same USB ID isn't even a
> ralink device but there isn't much we can do about those.
>

Ok, I failed to imagine the hardware makers' stupidity :) - In the case 
that you mentioned I agree that there is little that can be done based on 
device IDs. I'll check out subsequent releases to see if it gets fixed 
based on hardware characteristics (rt2500usb unloading and requesting the 
right one in my case for example).

Thanks

Parag
