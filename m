Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZJSPMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZJSPMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZJSPMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:12:31 -0400
Received: from lucidpixels.com ([75.144.35.66]:54033 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477AbZJSPMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:12:31 -0400
Date: Mon, 19 Oct 2009 11:12:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910191048000.7710@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910191112140.7710@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910191016370.3899-100000@iolanthe.rowland.org> <alpine.DEB.2.00.0910191048000.7710@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Oct 2009, Justin Piszcz wrote:

>
>
> On Mon, 19 Oct 2009, Alan Stern wrote:
>
>> On Sun, 18 Oct 2009, Justin Piszcz wrote:
>> 
>>> I have performed all of the steps you recommended, there is also a bug in
>>> the docs, the directory seems to be different, or at least if you have
>>> everything compiled into the kernel and not using modules.
>> 
>>> Steps from the USB documentation:
>>> 
>>> # mount -t debugfs none_debugs /sys/kernel/debug
>>> #
>>> 
>>> The kernel documentation is outdated:
>>> 
>>> # ls /sys/kernel/debug/usbmon
>>> 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
>>> #
>>> 
>>> The directory is:
>>> # ls /sys/kernel/debug/usb/usbmon
>>> 0s  0u  1s  1t  1u  2s  2t  2u
>> 
>> This has already been corrected in the 2.6.32-rc kernels.
> Great to hear, I will try the latest 2.6.31-rcX kernel!
Disregard this ^

Misread, thought you meant the bug was fixed in the latest kernel but saw
your follow-up that this appears to be nut-related.

Justin.

