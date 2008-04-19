Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYDSKkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYDSKkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYDSKj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:39:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYDSKj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:39:56 -0400
Date: Sat, 19 Apr 2008 12:39:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
	latest -git
Message-ID: <20080419103942.GA13599@elte.hu>
References: <20080419100034.GA9475@elte.hu> <20080419.030337.244502148.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419.030337.244502148.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 19 Apr 2008 12:00:35 +0200
> 
> > btw., i found no thread to reply to on lkml or elsewhere - arent all 
> > git pull requests supposed to be Cc:-ed to lkml, with shortlog 
> > included?
> 
> I have never once done this even going all the way back to the BK 
> days.

do you find this practice of private pull requests important? If not, 
would it be difficult to Cc: lkml to routine pull requests?

> I always send my pull requests directly to Linus, CC:'ing Andrew.

that makes bugs harder to report and makes the flow of patches harder to 
follow as well. Often (like in this case) i see it when a bug comes in 
via a specific group of commits but i have no time to do a bisection. In 
that case i'd like to report it to that pull request so i'd like to 
reply to that pull on lkml.

But in this case i first did an unsuccessful full-text search on lkml, 
then i also opened up netdev and did a full text search there too to 
find the originator pull request or the patches but the search turned up 
nothing. As the number of subsystems increases, i suspect you agree with 
me that this does not scale very well for bug reporters, correct?

i'm convinced that testers and bug reporters are the scarce resource 
these days, not patch integrators and not maintainers which was the 
scarce resource 3-4 years ago, before Git and before BK. It is testing 
(and review) capacity that limits the growth of Linux today, not patch 
writing and patch integration capacity.

	Ingo
