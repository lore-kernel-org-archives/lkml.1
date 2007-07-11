Return-Path: <linux-kernel-owner+w=401wt.eu-S1763242AbXGKVlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763242AbXGKVlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXGKVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:41:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38292 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752004AbXGKVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:41:14 -0400
Date: Wed, 11 Jul 2007 17:41:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [2.6.22-rc7] khubd NULL deref oops...
In-Reply-To: <6278d2220707111151o2b5f8b23ha14bf77be71b8b61@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707111734540.2718-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Daniel J Blueman wrote:

> > Try disabling CONFIG_USB_SUSPEND.  It makes lots of USB bugs go away
> 
> I'll give it a shot. For the record, I wasn't trying to perform a
> suspend at this time (or since booting).

I doubt that USB suspend has any connection with this problem.  It's
clear that the problem occurs in the driver core when the SCSI core
tries to unregister a device.  It's not directly related to USB at all.

In fact, it looks like the bug is connected with 
CONFIG_SYSFS_DEPRECATED.  You can try to see what happens with that 
switch disabled.

Alan Stern

