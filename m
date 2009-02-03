Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZBCFq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZBCFq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZBCFqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:46:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZBCFqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:46:18 -0500
Date: Tue, 3 Feb 2009 06:45:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, ak@linux.intel.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86_32: use 8 IPI vectors for tlb flush (as x86_64)
Message-ID: <20090203054559.GA20154@elte.hu>
References: <20090202235414.GA16750@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202235414.GA16750@gambetta>
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


* Frederik Deweerdt <frederik.deweerdt@xprog.eu> wrote:

> Hi,
> 
> The following patch allows using 8 different IPI vectors on ia32 for tlb
> flushes, this reduces the contention on the tlbstate_lock. It also makes
> the 32 bits version closer to the 64 bits version.

This was done recently :-(

Are you	aware of the x86 development tree? It's included in the -tip tree 
and can be found at:

  http://people.redhat.com/mingo/tip.git/README

Credit goes to Tejun Heo who unified the 32-bit and 64-bit TLB code (which 
also means 32-bit uses the 8 IPI vectors) - the code is now all in 
arch/x86/mm/tlb.c.

	Ingo
