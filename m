Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZHQJtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZHQJtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZHQJtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:49:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZHQJtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:49:10 -0400
Date: Mon, 17 Aug 2009 11:48:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and
	'slabinfo'
Message-ID: <20090817094822.GA17838@elte.hu>
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Amerigo Wang <amwang@redhat.com> wrote:

> /proc/timer_list and /proc/slabinfo are not supposed to be 
> written, so there should be no write permissions on it.

good catch!

> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c

I have applied the timer_list bits to the timer tree. The SLUB/SLAB 
bits should go into the SLAB tree i guess.

Thanks,

	Ingo
