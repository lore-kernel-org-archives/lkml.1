Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZFPJJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZFPJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZFPJJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:09:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZFPJJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:09:48 -0400
Date: Tue, 16 Jun 2009 11:09:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616090937.GE13771@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616095706.36f01282@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Hm, have you tried the patch i sent to you that extends the 
> > number-lock-locks-tracked limit you have run into? It is 
> > trivial.
> 
> I tried upping the number of locks a while ago - it has no effect, 
> which checking on irc seems to fit the general pattern of the 
> reports against Fedora.
> 
> The good thing is I trigger this at boot time reliably - so if 
> you've got some debug stuff you want to stick in I can do that

Could you please turn on CONFIG_DEBUG_LOCKDEP=y and after the 
overflow has happened, send us (or upload somewhere) the output of 
"cat /proc/lock*" ?

If we run out of chains then the source of the leak should be 
clearly visible in that debug outpt.

Thanks,

	Ingo
