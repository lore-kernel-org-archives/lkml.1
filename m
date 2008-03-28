Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYC1OTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYC1OTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYC1OTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:19:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbYC1OTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:19:36 -0400
Date: Fri, 28 Mar 2008 15:18:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328141845.GF29218@elte.hu>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com> <20080328101500.GF30863@elte.hu> <y0mabkjvufd.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mabkjvufd.fsf@ton.toronto.redhat.com>
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


* Frank Ch. Eigler <fche@redhat.com> wrote:

> 
> >> >  NACK-ed-by: Ingo Molnar <mingo@elte.hu>
> >> [...]
> >> I wonder why nobody doesn't fix this serious problem until now. [...]
> 
> Frankly, the "problem" has not yet been established.  Ingo has failed 
> to respond to Mathieu's analysis of the actual instruction streams, 
> which cast doubt on Ingo's technique of simply counting bytes. [...]

uhm no. The "difference" is due to Matthieu counting on the platform 
that is most favorable to his argument: 32-bit, while i counted on 
64-bit where most servers operate (and where instrumentation micro-cost 
actually matters).

	Ingo
