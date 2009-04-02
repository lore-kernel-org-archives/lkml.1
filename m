Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbZDBKak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbZDBKak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZDBKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:30:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbZDBKa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:30:29 -0400
Date: Thu, 2 Apr 2009 12:30:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: cacheinfo: complete L2/L3 Cache and TLB
	associativity field definitions
Message-ID: <20090402103008.GA10828@elte.hu>
References: <20090402100756.GN5740@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402100756.GN5740@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Impact: complete cache information for AMD CPUs
> 
> See "CPUID Specification" (AMD Publication #: 25481, Rev. 2.28, April 2008)
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> Please apply.

Hm, the x86/cpu topic is marked broken and blocked by another AMD 
patch from Mark Langsdorf:

 45ca863: x86, cpu: conform L3 Cache Index Disable to Linux standards

We cannot queue up new patches there before this one is fixed. I've 
attached below my last bugreport about it.

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Thu, 19 Mar 2009 09:18:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Subject: Re: [PATCH][retry 5] Conform L3 Cache Index Disable to Linux
	Standards
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	eric@lammerts.org, hpa@zytor.com


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> Add ABI Documentation entry and fix some /sys directory formating
> issues with the L3 Cache Index Disable feature for future AMD
> processors.  Add a check to disable it for family 0x10 models
> that do not support it properly.  Correct the disable algorithm
> to reflect erratum 388.
>     
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

i'm still getting this build failure:

 arch/x86/mm/built-in.o:(.bss+0x3640): multiple definition of `k8_northbridges'

i've reported this build failure before. I've excluded this commit 
from tip:master for now.

	Ingo

----- End forwarded message -----

