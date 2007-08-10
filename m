Return-Path: <linux-kernel-owner+w=401wt.eu-S941875AbXHJUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941875AbXHJUne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXHJUn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:43:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54006 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762484AbXHJUnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:43:25 -0400
Date: Fri, 10 Aug 2007 16:43:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Zwell <dzwell@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       David Brownell <david-b@pacbell.net>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: USB hard disk broken
In-Reply-To: <46BCCADD.1040501@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708101639310.4845-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Dan Zwell wrote:

> Alan,
> 
> Yes, that patch worked, and dmesg now shows the device auto-suspending 
> and resuming every few seconds. Thanks a lot. I hope you do merge this 
> patch or a workaround like it.

I will submit it; we'll see whether anyone objects.

By the way, you can change the constant autosuspend and autoresume 
behavior easily enough.  All you have to do is:

	echo N >/sys/bus/usb/devices/.../power/autosuspend

where "..." is the path for the disk's USB device and N is the number
of seconds the disk should be idle before it gets autosuspended.  If
you use -1 for N then the disk will never autosuspend.

Alan Stern

