Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYL2MdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYL2MdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYL2Mcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:32:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYL2Mcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:32:53 -0500
Date: Mon, 29 Dec 2008 13:32:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] RCU: Move some definitions to minimal headers.
Message-ID: <20081229123233.GA16364@elte.hu>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro> <84144f020812290142o6299c225o37c2c499db9f0985@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812290142o6299c225o37c2c499db9f0985@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Mon, Dec 29, 2008 at 3:40 AM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
> > linux/rcupdate.h used to include SLAB headers, which got in the way of
> > switching kmemtrace to use tracepoints instead of markers. The circular
> > header inclusion pattern that appeared was making it impossible to use
> > tracepoints in SLAB allocator inlines.
> >
> > This moves some header code into separate files. As an added bonus,
> > preprocessing is faster if care is taken to use these minimal headers,
> > since no effort is spent on including SLAB headers.
> >
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> 
> I'm okay with this but lets cc Paul for an ack/nak.

This should go via tip/core/rcu i suspect, which has pending RCU bits 
(already sent to Linus, but not merged yet).

	Ingo
