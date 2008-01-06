Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYAFPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYAFPin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYAFPie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:38:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYAFPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:38:32 -0500
Date: Sun, 6 Jan 2008 16:37:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 10/11] mcount tracer show task comm and pid
Message-ID: <20080106153758.GA27863@elte.hu>
References: <20080103071609.478486470@goodmis.org> <20080103072228.212967487@goodmis.org> <20080103175650.GE30582@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103175650.GE30582@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > @@ -34,6 +34,7 @@ mctracer_add_trace_entry(struct mctracer
> >  {
> >  	unsigned long idx, idx_next;
> >  	struct mctracer_entry *entry;
> > +	struct task_struct *tsk = current;
> 
> Aren't there situations, like in the middle of a context switch, where 
> current is not valid ? Is also poses a problem for early boot, and NMI 
> tracing.

no such problems on x86.

	Ingo
