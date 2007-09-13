Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbXIMUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbXIMUcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984AbXIMUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:31:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57511 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932875AbXIMUb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:31:57 -0400
Date: Thu, 13 Sep 2007 16:31:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Adrian Bunk <bunk@kernel.org>
cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070913201910.GH3563@stusta.de>
Message-ID: <Pine.LNX.4.44L0.0709131629010.8150-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Adrian Bunk wrote:

> > Maybe you're concerned about propagating updates as painlessly as 
> > possible -- if the whitelist is in the kernel then every kernel release 
> > would include an update.  But in userspace it's possible to do updates 
> > even more quickly and painlessly.  For example, there could be a 
> > network server available for both interactive lookups and automatic 
> > queries from HAL.
> >...
> 
> No, what I'm concerned about is that this would require userspace for 
> something that is completely in-kernel.

But it isn't completely in-kernel.  It is policy, and policy belongs in 
userspace.

The kernel provides the mechanism for autosuspending idle devices and 
setting the idle-delay length.  But userspace must be responsible for 
deciding what devices to autosuspend and how long the idle delays 
should be.

Alan Stern

