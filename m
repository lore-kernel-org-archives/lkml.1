Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYINM70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYINM70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYINM7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:59:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYINM7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:59:18 -0400
Date: Sun, 14 Sep 2008 14:59:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: macro@linux-mips.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [patch 0/2] -tip/master APIC fixes
Message-ID: <20080914125900.GC22281@elte.hu>
References: <48ccc4e3.0437560a.2f7a.5608@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ccc4e3.0437560a.2f7a.5608@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

>   Here are two patches with a few nits fixed
> 
> - lapic_setup_esr should inform us if ESR was asked to
>   not being touched (this nit is brough in by one of mine
>   commit during unification process -- not a serious issue
>   but...actually nit, sorry for this)
> - dont touch ESR register on 82489DX in setup_local_APIC
> 
>   Please review, any comments are highly appreciated!

applied to tip/irq/sparseirq:

 eeb0a2e: x86: apic - skip writting ESR register if we dont have on
 e613c97: x86: apic - lapic_setup_esr does not handle esr_disable - fix it

thanks Cyrill,

	Ingo
