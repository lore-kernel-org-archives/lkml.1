Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZCUOkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZCUOkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCUOk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:40:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZCUOkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:40:25 -0400
Date: Sat, 21 Mar 2009 15:40:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Restrict definitions of a couple of static
	functions
Message-ID: <20090321144013.GB25729@elte.hu>
References: <1237644922-7877-1-git-send-email-dmitri.vorobiev@movial.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237644922-7877-1-git-send-email-dmitri.vorobiev@movial.com>
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


* Dmitri Vorobiev <dmitri.vorobiev@movial.com> wrote:

> The call sites of the static functions free_cache_attributes() and
> detect_cache_attributes() in arch/x86/kernel/cpu/intel_cacheinfo.c
> are placed under #ifdef CONFIG_SYSFS/#endif, but their definitions
> are not. This may produce the following warning:
> 
> arch/x86/kernel/cpu/intel_cacheinfo.c:542: warning:
> 'free_cache_attributes' defined but not used
> arch/x86/kernel/cpu/intel_cacheinfo.c:573: warning:
> 'detect_cache_attributes' defined but not used
> 
> This patch fixes the warning by restricting the definitions of the
> two functions to the case when CONFIG_SYSFS is enabled.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   64 ++++++++++++++++----------------
>  1 files changed, 32 insertions(+), 32 deletions(-)

does not apply to the latest x86 tree anymore:

  http://people.redhat.com/mingo/tip.git/README

2 out of 3 hunks FAILED -- rejects in file arch/x86/kernel/cpu/intel_cacheinfo.c

	Ingo
