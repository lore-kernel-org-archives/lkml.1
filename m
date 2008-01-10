Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbYAJDn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbYAJDn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYAJDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:43:21 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:26241 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbYAJDnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:43:21 -0500
Subject: Re: [RFC PATCH 20/22 -v2] Add latency_trace format tor tracer
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080109233045.411814804@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233045.411814804@goodmis.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 19:41:45 -0800
Message-Id: <1199936505.18203.18.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 18:29 -0500, Steven Rostedt wrote:
> +enum trace_flag_type {
> +       TRACE_FLAG_IRQS_OFF             = 0x01,
> +       TRACE_FLAG_NEED_RESCHED         = 0x02,
> +       TRACE_FLAG_NEED_RESCHED_DELAYED = 0x04,
> +       TRACE_FLAG_HARDIRQ              = 0x08,
> +       TRACE_FLAG_SOFTIRQ              = 0x10,
> +       TRACE_FLAG_IRQS_HARD_OFF        = 0x20,
> +};

You've got some errant flags here .. TRACE_FLAG_NEED_RESCHED_DELAYED is
-rt only , and TRACE_FLAG_IRQS_HARD_OFF is unsed (and sort of a
relic) ..

Daniel

