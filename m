Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbYBVH4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbYBVH4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYBVH4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:56:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37907 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbYBVH4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:56:15 -0500
Date: Fri, 22 Feb 2008 08:56:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       kay.sievers@vrfy.org, Michael_E_Brown@dell.com, rdreier@cisco.com,
       htejun@gmail.com
Subject: Re: [GIT PATCH] driver core fixes against 2.6.25-rc2 git
Message-ID: <20080222075625.GA2660@uranus.ravnborg.org>
References: <20080221234649.GB7128@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221234649.GB7128@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

On Thu, Feb 21, 2008 at 03:46:49PM -0800, Greg KH wrote:
> Here are a few driver core fixes against your current git tree that fix some
> more problems that have cropped up:
> 	- shutdown problem due to logic problem with cpufreq usage of
> 	  kobjects.
> 	- build fix for powerpc due to previous kobject changes.
> 	- runtime errors when CONFIG_SYSFS=n
> 	- UIO code now works properly from my previous messups
> 	- proper encoding of the ja_JP stable_kernel_rules.txt file
> 	- updates to the stable_kernel_rules.txt file
> 	- mark ide=reverse as obsolete in preparation of 2.6.26 (Bart
> 	  wanted this to go in through my tree as I have the .26 patches
> 	  pending.)
> 	- other minor fixes.


Do we have any outstanding issues with section mismatch warnings in PCI Core?
I am as always optimistic and hope to get down to zero warnings soon.

	Sam
