Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYLPOTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYLPOTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYLPOTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:19:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:44840 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754161AbYLPOTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:19:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YuxsiKjgY9+3CdEwUvui0ASNJoZ8KHulAMKSI/d
	YSY7dVDy26423u
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
From: Mike Galbraith <efault@gmx.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, a.p.zijlstra@chello.nl, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <E1LCX8h-0001sh-Uo@pomaz-ex.szeredi.hu>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>  <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
	 <1229397927.5296.48.camel@marge.simson.net>
	 <E1LCX8h-0001sh-Uo@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 15:19:40 +0100
Message-Id: <1229437180.5379.76.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 11:26 +0100, Miklos Szeredi wrote:
> On Tue, 16 Dec 2008, Mike Galbraith wrote:

> > If that commit is responsible, then it should also be very slow in pre
> > 28 kernels, where the same exists.
> 
> Everything prior to 2.6.28 was fine in this respect, so there must be
> some subtle difference.

Yeah, strange.

> >   Hm, there's another possibility.
> > Can you try echo NO_LAST_BUDDY > /sys/kernel/debug/sched_features?
> 
> It didn't help, unfortunately.

I'm happy to hear that actually.

> Applying this patch on top of latest git (which essentially reverts
> the above commit) fixes the slowness.

We definitely don't want to do that.  Hm.  There are only two commits
that spring to mind...

1af5f730fc1bf7c62ec9fb2d307206e18bf40a69, which is another hope not, and
3f3a490480d8ab96e0fe30a41f80f14e6a0c579d which doesn't seem likely.

	-Mike

