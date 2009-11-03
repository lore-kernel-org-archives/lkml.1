Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZKCQIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZKCQIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZKCQIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:08:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbZKCQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:08:47 -0500
Date: Tue, 3 Nov 2009 08:07:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030756310.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
 <1257262588.3420.79.camel@localhost.localdomain> <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Linus Torvalds wrote:
> 
> But it should be fixed _quickly_. In this case, I have a bisection report 
> FROM TWO DAYS AGO. And I'm still kicking myself for not just reverting 
> that piece-of-shit commit then, because I spent the time to look at the 
> oops and the commit, and could tell that it was crap.

Btw, "two days" may not sound like a lot, but it's over five weeks since 
the merge window closed - we should be close to release. And the 
particular buggy commit was merged just a few days ago (Oct 29) - and it 
got some bisect loving within days of being merged.

If this had all happened during the merge window, and if the patch that 
got bisected was some complex one, my view of what "quickly" means would 
have been very different.

But this late in the -rc game, we should encourage people to expect the 
kernel to be stable. That means that if it's not stable, we should jump on 
it. As soon as possible. Quite often that should mean "revert it now, so 
that users don't have to see it, and then let the developers see if they 
can fix it properly".

Let the _maintainers_ run the buggy kernels in order to debug them, but we 
want all the _users_ to have kernels that are useful. For the last couple 
of days, we've done it the wrong way around.

			Linus

PS. The fix is pushed out now. But it could have been reverted on Sunday.
