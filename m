Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447Ab0AST1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0AST1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891Ab0AST1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:27:14 -0500
Received: from kroah.org ([198.145.64.141]:45823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0AST1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:27:13 -0500
Date: Tue, 19 Jan 2010 11:26:26 -0800
From: Greg KH <greg@kroah.com>
To: David Holm <dholmster@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@sierrawireless.com, klloyd@sierrawireless.com
Subject: Re: [PATCH] Backport of Sierra Wireless USB serial driver from 2.6
 to kernel 2.4.37
Message-ID: <20100119192626.GA31490@kroah.com>
References: <3194316b1001191119h6c15dd2bvbf32bf93a2d1730e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3194316b1001191119h6c15dd2bvbf32bf93a2d1730e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 08:19:40PM +0100, David Holm wrote:
> This is a backport of the Sierra Wireless USB modem from
> linux/kernel/git/torvalds/linux-2.6.git to kernel 2.4. We are actively
> using this driver on our embedded systems running uClinux 2.4.26 on an
> ARM7TDMI but the patch has been produced against 2.4.37. I did not
> have time to prepare and run the entire 2.4.37 on our platform but I
> did backport usbserial.c just to make sure that there woudln't be any
> obvious problems. Hence, if anyone owns a Sierra Wireless modem and is
> running 2.4.37 please help me double check that there are no hidden
> surprises.
> The driver has been run extensively with usbserial and sierra
> debugging turned on. I've also done some tests with debugging enabled
> in the USB subsystem but this was the first time ever that I had to
> code a driver for a USB device so those message were usually of
> limited help to me.
> 
> I've tried to retain formatting of the 2.6 code as much as possible to
> make it easier to diff against newer revisions. This also means that I
> intentionally did not fix code guideline errors in that code. The
> portions that I have written myself should follow the guidelines
> though.
> 
> The power management code was removed completely due to lack of
> support in 2.4. Other than that I believe I was able to retain all of
> the remaining functionality. We only have access to the Sierra
> Wireless Compass 889 at work so that is the only hardware I've been
> running it against but the only hardware that seems to need special
> handling are the "direct IP modems" and that code should still be in
> there untouched.
> 
> I'm pretty sure "sierra_intf_private" as well as the variable "opened"
> in the "sierra_port_private" struct can be removed completely but I
> left them in for now.
> 
> Even though I've worked on a couple of Linux projects before this is
> my first submission so please be gentle. Any feedback will be greatly
> appreciated.

Minor complaint, your email client wrapped the patch, so it would have
to be edited by hand in order to apply it.

Main question though is, why did you do this?  Is there some reason you
are stuck with such an old, and unsupported kernel version that you
required this driver?  What is keeping you from moving to a 2.6 kernel
on this hardware platform, and can we help you out with that in any way?

Otherwise, looks fine at first glance, but I don't know what to do with
the patch as no one is doing 2.4 work upstream anymore except for
security and other minor bugfixes.

thanks,

greg k-h
