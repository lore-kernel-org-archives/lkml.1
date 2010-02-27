Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967931Ab0B0ICT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:02:19 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:50383 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967879Ab0B0ICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:02:17 -0500
Message-ID: <4B88D183.9000006@maroy.hu>
Date: Sat, 27 Feb 2010 09:02:11 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
References: <20100225190452.GA4184@xanatos> <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org> <20100225195249.GA5245@xanatos> <4B86FBB0.1080104@maroy.hu> <20100226001621.GA6060@xanatos>
In-Reply-To: <20100226001621.GA6060@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah,

> Actually, I wonder if 2.6.32 stable needs commit bcef3fd from 2.6.33.
> If the xHCI driver wasn't cleaning up the endpoint rings properly after
> a transfer error, I suppose the hardware could get wedged.

I see. where would I get this commit from? I have to stick with 2.6.32,
as I'm using the binary ATI video driver, which doesn't work with 2.6.33...

> If the hardware wasn't responding properly to commands, then URBs
> wouldn't have been able to be killed, the USB core would have sat around
> waiting on those URBs, and rmmod could never exit.  I need a more
> detailed log to figure out exactly why the hardware is wedged though.
> Let me make the less-verbose debugging patch so you don't get log
> corruption, and then we'll see what's going on.

let me know how I can use this..


Akos

