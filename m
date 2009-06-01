Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZFAXku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZFAXku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZFAXkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:40:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35347 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZFAXkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:40:39 -0400
Date: Tue, 2 Jun 2009 01:40:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH -tip v8 5/7] x86: add pt_regs register and stack access
	APIs
Message-ID: <20090601234006.GA12629@elte.hu>
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090529000347.17532.34038.stgit@localhost.localdomain> <20090530081303.GB15755@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530081303.GB15755@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> > +	if (n < NR_REGPARMS) {
> > +		switch (n) {
> > +		case 0: return regs->ax;
> > +		case 1: return regs->dx;
> > +		case 2: return regs->cx;
> > +		}
> 
> Normal kernel style would be
> 
> 		switch (n) {
> 		case 0:
> 			return regs->ax;
> 		case 1:
> 			return regs->dx;
> 		case 2:
> 			return regs->cx;
> 		}

the original single-line shortcut is acceptable too.

	Ingo
