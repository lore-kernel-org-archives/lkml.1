Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbZFOP7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbZFOP7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZFOP64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:58:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZFOP6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:58:55 -0400
Date: Mon, 15 Jun 2009 17:58:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 4/7] tracing: replace a GFP_ATOMIC with GFP_KERNEL
	allocation
Message-ID: <20090615155850.GC19529@elte.hu>
References: <20090615154226.058101204@goodmis.org> <20090615154411.136115951@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615154411.136115951@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Li Zefan <lizf@cn.fujitsu.com>
> 
> Atomic allocation is not needed here.
> 
> [ Impact: clean up of memory alloction type ]

Note, the impact line was probably not needed here - and if we add 
one then the correct one would be:

 [ Impact: use less failure-prone (non-atomic) allocations ]

	Ingo
