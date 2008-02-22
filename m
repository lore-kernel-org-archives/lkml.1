Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbYBVUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbYBVUHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbYBVUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:00:48 -0500
Received: from ns1.suse.de ([195.135.220.2]:50075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683AbYBVUAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:00:42 -0500
Date: Fri, 22 Feb 2008 11:56:52 -0800
From: Greg KH <gregkh@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       kay.sievers@vrfy.org, Michael_E_Brown@dell.com, rdreier@cisco.com,
       htejun@gmail.com
Subject: Re: [GIT PATCH] driver core fixes against 2.6.25-rc2 git
Message-ID: <20080222195652.GA6395@suse.de>
References: <20080221234649.GB7128@kroah.com> <20080222075625.GA2660@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222075625.GA2660@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 08:56:25AM +0100, Sam Ravnborg wrote:
> Hi Greg.
> 
> On Thu, Feb 21, 2008 at 03:46:49PM -0800, Greg KH wrote:
> > Here are a few driver core fixes against your current git tree that fix some
> > more problems that have cropped up:
> > 	- shutdown problem due to logic problem with cpufreq usage of
> > 	  kobjects.
> > 	- build fix for powerpc due to previous kobject changes.
> > 	- runtime errors when CONFIG_SYSFS=n
> > 	- UIO code now works properly from my previous messups
> > 	- proper encoding of the ja_JP stable_kernel_rules.txt file
> > 	- updates to the stable_kernel_rules.txt file
> > 	- mark ide=reverse as obsolete in preparation of 2.6.26 (Bart
> > 	  wanted this to go in through my tree as I have the .26 patches
> > 	  pending.)
> > 	- other minor fixes.
> 
> 
> Do we have any outstanding issues with section mismatch warnings in PCI Core?
> I am as always optimistic and hope to get down to zero warnings soon.

I do not know, I saw your patches earlier and thought that they were
going in through another tree for some reason.  If you still see any
remaining, please send me the needed patches again.

thanks,

greg k-h
