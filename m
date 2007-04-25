Return-Path: <linux-kernel-owner+w=401wt.eu-S1030853AbXDYTcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853AbXDYTcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030998AbXDYTcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:32:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:51423 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030853AbXDYTcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:32:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19/mtVX5QZ/mlPLYMYE3gHR+IlcXlprA2l8gcrMzV
	BJZCy0tDlcRTxb
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070425120730.4c267c15.akpm@linux-foundation.org>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
	 <20070425120730.4c267c15.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 21:31:57 +0200
Message-Id: <1177529517.6434.29.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 12:07 -0700, Andrew Morton wrote:
> On Wed, 25 Apr 2007 19:54:14 +0530 "Sunil Naidu" <akula2.shark@gmail.com> wrote:
> 
> > I was trying to compile those kernels with make menuconfig. I am
> > getting the error in scripts/kconfig/lxdialog/checklist.o. Here is the
> > output:
> > 
> > [sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig
> >   HOSTCC  scripts/kconfig/lxdialog/checklist.o
> > In file included from scripts/kconfig/lxdialog/checklist.c:24:
> > scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file
> > or directory
> 
> I guess you need to install the curses development package.  Here it's called
> ncurses-devel.

There are general funnies in the menuconfig world (my preference) here.
For instance, I recently had reason to change/test different default IO
schedulers, and found that no matter what I did, I couldn't select a
default IO scheduler any more, though I used to be able to do so.  If I
totally whack my .config, i.e. use default config, I still _can't
select_.  If I take my current .config back to a kernel where I could
select (a 2.6.16 tree i still have lying about) I can't select either,
but with the config I had at the time, I could/can select just fine.  If
I use xconfig (don't really like, but...) I can select, and a manual
edit would likely also work just fine.

Box is P4, with SuSe 10.2.. haven't had time to see if maybe there's
some weird userland ncurses problem.  Just a note in case others are
seeing problems in this area.   Not much of a bug report I know, but
maybe useful for readers and those who keep strange events in the backs
of their minds ;)

	-Mike

