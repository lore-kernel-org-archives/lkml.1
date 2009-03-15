Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZCOS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZCOS5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZCOS45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:56:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZCOS44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:56:56 -0400
Date: Sun, 15 Mar 2009 19:56:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-tip-commits@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate
	reclaim context (__GFP_NOFS), fix SLOB)
Message-ID: <20090315185618.GC19737@elte.hu>
References: <20090128135457.350751756@chello.nl> <tip-bf722c9d324864b4256edaa330751b77f2a19861@git.kernel.org> <20090315064818.GA1193@elte.hu> <200903152006.21160.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903152006.21160.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> +		spin_lock_irqrestore(&slob_lock, flags);

that should be:

		spin_unlock_irqrestore(&slob_lock, flags);

	Ingo
