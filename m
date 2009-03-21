Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZCUHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZCUHnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 03:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZCUHnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 03:43:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41968 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZCUHnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 03:43:31 -0400
Date: Sat, 21 Mar 2009 08:43:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, utrace-devel@redhat.com,
       Frank Eigler <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321074301.GA19384@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321014244.9ADF1FC3AB@magilla.sf.frob.com>
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


* Roland McGrath <roland@redhat.com> wrote:

> From: Frank Ch. Eigler <fche@redhat.com>
> 
> This is v2 of the prototype utrace-ftrace interface.  This code is 
> based on Roland McGrath's utrace API, which provides programmatic 
> hooks to the in-tree tracehook layer.  This new patch interfaces 
> many of those events to ftrace, as configured by a small number of 
> debugfs controls.  Here's the 
> /debugfs/tracing/process_trace_README:

Please submit changes/enhancements to kernel/trace/* to the tracing 
tree maintainers (Steve and me) for review, testing and integration.

Please also post patches against the latest tracing tree:

   http://people.redhat.com/mingo/tip.git/README

As this patch does not apply:

 Applying patch patches/utrace-based-ftrace-process-engine-v2.patch
 patching file include/linux/processtrace.h
 patching file kernel/trace/Kconfig
 Hunk #1 succeeded at 186 with fuzz 2 (offset 36 lines).
 patching file kernel/trace/Makefile
 Hunk #1 FAILED at 33.
 1 out of 1 hunk FAILED -- rejects in file kernel/trace/Makefile
 patching file kernel/trace/trace.h
 Hunk #1 succeeded at 7 with fuzz 1.
 Hunk #2 FAILED at 31.
 Hunk #3 succeeded at 215 with fuzz 2 (offset 43 lines).
 Hunk #4 FAILED at 330.
 2 out of 4 hunks FAILED -- rejects in file kernel/trace/trace.h
 patching file kernel/trace/trace_process.c
 Patch patches/utrace-based-ftrace-process-engine-v2.patch does not apply (enforce with -f)

Thanks,

	Ingo
