Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYFRKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYFRKab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYFRKaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:30:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYFRKaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:30:23 -0400
Date: Wed, 18 Jun 2008 12:30:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080618103006.GF15255@elte.hu>
References: <20080610214544.GA14824@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610214544.GA14824@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> Summary: Add missing include guards for some x86 headers.

applied to tip/x86/cleanups, thanks Vegard.

> This has only had the most rudimentary testing, but is hopefully 
> obviously correct. (That's just doomed to generate some sort of build 
> failure, isn't it?)

heh ;-)

> PS: I now have a pretty cool framework in Perl for parsing and 
> checking headers. And it can be used to transform them automatically 
> too. So if you want to standardize the guard format of all the headers 
> in one go, we have the means to do it quickly and efficiently...

very nice! I think the reference should be something like the unified 
include/asm-x86/processor.h.

could you try a run with that and put the result into a git tree for me 
to pull for review? I think we want to finetune that result and do a 
flag day for those cleanups, right after all the x86 topics went into 
v2.6.27.

	Ingo
