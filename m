Return-Path: <linux-kernel-owner+w=401wt.eu-S966367AbXEHJpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966367AbXEHJpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934564AbXEHJpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:45:12 -0400
Received: from www.osadl.org ([213.239.205.134]:56675 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934501AbXEHJpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:45:10 -0400
Subject: Re: [PATCH 1/5] x86_64: tsc compile fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070508094236.GT3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <20070508094236.GT3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:47:56 +0200
Message-Id: <1178617676.3042.303.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:42 -0700, Chris Wright wrote:
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> Just double checked, this is already picked up in -v2 patch.
> 
>  arch/x86_64/kernel/tsc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- tglx.orig/arch/x86_64/kernel/tsc.c
> +++ tglx/arch/x86_64/kernel/tsc.c
> @@ -84,7 +84,7 @@ static struct notifier_block time_cpufre
>  static int __init cpufreq_tsc(void)
>  {
>  	cpufreq_register_notifier(&time_cpufreq_notifier_block,
> -				  CPUFREQ_TRANSITION_NOTIFIER))
> +				  CPUFREQ_TRANSITION_NOTIFIER);
>  	return 0;
>  }

Yep, have this already in my -v2 set along with the i386 compile fix
from Venki.

	tglx



