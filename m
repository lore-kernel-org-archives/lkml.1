Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZCMC43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZCMC43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZCMC4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:56:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbZCMC4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:56:19 -0400
Date: Thu, 12 Mar 2009 19:49:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/16] tracing: have event_trace_printk use static
 tracer
Message-Id: <20090312194942.8348613c.akpm@linux-foundation.org>
In-Reply-To: <20090313023826.503765882@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
	<20090313023826.503765882@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 22:37:12 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> +		static const char *trace_printk_fmt			\
> +		  __attribute__((section("__trace_printk_fmt"))) =	\
> +			__builtin_constant_p(fmt) ? fmt : NULL;		\

hm.  Does this put trace_printk_fmt into the __trace_printk_fmt
section, or does it put *trace_printk_fmt in there?

