Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYAOQdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYAOQdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYAOQd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:33:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYAOQd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:33:28 -0500
Date: Tue, 15 Jan 2008 17:32:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20080115163251.GC31270@elte.hu>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But as mentioned, it's totally untested and I don't have (or really 
> want to have) a cross-compiling environment. And I don't care *that* 
> much. I just want something we can all live with.
> 
> So does something like this work for people?

>  arch/arm/Kconfig                 |    2 +-
>  arch/arm/Kconfig.instrumentation |   52 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 1 deletions(-)

i like this approach better, not the least because it affects only one 
architecture so late in the .24-rc cycle. Instrumentation bugs tend to 
be found with a few weeks/months of delays. (because historically 
instrumentation has been typically used by folks who cannot change their 
kernel easily to debug it, i.e. by extension they dont run bleeding edge 
kernels either.)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
