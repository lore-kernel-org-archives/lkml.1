Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbYJTOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbYJTOCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYJTOC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:02:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751806AbYJTOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:02:26 -0400
Date: Mon, 20 Oct 2008 10:02:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Oliver Neukum <oliver@neukum.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)
In-Reply-To: <alpine.DEB.1.10.0810191247540.19058@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0810200959020.2477-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Justin Piszcz wrote:

> > You should turn on the usbfs_snoop module parameter for usbcore and see
> > what shows up in the system log.
> 
> > Alan Stern
> 
> Tried this, kernel would not boot up any further when I had that enabled
> alongside the 'extra' debugging options in the kernel:
> 
> http://home.comcast.net/~jpiszcz/20081019/2.6.27.2-usb-extra-debug.txt

I'm not interested in your config file; I need to see the dmesg log.

> > Please get sysrq-t of a hang.
> >
> > 	Regards
> > 		Oliver
> >
> 
> Before I tried the above, I was able to get a sysrq-t of the hang:
> 
> http://home.comcast.net/~jpiszcz/20081019/trace_before_trigger.txt
> http://home.comcast.net/~jpiszcz/20081019/trace_after_trigger.txt

Your trace is incomplete.  You might need to increase the size of the 
kernel log buffer (CONFIG_LOG_BUF_SHIFT) or the size of the buffer used 
by dmesg (the -s option).

Alan Stern

