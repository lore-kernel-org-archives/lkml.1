Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZFVNYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZFVNYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZFVNXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:23:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZFVNXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:23:52 -0400
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
 member in event_symbol
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245675657.7537.3.camel@localhost.localdomain>
References: <1245669194.17153.6.camel@localhost.localdomain>
	 <1245669268.17153.8.camel@localhost.localdomain>
	 <20090622113256.GA22479@elte.hu>
	 <1245675657.7537.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 18:53:18 +0530
Message-Id: <1245676998.7537.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 18:30 +0530, Jaswinder Singh Rajput wrote:
> On Mon, 2009-06-22 at 13:32 +0200, Ingo Molnar wrote:
> 
> > Another nice thing would be for 'perf list' to actually start each 
> > counter and stop it - and see whether it ticks. Perhaps that could 
> > be a new sub-command: 'perf test' ?
> > 
> > New 'perf' subcommands are added easily:
> > 
> > create a new tools/perf/builtin-foo.c file, add it to 
> > command-list.txt and to the Makefile - add it to perf.c's array of 
> > built-in commands and add a Documentation/perf-foo.txt file to 
> > generate manpages and usage strings for it.
> > 
> 
> Ok this is just a ugly quick hack to get the idea what actually you are
> looking for :
> 
> [RFC] perf_counter tools: introduce perf test to test each event for ticks
> 
> perf test to Test all events for whether it ticks
> 
>   $ perf test
> 
>   Performance counter stats for 'test':
> 
>   task-clock-msecs      Tick
>   context-switches      Tick
>   CPU-migrations        Tick
>   page-faults           Tick
>   cycles                Tick
>   instructions          Tick
>   cache-references      Tick
>   cache-misses          Tick
> 
>      0.007693869  seconds time elapsed.

Please let me know should I need to test all events (Hardware +
Software) and/or selective event based on user request.
And what should be output looks like.

Thanks,
--
JSR

