Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZCVT4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZCVT4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZCVT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:56:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZCVT4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:56:39 -0400
Date: Sun, 22 Mar 2009 20:56:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] tracing: event filtering v2
Message-ID: <20090322195624.GC15002@elte.hu>
References: <1237710626.7703.45.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237710626.7703.45.camel@charm-linux>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> Hi,
> 
> This is version 2 of my patchset adding filtering to the 
> event-tracing infrastructure.
> 
> Changes from the previous version:
> 
> - added common_ prefix to the 5 common event fields
> - ring_buffer_event_discard() fixes from Steven Rostedt
> - changed 'and' and 'or' for compound filters to '&&' and '||'
> - fixed a bug in the matching logic 
> 
> Everything seems to work ok for me, but I haven't yet gotten 
> around to changing the awkward UI.  I plan to fix that as soon as 
> I can i.e. allow complete compound expressions to be specified all 
> at once, add <, >, <=, >= and parens, etc.  Until then, it should 
> hopefully be usable for basic filtering.

Thanks Tom - Frederic and me had a good look and i picked them up 
into tip:tracing/filters for now and lets see how they hold up in 
testing. There was one boundary-condition bug Frederic noticed, i 
fixed that.

The subsystem level filters are a nice touch. We still have to 
complete and organize events into a comprehensive, Linux-wide set of 
tracepoints, so there will be some churn in this area.

	Ingo
