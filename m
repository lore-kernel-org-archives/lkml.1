Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbYJQEEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbYJQEEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYJQEEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:04:25 -0400
Received: from kroah.org ([198.145.64.141]:42896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbYJQEEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:04:24 -0400
Date: Thu, 16 Oct 2008 20:47:17 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017034717.GA28188@kroah.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016164602.GA22554@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 07:46:02PM +0300, Adrian Bunk wrote:
> On Thu, Oct 16, 2008 at 08:17:48AM -0700, Greg KH wrote:
> > On Thu, Oct 16, 2008 at 03:49:43PM +0300, Adrian Bunk wrote:
> >...
> > > If a distribution will try to autobuild an urgent OpenSSL security 
> > > update for their stable release in a chroot on a machine running
> > > kernel 2009.2.3 they will surely love you for being responsible
> > > for this...
> > 
> > Distros properly patch things and backport "urgent OpenSSL security
> > updates" to older versions of packages, so they would not run into this
> > problem.
> 
> You didn't get my point.
> 
> Let me make an example:
> 
> The current Debian release will be supported until one year after the
> next release gets released.
> 
> Someone from the Debian security team send a fixed package to the
> buildds.
> 
> The buildds build packages in chroots.
> 
> A buildd may run any Debian release.
> 
> And it's perfectly normal that a buildd runs a more recent release of 
> Debian than the one a package gets built for in a chroot.

So you are saying the Debian build system would build a package for an
older release, on a system that is newer, and that build would be
determining things based on the system it is built on, not what it is
being built for?

If so, then something is very broken already in the Debian build system
and I think you have much bigger problems to worry about right now.

For all other "sane" build systems that I know of, you build against the
libraries/kernel/gcc/glibc/etc that you are wanting to support it for,
not against some random-whatever-happened-to-be-installed-on-the-box.

> No matter what you claim, you suggest to break currently working setups.

No, you have described a broken setup.

Now for new releases, yes, something might have to be changed, but that
is when a sane distro would move to the newly named kernel, not
affecting any old releases at all.

Hope this helps,

greg k-h
