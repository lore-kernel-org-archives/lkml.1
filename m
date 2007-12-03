Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXLCKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXLCKGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXLCKGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:06:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXLCKGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:06:17 -0500
Date: Mon, 3 Dec 2007 11:05:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203100554.GA30050@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200711301346.22573.nickpiggin@yahoo.com.au> <1196392527.25646.65.camel@ymzhang> <200711301429.15664.nickpiggin@yahoo.com.au> <20071130100845.GB2201@elte.hu> <1196674170.25646.121.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196674170.25646.121.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Although no source codes of volanoMark, I suspect it calls 
> Thread.sched. volanoMark is a kind of chatroom benchmark. When a 
> client sends out a message, server will send the message to all 
> clients. I suspect the client calls Thread.yield after sending out a 
> couple of messages.

yeah, so far only volanomark seems to be affected by this, and if it 
indeed calls Thread.yield artificially it's a pretty stupid benchmark 
and it's not the fault of the JDK. If we had the source to volanomark we 
could fix this easily.

> 2 JVM all have regression if sched_compat_yield=0.
> 
> I ran some testing, such like iozone/specjbb/tbench/dbench/sysbench, 
> and didn't see regression.

which JVM was utilized by the specjbb (Java Business Benchmark) tests?

	Ingo
