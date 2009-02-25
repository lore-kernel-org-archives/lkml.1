Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZBYCMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZBYCMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZBYCMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:12:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbZBYCMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:12:07 -0500
Date: Tue, 24 Feb 2009 21:10:33 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
Message-ID: <20090225021033.GA17269@redhat.com>
References: <20090224193344.638329210@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224193344.638329210@goodmis.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> This is still RFC, do not pull.
> This patch set gives the ability to add a format string and args to
> a trace point declaration. [...]

It looks like a good compromise, a dual to the trace_mark_tp
prototype, and a plausible replacement for markers.  Thank you.  The
main thing this would lose is a callback API to intercept generic
varargs event flavour, which we in systemtap land enjoy using, but
before too long we would make do.

- FChE
