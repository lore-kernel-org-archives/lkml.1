Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbZDMATZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbZDMATZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 20:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZDMATR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 20:19:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47185 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDMATQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 20:19:16 -0400
Date: Sun, 12 Apr 2009 20:16:57 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] use smp_call_function_single() in
	arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Message-ID: <20090413001657.GA24946@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
	Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20090413000630.21C09DE12A@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413000630.21C09DE12A@ozlabs.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 09:30:02AM +0930, Rusty Russell wrote:
 > From: Andrew Morton <akpm@linux-foundation.org>
 > 
 > Impact: fix sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
 > 

This, and the other cpufreq related patches in this series look sound to me.
Given the other non-cpufreq bits in the series, do you want to just
have these go through Andrew and onto Linus?

	Dave

