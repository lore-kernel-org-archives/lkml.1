Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZBKMP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZBKMP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZBKMPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:15:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZBKMPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:15:16 -0500
Date: Wed, 11 Feb 2009 13:15:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090211121503.GA11610@elte.hu>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210122726.GA21531@elte.hu> <20090210123145.GA1403@elte.hu> <20090210141052.GA5836@nowhere> <20090210142543.GF16147@elte.hu> <20090210144910.GE5836@nowhere> <20090211120410.GC23873@elte.hu> <20090211121040.GA9105@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211121040.GA9105@elte.hu>
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

> 
> hm, still no good:
> 
> kernel/built-in.o: In function `boot_trace_init':
> trace_boot.c:(.text+0x7751a): undefined reference to 
> `tracing_sched_switch_assign_trace'
> kernel/built-in.o: In function `disable_boot_trace':
> (.text+0x7762c): undefined reference to `tracing_stop_sched_switch_record'

actually, that's Arnaldo's bug, caused by:

 9182702: tracing: use a single trace_enabled variable

	Ingo
