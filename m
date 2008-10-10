Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYJJOtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYJJOtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYJJOt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:49:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbYJJOt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:49:26 -0400
Date: Fri, 10 Oct 2008 16:49:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] tracing/fastboot: Print ktime of sched events when
	boot tracing
Message-ID: <20081010144914.GD11695@elte.hu>
References: <20081010123450.8D3E6D1BCF0@perso1.free.fr> <20081010140534.GB13137@elte.hu> <c62985530810100747m1094590ei5225f3a62e3d2248@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810100747m1094590ei5225f3a62e3d2248@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > Your other patches look good and i've applied them to
> > tip/tracing/fastboot:
> >
> >  3981ce9: tracing/fastboot: use sched switch tracer from boot tracer
> >  563582a: tracing/ftrace: remove unused code in sched_switch tracer
> >  d25b1ce: tracing/ftrace: fix a race condition in sched_switch tracer
> 
> Thanks. But are you really sure about d25b1ce?
> Steven suggested some changes. But it doesn't matter, I can apply his
> suggestions on top of this applied patch.

correct - that's how Steve meant it, as a delta patch. That other 
cleanup Steve suggested makes sense in a separate patch anyway.

	Ingo
