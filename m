Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYHKT1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYHKT1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbYHKT1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:27:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39108 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbYHKT1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:27:33 -0400
Date: Mon, 11 Aug 2008 21:27:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/5] [PATCH 4/5] x86: Minor correction to Intel
	microcode patch loader.
Message-ID: <20080811192713.GG12788@elte.hu>
References: <20080806152117.198754464@amd.com> <20080806152320.081968686@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806152320.081968686@amd.com>
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


* Peter Oruba <peter.oruba@amd.com> wrote:

> Signed-off-by: Peter Oruba <peter.oruba@amd.com>
> ---
>  arch/x86/kernel/microcode_intel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
> index 4ab6ce3..8d69470 100644
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -315,7 +315,7 @@ static void apply_microcode(int cpu)
>  	unsigned long flags;
>  	unsigned int val[2];
>  	int cpu_num = raw_smp_processor_id();
> -	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
> +	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);

hm, this does not apply to tip/x86/microcode nor tip/master nor 
linus/master. Does it fix a bug in one of the earlier patches in this 
5/5 queue?

	Ingo
