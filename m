Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZAEEkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZAEEkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZAEEk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:40:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35810 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZAEEk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:40:26 -0500
Date: Sun, 4 Jan 2009 20:40:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
Message-ID: <20090105044023.GC8080@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com> <49604E19.8040502@cn.fujitsu.com> <20090104194851.GM6958@linux.vnet.ibm.com> <496174EB.4030601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496174EB.4030601@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:48:11AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > 
> > In any case, I do apologize -- since I didn't see anything from you I
> > incorrectly assumed that you had given up on this patch.  Please accept
> > my apologies!
> 
> It's my fault.
> 
> I'm a very low-yield developer.

Well, I am certainly not the highest-yield developer around, and I have
probably put in at least 30,000 hours of programming over the past 35
years, and probably half of those between 1981 and 1985.  Of course,
a fair fraction of those hours were in languages and environments that
are pretty much irrelevant these days.  Nevertheless, my guess is that
you need to invest about 10,000 hours to really master programming, which
works out to about five years at 40 hours per week of doing nothing but
designing, coding, and debugging.

So please don't give up!

> I have given up on unaccepted cleanup-patches, kfree_rcu() is not a
> cleanup for reducing lines of code, it has some significances for kernel.

I agree that it would be a nice addition.

> > Would it be possible for you and Manfred to agree on a common patch, and
> > to have one of you submit it with both of you having Signed-off-by on it?
>
> All are OK.
> 
> I NAK-ed only for deferring kfree_rcu() being accepted.
> 
> I'm not concerned about whether I'm patches' Author or I'm in the
> Signed-off-by list.

I greatly appreciate the fact that you are more interested in the
quality of the Linux kernel than in credit.  That said, I would like the
solution to be something that both you and Manfred agree on.

							Thanx, Paul
