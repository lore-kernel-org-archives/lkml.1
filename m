Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbYKRAta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbYKRAta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYKRAtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:49:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:51262 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbYKRAtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:49:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,621,1220252400"; 
   d="scan'208";a="464221171"
Date: Mon, 17 Nov 2008 16:49:19 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
Message-ID: <20081118004918.GA19416@linux-os.sc.intel.com>
References: <20081118001137.GA12350@linux-os.sc.intel.com> <492208BE.2000001@zytor.com> <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com> <492209C8.7040602@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492209C8.7040602@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 04:18:16PM -0800, H. Peter Anvin wrote:
> Pallipadi, Venkatesh wrote:
> > 
> > All C-states higher than C1. 
> > 
> 
> Including C2?  If so, the TSC is unusable since C2 can be invoked 
> asynchronously by the chipset.
> 

No. Not on Intel CPUs atleast. On Intel CPUs, we enter C-states only on
hlt or mwait. C1 is always C1 or C1E, where TSC always runs.
C2, C3, ... implementation vary depending on processor and TSC may or may
not run. This 0x80000007 feature bit basically says TSC is going to run
during any C-state.

Thanks,
Venki
