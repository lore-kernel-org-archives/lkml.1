Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYL0KXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYL0KXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYL0KWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:22:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYL0KWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:22:55 -0500
Date: Sat, 27 Dec 2008 11:22:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: clean up setup_clear/force_cpu_cap handling
Message-ID: <20081227102234.GD14639@elte.hu>
References: <49509418.6040905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49509418.6040905@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix and cleanup
> 
> setup_force_cpu_cap() only have one user xen
> but it should not reuse cleared_cpu_cpus. it will have problem
> for smp.
> 
> need to have cpu_cpus_set array too.
> also need to setup handling before all cpus cap AND
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> 
> ---
>  arch/x86/include/asm/cpufeature.h |    4 ++--
>  arch/x86/include/asm/processor.h  |    3 ++-
>  arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
>  3 files changed, 16 insertions(+), 8 deletions(-)

Rusty, you'll carry this patch in your linux-2.6-boot-params.git tree, 
right? Merging this in the x86 tree would just needlessly complicate your 
logistics, right?

	Ingo
