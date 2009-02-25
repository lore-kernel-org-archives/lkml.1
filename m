Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbZBYLUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbZBYLUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbZBYLU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:20:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761516AbZBYLUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:20:25 -0500
Date: Wed, 25 Feb 2009 12:20:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: memtest: add additional (regular) test
	patterns
Message-ID: <20090225112017.GF15453@elte.hu>
References: <20090225102337.GP6298@alberich.amd.com> <20090225103149.GW6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225103149.GW6298@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/mm/memtest.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
> index 9c52ef1..0bcd788 100644
> --- a/arch/x86/mm/memtest.c
> +++ b/arch/x86/mm/memtest.c
> @@ -14,6 +14,19 @@ static u64 patterns[] __initdata = {
>  	0xffffffffffffffffULL,
>  	0x5555555555555555ULL,
>  	0xaaaaaaaaaaaaaaaaULL,
> +	0x1111111111111111ULL,
> +	0x2222222222222222ULL,
> +	0x4444444444444444ULL,
> +	0x8888888888888888ULL,
> +	0x3333333333333333ULL,
> +	0x6666666666666666ULL,
> +	0x9999999999999999ULL,
> +	0xccccccccccccccccULL,
> +	0x7777777777777777ULL,
> +	0xbbbbbbbbbbbbbbbbULL,
> +	0xddddddddddddddddULL,
> +	0xeeeeeeeeeeeeeeeeULL,
> +	0x7a6c7258554e494cULL, /* yeah ;-) */

it indeed does ;-)

	Ingo
