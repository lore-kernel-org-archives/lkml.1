Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXBIVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXBIVt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXBIVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:49:57 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4617 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbXBIVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:49:56 -0500
Date: Fri, 9 Feb 2007 21:49:44 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070209214944.GA16158@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Alexey Dobriyan <adobriyan@openvz.org>,
	linux-kernel@vger.kernel.org, drepper@redhat.com
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209134516.2367a7aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 01:45:16PM -0800, Andrew Morton wrote:
> On Fri, 09 Feb 2007 17:35:35 +0000
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Thu, 2007-02-08 at 15:07 -0800, Andrew Morton wrote:
> > > lutimesat-simplify-utime2.patch
> > > lutimesat-extend-do_utimes-with-flags.patch
> > > lutimesat-actual-syscall-and-wire-up-on-i386.patch
> > > 
> > >  Do we want this?  Ulrich says so.  Will merge, I guess.
> > 
> > I would strongly recommend that in the general case, you don't merge new
> > system calls unless the corresponding compat_ system call is
> > implemented.
> 
> Good point.
> 
> > This makes sure that people adding system calls will design the API for
> > the new system call appropriately, rather than trying to implement
> > compat support as an afterthought and only then realising that they wish
> > the original had been done differently. We've seen examples of this
> > where it would have been _trivial_ to adjust the API slightly to make
> > compat syscalls a non-issue, but the developer just didn't _think_ about
> > it until the syscall was set in stone.
> > 
> > This new system call seems to need compat_ support but lacks it, so I
> > would suggest you shouldn't merge it just yet.
> 
> OK, thanks.

urgh, new system calls... wonder if they fit in the ARM ABI...  Looks
fine.

Are there any other new syscalls sitting around in -mm ?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
