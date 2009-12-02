Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZLBOBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZLBOBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZLBOBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:01:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZLBOBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:01:40 -0500
Date: Wed, 2 Dec 2009 15:01:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
Message-ID: <20091202140128.GA2611@elte.hu>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
 <1259761934.12870.12.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259761934.12870.12.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2009-12-02 at 10:42 +0000, tip-bot for Jason Baron wrote:
> > Commit-ID:  3a9089fd78367e2c6c815129030b790a0f5c2715
> > Gitweb:     http://git.kernel.org/tip/3a9089fd78367e2c6c815129030b790a0f5c2715
> > Author:     Jason Baron <jbaron@redhat.com>
> > AuthorDate: Tue, 1 Dec 2009 12:18:49 -0500
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 2 Dec 2009 09:57:37 +0100
> > 
> > tracing: Add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support to docbook
> 
> Ug, I need more sleep, because I never noticed the "SINGLE" when I acked
> this :-p
> 
> I thought the DEFINE_SINGLE_EVENT was still under discussion because it
> is a confusing name. I suggested to call it exactly what is was.
> 
>  DECLARE_CLASS_AND_DEFINE_EVENT()

Hm, that's a bit too long. How about 'DEFINE_CLASS_EVENT()' as a 
compromise? It's similarly short-ish to TRACE_EVENT(), and it also 
conveys the fact that we create both a class and an event there.

The full series would thus be:

	DECLARE_EVENT_CLASS
	DEFINE_EVENT
	DEFINE_CLASS_EVENT

hm?

	Ingo
