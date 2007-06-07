Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXFGF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXFGF7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 01:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXFGF7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 01:59:30 -0400
Received: from waste.org ([66.93.16.53]:58167 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXFGF73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 01:59:29 -0400
Date: Thu, 7 Jun 2007 00:59:13 -0500
From: Matt Mackall <mpm@selenic.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607055912.GX11166@waste.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606161936.GA8952@localhost.localdomain> <20070606110931.fda845de.akpm@linux-foundation.org> <20070607022608.GA2416@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607022608.GA2416@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 10:26:09AM +0800, WANG Cong wrote:
> On Wed, Jun 06, 2007 at 11:09:31AM -0700, Andrew Morton wrote:
> >On Thu, 7 Jun 2007 00:19:36 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:
> >
> >> On Wed, Jun 06, 2007 at 02:07:37AM -0700, Andrew Morton wrote:
> >> >
> >> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >> >
> >> >- Somebody broke it on my powerpc G5, but I didn't have time to do yet
> >> >  another bisection yet.
> >> >
> >> 
> >> It seems strange that a new C source file (mlguest.c) appears in the top dir of the 
> >> kernel source. There are some problems with it.
> >> 
> >> First, I used `make mlguest.o` to compile that file, but I got tons of warnings and errors.
> >> (Too many to put here.) What's wrong with it? Or I didn't compile/configure it correctly?
> >> 
> >> Second, mlguest.c #includes a head file named "../../include/linux/lguest_launcher.h".
> >> Since mlguest.c is in the top dir, so where is ../../include/linux/lguest_launcher.h?
> >> 
> >
> >Confused.  I've grepped the entire universe here for "mlguest" and came up
> >with nothing.
> >
> >I don't have a clue where that file came from on your system.
> 
> 
> I used 'ketchup' to update my kernel from -rc3 to -rc4-mm1. I got the follow:
> 
> [wangcong@localhost linux-2.6.22-rc4-mm1]$ ls
> arch     Documentation  ipc          Makefile        README          System.map
> block    drivers        Kbuild       mlguest.c       REPORTING-BUGS  usr
> COPYING  fs             kernel       mm              scripts         vmlinux
> CREDITS  include        lib          Module.symvers  security
> crypto   init           MAINTAINERS  net             sound
> 
> Maybe there's something wrong with ketchup. ;(

Can you do an 'lsdiff | grep lguest' on the patch in your ~/.ketchup directory?

Ketchup simply applies patches, it never touches filenames directly.
So for something to go wrong here and drop a file in the tree with a
damaged pathname, you've either got a damaged patch, a bug in patch
itself, or some form of filesystem corruption.

-- 
Mathematics is the supreme nostalgia of our time.
