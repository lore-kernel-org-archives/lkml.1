Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZJSPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZJSPNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZJSPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:13:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40102 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756651AbZJSPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:13:17 -0400
Date: Mon, 19 Oct 2009 11:13:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910191048000.7710@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0910191110020.3899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Justin Piszcz wrote:

> >> The kernel documentation is outdated:
> >>
> >> # ls /sys/kernel/debug/usbmon
> >> 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
> >> #
> >>
> >> The directory is:
> >> # ls /sys/kernel/debug/usb/usbmon
> >> 0s  0u  1s  1t  1u  2s  2t  2u
> >
> > This has already been corrected in the 2.6.32-rc kernels.
> Great to hear, I will try the latest 2.6.31-rcX kernel!

It looks like you misunderstood.  I was referring to the 2.6.32-rc 
kernels, not 2.6.31-rc.  In particular, check out this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f0cc82a831d4d839eb6b67c7c046ebd2d1d7c4c2

> Hi,
> 
> Sure, what I meant is:
> 
> usbmon.txt states:
> /sys/kernel/debug/usbmon/3u
>              ^^^^^
> 
> Actual location:
> /sys/kernel/debug/usb/usbmon/3u
>              ^^^^^^^^^

Yes, I know.

> Patch below (and attached):

As I said, this correction has already been made.

Alan Stern

