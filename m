Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYAIAwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYAIAwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYAIAwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:52:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbYAIAwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:52:37 -0500
Date: Wed, 9 Jan 2008 01:52:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: m.kozlowski@tuxland.pl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at
	kernel/lockdep_proc.c:267 lockdep_stats_show()
Message-ID: <20080109005223.GA20392@elte.hu>
References: <200801081942.17139.m.kozlowski@tuxland.pl> <20080108.145038.203528847.davem@davemloft.net> <20080108225631.GA7021@elte.hu> <20080108.150609.43522839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108.150609.43522839.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 8 Jan 2008 23:56:31 +0100
> 
> > is this anything the core lockdep code could help improve? Let us know 
> > if any aspect is hindering you.
> 
> No, it's a sparc64 issue.
> 
> Another problem I ran into are the huge static table sizes lockdep 
> uses.  They really need to be either made smaller or dynamically 
> allocated.

Andi has submitted patches for that.

> Sparc64 has hard limitations on kernel size (due to firmware and 
> bootloader issues) and I hit these limits if I am not careful on SMP 
> with lockdep enabled.
> 
> Andi Kleen and I discussed in a thread several weeks ago. I believe 
> Andi even came up with a suggested direction to fix this.

yeah, i'll pick them up, probably tomorrow.

	Ingo
