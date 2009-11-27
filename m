Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZK0TQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZK0TQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZK0TQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:16:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50620 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZK0TQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:16:25 -0500
Date: Fri, 27 Nov 2009 20:16:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091127191614.GA30749@elte.hu>
References: <20091124200127.GA5751@redhat.com>
 <20091125214818.GA4916@infradead.org>
 <20091126091052.GF1389@elte.hu>
 <20091126104722.GA8316@infradead.org>
 <20091126122441.GC15189@elte.hu>
 <20091127140439.GA17000@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127140439.GA17000@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> > Yes. Which is a further argument to not do it like that but to do 
> > one arch at a time. Trying to do too much at once is bad 
> > engineering.
> 
> I'm not sure why you're trying to pick fights here, [...]

I am advocating proper engineering practices - not sure why you 
characterise it as 'picking fights'.

> [...] but no one has said about doing it all in once. [...]

To quote your mail in (<20091125214818.GA4916@infradead.org>):

> > [...] I'd suggest you make sure the remaining two major 
> > architectures (arm and mips) get converted [...]

Spreading the impact of these changes to even more architectures is bad, 
for the reasons i outlined in my previous mail.

Thanks,

	Ingo
