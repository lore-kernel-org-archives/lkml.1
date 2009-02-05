Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZBENhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZBENhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZBENg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:36:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbZBENg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:36:58 -0500
Date: Thu, 5 Feb 2009 14:36:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] trace: assign defaults at register_ftrace_event
Message-ID: <20090205133643.GA19907@elte.hu>
References: <20090204221639.GO3440@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090204221639.GO3440@ghostprotocols.net>
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

> Impact: simplification of tracers
> 
> As all tracers are doing this we might as well do it in
> register_ftrace_event and save one branch each time we call these
> callbacks.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  block/blktrace.c            |    2 --
>  kernel/trace/trace.c        |   13 +++++--------
>  kernel/trace/trace_branch.c |    3 ---
>  kernel/trace/trace_output.c |   13 +++++++++++--
>  4 files changed, 16 insertions(+), 15 deletions(-)

Applied to tip/tracing/ftrace, thanks guys!

	Ingo
