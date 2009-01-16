Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbZAPNLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbZAPNLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbZAPNLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:11:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36455 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZAPNLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:11:14 -0500
Date: Fri, 16 Jan 2009 14:10:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116131051.GM5421@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <c62985530901160508t318980a5vbbe9198f326e124@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901160508t318980a5vbbe9198f326e124@mail.gmail.com>
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

> 2009/1/16 Ingo Molnar <mingo@elte.hu>:
> >
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> Ingo,
> >>
> >> The first patch is critical, and needs to stay with trace_output.c Not
> >> that critical since trace_output.c is not in mainline yet.
> >>
> >> The second patch gives the ability to stack trace functions. I've been
> >> leery about adding this and still keep it a separate option from the
> >> "stacktrace" that already exists. This is because when enabled with no
> >> filtering, the lag between typing and seeing what is typed can be up to
> >> 10 seconds or more.
> >
> > Btw., is this true even if frame pointers are enabled? When frame pointers
> > are disabled we scan the full kernel stack => that can be quite slow if
> > every kernel function is traced ;-)
> 
> 
> Hi Ingo,
> 
> The function tracer selects Frame pointers :-)

doh, i even added that to begin with ;-)

Life is short but a coder's memory is even shorter.

	Ingo
