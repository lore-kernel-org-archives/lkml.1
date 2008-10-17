Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYJQStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYJQStp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbYJQSst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:48:49 -0400
Received: from kroah.org ([198.145.64.141]:38538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755063AbYJQSss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:48:48 -0400
Date: Fri, 17 Oct 2008 10:45:06 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017174506.GG2221@kroah.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017085604.GA20986@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 11:56:04AM +0300, Adrian Bunk wrote:
> On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
> > On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
> >...
> > > Packages are built in a chroot with the correct release installed.
> > 
> > Then why would this break if they are being built against the correct,
> > older, kernel?
> 
> How could you build userspace "against a kernel"?
> 
> sys_*uname() returns the version of the running kernel.

Great, then why does the build system depend on the running kernel?
Doesn't that sound like a bug?

> > > > and that build would be
> > > > determining things based on the system it is built on, not what it is
> > > > being built for?
> > > 
> > > No.
> > > 
> > > In the example I gave it is OpenSSL that parses the version number of 
> > > the kernel.
> > 
> > The running kernel, with the expectation that this is the kernel it is
> > going to be running on after it is built, right?  Sounds like to ensure
> > this is correct, you better be building it on the kernel that you are
> > going to run it on, or its build process is broken.
> 
> I'm not even sure whether OpenSSL actually does anything with the 
> information: The script comes from the Apache foundation and
> claims to be "Similar to config.guess but much, much smaller."
> 
> BTW: Apache 1.3 seems to ship and use the same script.

Again, depending on the kernel the product is being built on, to
determine a build-time configuration, seems quite broken if you want to
do cross-compilation.

Or you just do native builds, on the kernel you expect to run the
product, and everyone is happy and there are no errors.

thanks,

greg k-h
