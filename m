Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZIJL2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZIJL2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZIJL2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:28:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:41016 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752618AbZIJL2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:28:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19pbpUEPxBpPsomcR03AKgC/pjJrEAriNy6D1+iQ6
	+osZBEZwQFp0ot
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nikos Chantziaras <realnc@arcor.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090910112443.GN18599@kernel.dk>
References: <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu>
	 <20090910064059.GA22646@elte.hu> <20090910095457.GD18599@kernel.dk>
	 <20090910100321.GA7922@elte.hu> <20090910101137.GH18599@kernel.dk>
	 <20090910102837.GJ18599@kernel.dk>
	 <1252580251.18659.10.camel@marge.simson.net>
	 <20090910110912.GL18599@kernel.dk>
	 <1252581670.18659.11.camel@marge.simson.net>
	 <20090910112443.GN18599@kernel.dk>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 13:28:28 +0200
Message-Id: <1252582108.18659.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 13:24 +0200, Jens Axboe wrote:
> On Thu, Sep 10 2009, Mike Galbraith wrote:

> > xmodmap doesn't seem to be running in this sample.
> 
> That's weird, it was definitely running. I did:
> 
> sleep 1; xmodmap .xmodmap-carl
> 
> in one xterm, and then switched to the other and ran the sched_debug
> dump. I have to do it this way, as X will not move focus once xmodmap
> starts running. It could be that xmodmap is mostly idle, and the real
> work is done by Xorg and/or xfwm4 (my window manager).

Hm.  Ok, I'll crawl over it, see if anything falls out.

	-Mike

