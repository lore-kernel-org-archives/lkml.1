Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYENVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYENVBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYENVBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:01:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311AbYENVBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:01:30 -0400
Date: Wed, 14 May 2008 14:00:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc2-mm1
Message-Id: <20080514140032.83fc25b7.akpm@linux-foundation.org>
In-Reply-To: <1210798147.4234.5.camel@localhost>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<1210798147.4234.5.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 14:49:07 -0600
Zan Lynx <zlynx@acm.org> wrote:

> On Wed, 2008-05-14 at 01:01 -0700, Andrew Morton wrote: 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
> > 
> > 
> > - The -mm tree is now based on linux-next.
> > 
> >   I will occasionally pick up later versions of trees which are already
> >   in linux-next, to catch material which was added after Stephen last
> >   pulled that tree.  That happened this time: git-net had a lot of driver
> >   changes which weren't in linux-next and which I wanted in
> >   2.6.26-rc2-mm1.
> > 
> > - A few more git trees were added: git-ubifs.patch, git-regulator.patch,
> >   git-logfs.patch, git-orion.patch.
> 
> No good on my first attempt.  Here is what I ran into:
> 
> The printk timestamps have gone wild.  I cannot paste a dmesg but here
> is one line I wrote down:
> [17180644.495790] Testing tracer ftrace: NMI watchdog ...

I've seen reports like this against mainline, but I'm not sure that
much has been done about it yet.

> Which leads into the next problem: The kernel freezes after Testing
> tracer ftrace.  Then I rebooted with my special testing command line
> "kernel /bzImage-2.6.26-rc2-mm1 root=/dev/sda2 rootfstype=reiser4
> rootflags=defaults,noatime i8042.nomux elevator=cfq resume=/dev/sda3
> panic=5 nmi_watchdog=2,panic debug idle=poll nohz=off"
> 
> and I got the same freeze but then the NMI watchdog message.  Which is
> the third problem.
> 
> Why did the NMI watchdog not panic and reboot the system?  It detected
> the lock and printed the message.  It should have then panicked, waited
> 5 seconds, and rebooted.
> 
> System is a 64-bit Gentoo AMD-64 Compaq R3000 laptop.  Compiler is GCC
> 4.3.

afaict this is all Ingo/Thomas stuff, so I'll add the ccs and run away :(

> Config follows:

Thanks.
