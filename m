Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbZKZJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbZKZJtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZKZJtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:49:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZKZJti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:49:38 -0500
Date: Thu, 26 Nov 2009 10:49:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: ling.ma@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Message-ID: <20091126094930.GD32275@elte.hu>
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* ling.ma@intel.com <ling.ma@intel.com> wrote:

> Benchmarks:                          improvement 
> volano                                8%
> netperf                               6.7% 
> tbench                                6.45%
> Kbuild                                5.5% (3 time test, average improvement)

that Kbuild result looks suspicious. A kbuild only uses 25% of system 
time, so an 5.5% improvement means that system utilization dropped from 
25% to 19.5%, a 28% improvement in the kernel! That looks rather 
unlikely.

Could you please post before/after 'perf stat --repeat 3' results so 
that we can see the noise level?

Thanks,

	Ingo
