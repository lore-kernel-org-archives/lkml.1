Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752783AbYLRQv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLRQv6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLRQvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:51:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:41416 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYLRQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:51:47 -0500
Date: Thu, 18 Dec 2008 08:50:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ltt-dev@lists.casi.polymtl.ca, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] [PATCH] Simple LTTng userspace events through debugfs
Message-Id: <20081218085018.8bd1fd92.randy.dunlap@oracle.com>
In-Reply-To: <20081217173223.GA32699@Krystal>
References: <20081215231040.GA5936@Krystal>
	<20081216194201.GE843@elte.hu>
	<20081217041628.GA5409@Krystal>
	<20081217173223.GA32699@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.494A7F50.0106:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 12:32:24 -0500 Mathieu Desnoyers wrote:

> Index: linux-2.6-lttng/ltt/ltt-userspace-event.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/ltt/ltt-userspace-event.c	2008-12-17 12:03:43.000000000 -0500
> @@ -0,0 +1,129 @@
> +
> +/**
> + * write_event: write a userspace string into the trace stream

Hi Mathieu,

Please make above line:

 * write_event - write a userspace string into the trace system

Thanks.

> + * @file: file pointer
> + * @user_buf: user string
> + * @count: length to copy, including the final NULL
> + * @ppos: unused
> + *
> + * Copy a string into a trace event, in channel "userspace", event "event".
> + * Copies until either \n or \0 is reached.
> + * On success, returns the number of bytes copied from the source, including the
> + * \n or \0 character (if there was one in the count range). It cannot return
> + * more than count.
> + * Inspired from tracing_mark_write implementation from Steven Rostedt and
> + * Ingo Molnar.
> + */
> +static ssize_t write_event(struct file *file, const char __user *user_buf,
> +		size_t count, loff_t *ppos)
> +{


---
~Randy
