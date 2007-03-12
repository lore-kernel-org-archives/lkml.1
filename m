Return-Path: <linux-kernel-owner+w=401wt.eu-S1030512AbXCLQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030512AbXCLQLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXCLQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:11:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030512AbXCLQLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:11:43 -0400
Date: Mon, 12 Mar 2007 09:10:16 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Message-ID: <20070312161016.GA463@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com> <45F579CF.7040802@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F579CF.7040802@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:03:27PM -0400, Mark Lord wrote:
> Greg KH wrote:
> >..
> >And all of those fixes Oliver is referring to should be in anything
> >older than 2.6.21-rc3-git6.
> 
> Did you mean, "anything *newer* than -git6" ??

Oops, yes, I ment "newer", sorry.

> This last crash was with -git4.  I'm building -git7 now.

Ah, ok, there's still hope, Oliver's patches didn't go into -git4.

> >Does userspace have it open when you suspend/resume?
> 
> For the ooops I just posted, yes, I may have left Linux ckermit
> running on the serial port before the suspend.
> 
> We shouldn't be oopsing regardless, but perhaps that could help
> narrow things down a bit.
> 
> I'll also retest the simple plug-unplug-oops crash reported earlier,
> once I have rc3-git7 up and running.

thanks, but again, which usb-serial device do you have running here?

greg k-h
