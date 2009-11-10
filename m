Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZKJUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZKJUxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbZKJUxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:53:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZKJUxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:53:50 -0500
Date: Tue, 10 Nov 2009 21:53:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix typo in intel cache size
Message-ID: <20091110205342.GA23196@elte.hu>
References: <20091110200120.GA27090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110200120.GA27090@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> I double-checked the datasheet. This should be 2MB.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 804c40e..6123138 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -94,7 +94,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
>  	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
>  	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
>  	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
> -	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
> +	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */

ah, thanks - applied.

I also marked both fixes from you for -stable backport - these are 
pretty risk-free fixes and cpuinfo looks ugly on new CPUs without a 
proper cache size entry.

Thanks,

	Ingo
