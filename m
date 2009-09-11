Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZIKTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZIKTEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZIKTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZIKTES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:04:18 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based 	event tracer update and perf support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
	<20090911013332.GB16396@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 11 Sep 2009 15:03:35 -0400
In-Reply-To: <20090911013332.GB16396@nowhere> (Frederic Weisbecker's message of "Fri, 11 Sep 2009 03:33:33 +0200")
Message-ID: <y0mr5udjoc8.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]  I'm really looking forward seeing this C expression-like
> kprobe creation tool.  It seems powerful enough to replace printk +
> kernel rebuild.  No need anymore to write some printk to debug,
> worrying, [...]

To a large extent, systemtap had delivered this already some years
ago, including the cushy ponies dancing in the sunlight.  While such
low-level machinery is fine, some of our experience indicates that it
is dramatically easier to use if high-level, symbolic, debugging data
is used to compute probe locations and variable names/types/locations.

It is also too easy to stress the low-level machinery beyond its
humble origins, in this case meaning putting probes in all kinds of
tender spots that go "ouch".  The kprobes robustness patches coming in
are great and will benefit all of our efforts, but it will be awhile
until the kernel can survive a fuzz/crashme type stress test on that
subsystem.  So expect ongoing effort there.

- FChE
