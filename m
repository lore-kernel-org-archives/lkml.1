Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbZCQKOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbZCQKOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZCQKOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:14:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58742 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbZCQKO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:14:29 -0400
Date: Tue, 17 Mar 2009 11:13:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       ego@in.ibm.com, tglx@linutronix.de, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 3/4] timers: /proc/sys sysctl hook to enable timer
	migration
Message-ID: <20090317101356.GF6477@elte.hu>
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111444.GD4686@linux.vnet.ibm.com> <20090316152956.GA2344@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316152956.GA2344@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Mar 16, 2009 at 04:44:44PM +0530, Arun R Bharadwaj wrote:
> > echo 0 > /proc/sys/kernel/timer_migration
> 
> There should be no sysctl for this.
> 
> Timer migration should be good enough to be always enabled.

It's in the CONFIG_SCHED_DEBUG section - i.e. only available 
under scheduler debugging. (and it's a fair flag for that case)

	Ingo
