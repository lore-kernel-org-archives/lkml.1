Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZISCTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZISCTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZISCTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:19:47 -0400
Received: from fifo99.com ([67.223.236.141]:43037 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZISCTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:19:47 -0400
Subject: Re: [patch] x86, apic: use logical flat on intel with <= 8 logical
 cpus
From: Daniel Walker <dwalker@fifo99.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1253325936.3948.720.camel@sbs-t61.sc.intel.com>
References: <1253325936.3948.720.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 19:19:50 -0700
Message-Id: <1253326790.6699.38.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 19:05 -0700, Suresh Siddha wrote:
> +               switch (boot_cpu_data.x86_vendor) {
> +                       case X86_VENDOR_INTEL:
> +                               if (num_processors > 8)
> +                                       apic = &apic_physflat;
> +                               break;
> +                       case X86_VENDOR_AMD:
> +                               if (max_physical_apicid >= 8)
> +                                       apic = &apic_physflat;
> +               }

There are a couple of checkpatch issues in this patch .. Could you run
it through and fix the errors that show up.. One is that you need 1 less
tab for the code inside the switch statement .. You have another switch
statement in apic.c that needs similar attention .

Daniel

