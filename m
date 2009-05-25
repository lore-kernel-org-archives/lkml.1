Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZEYDfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZEYDfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZEYDfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:35:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58418 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZEYDfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:35:36 -0400
Date: Mon, 25 May 2009 05:34:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, suresh.b.siddha@intel.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2.6.30-rc7] x86: remove remap percpu allocator for the
	time being
Message-ID: <20090525033429.GC20687@elte.hu>
References: <4A1A0A27.4050301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A0A27.4050301@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Tejun Heo <tj@kernel.org> wrote:

> @@ -365,9 +249,7 @@ void __init setup_per_cpu_areas(void)
>  	 * of large page mappings.  Please read comments on top of
>  	 * each allocator for details.
>  	 */
> -	ret = setup_pcpu_remap(static_size);
> -	if (ret < 0)
> -		ret = setup_pcpu_embed(static_size);
> +	ret = setup_pcpu_embed(static_size);
>  	if (ret < 0)
>  		ret = setup_pcpu_4k(static_size);
>  	if (ret < 0)

Please send a patch that only does the above chunk in essence. We 
can deal with the rest in .31.

Thanks,

	Ingo
