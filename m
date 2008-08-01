Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbYHAQrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbYHAQrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYHAQo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:44:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55732 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbYHAQo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:44:58 -0400
Date: Fri, 1 Aug 2008 09:43:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 2/2] ftrace: printk formatting infrastructure
Message-Id: <20080801094331.626195c8.randy.dunlap@oracle.com>
In-Reply-To: <20080801163737.420519487@goodmis.org>
References: <20080801162639.175407419@goodmis.org>
	<20080801163737.420519487@goodmis.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2008 12:26:41 -0400 Steven Rostedt wrote:

> +/**
> + * ftrace_printk - printf formatting in the ftrace buffer
> + * @fmt - the printf format for printing.

    * @fmt: the printf format for printing
    * @ip: <description>

> + *
> + * Note: __ftrace_printk is an internal function for ftrace_printk and
> + *       the @ip is passed in via the ftrace_printk macro.
> + *
> + * This function allows a kernel developer to debug fast path sections
> + * that printk is not appropriate for. By scattering in various
> + * printk like tracing in the code, a developer can quickly see
> + * where problems are occurring.
> + *
> + * This is intended as a debugging tool for the developer only.
> + * Please reframe from leaving ftrace_printks scattered around in
> + * your code.
> + */
> +int __ftrace_printk(unsigned long ip, const char *fmt, ...)
> +{


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
