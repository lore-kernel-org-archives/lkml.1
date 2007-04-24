Return-Path: <linux-kernel-owner+w=401wt.eu-S1422774AbXDXQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422774AbXDXQk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422772AbXDXQk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:40:59 -0400
Received: from waste.org ([66.93.16.53]:45852 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422774AbXDXQk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:40:58 -0400
Date: Tue, 24 Apr 2007 11:23:00 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ray Lee <ray@madrabbit.org>
Cc: Nick Piggin <npiggin@suse.de>, ray-gmail@madrabbit.org,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
Message-ID: <20070424162300.GC11115@waste.org>
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com> <20070420040933.GA2392@wotan.suse.de> <462E273C.7050607@madrabbit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462E273C.7050607@madrabbit.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 08:50:20AM -0700, Ray Lee wrote:
> > Firstly, lots of clients in your list are remote. X usually isn't.
> 
> They really aren't, unless you happen to work somewhere that can afford
> to dedicate a box to a db, which suddenly makes the scheduler a dull
> topic.
> 
> For example, I have a db and web server installed on my laptop, so
> that the few times that I have to do web app programming (while wearing
> a mustache and glasses so that I don't have to admit to it in polite
> company), I can be functional with just one computer.

Indeed. The vast majority of people doing "LAMP" web services are
doing it on a single machine. Or VM for that matter.

It seems that this is a lot like the priority inheritance problem. If
a nice -19 process blocks on the db running at nice 0, the db ought to
get a boost until it wakes the original process up. The same should
apply at the level of dynamic priorities at the same nice level.

-- 
Mathematics is the supreme nostalgia of our time.
