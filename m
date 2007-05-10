Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXEJSwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXEJSwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXEJSwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:52:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXEJSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:51:59 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v11
Date: Thu, 10 May 2007 20:51:09 +0200
User-Agent: KMail/1.9.6
References: <20070508150431.GA26977@elte.hu> <200705101859.11696.christiand59@web.de> <1178817044.25266.8.camel@localhost>
In-Reply-To: <1178817044.25266.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705102051.09432.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX18V+djRcOJZvbwz6jeVkc0JT3o+8eil2w0dg7P
 qVogc4ikXifqxQCj6Uh8YGGu9xnjxPLrA9S6WJQb7pmI4KfgUH
 rRwogwAah00Gm1sQbbnEw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 19:10:44 Kasper Sandberg wrote:
> On Thu, 2007-05-10 at 18:59 +0200, Christian wrote:
> > Hello lkml, hello Ingo!
> >
> > I've been using CFS-v10 for a few days and I must say that I'm verry
> > impressed ;-)
> >
> > Desktop performance without any manual renicing is excellent, even with
> > make -j20. Gaming performance is at least on par with SD now! I've tried
> > to
>
> Which games are you trying? and have you tried other workloads then make
> -j20?
>
> try have a window with some 3d game open, and a browser besides it, and
> press a link. i cant seem to get smooth results with CFS.
>
> Perhaps i could also conduct tests with the games you are trying on my
> hardware.
>
> > change the sched_load_smoothing config to "8" but there is no visible
> > difference when it's set to "7".
> >
> > Both schedulers are verrry good! I can't really tell which one is better.
> > I noticed that while compiling a kernel (with -j4) my CPU temperature is
> > two to three degrees hotter than with mainline. I have not done any
> > timing tests, but I suspect that it's a little faster while preserving
> > excellent desktop usability. Great work!! :-)
> >
> > -Christian
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

I've tried many different workloads, kernel compile (normal -j4), extreme 
kernel compile (-j20) and Browsing/Open Office. GLXGears, Briquolo and 
enemy-territory work relly well under these loads.

I just tried another test with "nice make -j20" and I see latency blips while 
gaming. SD did not have this. Latencies with nice are _worse_ than latencies 
without nice on my system. Playing with sched_load_smoothing does not change 
anything. (I've tested values in the range 1-10)

-Christian
