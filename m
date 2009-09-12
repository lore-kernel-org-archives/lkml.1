Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZILKZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZILKZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 06:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZILKZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 06:25:42 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33701 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZILKZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 06:25:41 -0400
Date: Sat, 12 Sep 2009 11:25:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph
 tracer
Message-ID: <20090912102506.GC21695@console-pimps.org>
References: <20090911135452.866274568@goodmis.org>
 <20090911135626.824079836@goodmis.org>
 <20090911145521.GA6119@nowhere>
 <1252681916.18996.697.camel@gandalf.stny.rr.com>
 <20090911151811.GB6119@nowhere>
 <4AAA6EE2.8000807@gmail.com>
 <1252684229.18996.699.camel@gandalf.stny.rr.com>
 <4AAA75E0.6020604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AAA75E0.6020604@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 07:08:00PM +0300, Török Edwin wrote:
> 
> BTW any plans on integrating an in-kernel unwinder like systemtap has?
> 
> Even if I build libc with framepointers, a userspace stacktrace on
> x86-64 can't go beyond most pthreads routines, like __read_nocancel
> (they're written in asm maybe?).
> 

fyi SH has an in-kernel DWARF unwinder. It was my intention to shake out
most of the bugs (of which there have been a few) by having it in the SH
tree and then submit it for generic inclusion.

So by carefully placing .cfi_* directives in assembly, you can get
stacktraces for assembly routines in the kernel.

The branch containing the latest code is here,
http://git.kernel.org/?p=linux/kernel/git/lethal/sh-2.6.git;a=shortlog;h=sh/dwarf-unwinder
