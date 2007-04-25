Return-Path: <linux-kernel-owner+w=401wt.eu-S2993095AbXDYU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993095AbXDYU3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993097AbXDYU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:29:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49162 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993095AbXDYU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:29:19 -0400
Date: Wed, 25 Apr 2007 22:30:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
Message-ID: <20070425203009.GA15917@uranus.ravnborg.org>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com> <20070425120730.4c267c15.akpm@linux-foundation.org> <1177529517.6434.29.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177529517.6434.29.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > [sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig
> > >   HOSTCC  scripts/kconfig/lxdialog/checklist.o
> > > In file included from scripts/kconfig/lxdialog/checklist.c:24:
> > > scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file
> > > or directory
> > 
> > I guess you need to install the curses development package.  Here it's called
> > ncurses-devel.
check-lxdialog.sh should be extended to catch this case.
We can link but .h file is not present.
Will take a look at it later.

> There are general funnies in the menuconfig world (my preference) here.
> For instance, I recently had reason to change/test different default IO
> schedulers, and found that no matter what I did, I couldn't select a
> default IO scheduler any more, though I used to be able to do so.
Tried it now with latest -git from Linus and here it works.
Notice that you need to make the scheduler a built-in <*>
before you can select it as default.
A scheduler selected as a module <M> cannot be made default.

	Sam
