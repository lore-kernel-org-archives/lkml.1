Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYH3Fud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYH3Fud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYH3FuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:50:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38730 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYH3FuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:50:22 -0400
Date: Fri, 29 Aug 2008 23:50:08 -0600
From: "Brian G. Merrell" <bgmerrell@novell.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, gregkh@suse.de
Subject: Re: [patch 00/03] USB-IP patches
Message-ID: <20080830055007.GB3422@novell.com>
References: <20080828230016.GA15014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828230016.GA15014@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 04:00:16PM -0700, greg@kroah.com wrote:
> Here's 3 patches that adds USB-IP functionality code to the kernel tree.
> 
> It is against 2.6.27-rc4, and has been added to the -staging tree.  If
> there are no major objections, I'll also queue it up in the usb tree for
> submission into 2.6.28.
> 
> The code is based on Takahiro's great work that has been sitting outside
> of the kernel for many many years now.  Brian Merrell took the most
> recent version of the code, cleaned it up and sent it to me.  I did more
> cleanup and split the patch into 3 pieces, making it a bit easier to
> work with.
> 
> There are still a number of checkpatch.pl warnings/errors emitted, and
> Brian said he would work on them in the upcoming weeks, but they don't
> distract from the basic functionality and a good review would be nice to
> have.

I will indeed continue to work on getting rid of the checkpatch.pl
warnings/errors during the upcoming weeks.  I already eliminated the
ones I could figure out without too much effort;  I am sure the
remaining ones are trivial to many of you out there, so I welcome
any suggestions.

> 
> We do need some more documentation for how to use this code (you need
> the tools at usbip.sf.net), and how the sysfs files are exporting data
> to userspace.  Brian, can you write up the sysfs interface in the format
> that Documentation/ABI/ details and also provide some kind of basic
> HOWTO to include in the kernel source tree?

Yes, I would be happy to work on this.

> 
> thanks,
> 
> greg k-h

Thanks,
Brian G. Merrell
