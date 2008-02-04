Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYBDPGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYBDPGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYBDPGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:06:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYBDPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:06:36 -0500
Date: Mon, 4 Feb 2008 07:04:50 -0800
From: Greg KH <greg@kroah.com>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080204150450.GB19611@kroah.com>
References: <e85b9d30802040343j13a0ec39if646740b0c26b7c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30802040343j13a0ec39if646740b0c26b7c6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 12:43:11PM +0100, Matthew wrote:
> Hi everybody,
> 
> >Over two years ago, the Linux USB developers stated that they believed
> >there was no way to create a USB kernel driver that was not under the
> >GPL.  This patch moves the USB apis to enforce that decision.
> 
> >There are no known closed source USB drivers in the wild, so this patch
> >should cause no problems.
> 
> hm, I'm not sure, but will your patch make Samsung's Unified Linux
> Driver for printing & scanning stop working?
> http://org.downloadcenter.samsung.com/downloadfile/ContentsFile.aspx?CDSite=DE&CttFileID=801111&CDCttType=DR&ModelType=N&ModelName=SCX-4521F&VPath=DR/200707/20070720165133984_UnifiedLinuxDriver.tar.gz

No, in looking at that package, I do not see any kernel modules, just
userspace programs.  They must be using the usbfs interface to the
kernel from userspace, a perfict example of how a vendor can control USB
device from userspace, without needing a kernel driver :)

So it should continue to work just fine.

> another Manufacturer / Candidate I'm worrying about is Brother:
> http://solutions.brother.com/linux/en_us/index.html
> Brother is providing opensource cups drivers (kudos to the developers
> @ Brother for that!), the sane-drivers however seem to be closed
> source, will those work ?

Both sane and cups are userspace programs, using usbfs and the kernel
usblp driver respectively, and should not see anything change at all.

> I'm no developer, just a heavy user ;) so unfortunately I can't tell
> whether those drivers are dependent on being NOT GPL,

You would be seeing some warnings in the kernel log for the past 2 years
when using these products, about how the symbols were going to be
changed in the future.  If not, you are fine.

thanks,

greg k-h
