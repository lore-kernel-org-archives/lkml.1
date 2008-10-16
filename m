Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYJPQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYJPQqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYJPQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:46:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58449 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYJPQqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:46:12 -0400
Date: Thu, 16 Oct 2008 19:46:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016164602.GA22554@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081016151748.GA31075@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:17:48AM -0700, Greg KH wrote:
> On Thu, Oct 16, 2008 at 03:49:43PM +0300, Adrian Bunk wrote:
>...
> > If a distribution will try to autobuild an urgent OpenSSL security 
> > update for their stable release in a chroot on a machine running
> > kernel 2009.2.3 they will surely love you for being responsible
> > for this...
> 
> Distros properly patch things and backport "urgent OpenSSL security
> updates" to older versions of packages, so they would not run into this
> problem.

You didn't get my point.

Let me make an example:

The current Debian release will be supported until one year after the
next release gets released.

Someone from the Debian security team send a fixed package to the
buildds.

The buildds build packages in chroots.

A buildd may run any Debian release.

And it's perfectly normal that a buildd runs a more recent release of 
Debian than the one a package gets built for in a chroot.

No matter what you claim, you suggest to break currently working setups.

> Newer releases would run into this problem, but as almost all distros
> have huge, easy to run, build systems, a change like this would show up
> immediately and be fixed in a matter of hours, with the needed fixes
> being pushed upstream to the various packages as needed.
> 
> So I really don't think this is much of a problem.
>...

Using the same logic we could drop all legacy userspace ABIs
immediately - after all, it should only be a matter of hours
for a distribution to e.g. upgrade their glibc to 2.8 ...

You cannot suggest to change something that is some kind of informal 
userspace ABI and the claim it was not much of a problem.

I don't know what exactly would break, but various places in userspace 
would break in perhaps unexpected and strange ways, and this would cause 
many people quite a bit of headaches and work.

And I don't see any *really* good reason that would justify such
a change in the versioning.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

