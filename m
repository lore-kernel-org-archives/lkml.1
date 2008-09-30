Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYI3JMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYI3JMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYI3JMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:12:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYI3JMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:12:13 -0400
Date: Tue, 30 Sep 2008 11:11:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] cpumask: Provide new cpumask API
Message-ID: <20080930091140.GB27452@elte.hu>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <20080929180250.825653000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929180250.825653000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

>     /* replaces cpumask_t dst = (cpumask_t)src */
>     void cpus_copy(cpumask_t dst, const cpumask_t src);

minor namespace nit i noticed while looking at actual usage of 
cpus_copy(): could you please rename it cpumask_set(dst, src)?

That streamlines it to have the same naming concept as atomic_set(), 
node_set(), zero_fd_set(), etc.

the patch-set looks quite nice otherwise already, the changes are 
straightforward and the end result already looks a lot more maintainable 
and not fragile at all.

In what way will Rusty's changes differ? Since you incorporate some of 
Rusty's changes already, could you please iterate towards a single 
patchset which we could then start testing?

	Ingo
