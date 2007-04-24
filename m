Return-Path: <linux-kernel-owner+w=401wt.eu-S1423091AbXDXUzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423091AbXDXUzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423102AbXDXUzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:55:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423091AbXDXUzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:55:39 -0400
Date: Tue, 24 Apr 2007 22:54:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070424205416.GA23032@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I have not a frigging clue whether that is the case in suspend2 vs 
> uswsusp, but I object to this idiotic argument of counting "kernel 
> code". That's simply not a valid argument. It never was.

the raw linecount appears to be the following:

 suspend2-2.2.9.12-for-2.6.21-rc6.patch

   89 files changed, 16452 insertions(+), 69 deletions(-)

 $ suspend-0.5> countlines
 32260

so, while it's probably apples to oranges, uswsusp seems to be larger, 
while there's at least one feature that it is missing.

also, from the structure of the suspend2 patch it seemed to me that they 
could peacefully coexist in the kernel without stepping on each other's 
toes - why not do that? Users will then pick the winner.

	Ingo
