Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbYJZJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbYJZJQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 05:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJZJPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 05:15:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:45753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751041AbYJZJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 05:15:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19PoN5Z88BPYHEBO8P3k+I/5GV7/+kK2kIw8eGCGi
	whY+sXIkNwXJvD
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jkosina@suse.cz>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, s0mbre@tservice.net.ru,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1225011648.27415.4.camel@twins>
References: <20081024.221653.23695396.davem@davemloft.net>
	 <1224914333.3822.18.camel@marge.simson.net>
	 <1224917623.4929.15.camel@marge.simson.net>
	 <20081025.002420.82739316.davem@davemloft.net>
	 <Pine.LNX.4.64.0810260055070.22126@twin.jikos.cz>
	 <1225010790.8566.22.camel@marge.simson.net>
	 <1225011648.27415.4.camel@twins>
Content-Type: text/plain
Date: Sun, 26 Oct 2008 10:15:46 +0100
Message-Id: <1225012546.8566.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-26 at 10:00 +0100, Peter Zijlstra wrote:
> On Sun, 2008-10-26 at 09:46 +0100, Mike Galbraith wrote: 

> > I reproduced this on my Q6600 box.  However, I also reproduced it with
> > 2.6.22.19.  What I think you're seeing is just dbench creating a
> > massive train wreck. 
> 
> wasn't dbench one of those non-benchmarks that thrives on randomness and
> unfairness?
> 
> Andrew said recently:
>   "dbench is pretty chaotic and it could be that a good change causes
> dbench to get worse.  That's happened plenty of times in the past."
> 
> So I'm not inclined to worry too much about dbench in any way shape or
> form.

Yeah, I was just curious.  The switch rate of dbench isn't high enough
for math to be an issue, so I wondered how the heck CFS could be such a
huge problem for this load.  Looks to me like all the math in the
_world_ couldn't hurt.. or help.

	-Mike

