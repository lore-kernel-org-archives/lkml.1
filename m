Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbZHLLO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbZHLLO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554AbZHLLO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:14:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbZHLLO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:14:56 -0400
Date: Wed, 12 Aug 2009 13:14:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812111436.GA24263@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090812110307.GA806@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812110307.GA806@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another thing: could we please also have a generic, highlevel 
tracepoint (in addition to the specific tracepoints) that
enumerates the raw syscall Nr and the parameters it gets - in a
single tracepoint?

That would allow 'all' syscalls to be traced, at the cost of no 
argument type/name/etc expansion.

	Ingo
