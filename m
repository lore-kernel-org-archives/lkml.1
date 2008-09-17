Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYIQLmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYIQLmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 07:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYIQLml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 07:42:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbYIQLml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 07:42:41 -0400
Date: Wed, 17 Sep 2008 13:42:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 3/7] ftrace: add trace_vprintk()
Message-ID: <20080917114216.GG18764@elte.hu>
References: <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com> <20080828214256.296e34ec@daedalus.pq.iki.fi> <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com> <20080904203058.7e57729e@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com> <20080915224707.76b2cca0@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com> <20080916215416.16aee2dd@daedalus.pq.iki.fi> <20080916215824.7b0b69e5@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809161606340.7650@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809161606340.7650@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Tue, 16 Sep 2008, Pekka Paalanen wrote:
> 
> > From 5579d3e6471201524697d1cc32fb37f1a4f70f95 Mon Sep 17 00:00:00 2001
> > From: Pekka Paalanen <pq@iki.fi>
> > Date: Sun, 14 Sep 2008 17:27:05 +0300
> > Subject: [PATCH] ftrace: add trace_vprintk()
> > 
> > trace_vprintk() for easier implementation of tracer specific *_printk
> > functions. Add check check for no_tracer, and implement
> > __ftrace_printk() as a wrapper.
> > 
> > Signed-off-by: Pekka Paalanen <pq@iki.fi>
> 
> Nice!
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

nice - i've picked up Pekka's patches into tip/tracing/ftrace:

 f2e1ec3: ftrace: inject markers via trace_marker file
 574a7a7: mmiotrace: remove left-over marker cruft
 fb87810: mmiotrace: handle TRACE_PRINT entries
 eaa4f4e: x86 mmiotrace: implement mmiotrace_printk()
 d77a3b8: ftrace: add trace_vprintk()
 809fff6: ftrace: move mmiotrace functions out of trace.c
 bc94fff: x86 mmiotrace: fix a rare memory leak

and added your ack to all of them. Thanks,

	Ingo
