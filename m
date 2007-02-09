Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbXBIVpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbXBIVpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXBIVpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:45:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbXBIVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:45:30 -0500
Date: Fri, 9 Feb 2007 13:45:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070209134516.2367a7aa.akpm@linux-foundation.org>
In-Reply-To: <1171042535.29713.96.camel@pmac.infradead.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<1171042535.29713.96.camel@pmac.infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 17:35:35 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2007-02-08 at 15:07 -0800, Andrew Morton wrote:
> > lutimesat-simplify-utime2.patch
> > lutimesat-extend-do_utimes-with-flags.patch
> > lutimesat-actual-syscall-and-wire-up-on-i386.patch
> > 
> >  Do we want this?  Ulrich says so.  Will merge, I guess.
> 
> I would strongly recommend that in the general case, you don't merge new
> system calls unless the corresponding compat_ system call is
> implemented.

Good point.

> This makes sure that people adding system calls will design the API for
> the new system call appropriately, rather than trying to implement
> compat support as an afterthought and only then realising that they wish
> the original had been done differently. We've seen examples of this
> where it would have been _trivial_ to adjust the API slightly to make
> compat syscalls a non-issue, but the developer just didn't _think_ about
> it until the syscall was set in stone.
> 
> This new system call seems to need compat_ support but lacks it, so I
> would suggest you shouldn't merge it just yet.

OK, thanks.
