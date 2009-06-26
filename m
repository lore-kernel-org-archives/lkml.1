Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZFZInE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZFZInE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZFZImy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:42:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZFZImx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:42:53 -0400
Date: Fri, 26 Jun 2009 10:42:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626084228.GA9789@elte.hu>
References: <20090625221816.GA3480@localdomain.by> <20090626065923.GA14078@elte.hu> <1246004740.30717.3.camel@pc1117.cambridge.arm.com> <1246004879.27533.18.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246004879.27533.18.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, 2009-06-26 at 09:25 +0100, Catalin Marinas wrote:
>
> > BTW, this was questioned in the past as well - do we still need 
> > the automatic scanning from a kernel thread? Can a user cron job 
> > just read the kmemleak file?
> 
> I think the kernel thread makes sense so that we get an early 
> warning in syslog. Ingo, what's your take on this from autoqa 
> point of view?

it would be nice to have more relevant messages. Many of the 
messages seem false positives, right? So it would be nice to 
constrain kmemleak into a mode of operation that makes its 
backtraces worth looking at. A message about suspected leaks is 
definitely useful, it just shouldnt be printed too frequently.

	Ingo
