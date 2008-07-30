Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYG3Q4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYG3Q4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYG3Q4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:56:03 -0400
Received: from testure.choralone.org ([194.9.77.134]:53566 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYG3Q4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:56:01 -0400
Date: Wed, 30 Jul 2008 12:55:39 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
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
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use
	cpumask_of_cpu_map
Message-ID: <20080730165539.GA10079@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
	Lennert Buytenhek <kernel@wantstofly.org>,
	Paul Jackson <pj@sgi.com>, Tony Luck <tony.luck@intel.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Robert Richter <robert.richter@amd.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Andreas Schwab <schwab@suse.de>,
	Johannes Weiner <hannes@saeurebad.de>
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723171841.997896000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:18:42AM -0700, Mike Travis wrote:
 >   * The previous "lvalue replacement for cpumask_of_cpu()" was not usable
 >     in certain situations and generally added unneeded complexity.  So
 >     this patch replaces the cpumask_of_cpu_ptr* macros with a generic
 >     cpumask_of_cpu_map[].  The only config option is whether this is a
 >     static map, or allocated at boot up time:

I've lost the plot on what's going on with these cpumask patches.
But I just saw this on -rc1.

arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:206:33: error: not addressable
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:274:32: error: not addressable
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:352:34: error: not addressable

	Dave

-- 
http://www.codemonkey.org.uk
