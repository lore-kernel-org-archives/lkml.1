Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZHRPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZHRPiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZHRPiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:38:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZHRPiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:38:21 -0400
Date: Tue, 18 Aug 2009 17:38:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] replace various uses of num_physpages by totalram_pages
Message-ID: <20090818153815.GA11913@elte.hu>
References: <4A8AE6280200007800010539@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8AE6280200007800010539@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jan Beulich <JBeulich@novell.com> wrote:

> Sizing of memory allocations shouldn't depend on the number of 
> physical pages found in a system, as that generally includes 
> (perhaps a huge amount of) non-RAM pages. The amount of what 
> actually is usable as storage should instead be used as a basis 
> here.
> 
> Some of the calculations (i.e. those not intending to use high 
> memory) should likely even use (totalram_pages - 
> totalhigh_pages).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> ---
>  arch/x86/kernel/microcode_core.c  |    4 ++--

Acked-by: Ingo Molnar <mingo@elte.hu>

Just curious: how did you find this bug? Did you find this by 
experiencing problems on a system with a lot of declared non-RAM 
memory?

	Ingo
