Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZBFVhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZBFVhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBFVhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:37:05 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52604 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZBFVhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:37:03 -0500
Date: Fri, 6 Feb 2009 13:37:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Message-ID: <20090206213701.GN10918@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090205180132.GJ6915@linux.vnet.ibm.com> <20090205183158.GA1969@Krystal> <20090205184456.GK6915@linux.vnet.ibm.com> <20090205202249.GA26964@Krystal> <20090205210415.GM6915@linux.vnet.ibm.com> <20090205210627.GA1313@Krystal> <20090206003308.GO6915@linux.vnet.ibm.com> <20090206020005.GA8560@Krystal> <20090206134833.GC10918@linux.vnet.ibm.com> <20090206200329.GA1824@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090206200329.GA1824@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 03:03:29PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Feb 05, 2009 at 09:00:05PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Thu, Feb 05, 2009 at 04:06:27PM -0500, Mathieu Desnoyers wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Thu, Feb 05, 2009 at 03:22:49PM -0500, Mathieu Desnoyers wrote:
> > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > On Thu, Feb 05, 2009 at 01:31:59PM -0500, Mathieu Desnoyers wrote:
> > > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > > > On Thu, Feb 05, 2009 at 09:52:16PM +0530, Trilok Soni wrote:
> > > > > > > > > > > Hi Paul,
> > > > > > > > > > > 
> > > > > > > > > > > On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
> > > > > > > > > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > > > > > > > > >>
> > > > > > > > > > > >> Are you using quilt to apply the patchset series file in the right order ?
> > > > > > > > > > > >
> > > > > > > > > > > > Ummm...  No.  I never have used quilt.
> > > > > > > > > > > >
> > > > > > > > > > > > Ah, there is a series file.  I guess it would not be too hard to make
> > > > > > > > > > > > an appropriate "sh" command:
> > > > > > > > > > > 
> > > > > > > > > > > How about trying?
> > > > > > > > > > > 
> > > > > > > > > > > #quilt push -a
> > > > > > > > > > 
> > > > > > > > > > Is the appropriate incantation as follows?
> > > > > > > > > > 
> > > > > > > > > > 	cd <top of git tree>
> > > > > > > > > > 	mkdir patches
> > > > > > > > > > 	cp /tmp/patch-2.6.29-rc3-lttng-0.92/* patches
> > > > > > > > > > 	quilt push -a
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Yes, exactly.
> > > > > > > > 
> > > > > > > > Whew!  ;-)
> > > > > > > > 
> > > > > > > > > And from there you can follow the LTTng manual here :
> > > > > > > > > 
> > > > > > > > > http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html
> > > > > > > > 
> > > > > > > > I get some fuzz and the following:
> > > > > > > > 
> > > > > > > > 	patching file kernel/trace/trace-clock-32-to-64.c
> > > > > > > > 	Patch attempted to create file kernel/trace/trace-clock-32-to-64.c,
> > > > > > > > 	which already exists.
> > > > > > > > 	Hunk #1 FAILED at 1.
> > > > > > > > 	1 out of 1 hunk FAILED -- rejects in file
> > > > > > > > 	kernel/trace/trace-clock-32-to-64.c
> > > > > > > > 
> > > > > > > > Should I be starting from somewhere other than v2.6.29-rc3?
> > > > > > > > 
> > > > > > > 
> > > > > > > Let's see it step by step, that should get us there.
> > > > > > > 
> > > > > > > With patches :
> > > > > > > 
> > > > > > > mkdir ~/lttng
> > > > > > > cd ~/lttng
> > > > > > > wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc3.tar.bz2
> > > > > > > wget http://lttng.org/files/lttng/patch-2.6.29-rc3-lttng-0.92.tar.bz2
> > > > > > > bzip2 -cd linux-2.6.29-rc3.tar.bz2 |tar xvof -
> > > > > > > bzip2 -cd patch-2.6.29-rc3-lttng-0.92.tar.bz2  |tar xvof -
> > > > > > > cd linux-2.6.29-rc3
> > > > > > > mkdir patches
> > > > > > > ln -s ../patch-2.6.29-rc3-lttng-0.92 patches
> > > > > > > quilt push -a
> > > > > > > 
> > > > > > > Does this work ?
> > > > > > 
> > > > > > Leaving out the "mkdir", yes.
> > > > > 
> > > > > Ah, yes, my mistake.
> > > > > 
> > > > > > My apologies -- I was forgetting that
> > > > > > "git reset --hard" doesn't get rid of untracked files.  I do see fuzz
> > > > > > in a few places, but hopefully this is non-fatal.  And in any case, I
> > > > > > can now make the patch required to actually try this out.  ;-)
> > > > > > 
> > > > > 
> > > > > Great !
> > > > > 
> > > > > Don't hesitate to ask if you have any question.
> > > > > 
> > > > > Mathieu
> > > > 
> > > > Fails to build on Power, so trying x86...  (Stock 2.6.29-rc3 does
> > > > build and boot, FWIW.)
> > > > 
> > > > Looks like misplaced file.
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > > ------------------------------------------------------------------------
> > > > 
> > > >   CHK     include/linux/version.h
> > > >   UPD     include/linux/version.h
> > > >   CHK     include/linux/utsrelease.h
> > > >   UPD     include/linux/utsrelease.h
> > > >   SYMLINK include/asm -> include/asm-powerpc
> > > >   HOSTCC  scripts/ihex2fw
> > > >   HOSTCC  scripts/kallsyms
> > > >   HOSTCC  scripts/pnmtologo
> > > >   HOSTCC  scripts/genksyms/genksyms.o
> > > >   HOSTCC  scripts/conmakehash
> > > >   HOSTCC  scripts/bin2c
> > > >   CC      scripts/mod/empty.o
> > > >   HOSTCC  scripts/mod/mk_elfconfig
> > > >   SHIPPED scripts/genksyms/lex.c
> > > >   SHIPPED scripts/genksyms/parse.h
> > > >   SHIPPED scripts/genksyms/keywords.c
> > > >   SHIPPED scripts/genksyms/parse.c
> > > >   HOSTCC  scripts/genksyms/parse.o
> > > >   HOSTCC  scripts/genksyms/lex.o
> > > >   MKELF   scripts/mod/elfconfig.h
> > > >   HOSTCC  scripts/mod/file2alias.o
> > > >   HOSTCC  scripts/mod/modpost.o
> > > >   HOSTCC  scripts/mod/sumversion.o
> > > >   HOSTLD  scripts/genksyms/genksyms
> > > >   HOSTLD  scripts/mod/modpost
> > > >   CC      kernel/bounds.s
> > > >   GEN     include/linux/bounds.h
> > > >   CC      arch/powerpc/kernel/asm-offsets.s
> > > > In file included from include/linux/module.h:18,
> > > >                  from include/linux/sysdev.h:25,
> > > >                  from include/linux/node.h:22,
> > > >                  from include/linux/swap.h:10,
> > > >                  from include/linux/suspend.h:7,
> > > >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > > > include/linux/immediate.h:15:27: error: asm/immediate.h: No such file or directory
> > > > In file included from include/linux/module.h:18,
> > > >                  from include/linux/sysdev.h:25,
> > > >                  from include/linux/node.h:22,
> > > >                  from include/linux/swap.h:10,
> > > >                  from include/linux/suspend.h:7,
> > > >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > > > include/linux/immediate.h:37: warning: â€˜struct __imvâ€™ declared
> > > > inside parameter list
> > > > include/linux/immediate.h:37: warning: its scope is only this definition
> > > > or declaration, which is probably not what you want
> > > > include/linux/immediate.h:40: warning: â€˜struct __imvâ€™ declared
> > > > inside parameter list
> > > > make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
> > > > make: *** [prepare0] Error 2
> > > > 02/05/2009-17:57:41 Build the kernel. Failed rc = 2
> > > > 02/05/2009-17:57:41 build: Building kernel... Failed rc = 1
> > > > 
> > > 
> > > Hrm, does the file
> > > 
> > > arch/powerpc/include/asm/immediate.h exist in your tree ?
> > > 
> > > Here, with the setup done following the commands I gave you (minus the
> > > mkdir patch), I get :
> > > 
> > > 
> > > compudj@ok:~$ head testpaulmck/linux-2.6.29-rc3/arch/powerpc/include/asm/immediate.h 
> > > #ifndef _ASM_POWERPC_IMMEDIATE_H
> > > #define _ASM_POWERPC_IMMEDIATE_H
> > > 
> > > /*
> > >  * Immediate values. PowerPC architecture optimizations.
> > >  *
> > >  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > >  *
> > >  * This file is released under the GPLv2.
> > >  * See the file COPYING for more details.
> > > 
> > > ....
> > > 
> > > Which defines struct __imv. So hrm, normally the header should be there.
> > > (/me still confused) :)
> > 
> > It does indeed, see the patch I generated against 2.6.29-rc3:
> > 
> > 	http://www.rdrop.com/users/paulmck/patches/2.6.29-rc3-ltt-1.patch
> > 
> > I get a similar failure on x86 -- perhaps my tools or build environment
> > does not match yours?
> > 
> 
> Maybe. If you want a quick and dirty solution, try :
> 
> CONFIG_IMMEDIATE=n
> 
> Immediate values are just an optimization, not necessary anyway.

K -- kicking it off.

						Thanx, Paul
