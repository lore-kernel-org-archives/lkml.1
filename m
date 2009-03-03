Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZCCOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZCCOHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZCCOHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:07:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZCCOHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:07:42 -0500
Date: Tue, 3 Mar 2009 15:07:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 5/6] slqb: introduce __kfree_rcu
Message-ID: <20090303140724.GC23822@elte.hu>
References: <49AD3448.6050105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD3448.6050105@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Introduce __kfree_rcu() for kfree_rcu()
> 
> It like __kfree_rcu() in slab.c, slub.c
> We can calculate the object poiter from a poiter inside this
> object in slqb.c, so we can use it for rcu callback and free
> the object.

s/poiter/pointer

(that typo is in other patches too.)

	Ingo
