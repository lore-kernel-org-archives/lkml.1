Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZA2U0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZA2U0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZA2U0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:26:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36358 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZA2U0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:26:33 -0500
Date: Thu, 29 Jan 2009 21:26:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
Message-ID: <20090129202623.GB12819@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <1233193977.15801.72.camel@vayu> <20090129112700.GA9624@elte.hu> <20090129201108.GA9994@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129201108.GA9994@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, Jan 29, 2009 at 03:27:00AM -0800, Ingo Molnar wrote:
> > Did it work fine on xapic otherwise?
> 
> xapic fix for 32bit platform with less than 8 cpu's appended. Thanks.
> ---
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
> index 61339a0..b5db26f 100644
> --- a/arch/x86/kernel/probe_32.c
> +++ b/arch/x86/kernel/probe_32.c
> @@ -113,7 +113,7 @@ struct genapic apic_default = {
>  	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
>  
>  	.send_IPI_mask			= default_send_IPI_mask,
> -	.send_IPI_mask_allbutself	= NULL,
> +	.send_IPI_mask_allbutself	= default_send_IPI_mask_allbutself,
>  	.send_IPI_allbutself		= default_send_IPI_allbutself,
>  	.send_IPI_all			= default_send_IPI_all,
>  	.send_IPI_self			= NULL,

applied to tip/x86/apic, thanks Suresh!

	Ingo
