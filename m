Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZANTK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZANTK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZANTKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:10:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZANTKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:10:48 -0500
Date: Wed, 14 Jan 2009 20:10:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com
Subject: Re: [PATCH fyi] RCU: the bloatwatch edition
Message-ID: <20090114191035.GA17521@elte.hu>
References: <20090113221724.GA15307@linux.vnet.ibm.com> <20090114104055.GD2913@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114104055.GD2913@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3901]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Just FYI, not for inclusion.
> > 
> > This patch is a version of RCU designed for !CONFIG_SMP provided as a 
> > proof of concept of a small-footprint RCU implementation.  In 
> > particular, the implementation of synchronize_rcu() is extremely 
> > lightweight and high performance.  It passes moderate rcutorture testing 
> > in each of the four relevant configurations (combinations of NO_HZ and 
> > PREEMPT) on x86.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> maybe it could be included - dependent on PREEMPT, just like we have SLOB?

s/PREEMPT/EMBEDDED

	Ingo
