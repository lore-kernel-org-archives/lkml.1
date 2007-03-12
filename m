Return-Path: <linux-kernel-owner+w=401wt.eu-S1030403AbXCLPdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030403AbXCLPdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030430AbXCLPdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:33:21 -0400
Received: from ns.suse.de ([195.135.220.2]:47395 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404AbXCLPdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:33:20 -0400
Date: Mon, 12 Mar 2007 08:31:50 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Message-ID: <20070312153150.GB29597@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F56A2D.9010808@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:56:45AM -0400, Mark Lord wrote:
> Still no improvement on the b0rken usb-serial resume support in -rc*.
> 
> Today I got this ooops on resume from RAM.
> Slightly tainted kernel this time (vmware), but not previously
> on similar crashes.  I cannot yet get it to "crash on demaind",
> so you'll just have to live with it this time.
> 
> All USB was dead until after a reboot this time.

What type of usb-serial device do you have plugged in?
Does userspace have it open when you suspend/resume?
Is vmware accessing the device?

thanks,

greg k-h
