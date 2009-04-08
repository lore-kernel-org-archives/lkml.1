Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbZDHJO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbZDHJO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZDHJOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:14:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608AbZDHJOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:14:48 -0400
Date: Wed, 8 Apr 2009 11:14:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH v2] tracing/filters: use ring_buffer_discard_commit()
	in filter_check_discard()
Message-ID: <20090408091432.GA10381@elte.hu>
References: <1239178554.10295.36.camel@tropicana> <20090408084405.GA12283@elte.hu> <20090408085635.GA6203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408085635.GA6203@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > This patch changes filter_check_discard() to make use of the new 
> > > ring_buffer_discard_commit() function and modifies the current 
> > > users to call the old commit function in the non-discard case.  It 
> > > also introduces a version of filter_check_discard() that uses the 
> > > global trace buffer (filter_current_check_discard()) for those 
> > > cases.
> > > 
> > > v2 changes:
> > > 
> > > - fix compile error noticed by Ingo Molnar
> > > 
> > > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > 
> > Thanks Tom, i've applied it to tip:tracing/filters and i've started 
> > testing it.
> 
> still has build failures:
> 
> kernel/built-in.o: In function `filter_check_discard':
> trace.c:(.text+0x5b057): undefined reference to `filter_match_preds'

ah, i'll try your other patch as well that separates the event 
infrastructre from the event-tracer.

	Ingo
