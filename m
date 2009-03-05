Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZCELGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZCELGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZCELFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:05:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZCELFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:05:39 -0500
Date: Thu, 5 Mar 2009 12:05:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
Message-ID: <20090305110522.GI32407@elte.hu>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com> <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com> <1236250159.4228.186.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236250159.4228.186.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-03-05 at 02:29 -0800, David Rientjes wrote:
> > The CONFIG_DEBUG_LOCKDEP statistics need to be initialized with
> > ATOMIC_INIT(0) since they are of type atomic_t.
> 
> And how does ATOMIC_INIT(0) differ from the global/static 
> storage being initialized to 0?
> 
> All I can see this doing it moving the variables from bss to 
> data for some compilers.

ok, i dropped it for now.

	Ingo
