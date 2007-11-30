Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXK3Kzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXK3Kzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXK3KzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:55:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXK3KzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:55:23 -0500
Date: Fri, 30 Nov 2007 11:54:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       ak@suse.de, suresh.b.siddha@intel.com,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Message-ID: <20071130105450.GE9941@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129155940.7df70ac2.akpm@linux-foundation.org>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> The patches were horridly wordwrapped.

yep, i already tried to check how well it integrates to x86.git:

 http://lkml.org/lkml/2007/11/29/93

the code does not seem to be layered correctly: i'd suggest to read the 
discussion between Roland McGrath and Alan Stern on lkml, about kwatch 
-> hw_breakpoint, to see how a more general debugging framework 
can/should be built. These things shouldnt be limited to user-space 
alone, the kernel could probably use hardware tracing even more than 
user-space could. (because it's a much harder to debug environment)

	Ingo
