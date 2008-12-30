Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYL3Hu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYL3Hu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYL3HuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:50:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYL3HuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:50:15 -0500
Date: Tue, 30 Dec 2008 08:49:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] RCU: Don't include unnecessary headers, allow
	kmemtrace w/ tracepoints.
Message-ID: <20081230074952.GA5482@elte.hu>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro>
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


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> linux/percpu.h includes linux/slab.h, which generates circular inclusion
> dependencies when trying to switch kmemtrace to use tracepoints instead
> of markers. This patch allows tracing within slab headers' inline
> functions.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/linux/rcuclassic.h |    1 -
>  include/linux/rcupdate.h   |    1 -
>  include/linux/rcupreempt.h |    2 +-
>  3 files changed, 1 insertions(+), 3 deletions(-)

applied to tip/core/rcu, thanks Eduard!

I'll do some build coverage testing to see whether there's anything that 
assumes the presence of percpu.h.

	Ingo
