Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZJRUmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZJRUmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 16:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZJRUmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 16:42:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46558 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755153AbZJRUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 16:42:08 -0400
Date: Sun, 18 Oct 2009 16:42:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: nut-upsuser@lists.alioth.debian.org, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910181619360.27363@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0910181640090.18952-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Oct 2009, Justin Piszcz wrote:

> >> I have included debugging logs-- see below, is this a nut or kernel/USB 
> >> subsystem issue?
> >> 
> >> Robert/Nut User List--
> >> 
> >> Looks like the data goes stale, please let me know if any more 
> >> logs/debugging is required, is this a kernel/usb problem or a nut issue? I 
> >> recall a change in the USB subsystem a few kernel versions back caused a 
> >> different issue (on a different UPS, but nevertheless it was kernel 
> >> related).
> >
> 
> The details+logs are here (previous e-mail did not go through, too large for
> the list):
> wget http://home.comcast.net/~jpiszcz/20091014/nut-problem.txt
> 
> For now I have disabled nut-- is there any more debugging that I can do to
> help find/solve the problem?  Also cc'ing linux-usb & linux-kernel on this 
> one.

You could collect a usbmon trace showing the problem.  For 
instructions, see the kernel source file Documentation/usb/usbmon.txt.

It might also help to provide the dmesg log from a kernel built with 
CONFIG_USB_DEBUG enabled.

Alan Stern

