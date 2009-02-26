Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbZBZFgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbZBZFgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZBZFfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:35:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654AbZBZFft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:35:49 -0500
Date: Thu, 26 Feb 2009 06:35:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters/powerpc: Add support for POWER5 processors
Message-ID: <20090226053534.GA25065@elte.hu>
References: <18854.9377.127957.306360@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18854.9377.127957.306360@drongo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> This adds the back-end for the PMU on the POWER5 processor.  This knows
> how to use the fixed-function PMC5 and PMC6 (instructions completed and
> run cycles).  Unlike POWER6, PMC5/6 obey the freeze conditions and can
> generate interrupts, so their use doesn't impose any extra restrictions.
> 
> POWER5+ is different and is not supported by this patch.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Ingo, please pull this from my perfcounters.git tree master branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
>  arch/powerpc/kernel/Makefile       |    3 +-
>  arch/powerpc/kernel/perf_counter.c |    4 +
>  arch/powerpc/kernel/power5-pmu.c   |  475 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 481 insertions(+), 1 deletions(-)
>  create mode 100644 arch/powerpc/kernel/power5-pmu.c

Pulled into tip:perfcounters/core, thanks Paul!

	Ingo
