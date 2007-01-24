Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXAXD01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXAXD01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030229AbXAXD01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:26:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:4858 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbXAXD00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:26:26 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070123182306.34e90711.akpm@osdl.org>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070123182306.34e90711.akpm@osdl.org>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 19:25:09 -0800
Message-Id: <1169609109.19471.147.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 18:23 -0800, Andrew Morton wrote:

> > There appears to be some fairly clear duplication between my clocksource
> > tree and this release of high resolution timers. Not to mention that we
> > both submitted our tree's to Andrew within days . 
> > 
> > To lessen Andrews burden it would be wise to integrate the two trees
> > prior to anything going into -mm .. It makes sense to eliminate this
> > kind of duplication since it just results in wasted effort. With the
> > benefit that the merge would likely result in a stronger patch set over
> > all.
> > 
> 
> There's also the question of testing status.  We know that the dynticks
> patches in -mm mostly work.  Now that they appear to have been largely respun,
> we don't know that any more.  Then if we go adding more stuff on top, problem
> identification becomes harder.

My code is fairly stable and reviewed, for a couple months .. It also
goes on -mm without this new high res/dynamic tick patches.. So you
could accept that set while HRT stabilizes, and gets merged with my
stuff. I wouldn't be pushing for my changes to go into 2.6.20 , but I
think they could.

There is more collision from parts of my patch set which haven't been
submitted to you. It's the clocksource->flags introduction in this new
high res/dynamic tick patch set. I'd NAK those just because I'm not
convinced they're well thought out, and since they make changes to
several arch clocksources reverting them later wouldn't be to fun.

> I thought that dynticks/hrtimers was a done thing: in fact $certain_people wanted
> them in 2.6.20.  The late-breaking rip-up-and-rewrite was rather unwelcome.  But
> I haven't got onto reading the patchset yet.

I haven't review it all either, but I was rather surprised to see such
extensive changes this late. The -mm version was getting pretty mature
too..

Daniel

