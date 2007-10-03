Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXJCA34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXJCA34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJCA3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:29:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17144 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbXJCA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:29:48 -0400
Date: Tue, 2 Oct 2007 17:28:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build error
Message-Id: <20071002172827.b2f51626.randy.dunlap@oracle.com>
In-Reply-To: <20071002171942.047450fe@freepuppy.rosehill>
References: <20071002201213.GA5605@chaos.in-kiel.de>
	<20071002171942.047450fe@freepuppy.rosehill>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 17:19:42 -0700 Stephen Hemminger wrote:

> On Tue, 2 Oct 2007 22:12:13 +0200
> linux-kernel@lebenslange-mailadresse.de wrote:
> 
> > [please CC: me, my subscribe mail was greylisted]
> > 
> > Morning!
> > 
> > My make run for 2.6.23-rc9 ends like this:
> > 
> >   GEN     .version
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > kernel/built-in.o: In function `getnstimeofday':
> > (.text+0x1e141): undefined reference to `__udivdi3'
> > kernel/built-in.o: In function `do_gettimeofday':
> > (.text+0x1e263): undefined reference to `__udivdi3'
> > kernel/built-in.o: In function `timekeeping_resume':
> > timekeeping.c:(.text+0x1e427): undefined reference to `__udivdi3'
> > kernel/built-in.o: In function `update_wall_time':
> > (.text+0x1e829): undefined reference to `__udivdi3'
> > kernel/built-in.o: In function `update_wall_time':
> > (.text+0x1ec4c): undefined reference to `__udivdi3'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > .config attached.
> > 
> > I have already read the diff from -rc8 and found nothing that helped me.
> > 
> > Any ideas? Further questions?
> > 
> > Wilfried
> > 
> 
> What Gcc version? and config/architecture?

.config file was attached.  It says X86_32.

I can't reproduce it on 2 different systems & toolchains.

---
~Randy
