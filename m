Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903Ab0ADV7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0ADV7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0ADV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:59:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:59940 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0ADV7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:59:46 -0500
Date: Mon, 4 Jan 2010 22:59:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PULL] pull request for writable limits for 2.6.33-rc0
In-Reply-To: <20100102215204.GA26296@elte.hu>
Message-ID: <alpine.LNX.2.00.1001042257450.2277@pobox.suse.cz>
References: <4B1D32D1.4090404@gmail.com> <4B1FF9A1.2040305@gmail.com> <alpine.LRH.2.00.1001022239060.15694@twin.jikos.cz> <20100102215204.GA26296@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jan 2010, Ingo Molnar wrote:

> > Hmm, so this seems to have missed thw 2.6.33 merge window, being dropped in 
> > a silent way.
> > 
> > Linus, is there any reason you have not pulled this for .33 (I can't see any 
> > objections from previous reviews), or was this just forgotten?
> 
> I think a "why do we want this badly" blurb would be helpful for next time 
> around, to justify the impact to the core kernel:
> 
>   48 files changed, 451 insertions(+), 153 deletions(-)
> 
> And, maybe, if you know about pros/cons of the approach, list them as well. 
> The patches looked reasonably clean when i last saw them, and i havent seen 
> anyone comment pro or contra - and that's both good and bad: good because 
> there's no 'contra' opinion - bad because there's no 'pro' opinion either.

Well, I am myself aware of users asking for this functionality, and 
thinking about it, it "just makes sense" to have the possibility to 
change the limits on the fly.

... but you are right that such justification should probably be clearly 
expressed in the pull request itself.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
