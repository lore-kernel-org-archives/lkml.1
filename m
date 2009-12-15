Return-Path: <linux-kernel-owner+w=401wt.eu-S933442AbZLOTXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbZLOTXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933428AbZLOTXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:23:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbZLOTXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:23:38 -0500
Date: Tue, 15 Dec 2009 20:22:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 00/14] perf-probe updates
Message-ID: <20091215192258.GB15443@elte.hu>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=FS_TIP_DDD autolearn=no SpamAssassin version=3.2.5
	0.0 FS_TIP_DDD             Phrase: subject = tip ddd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo,
> 
> Here are several bugfixes and updates of perf-probe.
> This updates includes below features.
> 
>   - Support checking kernel Build-ID
> 	Comparing vmlinux build-id and running kernel build-id
> 	can prevent user to set incorrect probes by using
> 	old/incorrect vmlinux.
> 
>   - Symbol search by libelf/kallsyms
> 	This allows to check probed symbol exists in the kernel
> 	even if debuginfo is not available.
> 
>   - Support glob expression with --del option (like --del '*')
> 	This allows users to use wildcard for specifying
> 	deleting events.
> 
>   - Reject adding same-name events
> 	Rejecting to add event which name already exists.
> 
>   - Support event name specifying for new events
> 	This allows users to set their own name to new
> 	events. Currently setting group name is not
> 	allowed, because it will conflict with other
> 	tracepoints and kmem event.
> 
> I think the glob expression (wildcard matching) can be
> applied to other perf tools for choosing events, and it
> will give user better experience :-)

Very nice improvements! :)

Applied, thanks!

	Ingo
