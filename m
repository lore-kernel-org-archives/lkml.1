Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZKHJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZKHJja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZKHJj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:39:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZKHJj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:39:26 -0500
Date: Sun, 8 Nov 2009 10:38:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
Message-ID: <20091108093859.GA2845@elte.hu>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com>
 <4AF25FC7.4000502@kernel.org>
 <20091105082102.GA2870@elte.hu>
 <4AF28D7A.6020209@kernel.org>
 <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de>
 <4AF3B9BD.9050300@kernel.org>
 <20091106071711.GA20946@elte.hu>
 <20091106095922.GH8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106095922.GH8742@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Nov 06 2009, Ingo Molnar wrote:
> > Read the lockdep message please, consider all the backtraces it prints, 
> > it says something different.
> 
> In all honesty, reading and parsing lockdep messages requires a 
> special state of mind. IOW, readability is not its high point.

We frequently do patches to improve the messages but there's a hard 
limit: generally the messages mirror the complexity of the underlying 
locking scenario.

Unfortunately lockdep cannot pretend something is simple when it is not. 
There are two ways out of that: either to simplify the underlying 
locking rules, or to understand them.

	Ingo
