Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYGVPfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYGVPfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYGVPfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:35:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGVPfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:35:03 -0400
Date: Tue, 22 Jul 2008 17:34:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Newall <davidn@davidnewall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [TCP bug] stuck distcc connections in latest -git
Message-ID: <20080722153443.GB18757@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net> <20080721133059.GA30637@elte.hu> <20080721134506.GA27598@elte.hu> <20080721182318.GA20940@elte.hu> <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org> <20080721184616.GA8442@elte.hu> <20080722112133.GA6575@elte.hu> <4885E482.5020502@davidnewall.com> <20080722135723.GA23077@elte.hu> <4885F496.3010305@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885F496.3010305@davidnewall.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Newall <davidn@davidnewall.com> wrote:

> Ingo Molnar wrote:
> > * David Newall <davidn@davidnewall.com> wrote:
> >   
> >> You really should start that capture, and on both client and server. 
> >> You don't need to dump everything, only traffic to or from 
> >> server:distcc.
> >>     
> >
> > It's not feasible. That box did in excess of 200 GB of network traffic 
> > in the past 7 hours alone.
> 
> You only need distcc traffic, and perhaps only after it's hung.  With 
> 250k outstanding per socket, are you certain that no traffic was sent? 
> Is it certain that one packet wasn't being sent each three minutes?  I 
> suppose you're right and the stack really is stuck, but this is such 
> an easy thing to check and eliminate that you should do so.  I 
> suppose, too, that you should trace the server-side processes and 
> confirm that they are waiting for socket input.  You should dump tcp 
> (for the distcc port) next time the problem recurs and also check that 
> the server processes are waiting for socket input.

ok, will do that if it happens again.

	Ingo
