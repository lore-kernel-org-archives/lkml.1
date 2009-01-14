Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZANKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZANKlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZANKlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:41:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZANKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:41:08 -0500
Date: Wed, 14 Jan 2009 11:40:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com
Subject: Re: [PATCH fyi] RCU: the bloatwatch edition
Message-ID: <20090114104055.GD2913@elte.hu>
References: <20090113221724.GA15307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113221724.GA15307@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Just FYI, not for inclusion.
> 
> This patch is a version of RCU designed for !CONFIG_SMP provided as a 
> proof of concept of a small-footprint RCU implementation.  In 
> particular, the implementation of synchronize_rcu() is extremely 
> lightweight and high performance.  It passes moderate rcutorture testing 
> in each of the four relevant configurations (combinations of NO_HZ and 
> PREEMPT) on x86.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

maybe it could be included - dependent on PREEMPT, just like we have SLOB?

it would also be rather educative IMO: if someone wants to understand the 
core concepts of RCU, start with kernel/rcutiny.c. We are getting 
complaints from academic institutions that the Linux kernel is getting too 
complex to teach in courses - and that's a pity.

	Ingo
