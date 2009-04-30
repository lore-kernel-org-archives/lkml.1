Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbZD3Ola@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbZD3Ola (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZD3OlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:41:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZD3OlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:41:20 -0400
Date: Thu, 30 Apr 2009 16:40:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Lacombe <goretux@gmail.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com, tglx@linutronix.de
Subject: Re: [unused symbol] need to use init_mm
Message-ID: <20090430144057.GA14897@elte.hu>
References: <200904301232.05302.goretux@gmail.com> <20090430140957.GD21997@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430140957.GD21997@csn.ul.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> On Thu, Apr 30, 2009 at 12:32:04PM +0200, Eric Lacombe wrote:
> > Hi,
> > 
> > Within a module I work on, I need to access to init_mm, but as it is marked 
> > UNUSED, I wonder if there is another way (an API) to access to it.
> > Otherwise, what can I do to have this mark removed from init_mm in the 
> > mainline? as my module is really not yet ready for inclusion.
> > 
> > Thanks in advance for your response,
> > 
> 
> It looks to be that it was removed already, somewhat behind schedule, in
> commit 9470565579f29486f4ed0ffa50774268b64994b0 after an initial attempt
> was made in commit 3abf024d2abb79614d8c4cb25a70d5596f77d0ad.  I don't know
> if there is a procedure for bringing it back but I would guess it's a call
> for the x86 maintainers. I imagine they will want to at least know;
> 
> 1. Why do you need init_mm exported?
> 2. Is there an alternative approach to using init_mm?
> 3. Assuming yes, what are the downsides?
> 4. When do you think the module will be ready for posting?  i.e. is this
>    really something destined for mainline or some perma-out-of-tree?

yes, those questions have to be answered.

	Ingo
