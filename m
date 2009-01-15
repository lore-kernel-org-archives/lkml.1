Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbZAORhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbZAORhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZAORhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:37:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZAORhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:37:38 -0500
Date: Thu, 15 Jan 2009 18:37:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73
	[PATCH supplied]
Message-ID: <20090115173725.GC22472@elte.hu>
References: <496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com> <496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu> <20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu> <496E78BA.5040609@sgi.com> <20090115101617.GH5833@elte.hu> <20090115122156.GA20349@elte.hu> <496F7299.3060900@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <496F7299.3060900@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2295]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > FYI, there's new warnings due to cpumask changes:
> > 
> > arch/x86/kernel/cpu/intel_cacheinfo.c: In function â€˜show_cache_disableâ€™:
> > arch/x86/kernel/cpu/intel_cacheinfo.c:710: warning: unused variable â€˜maskâ€™
> > arch/x86/kernel/cpu/intel_cacheinfo.c: In function â€˜store_cache_disableâ€™:
> > arch/x86/kernel/cpu/intel_cacheinfo.c:745: warning: unused variable â€˜maskâ€™
> > 
> > on 32-bit defconfig.
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> You can pull the following patch to fix this build warning.

pulled into tip/cpus4096, thanks Mike!

	Ingo
