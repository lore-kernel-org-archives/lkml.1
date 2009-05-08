Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbZEHJTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbZEHJTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757067AbZEHJTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:19:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZEHJTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:19:30 -0400
Date: Fri, 8 May 2009 11:19:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Adam Langley <agl@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, markus@google.com
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
Message-ID: <20090508091912.GB3559@elte.hu>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa> <20090507221447.GE28770@elte.hu> <a84d7bc60905071534l1e65f216mfd9330e93e4da4e2@mail.gmail.com> <20090507230021.GC6472@nowhere> <1241760745.9416.37.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241760745.9416.37.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> I guess it would be easier for seccomp to make use of the 
> filtering and reuse the syscall tracing facility if we added 
> filtering to the syscall tracer first.  It would be useful to do 
> for the syscall tracer anyway, regardless of whether it (or 
> something similar) ended up being used by seccomp.
> 
> Frederic, did you have any plans for that?  If not, I can take a 
> look when I get the chance...

Doing that would be very nice and useful indeed.

	Ingo
