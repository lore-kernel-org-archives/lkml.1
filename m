Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYI3Pje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYI3Pje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYI3PjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:39:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45557 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYI3PjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:39:24 -0400
Date: Tue, 30 Sep 2008 17:39:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new
	type of print_line
Message-ID: <20080930153912.GB22693@elte.hu>
References: <48E11E1E.7010001@gmail.com> <20080929221934.260306dd@daedalus.pq.iki.fi> <20080930085241.GB10374@elte.hu> <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com> <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com> <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/9/30 Steven Rostedt <rostedt@goodmis.org>:
> >
> > OK, I'll nuke the ring_buffer_lock :-/
> >
> > The trace_pipe calls that and then calls print_trace_line which will
> > eventually lock the buffer again. This is a bug on my part. I'll fix that
> > today.
> >
> > Thanks,
> 
> Strange, I can't see any case where print_trace_line could call the
> ring_buffer_lock.
> Hmm, I will see in your patch.
> 
> Ingo, I just saw one damage from the merging, trace_empty() returns 
> TRACE_TYPE_HANDLED. The type is wrong, it should return 1. It's not 
> urgent since the value is the same. Should I send a patch for such a 
> small error?

yes, please do. One too many patch is far better than one too few ;-)

	Ingo
