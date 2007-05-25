Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXEYKNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXEYKNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXEYKM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:12:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59746 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXEYKM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:12:59 -0400
Date: Fri, 25 May 2007 12:12:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525101248.GA7547@elte.hu>
References: <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525094640.GL8094@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > please indicate that you've picked up my style cleanups, i dont want 
> > to redo all this a few days/weeks down the line ...
> 
> It's done slightly differently now due to conflicting earlier changes, 
> but the end result should be about what you intended. [...]

please send me your current sched-clock.c, i'll redo any remaining 
cleanups.

But ... i find your approach curious, why didnt you just apply the 
cleanups i sent? You clearly started working on this as a reaction to my 
cleanup patches and to the bugfixes i sent ontop of the cleanup patches. 
Your "I'll do this differently" approach is totally unnecessary from a 
commit management point of view (this is new code after all and 
will/should go upstream in a single clean chunk anyway), the only effect 
this has is that that you are discouraging contributors like me from 
contributing cleanups to the x86_64 tree.

To further underline this feeling i got, none of your reactions to any 
of my patches showed even a single positive thought that you are happy 
about people fixing code you are introducing (in fact you didnt even 
indicate which patch you took, only at my repeated prodding did you say 
anything about the cleanup patch i sent!), so to me the impression is 
that deep in yourself you are (subconsciously) not happy about others 
contributing to the x86_64 tree. Please tell me that i'm wrong :-(

	Ingo
