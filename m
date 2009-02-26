Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZBZR6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZBZR6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZBZR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:58:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51406 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbZBZR6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:58:15 -0500
Date: Thu, 26 Feb 2009 18:57:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: hpa@zytor.com, mingo@redhat.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] tracing: implement trace_clock_*() APIs
Message-ID: <20090226175758.GA8262@elte.hu>
References: <tip-14131f2f98ac350ee9e73faed916d2238a8b6a0d@kernel.org> <20090226175302.GD5889@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226175302.GD5889@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> I missed this one.

because i just posted it :)

> Wouldn't your previous idea of a cmpxchg global clock be 
> better? Perhaps it would scale better while tracing on many 
> cpus.

a cmpxchg global clock has exactly the same cacheline-bouncing 
properties as the lock here, so there's no real difference.

	Ingo
