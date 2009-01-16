Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbZAPLVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbZAPLVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbZAPLVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:21:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760588AbZAPLU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:20:59 -0500
Date: Fri, 16 Jan 2009 12:19:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ftrace: add stack trace to function tracer
Message-ID: <20090116111954.GB20082@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116004121.302184848@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116004121.302184848@goodmis.org>
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

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: new feature to stack trace any function
> 
> Chris Mason asked about being able to pick and choose a function
> and get a stack trace from it. This feature enables his request.
> 
>  # echo io_schedule > /debug/tracing/set_ftrace_filter
>  # echo function > /debug/tracing/current_tracer
>  # echo func_stack_trace > /debug/tracing/trace_options
> 
> Produces the following in /debug/tracing/trace:
> 
>        kjournald-702   [001]   135.673060: io_schedule <-sync_buffer
>        kjournald-702   [002]   135.673671:
>  <= sync_buffer
>  <= __wait_on_bit
>  <= out_of_line_wait_on_bit
>  <= __wait_on_buffer
>  <= sync_dirty_buffer
>  <= journal_commit_transaction
>  <= kjournald

neat!

	Ingo
