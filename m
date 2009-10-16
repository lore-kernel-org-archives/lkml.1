Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZJPHVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZJPHVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZJPHVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:21:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZJPHVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:21:38 -0400
Date: Fri, 16 Oct 2009 09:20:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86: Don't print number of MCE banks for every CPU
Message-ID: <20091016072016.GA30019@elte.hu>
References: <adaeip473qt.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaeip473qt.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

> The MCE initialization code explicitly says it doesn't handle asymmetric
> configurations where different CPUs support different numbers of MCE
> banks, and it prints a big warning in that case.  Therefore, printing
> the "mce: CPU supports <x> MCE banks" message into the kernel log for
> every CPU is pure redundancy that clutters the log significantly for
> systems with lots of CPUs.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks Roland!

	Ingo
