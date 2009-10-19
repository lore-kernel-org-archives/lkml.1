Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZJSOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZJSOX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbZJSOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:23:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50254 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755934AbZJSOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:23:28 -0400
Date: Mon, 19 Oct 2009 10:23:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910181732550.4761@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0910191016370.3899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Oct 2009, Justin Piszcz wrote:

> I have performed all of the steps you recommended, there is also a bug in
> the docs, the directory seems to be different, or at least if you have
> everything compiled into the kernel and not using modules.

> Steps from the USB documentation:
> 
> # mount -t debugfs none_debugs /sys/kernel/debug
> #
> 
> The kernel documentation is outdated:
> 
> # ls /sys/kernel/debug/usbmon
> 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
> #
> 
> The directory is: 
> # ls /sys/kernel/debug/usb/usbmon
> 0s  0u  1s  1t  1u  2s  2t  2u

This has already been corrected in the 2.6.32-rc kernels.

However there is another respect in which the documentation is
outdated: It mentions /proc/bus/usb/devices.  That file has moved; it
is now named /sys/kernel/debug/usb/devices.  Would you like to submit a
patch fixing this?

Alan Stern

