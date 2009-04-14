Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZDNJGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZDNJGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZDNJFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:05:52 -0400
Received: from ozlabs.org ([203.10.76.45]:57052 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZDNJFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:05:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/7] use smp_call_function_single() in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Date: Tue, 14 Apr 2009 18:35:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090413000630.21C09DE12A@ozlabs.org> <20090413001657.GA24946@redhat.com>
In-Reply-To: <20090413001657.GA24946@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141835.41961.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 09:46:57 am Dave Jones wrote:
> On Mon, Apr 13, 2009 at 09:30:02AM +0930, Rusty Russell wrote:
>  > From: Andrew Morton <akpm@linux-foundation.org>
>  > 
>  > Impact: fix sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
>  > 
> 
> This, and the other cpufreq related patches in this series look sound to me.
> Given the other non-cpufreq bits in the series, do you want to just
> have these go through Andrew and onto Linus?

Sure, that's certainly easiest for me.   I'd assumed Ingo would snarf them,
but as he's suggested -mm, Andrew?

Thanks!
Rusty.
