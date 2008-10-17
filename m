Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYJQGsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYJQGsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJQGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:48:05 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43332 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYJQGsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:48:04 -0400
Date: Fri, 17 Oct 2008 09:47:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017064751.GE22554@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081017034717.GA28188@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:47:17PM -0700, Greg KH wrote:
> On Thu, Oct 16, 2008 at 07:46:02PM +0300, Adrian Bunk wrote:
> > On Thu, Oct 16, 2008 at 08:17:48AM -0700, Greg KH wrote:
> > > On Thu, Oct 16, 2008 at 03:49:43PM +0300, Adrian Bunk wrote:
> > >...
> > > > If a distribution will try to autobuild an urgent OpenSSL security 
> > > > update for their stable release in a chroot on a machine running
> > > > kernel 2009.2.3 they will surely love you for being responsible
> > > > for this...
> > > 
> > > Distros properly patch things and backport "urgent OpenSSL security
> > > updates" to older versions of packages, so they would not run into this
> > > problem.
> > 
> > You didn't get my point.
> > 
> > Let me make an example:
> > 
> > The current Debian release will be supported until one year after the
> > next release gets released.
> > 
> > Someone from the Debian security team send a fixed package to the
> > buildds.
> > 
> > The buildds build packages in chroots.
> > 
> > A buildd may run any Debian release.
> > 
> > And it's perfectly normal that a buildd runs a more recent release of 
> > Debian than the one a package gets built for in a chroot.
> 
> So you are saying the Debian build system would build a package for an
> older release, on a system that is newer,

Packages are built in a chroot with the correct release installed.

> and that build would be
> determining things based on the system it is built on, not what it is
> being built for?

No.

In the example I gave it is OpenSSL that parses the version number of 
the kernel.

> If so, then something is very broken already in the Debian build system
> and I think you have much bigger problems to worry about right now.
> 
> For all other "sane" build systems that I know of, you build against the
> libraries/kernel/gcc/glibc/etc that you are wanting to support it for,
> not against some random-whatever-happened-to-be-installed-on-the-box.

Building in a chroot is hardly "very broken".

And it does build against the correct
libraries/kernel headers/gcc/glibc/etc .

Did you ever use a chroot?


And this was just one example.

What does userspace with the kernel version returned by GDTIOCTL_OSVERS?
I don't know whether it just displays the number, or whether it 
determines anything based on it.

Or what else might parse the version number?

What if some proprietary userspace software like Skype or Flash or 
whatever parses the kernel version number at runtime and barfs on 
2009.2.3 in a way similar to the OpenSSL build system?

WHAT YOU SUGGEST WILL BREAK EXISTING USERSPACE SOFTWARE.

Please admit this fact.


>...
> Hope this helps,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

