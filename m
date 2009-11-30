Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZK3PRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZK3PRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZK3PRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:17:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46397 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbZK3PRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:17:04 -0500
Date: Mon, 30 Nov 2009 16:16:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130151650.GA24316@elte.hu>
References: <20091130120345.GA18879@linux.vnet.ibm.com>
 <1259582952.20516.209.camel@laptop>
 <20091130123257.GB18879@linux.vnet.ibm.com>
 <1259584907.20516.246.camel@laptop>
 <20091130131928.GC18879@linux.vnet.ibm.com>
 <1259588232.20516.307.camel@laptop>
 <20091130150314.GA10331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130150314.GA10331@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> peterz wrote: 
> 
> > Hmm,. wouldn't it make much more sense to extend the current kgdb stub
> > to include userspace debugging, providing an all-in-one solution?
> > I think it would be much more powerful to be able to observe the full
> > software stack and not be limited by this user<->kernel barrier.
> 
> There exist other tools for this broad a scope (systemtap being one), 
> and present gdb is not well suited for this.  That makes this idea an 
> exciting potential for the future, but not a practical short-term 
> goal.

Well, but Peter's suggestion is the obvious next step - or even a 
necessary first step in my view.

kgdb exists here and today in the kernel and you cannot just build a 
facility that doesnt replace it and doesnt integrate well with it.

So if a unified user/kernel model for debugging is a 'long term' feature 
in your view then perhaps this framework (which introduces _extensive_ 
hooks all around the kernel) is not designed/approached in the right way 
and should not be merged in this form.

Concentrating on 'other tools' just generates extensive dependencies on 
something that is lacking - making it even harder to implement unified 
debugging down the line.

Thanks,

	Ingo
