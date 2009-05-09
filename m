Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZEIP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZEIP5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZEIP5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:57:46 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:41726 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbZEIP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:57:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8GAKtEBUpMQW1W/2dsb2JhbACBUM0Yg34F
Date: Sat, 9 May 2009 11:57:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509155742.GA6340@Krystal>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <20090509153629.GC29911@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090509153629.GC29911@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:55:25 up 70 days, 12:21,  4 users,  load average: 0.91, 0.55,
	0.57
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Sat, May 09, 2009 at 10:37:37AM +0200, Ingo Molnar wrote:
> > [...]
> > Firstly, it adds two new tracepoints to every system call. That is 
> > unnecessary - we already have the TIF flag based callbacks, and we 
> > can use the existing syscall attributes table to get to tracepoints 
> > - without slow down (or impacting) the fast path in any way.
> > [...]
> 
> However, as the TIF_SYSCALL_FTRACE and/or TIF_SYSCALL_TRACE flags are
> tied to a single consumer, it would limit the usefulness of the
> naturally multiple-client tracepoints, if they were made conditional
> on them.  Would you be interested in a proper reference-counting API?
> 

I've got this in my TIF_KERNEL_TRACE patchset. I think I should post it
as-is for RFC once more.

Mathieu

> - FChE

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
