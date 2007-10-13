Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbXJMRbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbXJMRbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJMRbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:31:36 -0400
Received: from 1wt.eu ([62.212.114.60]:3096 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXJMRbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:31:35 -0400
Date: Sat, 13 Oct 2007 19:12:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: animesh saxena <animesh.saxena@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Compiling kernel 2.6.23.1 HELP
Message-ID: <20071013171202.GU10199@1wt.eu>
References: <20071004035935.042951211@sgi.com> <20071004040003.303112696@sgi.com> <1192293968.16391.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192293968.16391.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 10:16:08PM +0530, animesh saxena wrote:
> Hi,
>    I am a kernel newbie, so need some help trying to compile it. 
> I have fedora 7 installed. 
> 
> While compiling it, I get errors as follows.....
> 
>  HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c:107:23: error: sys/types.h: No such file or
> directory
> scripts/basic/fixdep.c:108:22: error: sys/stat.h: No such file or
> directory
> scripts/basic/fixdep.c:109:22: error: sys/mman.h: No such file or
> directory
> scripts/basic/fixdep.c:110:20: error: unistd.h: No such file or
> directory
> scripts/basic/fixdep.c:111:19: error: fcntl.h: No such file or directory
> scripts/basic/fixdep.c:112:20: error: string.h: No such file or
> directory
> scripts/basic/fixdep.c:113:20: error: stdlib.h: No such file or
> directory
> scripts/basic/fixdep.c:114:19: error: stdio.h: No such file or directory

It seems to me that you do not have glibc-devel or any other name it
can have on your distro. It's very likely that after that you will be
missing a few other development packages, but you'll quickly find them
one at a time.

(...)
> On many forums it said I need to have 2.4 kernel headers. I can't
> understand why is it so? Am I missing something?

Possibly that you will also need some random kernel-header-xxxx package,
I don't know how it's packaged. Install the libc headers first to see.

> I used git for getting the latest kernel. 
> 
> git-clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

If you're a newbie, you're not encouraged to try building GIT kernels.
They are *very* likely to break during build with nasty errors. You'd
better get the official releases in tar.bz2 form which are know to build
and work for most people.

> Is there something similar for getting kernel headers? Please help. 

not to my knowledge.

Regards,
Willy

