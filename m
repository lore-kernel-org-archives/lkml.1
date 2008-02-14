Return-Path: <linux-kernel-owner+w=401wt.eu-S934905AbYBNX5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905AbYBNX5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933990AbYBNX5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:57:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933831AbYBNX5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:57:04 -0500
Date: Fri, 15 Feb 2008 00:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Fix direct mapping alias regressin in ioremap v2
Message-ID: <20080214235652.GA17007@elte.hu>
References: <20080214165645.GA26748@basil.nowhere.org> <20080214174237.GA24383@elte.hu> <20080214213417.GA19473@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214213417.GA19473@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > >     Fix bug noticed by Ingo of __va() wrapping on 32bit
> > 
> > what you should realize is that had we applied your previous patch 
> > in a rush, it would have introduced a far more serious regression 
> > than the type of problem you are trying to solve. That's one of the 
> > reasons why we disagree with your sense of urgency.
> 
> Sense of urgency in this case just means for 2.6.25 which is still a 
> few weeks away.

FYI, we had the -rc1 release 4 days ago.

> Sorry for not being a perfect being. Yes I did test the patch, but no 
> my testing did not catch the problem unfortunately. But I'm grateful 
> that your review caught the problem.

That's the task of the maintainers, to review, test and stage patches.

> > We've got the clean fixes queued up and it's all under testing. 
> > (going fine so far)
> 
> Ok but will you push them to .25?

Yes, of course, once they have been tested through - like all arch/x86 
patches/fixes. If everything goes well in overnight testing it might be 
pushed as early as tomorrow.

This is exactly how it was for 2.6.24: x86.git#mm is where we stage 
patches while they are being tested - as you probably are well aware of.

It does not mean they are .26 material (although some of them clearly 
are - such as kgdb-light) - most of the fix patches start out there, and 
once we trust them we percolate them upwards in the queue and then they 
eventually get submitted to Linus. If any bug happens to some of them 
then they bubble back to the tail of the queue. For most of the 
nontrivial patches, even if they are fixes we want to push upstream, it 
is usually at least several days of testing until we trust them.

	Ingo
