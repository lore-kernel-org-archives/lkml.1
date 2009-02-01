Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZBAKHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZBAKHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZBAKHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:07:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZBAKHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:07:33 -0500
Date: Sun, 1 Feb 2009 11:07:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Add cache descriptors for Intel Core i7
Message-ID: <20090201100721.GA23610@elte.hu>
References: <20090201011214.GA6043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090201011214.GA6043@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> --- linux-2.6.28.noarch/arch/x86/kernel/cpu/intel_cacheinfo.c~	2009-01-31 20:04:32.000000000 -0500
> +++ linux-2.6.28.noarch/arch/x86/kernel/cpu/intel_cacheinfo.c	2009-01-31 20:10:22.000000000 -0500
> @@ -36,8 +36,11 @@ static struct _cache_table cache_table[]
>  {
>  	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
>  	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
> +	{ 0x09, LVL_1_INST, 32 },	/* 4-way set assoc, 64 byte line size */

Applied to tip/x86/urgent, thanks Dave!

	Ingo
