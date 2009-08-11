Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZHKMRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZHKMRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZHKMRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:17:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZHKMRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:17:32 -0400
Date: Tue, 11 Aug 2009 14:17:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 10/12] add perf counter support
Message-ID: <20090811121711.GA31549@elte.hu>
References: <cover.1249932670.git.jbaron@redhat.com> <b9d3c5f9d0ff2fb71993530873807443a0c7eb64.1249932670.git.jbaron@redhat.com> <20090811121227.GF4938@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811121227.GF4938@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Aug 10, 2009 at 04:53:02PM -0400, Jason Baron wrote:
> > Make 'perf stat -e syscalls:sys_enter_blah' work with syscall style tracepoints.
> 
> 
> It would be nice to also be able to type:
> 
> perf stat -e syscalls:blah
> 
> and then having both enter/exit counters.

Plus wildcard/regex support would be nice as well in the listing of 
events. That way one could do a shortcut of:

 perf stat -e syscalls:*

to trace all syscalls. Or:

 perf stat -e syscalls:*read*

to see all the read variants - etc.

	Ingo
