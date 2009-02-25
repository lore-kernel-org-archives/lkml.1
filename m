Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZBYG2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZBYG2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZBYG1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:27:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZBYG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:27:49 -0500
Subject: Re: [PATCH 1/4] tracing: add DEFINE_TRACE_FMT to tracepoint.h
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090225025753.547618424@goodmis.org>
References: <20090225025608.956691460@goodmis.org>
	 <20090225025753.547618424@goodmis.org>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 07:27:07 +0100
Message-Id: <1235543227.4645.2907.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 21:56 -0500, Steven Rostedt wrote:

> +#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
> +	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> +

If TPPROTO and TPARGS were anything but empty stubs, the above would add
them twice, no?

