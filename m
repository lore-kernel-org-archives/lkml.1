Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYJYFxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYJYFxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 01:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYJYFxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 01:53:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:60555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751164AbYJYFxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 01:53:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FO1t+Ps8Fx59C4MoT+LpvfjE5YsNQe4P6Leau4w
	3693nqOXUIEFzr
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20081024.221525.259940836.davem@davemloft.net>
References: <200810250025.35734.rjw@sisk.pl>
	 <20081024.163111.244324800.davem@davemloft.net>
	 <1224907501.5161.36.camel@marge.simson.net>
	 <20081024.221525.259940836.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 07:53:05 +0200
Message-Id: <1224913985.3822.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 22:15 -0700, David Miller wrote:
> From: Mike Galbraith <efault@gmx.de>
> Date: Sat, 25 Oct 2008 06:05:01 +0200
> 
> > My test data indicates (to me anyway) that there is another source of
> > localhost throughput loss in .27.  In that data, there is no hrtick
> > overhead since I didn't have highres timers enabled, and computational
> > costs added in .27 were removed.  Dunno where it lives, but it does
> > appear to exist.
> 
> Disabling TSO on loopback doesn't fix that bit for you?

No.  Those numbers are with TSO/GSO disabled.

I did a manual 100% sched and everything related revert to 26 scheduler,
and had ~the same result as these numbers.  27 with 100% revert actually
performed a bit _worse_ for me than 27 with it's overhead.. which
puzzles me greatly.

	-Mike

