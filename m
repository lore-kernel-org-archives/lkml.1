Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115Ab0ACVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0ACVkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042Ab0ACVkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:40:39 -0500
Received: from lucidpixels.com ([75.144.35.66]:59059 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab0ACVki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:40:38 -0500
Date: Sun, 3 Jan 2010 16:40:38 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christian Hofstaedtler <ch@zeha.at>
cc: linux-kernel@vger.kernel.org, bruce.w.allan@intel.com
Subject: RE: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
In-Reply-To: <20100103202345.GA20015@percival.namespace.at>
Message-ID: <alpine.DEB.2.00.1001031637230.17894@p34.internal.lan>
References: <20100103202345.GA20015@percival.namespace.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jan 2010, Christian Hofstaedtler wrote:

> Hi,
>
> In regard to the DP55KG board having reboot [1] and HPET [2] issues,
> have you seen any fixes (from Intel?) for these problems?
>
> I now own such a board and see the same stuff on a distro-patched
> 2.6.31.6.
>
> Thanks,
>  Christian
>
> [1] http://thread.gmane.org/gmane.linux.kernel/903161/
> [2] http://thread.gmane.org/gmane.linux.kernel/913374
>
> -- 
> christian hofstaedtler
>

Hello Christian,

The work around for the reboot [1] issue is append this to your kernel 
boot options in lilo/grub:

reboot=a

For the HPET [2] issues, from what I understand it is nothing to be 
worried about.

There is also a USB issue (will not work correctly with iPods/or UPS) the 
only work-around there is to buy a USB card.

You can read that here:
http://communities.intel.com/message/76837#76837

Summary:

1. Use reboot append line in lilo/grub.
2. Do not worry about it (is what I am told, its normal)
3. Buy a USB PCI(-e) card if you want to use USB for anything beyond a 
keyboard/mouse.

Justin.
