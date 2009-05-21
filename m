Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZEUXef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZEUXef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZEUXe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:34:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2633 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbZEUXe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:34:27 -0400
Subject: Re: [PATCH 2/3] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: Use
 DO_ONCE & spelling fix
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20090521232604.GA26150@redhat.com>
References: <cover.1242943463.git.joe@perches.com>
	 <a4b6b12afa9cf1ee6e936de5eed7cb31181553d8.1242943463.git.joe@perches.com>
	 <20090521232604.GA26150@redhat.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 16:34:01 -0700
Message-Id: <1242948841.3373.145.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 19:26 -0400, Dave Jones wrote:
> On Thu, May 21, 2009 at 04:00:23PM -0700, Joe Perches wrote:
>  > diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
>  > index 208ecf6..f569cff 100644
>  > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
>  > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
>  > @@ -693,8 +693,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  >  	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
>  >  	    policy->cpuinfo.transition_latency > 20 * 1000) {
>  >  		policy->cpuinfo.transition_latency = 20 * 1000;
>  > -			printk_once(KERN_INFO "Capping off P-state tranision"
>  > -				    " latency at 20 uS\n");
>  > +		DO_ONCE(printk(KERN_INFO
>  > +			       "P-state transition latency capped at 20 uS\n"));
>  
> ewww. This looks pretty ugly to me. Anyone else?

What look ugly?

The macro use or the newline between KERN_INFO and "P-"
or the reformatting of the quoted string?

