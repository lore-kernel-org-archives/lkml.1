Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYACJVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYACJVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYACJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:21:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYACJVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:21:35 -0500
Date: Thu, 3 Jan 2008 10:21:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler
	instrumentation
Message-ID: <20080103092104.GE10813@elte.hu>
References: <20080103071609.478486470@goodmis.org> <20080103072226.776141236@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103072226.776141236@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> +# function tracing might turn this off:
> +config REGPARM
> +	bool
> +	depends on !MCOUNT
> +	default y

are you sure -pg really needs this? I just carried this along the years 
and went the path of least resistence, but we should not be 
reintroducing the !REGPARM build mode for the kernel. I'd not be 
surprised if there were a few issues with REGPARM + mcount, but we have 
to figure it out before merging ...

	Ingo
