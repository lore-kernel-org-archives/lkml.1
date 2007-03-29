Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXC2NUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXC2NUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXC2NUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:20:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbXC2NUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:20:40 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070326123141.GA11288@ucw.cz> <1174917142.4182.39.camel@chaos>
	<200703271719.25795.lenb@kernel.org>
	<Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Mar 2007 16:19:25 +0200
In-Reply-To: <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
Message-ID: <p73hcs42kuq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 27 Mar 2007, Len Brown wrote:
> > 
> > I think the only fool-proof way to do this automatically is to
> 
> Why not just take the known-good CPUID signature?

I didn't think we could reliably distingush mobile cpus with C2+ 
versus desktop CPUs without it. Or rather you would need a table
for each new CPU revision Intel/AMD put out. That would be probably
quite nightmarish to maintain.

-Andi
