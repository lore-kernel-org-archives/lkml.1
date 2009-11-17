Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZKQRZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZKQRZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZKQRZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:25:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZKQRZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:25:12 -0500
Date: Tue, 17 Nov 2009 18:24:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091117172456.GA14749@elte.hu>
References: <20091117074655.GA14023@google.com>
 <20091117081817.GA7963@elte.hu>
 <1258448121.7816.29.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258448121.7816.29.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-11-17 at 09:18 +0100, Ingo Molnar wrote:
> > 
> > Would you be interested in adding it as a 'perf bench futex' testcase? 
> > That way kernel developers could monitor futex performance in the future 
> > as well.
> > 
> > See 'perf bench' in the latest perf events tree:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > Do 'cd tools/perf; make -j install' to install perf.
> 
> Darren has recently been putting a lot of effort in making a futex test
> suite:
> 
> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
> 
> Its not yet complete, but hopefully it will soon be :-)

Looks nice! Any futex performance measurements within it could be added 
to perf bench - with standardized options and output, etc.

	Ingo
