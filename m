Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZBTLbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZBTLbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZBTLbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:31:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZBTLbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:31:22 -0500
Date: Fri, 20 Feb 2009 12:31:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: What made this bug report better? (was Re: Poking
	ieee80211_default_rc_algo causes kernel lockups)
Message-ID: <20090220113107.GK28581@elte.hu>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <200902162040.44178.rusty@rustcorp.com.au> <20090216175907.GA4582@nowhere> <200902171007.28257.rusty@rustcorp.com.au> <20090220102705.GA2884@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220102705.GA2884@silver.sucs.org>
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


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On Tue, Feb 17, 2009 at 10:07:27AM +1030, Rusty Russell wrote:
> > 
> > Thanks, done, and I'll send to Linus and -stable immediately.
> 
> I'm curious - only two days after I reposted this the problem 
> [1] it appears to have been resolved. When I posted it the 
> first time [2] I only received one reply (privately) and that 
> was from Greg wondering why I had only sent the email to him 
> (which was an unfortunate problem and down to how I was trying 
> to send LKML mails at the time).
> 
> What happened this time that made things succesful? Was the 
> original mail too big? Did it not make it to the list?
> 
> [1] http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/2a816ca521d72494/bd607c7e143def6f?#bd607c7e143def6f
> [2] http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6

It does not seem to have made it to everyone - it's not in my 
lkml folder for example. Sometimes vger eats emails. Filing a 
bugzilla for reproducible bugs makes sense - especially if you 
see that no action has been taken by anyone.

But note that even with expanded Cc:s and a properly working 
list it needed Frederic's excellent function-graph trace and 
analysis.

A crash in the wireless code rarely gets tracked back to a core 
kernel module support bug, and it would have taken quite some 
time for someone to make that connection.

	Ingo
