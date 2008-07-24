Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYGXRLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYGXRLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYGXRLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:11:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49792 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751600AbYGXRLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:11:31 -0400
Message-ID: <4888B7B8.9060100@sgi.com>
Date: Thu, 24 Jul 2008 10:11:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
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
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com> <20080724114622.GA8516@elte.hu>
In-Reply-To: <20080724114622.GA8516@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> found a build failure with your patch:
> 
> init/main.c:493: error: array index in non-array initializer
> init/main.c:493: error: (near initialization for 'cpumask_of_cpu_map[0]')
> init/main.c:494: warning: missing braces around initializer
> init/main.c:494: warning: (near initialization for 'cpumask_of_cpu_map[0].bits')
> 
> with this config:
> 
> http://redhat.com/~mingo/misc/config-Thu_Jul_24_13_44_56_CEST_2008.bad
> 
> 	Ingo

Hmm, it does not fail for me...

12> gcc --version
gcc (GCC) 4.2.4
Copyright (C) 2007 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

There are a number of warnings but none of the files are related to this patch.

(I'm still on hold until our sys admin gets back from vacation to install
gcc-4.2.3.)

Thanks,
Mike
