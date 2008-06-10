Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYFJK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYFJK3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYFJK3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:29:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbYFJK3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:29:09 -0400
Date: Tue, 10 Jun 2008 12:28:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing
	cpus_allowed
Message-ID: <20080610102858.GE19136@elte.hu>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> Kthreads that have called kthread_bind() are bound to specific cpus, 
> so other tasks should not be able to change their cpus_allowed from 
> under them.  Otherwise, it is possible to move kthreads, such as the 
> migration or software watchdog threads, so they are not allowed access 
> to the cpu they work on.

applied to tip/sched-devel, thanks David.

	Ingo
