Return-Path: <linux-kernel-owner+w=401wt.eu-S1764986AbXHANdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764986AbXHANdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762522AbXHANdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:33:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4476 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762532AbXHANd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:33:28 -0400
Date: Wed, 1 Aug 2007 15:33:17 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andi Kleen <andi@firstfloor.org>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <p73wswfo0hf.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708011525560.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Andi Kleen wrote:

> > especially if one already knows that
> > scheduler clock has only limited resolution (because it's based on
> > jiffies), it becomes possible to use mostly 32bit values.
> 
> jiffies based sched_clock should be soon very rare. It's probably
> not worth optimizing for it.

I'm not so sure about that. sched_clock() has to be fast, so many archs 
may want to continue to use jiffies. As soon as one does that one can also 
save a lot of computational overhead by using 32bit instead of 64bit.
The question is then how easy that is possible.

bye, Roman
