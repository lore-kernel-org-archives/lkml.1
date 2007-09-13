Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXIMUuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXIMUuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXIMUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:49:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997AbXIMUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:49:56 -0400
Date: Thu, 13 Sep 2007 13:44:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070913201910.GH3563@stusta.de>
Message-ID: <alpine.LFD.0.999.0709131341300.16478@woody.linux-foundation.org>
References: <20070913154019.GG3563@stusta.de>
 <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
 <20070913201910.GH3563@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Sep 2007, Adrian Bunk wrote:
> 
> No, what I'm concerned about is that this would require userspace for 
> something that is completely in-kernel.

If done right (and autosuspend now is), there is no "required" userspace.

If you want autosuspend, you just say so. The kernel doesn't do it by 
default. This is not about "user space required" - it's about "user space 
can ask for it if it wants to".

Notice? There doesn't even have to be any blacklists/whitelists at all. It 
really can be just an application that allows the user to check or uncheck 
the capability (with a warning saying something like: "Some USB devices 
may disconnect when suspended - if this affects you, uncheck this").

That's why the kernel shouldn't set policy. It's a *good* thing to just 
expose the capabilities, but not necessarily use them! 

		Linus
