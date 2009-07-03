Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZGCHNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZGCHNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZGCHN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:13:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZGCHN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:13:26 -0400
Date: Fri, 3 Jul 2009 09:13:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] gcov causes vread_tsc to increment kernel memory
Message-ID: <20090703071315.GE32687@elte.hu>
References: <alpine.DEB.2.00.0907011245230.22887@gandalf.stny.rr.com> <4A4CA0D5.6010103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4CA0D5.6010103@linux.vnet.ibm.com>
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


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> Also seeing as function tracer and gcov work on a similar basis 
> and require similar files to be excluded from profiling, it would 
> be nice if we wouldn't need to mark those files separately. [...]

One of the general things i pointed out during review is that 
there's a fair amount of overlap between tracing/instrumentation and 
the gcov support patches and now for a change Andrew has merged 
incomplete stuff upstream prematurely ;-) Andrew, could you please 
make sure this all gets fixed and the review suggestions get 
implemented?

	Ingo
