Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYECXW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYECXW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYECXWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:22:49 -0400
Received: from www.tglx.de ([62.245.132.106]:56311 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbYECXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:22:48 -0400
Date: Sun, 4 May 2008 01:22:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
In-Reply-To: <20080503212429.GT5838@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805040018420.6003@apollo.tec.linutronix.de>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi>
 <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Adrian Bunk wrote:
> > at minimum a warning needs to be emitted by the kconfig tool if such 
> > incomplete selects are used. I've stopped counting the number of times 
> > such issues have broken the build and have held up kernel development. 
> 
> It might held up your randconfig compiles.
> 
> Actual kernel development isn't much affected.

Interesting. You confidently define how kernel development works and
what affects it and what not. 

I just caught a build wreckage via randconfig builds on a patch which
was sent through Andrew to x86 for merging into mainline.

So you think that we should stop sharing with the wider kernel
community the fixes that result out of our automated randconfig builds
and should instead wait for Joe User or another kernel developer to
trip into some subtle missing Kconfig dependency, just because a fix
might not be the right one and might need another iteration before it
can go upstream?

You are wrong as usual.

I for one prefer getting a (even wrong) patch which points to the
problem instead of some (often grumpy) "this broke" message.

> Before you started your randconfig builds and sending (often buggy) 
> kconfig patches like crazy there wasn't a problem (and Toralf's 
> randconfig builds already catched these problems in the past).

FYI, Ingo has been doing randconfig build and boot tests for a long,
long time. There are dozens and dozens of (non-build) fixes in the
upstream kernel that resulted from that effort - it's really valuable
in practice.

So what you say is complete nonsense.

The RDC subarch commit was buggy, but that does not justify your
insulting and self-righteous behaviour at all. If you think that your
behaviour vs. Ingo is improving kernel development, then you are on
the completely wrong track. It might earn you an entry in his
killfile, but nothing else.

Thanks,

	tglx
