Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbXIMQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbXIMQcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXIMQcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:32:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:44081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXIMQco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:32:44 -0400
Date: Thu, 13 Sep 2007 09:34:05 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070913163405.GA8325@suse.de>
References: <20070913154019.GG3563@stusta.de> <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 12:07:15PM -0400, Alan Stern wrote:
> You _can't_ change the autosuspend setting for a device that hasn't yet
> been detected; you can only do it after detection.  But you _can_
> modify a whitelist either before or after a device is detected; any
> such modifications won't affect the already-existing devices.

Exactly.  The kernel will by default get the device up and working.  Any
capabilities to be changed after it is working can be done by userspace
with a "whitelist" type program that can properly tell the kernel that
this specific device can be safely suspended.

If you decide to do this in a small bash script, or in
HAL/udevd/DeviceKit/whatever, it all doesn't matter to the kernel.

thanks,

greg k-h
