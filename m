Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXJCAjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXJCAjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXJCAj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:39:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbXJCAj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:39:27 -0400
Date: Tue, 2 Oct 2007 17:39:21 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build error
Message-ID: <20071002173921.4710a74b@oldman>
In-Reply-To: <20071002172827.b2f51626.randy.dunlap@oracle.com>
References: <20071002201213.GA5605@chaos.in-kiel.de>
	<20071002171942.047450fe@freepuppy.rosehill>
	<20071002172827.b2f51626.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 17:28:27 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 2 Oct 2007 17:19:42 -0700 Stephen Hemminger wrote:
> 
> > On Tue, 2 Oct 2007 22:12:13 +0200
> > linux-kernel@lebenslange-mailadresse.de wrote:
> > 
> > > [please CC: me, my subscribe mail was greylisted]
> > > 
> > > Morning!
> > > 
> > > My make run for 2.6.23-rc9 ends like this:
> > > 
> > >   GEN     .version
> > >   CHK     include/linux/compile.h
> > >   UPD     include/linux/compile.h
> > >   CC      init/version.o
> > >   LD      init/built-in.o
> > >   LD      .tmp_vmlinux1
> > > kernel/built-in.o: In function `getnstimeofday':
> > > (.text+0x1e141): undefined reference to `__udivdi3'
> > > kernel/built-in.o: In function `do_gettimeofday':
> > > (.text+0x1e263): undefined reference to `__udivdi3'
> > > kernel/built-in.o: In function `timekeeping_resume':
> > > timekeeping.c:(.text+0x1e427): undefined reference to `__udivdi3'
> > > kernel/built-in.o: In function `update_wall_time':
> > > (.text+0x1e829): undefined reference to `__udivdi3'
> > > kernel/built-in.o: In function `update_wall_time':
> > > (.text+0x1ec4c): undefined reference to `__udivdi3'
> > > make: *** [.tmp_vmlinux1] Error 1
> > > 
> > > .config attached.
> > > 
> > > I have already read the diff from -rc8 and found nothing that helped me.
> > > 
> > > Any ideas? Further questions?
> > > 
> > > Wilfried
> > > 
> > 
> > What Gcc version? and config/architecture?
> 
> .config file was attached.  It says X86_32.
> 
> I can't reproduce it on 2 different systems & toolchains.

There were earlier reports of gcc 4.3 bogus optimization:
  http://lkml.org/lkml/2007/5/18/355
