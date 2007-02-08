Return-Path: <linux-kernel-owner+w=401wt.eu-S1422752AbXBHFvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422752AbXBHFvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422763AbXBHFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:51:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422752AbXBHFvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:51:17 -0500
Date: Wed, 7 Feb 2007 21:50:08 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
Message-ID: <20070208055008.GA13270@kroah.com>
References: <1170897212.7070.15.camel@lade.trondhjem.org> <Pine.LNX.4.64.0702071924570.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071924570.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 07:28:19PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Feb 2007, Trond Myklebust wrote:
> >
> > The latest pull from the git tree spews out a torrent of the above
> > warning on a recent Fedora Core 6 machine running gcc-4.1.1. config file
> > is attached...
> 
> Should hopefully be fixed already in current -git

It is, but now I'm getting this warning instead all over the place:
  CC      init/initramfs.o
In file included from include/asm/thread_info.h:17,
                 from include/linux/thread_info.h:22,
                 from include/linux/preempt.h:10,
                 from include/linux/spinlock.h:50,
                 from include/linux/capability.h:46,
                 from include/linux/sched.h:47,
                 from arch/i386/kernel/time.c:35:
include/asm/processor.h: In function 'cpuid_count':
include/asm/processor.h:611: warning: pointer targets in passing argument 1 of 'native_cpuid' differ in signedness
include/asm/processor.h:611: warning: pointer targets in passing argument 2 of 'native_cpuid' differ in signedness
include/asm/processor.h:611: warning: pointer targets in passing argument 3 of 'native_cpuid' differ in signedness
include/asm/processor.h:611: warning: pointer targets in passing argument 4 of 'native_cpuid' differ in signedness


I'm using gcc 4.1.1 here if that matters any...

thanks,

greg k-h
