Return-Path: <linux-kernel-owner+w=401wt.eu-S938590AbXG1ADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938590AbXG1ADb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbXG1ADY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:03:24 -0400
Received: from neon.samage.net ([85.17.153.66]:44560 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbXG1ADX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:03:23 -0400
Message-ID: <50998.81.207.0.53.1185580999.squirrel@secure.samage.net>
In-Reply-To: <20070728013251.7c110223.grundig@teleline.es>
References: <200707272243.02336.a1426z@gawab.com>
    <1185568498.2711.5.camel@laptopd505.fenrus.org>
    <52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
    <1185573974.2711.8.camel@laptopd505.fenrus.org>
    <20070728013251.7c110223.grundig@teleline.es>
Date: Sat, 28 Jul 2007 02:03:19 +0200 (CEST)
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources 
     (was: updatedb)
From: "Indan Zupancic" <indan@nul.nu>
To: "grundig" <grundig@teleline.es>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Al Boldi" <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 729ef2e9e2cd27dd49f9ca04774c95e6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, July 28, 2007 01:34, grundig wrote:
> El Fri, 27 Jul 2007 15:06:14 -0700, Arjan van de Ven <arjan@infradead.org> escribi�:
>
>> how do you know there will be other activity? You start the IO and that
>> basically blacks out the disk for 5 to 10 ms. If the "real" IO gets
>> submitted in that time you add latency. You cannot predict that IO
>> happening or not happening.
>
> If there hasn't be much IO for some time, it looks quite reasonable to expect
> that there won't be more in the near future.

Good argument.

> As most of heuristics can fail, but
> then this is a feature mostly for desktops, not servers.

Bad argument. It doesn't matter for who the feature is intended, it matter
what it does and if it does it well or not. In this case, prefetching swap without
disturbing anything else.

> There's an old saying that says something like "an open source project starts
> dying when new people can't participate in the project no matter how hard
> they try". It's hard to understand why there's so many people opposing to
> this when other more controversial features are merged much faster, (like, fe.
> the UIO driver framework).

Could people please stop this emotional crap non-argumentation? At best it reduces
the chance of swap-prefetch to be merged.

Perhaps one of the reasons is that this is core kernel code. And that it isn't a new
feature, but a performance improvement with doubtful trade-offs. The problem
statement isn't clear either. It seems like a natural enhancement, but is that enough
reason to merge it? Maybe, maybe not. But if slow swap-in is the problem, shouldn't
that be fixed instead of bypassed?

Yes, there are people that say that it works for them, but of those a lot claim
updatedb damage is fixed by it too, while that can't be true. And how many of those
people did test swap prefetch stand-alone? The ck kernel has other mm patches too,
perhaps those are the real goodies...

And there don't seem to be many people opposing swap prefetch either. A bunch seem
in favour of it, and others seem unconvinced.

Me, I don't know if it should be merged or not, it solves one very specific workload, and
nothing else (swap is used, and memory becomes free which won't be used in the near
future). All in all it seems good, but doubtful, and when in doubt, don't merge.

Greetings,

Indan


