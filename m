Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZCJMop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZCJMop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZCJMod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:44:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZCJMod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:44:33 -0400
Date: Tue, 10 Mar 2009 13:44:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090310124400.GG5794@elte.hu>
References: <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org> <20090308110150.GA19151@elte.hu> <49B43F1D.2000400@zytor.com> <20090308220609.GA23447@elte.hu> <49B441D9.4010004@zytor.com> <20090308221208.GA24079@elte.hu> <49B55AB0.1070605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B55AB0.1070605@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> Yeah - it was Jeremy expressed doubt in the numbers, not me.
>
> Mainly because I was seeing the instruction and cycle counts 
> completely unchanged from run to run, which is implausible.  
> They're not zero, so they're clearly measurements of 
> *something*, but not cycles and instructions, since we know 
> that they're changing.  So what are they measurements of?  And 
> if they're not what they claim, are the other numbers more 
> meaningful?

cycle count not changing in a macro-workload is not plausible. 
Instruction count not changing can happen sometimes - if the 
workload is deterministic (which this one is) and we happen to 
get exactly the same number of timer irqs during the test. But 
it's more common that it varies slightly - especially on SMP 
where task balancing can be timing-dependent and hence is noise.

	Ingo
