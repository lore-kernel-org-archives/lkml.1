Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYG3RLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYG3RLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYG3RLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:11:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39056 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753046AbYG3RLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:11:11 -0400
Message-ID: <4890A0A8.4000502@sgi.com>
Date: Wed, 30 Jul 2008 10:11:04 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use	cpumask_of_cpu_map
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com> <20080730165539.GA10079@codemonkey.org.uk>
In-Reply-To: <20080730165539.GA10079@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, Jul 23, 2008 at 10:18:42AM -0700, Mike Travis wrote:
>  >   * The previous "lvalue replacement for cpumask_of_cpu()" was not usable
>  >     in certain situations and generally added unneeded complexity.  So
>  >     this patch replaces the cpumask_of_cpu_ptr* macros with a generic
>  >     cpumask_of_cpu_map[].  The only config option is whether this is a
>  >     static map, or allocated at boot up time:
> 
> I've lost the plot on what's going on with these cpumask patches.
> But I just saw this on -rc1.
> 
> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:206:33: error: not addressable
> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:274:32: error: not addressable
> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:352:34: error: not addressable
> 
> 	Dave
> 

It looks like some old code is still there (patch dropped?).  I'll send a fix asap.

Thanks,
Mike
