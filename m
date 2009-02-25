Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbZBYJXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbZBYJXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZBYJWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:22:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51561 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZBYJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:22:47 -0500
Message-ID: <49A50D9D.2030400@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 17:21:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org>
In-Reply-To: <20090225025753.798204550@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt 写道:
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/asm-generic/vmlinux.lds.h |   11 ++-
>  kernel/trace/Kconfig              |    9 ++
>  kernel/trace/Makefile             |    1 +
>  kernel/trace/trace_events.c       |  280 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_events.h       |   52 +++++++
>  5 files changed, 352 insertions(+), 1 deletions(-)
>  create mode 100644 kernel/trace/trace_events.c
>  create mode 100644 kernel/trace/trace_events.h
> 

Modules can not use this infrastructure,
will it be implemented in future?

Lai

