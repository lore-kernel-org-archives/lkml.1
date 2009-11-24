Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbZKXSWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbZKXSWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbZKXSWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:22:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933773AbZKXSWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:22:08 -0500
Date: Tue, 24 Nov 2009 19:20:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091124182059.GB11894@elte.hu>
References: <20091120211139.GB19106@sgi.com>
 <m1r5rrr9v5.fsf@fess.ebiederm.org>
 <20091122011457.GA16910@sgi.com>
 <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
 <1259069986.4531.1453.camel@laptop>
 <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
 <20091124065022.6933be1a@infradead.org>
 <m1ws1f6csh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ws1f6csh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Currently the irq code treats /proc/irq/N/smp_affinity as a strong 
> hint on where we would like interrupts to be delivered, and we don't 
> have good feedback from there to architecture specific code that knows 
> what we really can do.  It is going to take some effort and some work 
> to make that happen.
> 
> I think the irq scheduler is the only scheduler (except for batch 
> jobs) that we don't put in the kernel.  It seems to me that if we are 
> going to go to all of the trouble to rewrite the generic code to 
> better support irqbalance because we are having serious irqbalance 
> problems, it will be less effort to suck irqbalance into the kernel 
> along with everything else.
> 
> I really think irqbalancing belongs in the kernel. [...]

Interesting. I've yet to see a solution that is maintainable and works 
well, without putting too much policy into the kernel. Our previous 
solutions didnt really work all that well.

What would your model be, and can it be implemented reasonably?

	Ingo
