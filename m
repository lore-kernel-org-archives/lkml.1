Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYISIWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYISIWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYISIWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:22:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:35987 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYISIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:22:43 -0400
Message-ID: <f488382f0809190122k1b30cd9q22fd076c1e3eaa18@mail.gmail.com>
Date: Fri, 19 Sep 2008 01:22:41 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080919081733.GC19491@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
	 <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com>
	 <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com>
	 <20080919030125.GG7408@tesla>
	 <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com>
	 <20080919081733.GC19491@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> in tip/master there's an ftrace_printk() facility. You can just replace
> the verbose printk()s with ftrace_printk() and see the result in
> /debug/tracing/trace.
>
> This sort of tracing has very low overhead and can be used in an easy
> ad-hoc manner with no extra infrastructure. Here's a few quick-start
> links about how to enable the scheduler tracer:
>
>  http://redhat.com/~mingo/sched-devel.git/readme-tracer.txt
>  http://redhat.com/~mingo/sched-devel.git/howto-trace-latencies.txt
>
> any ftrace_printk() you add in the kernel will show up in that trace.
>
> (If the scheduling events are uninteresting and clutter the output then
> you might want to remove the scheduler tracing entries from kernel/*.c
> by removing the trace_sched_*() calls or use a less noisy tracer.)
>
> to get enough of a trace history you might want to increase the number
> of trace entries in /debug/tracing/trace_entries from 16K to 128K or so.
>

Thanks for the suggestion, I'll do that. :)
