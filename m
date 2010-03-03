Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0CCV6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:58:00 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756825Ab0CCV5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:57:51 -0500
Date: Wed, 3 Mar 2010 22:57:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: venkatesh.pallipadi@intel.com, Ingo Molnar <mingo@elte.hu>,
       H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq
	governor
Message-ID: <20100303215453.GG2579@ucw.cz>
References: <20100303000649.757684000@intel.com> <20100303000849.278509000@intel.com> <4B8DADB9.1040302@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8DADB9.1040302@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> index 8c666d8..4945add 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -749,6 +749,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Default value is 0.
>  			Value can be changed at runtime via /selinux/enforce.
>  
> +	epb		[X86] Control IA32_ENERGY_PERF_BIAS setting
> +			"disable" - Kernel will not modify this MSR
> +			<0..15> - Kernel will set this MSR to i/p static value
> +
> 
> 
> Should be more like:
> 
> 	epb=		[X86] Control IA32_ENERGY_PERF_BIAS setting
> 			Format: { disable | <0...15> }
> 			"disable" - Kernel will not modify this MSR
> 			<0..15> - Kernel will set this MSR to i/p static value
> 
> 
> But what is "i/p"?  Use whatever word it should be, please.
> What do the values mean?
> And what does IA32 have to do with this?  does it not apply to x86_64?

Exactly. This is end user documentation, it should not even talk about
MSRs. Tell us what the setting does...

Also... does it make change to tweak the setting during runtime? Maybe
different settings for AC and battery power?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
