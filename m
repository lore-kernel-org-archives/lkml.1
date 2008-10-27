Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYJ0TtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYJ0TtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYJ0TtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:49:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40459
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbYJ0TtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:49:11 -0400
Date: Mon, 27 Oct 2008 12:48:48 -0700 (PDT)
Message-Id: <20081027.124848.163119274.davem@davemloft.net>
To: zbr@ioremap.net
Cc: mingo@elte.hu, alan@lxorguk.ukuu.org.uk, jkosina@suse.cz,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rjw@sisk.pl, s0mbre@tservice.net.ru, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081027193933.GB2590@ioremap.net>
References: <20081027113306.5b1d5898@lxorguk.ukuu.org.uk>
	<20081027183312.GD11494@elte.hu>
	<20081027193933.GB2590@ioremap.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Mon, 27 Oct 2008 22:39:34 +0300

> On Mon, Oct 27, 2008 at 07:33:12PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > The moment there's real IO it becomes harder to analyze but the same 
> > basic behavior remains: the more unfair the IO scheduler, the "better" 
> > dbench results we get.
> 
> Right now there is no disk IO at all. Only quite usual network and
> process load.

I think the hope is that by saying there isn't a problem enough times,
it will become truth. :-)

More seriously, Ingo, what in the world do we need to do in order to get
you to start doing tbench runs and optimizing things (read as: fixing
the regression you added)?

I'm personally working on a test fibonacci heap implementation for
the fair sched code, and I already did all of the cost analysis all
the way back to the 2.6.22 pre-CFS days.

But I'm NOT a scheduler developer, so it isn't my responsibility to do
this crap for you.  You added this regression, why do I have to get my
hands dirty in order for there to be some hope that these regressions
start to get fixed?
