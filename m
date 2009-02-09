Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZBIKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZBIKQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZBIKQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:16:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZBIKQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:16:00 -0500
Date: Mon, 9 Feb 2009 11:15:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series
	- v2
Message-ID: <20090209101552.GF20467@elte.hu>
References: <20090207005205.GB17586@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207005205.GB17586@linux-os.sc.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> For Intel 7400 series CPUs, the recommendation is to use a clflush on the 
> monitored address just before monitor and mwait pair [1]. This clflush makes sure 
> that there are no false wakeups from mwait when the monitored address was recently 
> written to.
> 
> [1] "MONITOR/MWAIT Recommendations for Intel Xeon Processor 7400 series"
> section in specification update document of 7400 series
> http://download.intel.com/design/xeon/specupdt/32033601.pdf
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---
> 
> Earlier patch:
> http://marc.info/?l=linux-kernel&m=122341330606025&w=2
> 
> Current changes:
> Minor modification based on Peter's comment
> 
>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/intel.c       |    3 +++
>  arch/x86/kernel/process.c         |    6 ++++++
>  3 files changed, 10 insertions(+)

applied to tip/x86/urgent, thanks Venki!

	Ingo
