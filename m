Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264Ab0ABVwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0ABVwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446Ab0ABVwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:52:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0ABVwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:52:31 -0500
Date: Sat, 2 Jan 2010 22:52:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PULL] pull request for writable limits for 2.6.33-rc0
Message-ID: <20100102215204.GA26296@elte.hu>
References: <4B1D32D1.4090404@gmail.com>
 <4B1FF9A1.2040305@gmail.com>
 <alpine.LRH.2.00.1001022239060.15694@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1001022239060.15694@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 3.4
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.4 required=5.9 tests=FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.4 FH_DATE_PAST_20XX      The date is grossly in the future.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> Hmm, so this seems to have missed thw 2.6.33 merge window, being dropped in 
> a silent way.
> 
> Linus, is there any reason you have not pulled this for .33 (I can't see any 
> objections from previous reviews), or was this just forgotten?

I think a "why do we want this badly" blurb would be helpful for next time 
around, to justify the impact to the core kernel:

  48 files changed, 451 insertions(+), 153 deletions(-)

And, maybe, if you know about pros/cons of the approach, list them as well. 
The patches looked reasonably clean when i last saw them, and i havent seen 
anyone comment pro or contra - and that's both good and bad: good because 
there's no 'contra' opinion - bad because there's no 'pro' opinion either.

	Ingo
