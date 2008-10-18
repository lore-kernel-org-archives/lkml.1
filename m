Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbYJRKE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbYJRKE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 06:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYJRKEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 06:04:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59627 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYJRKEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 06:04:20 -0400
Date: Sat, 18 Oct 2008 13:04:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018100401.GA6535@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <20081018090117.GR24654@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081018090117.GR24654@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 11:01:18AM +0200, Willy Tarreau wrote:
> On Fri, Oct 17, 2008 at 11:56:04AM +0300, Adrian Bunk wrote:
>...
> > Building software in a chroot is a common thing if you don't want to 
> > setup a dedicated machine for a build environment (and all these hyped 
> > virtualization solutions tend to not support architectures like alpha
> > or parisc).
> 
> The chroot is OK when you want to maintain a few packages once in
> a while (eg: have it on your notebook to build packages for your
> customers' various distros). But it's not suited to maintain full
> distros,

You claim Debian was not a full distro?

> nor to cross-compile.

Scratchbox [1], e.g. used for building the software in Nokias Internet 
Tablets [2] or the ARM Linux Internet Platform [3], is a chrooted 
cross-compilation environment.

Yes, it works.

And since a few years everyone can buy devices running software built 
inside Scratchbox chroots.

> > The OpenSSL 0.9.8 config script is existing userspace, and it will 
> > break.
> 
> And ? All distros shipping version 0.9.8 with a current kernel will
> have no problem because they backport fixes only. Once the new kernel
> is out, openssl will release a minor update with a few fixes and features,
> one of them being tagged as "support for Linux 2.8 and above". New distros
> will then have no trouble shipping a standard openssl with a standard
> kernel. All software have always worked like this, I really don't see
> the problem Adrian.

Since Debian has a "support a release until one year after the next 
release" policy, Debian will at some point in the future build security 
fixes for OpenSSL 0.9.8g (shipped with Debian 5.0) in chroots on 
autobuilders running Debian 6.0 (runing kernel 2010.2.6).

> > That is one example that "Will" definitely break (no matter how broken 
> > or how easy to fix it is).
> 
> What makes you think that current 0.9.8g will work on 2.6.521 ?
>...

Userspace ABIs of the kernel are usually stable.

There might be special cases like the year 2038 problem, but usually 
breaking an ABI software like OpenSSL uses would be considered a grave 
regression. [4]

> Regards,
> Willy

cu
Adrian

[1] http://scratchbox.org/
[2] http://maemo.org/
[3] http://linux.onarm.com/
[4] note that the value of the kernel version number is not strictly
    a userspace ABI - but changing it in unexpected ways will break
    existing software

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

