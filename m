Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYJWWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYJWWzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJWWzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:55:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27809 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYJWWzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:55:23 -0400
Date: Thu, 23 Oct 2008 15:54:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: ftrace dump on oops control
Message-Id: <20081023155440.3b90e129.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.10.0810231514140.8986@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231514140.8986@gandalf.stny.rr.com>
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

On Thu, 23 Oct 2008 15:15:27 -0400 (EDT) Steven Rostedt wrote:

> +/**
> + * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
> + *
> + * If there is an oops (or kernel panic) and the ftrace_dump_on_oops
> + * is set, then ftrace_dump is called. This will output the contents
> + * of the ftrace buffers to the console.  This is very useful for
> + * capturing traces that lead to crashes and outputing it to a
> + * serial console.
> + *
> + * It is default off, but you can enable it with either specifying
> + * "ftrace_dump_on_oops" in the kernel command line, or setting
> + * /proc/sys/kernel/ftrace_dump_on_oops to true.
> + */
> +int ftrace_dump_on_oops;

Hi Steven,

Please lose the /** (just use /*).  The documentation is a good thing,
but we don't do kernel-doc for simple variables.
That might be a good thing to add one day....

---
~Randy
