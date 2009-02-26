Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZBZNWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZBZNWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZBZNWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:22:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZBZNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:22:45 -0500
Date: Thu, 26 Feb 2009 14:22:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing/core: make the per cpu trace files in per
	cpu directories
Message-ID: <20090226132227.GA17530@elte.hu>
References: <49a632a5.0707d00a.296d.24b3@mx.google.com> <20090226131431.GA14722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226131431.GA14722@elte.hu>
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

> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: scale per cpu tracing
> > 
> > The per cpu trace files are all in a single directory: 
> > /debug/tracing/per_cpu. In case of a large number of cpu, the 
> > content of this directory becomes messy so we create now one 
> > directory per cpu inside /debug/tracing/per_cpu which contain 
> > each their own trace_pipe and trace files.
> 
> Applied to tip:tracing/ftrace, thanks Frederic!

The layout looks much more structured on a 16-way box now:

phoenix:/debug/tracing/per_cpu> ll
total 0
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu0
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu1
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu10
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu11
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu12
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu13
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu14
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu15
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu2
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu3
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu4
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu5
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu6
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu7
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu8
drwxr-xr-x 2 root root 0 2009-02-26 14:19 cpu9
phoenix:/debug/tracing/per_cpu> cd cpu0
phoenix:/debug/tracing/per_cpu/cpu0> ll
total 0
-r--r--r-- 1 root root 0 2009-02-26 14:19 trace
-r--r--r-- 1 root root 0 2009-02-26 14:19 trace_pipe
phoenix:/debug/tracing/per_cpu/cpu0> 

	Ingo
