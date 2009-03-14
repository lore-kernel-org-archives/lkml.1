Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZCNLva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZCNLva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZCNLvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:51:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZCNLvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:51:18 -0400
Date: Sat, 14 Mar 2009 12:51:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
	when group is on
Message-ID: <20090314115105.GC3805@elte.hu>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com> <1236939816.22914.3714.camel@twins> <18874.20538.785519.824803@cargo.ozlabs.ibm.com> <1236948283.22447.36.camel@twins> <18874.57621.950179.972863@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18874.57621.950179.972863@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > The issue I have with your approach is two-fold:
> >  - it breaks the symmetry between software and hardware counters by
> >    treating them differently.
> 
> So... I was about to restore that symmetry by implementing 
> lazy PMU context switching.  [...]

That would be _really_ neat to have.

	Ingo
