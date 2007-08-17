Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbXHQPF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbXHQPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXHQPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:05:48 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:45407 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXHQPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:05:47 -0400
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel events? [u]
Date: Fri, 17 Aug 2007 17:05:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0708171047170.2546-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708171047170.2546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171705.35793.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 17. August 2007 schrieb Alan Stern:
> On Fri, 17 Aug 2007, Andreas Jellinghaus [c] wrote:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >diff;h=9f8b17e643fe6aa505629658445849397bda4e4f
> >
> > removes MODALIAS from one of the events, this breaks user space
> > applications like openct - everything that depends on getting an event
> > that has both the DEVICE= path to the usb device and any information on
> > the interface, so it can check if the device is something it supports (in
> > case of openct: smart card reader, i.e. bInterfaceClass 0b).
>
> There is no MODALIAS for these events because there are no drivers for
> the devices they report.  Perhaps you should be looking at
> usb_if_uevent() in drivers/usb/core/message.c instead.  Is the problem
> that this routine doesn't set DEVICE, BUSNUM, or DEVNUM?

I need some kernel event that has both DEVICE and MODALIAS set. 
up to including kernel 2.6.21 this seems to come from 
drivers/usb/core/driver.c if I read the code correctly, and then
it was removed.

udevmonitor --kernel --environment shows one event with both on 2.6.21 plain, 
but not on 2.6.22 plain.

Regards, Andreas
