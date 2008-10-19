Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYJSQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYJSQvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 12:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYJSQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 12:51:32 -0400
Received: from lucidpixels.com ([75.144.35.66]:43924 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYJSQvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 12:51:32 -0400
Date: Sun, 19 Oct 2008 12:51:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)
In-Reply-To: <200810191734.11044.oliver@neukum.org>
Message-ID: <alpine.DEB.1.10.0810191247540.19058@p34.internal.lan>
References: <alpine.DEB.1.10.0810190720210.26990@p34.internal.lan> <alpine.DEB.1.10.0810190728030.26990@p34.internal.lan> <200810191734.11044.oliver@neukum.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 19 Oct 2008, Oliver Neukum wrote:

> You should turn on the usbfs_snoop module parameter for usbcore and see
> what shows up in the system log.

> Alan Stern

Tried this, kernel would not boot up any further when I had that enabled
alongside the 'extra' debugging options in the kernel:

http://home.comcast.net/~jpiszcz/20081019/2.6.27.2-usb-extra-debug.txt

My netconsole is not working right at the moment either so I was not
able to pull a sysrq-of this, but it hung twice, once on one device, rebooted
then it hung on another device the second time.

>
> Please get sysrq-t of a hang.
>
> 	Regards
> 		Oliver
>

Before I tried the above, I was able to get a sysrq-t of the hang:

http://home.comcast.net/~jpiszcz/20081019/trace_before_trigger.txt
http://home.comcast.net/~jpiszcz/20081019/trace_after_trigger.txt

Justin.

