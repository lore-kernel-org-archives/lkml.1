Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbZANIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbZANIHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZANIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:06:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38766 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbZANIG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:06:57 -0500
Date: Wed, 14 Jan 2009 09:06:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com, akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] softlockup: detect bottom-half lockups
Message-ID: <20090114080640.GA19116@elte.hu>
References: <20090114070447.GA25222@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114070447.GA25222@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> The feature should be useful to real-time developers and developers of 
> network and other high-performance drivers.

hm, did you know about the ftrace latency tracers:

 config IRQSOFF_TRACER
         bool "Interrupts-off Latency Tracer"

 config PREEMPT_TRACER
         bool "Preemption-off Latency Tracer"

 config SCHED_TRACER
         bool "Scheduling Latency Tracer"

PREEMPT_TRACER would have shown you that softirqs-off section very nicely. 

(And if you also enable the function tracer then not just the latency 
endpoint is shown, but also all the function calls that happened in the 
critical section.)

	Ingo
