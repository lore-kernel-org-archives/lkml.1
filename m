Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbZJaUGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbZJaUGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 16:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933207AbZJaUGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 16:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933205AbZJaUGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 16:06:53 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing function graph tracer
References: <20091029205151.852744305@goodmis.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 31 Oct 2009 16:06:09 -0400
In-Reply-To: <20091029205151.852744305@goodmis.org> (Steven Rostedt's message of "Thu, 29 Oct 2009 16:51:51 -0400")
Message-ID: <y0m4opfz5u6.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> [...]  Jprobes and the function graph tracer use the same mechanism
> to trace the exit of a function. Unfortunately, only one can be done
> at a time.  The function graph tracer replaces the return address
> with its own handler, but so does jprobes. The two are not
> compatible. [...]

What about kretprobes?  It too uses the same mechanism.

- FChE
