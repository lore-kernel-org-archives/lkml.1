Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbXHBXXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbXHBXXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXHBXXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:23:00 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3727 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbXHBXXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:23:00 -0400
Date: Fri, 3 Aug 2007 01:23:04 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708030041021.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0708011525560.1817@scrub.home>
 <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Linus Torvalds wrote:

> So I think it would be entirely appropriate to
> 
>  - do something that *approximates* microseconds.
> 
>    Using microseconds instead of nanoseconds would likely allow us to do 
>    32-bit arithmetic in more areas, without any real overflow.

The basic problem is that one needs a number of bits (at least 16) for 
normalization, which limits the time range one can work with. This means 
that 32 bit leaves only room for 1 millisecond resolution, the remainder 
could maybe saved and reused later.
So AFAICT using micro- or nanosecond resolution doesn't make much 
computational difference.

bye, Roman
