Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXCYMBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXCYMBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXCYMBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:01:36 -0400
Received: from www.osadl.org ([213.239.205.134]:41223 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911AbXCYMBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:01:35 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070325111602.GB16988@elte.hu>
References: <20070323185028.GR752@stusta.de>
	 <1174679344.10840.334.camel@localhost.localdomain>
	 <20070325071023.GL17532@mellanox.co.il>
	 <1174808247.10840.467.camel@localhost.localdomain>
	 <20070325085705.GB24225@mellanox.co.il>
	 <1174817872.10840.478.camel@localhost.localdomain>
	 <20070325101548.GI24225@mellanox.co.il>
	 <1174818459.10840.481.camel@localhost.localdomain>
	 <20070325102543.GK24225@mellanox.co.il>
	 <1174819103.10840.484.camel@localhost.localdomain>
	 <20070325111602.GB16988@elte.hu>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 14:09:03 +0200
Message-Id: <1174824543.10840.496.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 13:16 +0200, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > Sorry, now I'm confused.
> > > Could you pls list the full set of tests you want me to run,
> > > and what information to collect from each of them?
> > 
> > 1. Test:
> 
> I suspect step 0 would be use Linus' latest tree, ontop of -rc4:
> 
>  http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-rc4-git11.bz2
> 
> to make sure all post-rc4 time fixes are included.

Ick, yes: The missing bits are here:

http://tglx.de/private/tglx/2.6.21-rc4-pending/acpi-pm-fix.patch

http://tglx.de/private/tglx/2.6.21-rc4-pending/fix-tsc-watchdog.patch

	tglx


