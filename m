Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZFYB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZFYB0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZFYB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:26:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56505 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbZFYB0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:26:43 -0400
Message-ID: <4A42D284.2080501@cn.fujitsu.com>
Date: Thu, 25 Jun 2009 09:27:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 0/7] V2 add syscall tracepoints
References: <cover.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> hi,
> 
> The following is an implementation of Frederic's syscall tracer on top of
> tracepoints. It adds the ability to toggle the entry/exit of each syscall
> via the standard events/syscalls/syscall_blah/enable interface. The
> implementation is done by adding 2 tracepoints. One on entry and one for exit.
> 
> I've tried to address all of the comments from the last posting...updates include:
> -2/7: make arch_init_ftrace_syscalls static, removed locking, make patch bi-sectable
> -3/7: rename DECLARE_TRACE_REG as DECLARE_TRACE_WITH_CALLBACK
> -4/7: make mutex and counter static
> -7/7: add event tracing for syscalls that take no args
> 

Each patch should have a different title.

