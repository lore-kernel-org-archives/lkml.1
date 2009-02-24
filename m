Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZBXToB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZBXToB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZBXTnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:43:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbZBXTnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:43:51 -0500
Date: Tue, 24 Feb 2009 11:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, fweisbec@gmail.com, tytso@mit.edu,
       arjan@infradead.org, pq@iki.fi, acme@redhat.com, jbaron@redhat.com,
       mbligh@google.com, compudj@krystal.dyndns.org, fche@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com,
       mhiramat@redhat.com, srostedt@redhat.com
Subject: Re: [PATCH 1/4][RFC] tracing: add event trace infrastructure
Message-Id: <20090224114217.d30ab19a.akpm@linux-foundation.org>
In-Reply-To: <20090224193450.734369391@goodmis.org>
References: <20090224193344.638329210@goodmis.org>
	<20090224193450.734369391@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 14:33:45 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +#define DECLARE_TRACE_FMT(call, proto, args, fmt, fmt_args)		\
> +static void ftrace_event_##call(proto)					\
> +{									\
> +	event_trace_printk(_RET_IP_, "(%s) " fmt "\n", #call, fmt_args); \
> +}									\

<anal>This macro emits a definition, not a declaration.</anal>
