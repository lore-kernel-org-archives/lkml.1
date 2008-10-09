Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYJIWPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYJIWPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYJIWPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:15:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:40203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYJIWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:15:32 -0400
Subject: Re: Building a tracing userspace tool in the kernel tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20081009191626.GA29344@Krystal>
References: <20081009191626.GA29344@Krystal>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 00:15:13 +0200
Message-Id: <1223590513.7382.45.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 15:16 -0400, Mathieu Desnoyers wrote:
> Hi Sam,
> 
> At the kernel summit, people seemed to be interested to have the basic
> userspace tools required to extract and pretty-print a trace available
> within the kernel tree. Therefore, what I am trying to do is something
> along the lines of
> 
> ltt/usr/
> ltt/usr/tracectl/    (control tracing)
> ltt/usr/tracesplice/ (splice buffers to disk)
> ltt/usr/tracecat/    (merge sort and format the binary buffers into
>                       human-readable text)

I'd rather have you provide that interface from the kernel much like
ftrace does. So we can do:

# cat /debug/tracing/lttng/trace



