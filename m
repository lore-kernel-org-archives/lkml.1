Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZBIJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZBIJ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZBIJ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:58:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBIJ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:58:27 -0500
Date: Mon, 9 Feb 2009 10:58:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] tracing: handle unregistering the current
	tracer
Message-ID: <20090209095816.GB20467@elte.hu>
References: <20090207205259.GB11892@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207205259.GB11892@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Impact: simplification
> 
> Instead of requiring that plugins have the sequence:
> 
>   my_tracer_stop(my_trace_array);
>   unregister_tracer(my_tracer);
> 
> it should be possible just do a:
> 
>   unregister_tracer(my_tracer);
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  kernel/trace/trace.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

Applied to tip/tracing/ftrace, thanks Arnaldo!

Nice one - we should try to shoot for the smallest physically
possible linecount for any new (possibly trivial) tracer plugin.

	Ingo
