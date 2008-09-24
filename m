Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYIXOt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYIXOt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYIXOtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:49:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55427 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752043AbYIXOtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:49:49 -0400
Date: Wed, 24 Sep 2008 10:49:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
In-Reply-To: <48DA1CA5.20409@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809241047500.2650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Jiri Slaby wrote:

> >> pm_op(): pci_pm_suspend+0x0/0xd0 returns -16
> >> PM: Device 0000:00:1d.0 failed to suspend: error -16
> >> PM: Some devices failed to suspend
> > 
> > The reason for this error is that the root hub wasn't already 
> > suspended.  Was there a USB device plugged into that controller?
> 
> No:

> > If you still run into problems, post more of the dmesg log (with 
> > CONFIG_USB_DEBUG enabled, of course!).
> 
> Hm, it doesn't work. 2 dmesgs from mmotm 2008-09-10-19-39 (without usb debug)
> [ok] and -rc6+gkh-all (with usb debug) [fail]:
> http://decibel.fi.muni.cz/~xslaby/dmesg_fail.hcd
> http://decibel.fi.muni.cz/~xslaby/dmesg_ok.hcd

In fact neither of those logs includes USB debugging messages.  Maybe
you omitted a mkinitrd step.

Alan Stern

