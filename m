Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZEFMJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZEFMJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbZEFMJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:09:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249AbZEFMJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:09:35 -0400
Date: Wed, 6 May 2009 14:09:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, lethal@linux-sh.org, kernel@wantstofly.org,
       matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-ID: <20090506120909.GR25203@elte.hu>
References: <20090502163423.GA1633@linux.vnet.ibm.com> <12234.1241558327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12234.1241558327@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* David Howells <dhowells@redhat.com> wrote:

> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch is a version of RCU designed for (!SMP && EMBEDDED)
> > provided as a proof of concept of a small-footprint RCU implementation.
> > In particular, the implementation of synchronize_rcu() is extremely
> > lightweight and high performance.  It passes rcutorture testing in each
> > of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> > on x86.  This saves about 900 bytes compared to Classic RCU, and a
> > couple kilobytes compared to Hierarchical RCU (updated to 2.6.29):
> > ...
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

i'm wondering what Andrew thinks - he had objections, right?

	Ingo
