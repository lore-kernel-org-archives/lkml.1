Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZCCOKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZCCOKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZCCOKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:10:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZCCOKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:10:21 -0500
Date: Tue, 3 Mar 2009 15:09:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] rcu: introduce kfree_rcu V2
Message-ID: <20090303140955.GD23822@elte.hu>
References: <49AD342D.6030609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD342D.6030609@cn.fujitsu.com>
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

> 
> There are 23 instances where the rcu callback just does
> 
> 	kfree(containerof(head,struct whatever_struct,rcu_member));
> 
> The 23 instances exist because there are 23 'struct 
> whatever_struct' with their individual rcu_member. These 
> patches creates a generic kfree_rcu() function that removes 
> the need for these 23 helpers.

Nice idea. The patches dont actually remove the RCU helpers 
anywhere. Might be useful to include a few example conversions 
of this facility as well, so that the total impact can be seen.

	Ingo
