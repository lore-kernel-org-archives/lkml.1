Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZKWR6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZKWR6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZKWR6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:58:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbZKWR57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:57:59 -0500
Date: Mon, 23 Nov 2009 18:57:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 0/3] tracepoint: Add signal events
Message-ID: <20091123175740.GA15594@elte.hu>
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi,
> 
> These patches add signal related tracepoints including
> signal generation, delivery, and loss. First patch also
> moves signal-sending tracepoint from events/sched.h to
> events/signal.h.
> 
> Changes in v3
> - Add Docbook style comments
> 
> Changes in v2
> - Add siginfo arguments
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (3):
>       tracepoint: Add signal loss events
>       tracepoint: Add signal deliver event
>       tracepoint: Move signal sending tracepoint to events/signal.h
> 
> 
>  Documentation/DocBook/tracepoint.tmpl |    5 +
>  include/trace/events/sched.h          |   25 -----
>  include/trace/events/signal.h         |  173 +++++++++++++++++++++++++++++++++
>  kernel/signal.c                       |   27 ++++-
>  4 files changed, 198 insertions(+), 32 deletions(-)
>  create mode 100644 include/trace/events/signal.h

Would be nice to have Roland's and Oleg's Acked-by tags in the patches - 
to show that this is a representative and useful looking set of signal 
events.

	Ingo
