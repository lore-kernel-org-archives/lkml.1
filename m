Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbXCEFBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbXCEFBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 00:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXCEFBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 00:01:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:28884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbXCEFBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 00:01:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,247,1170662400"; 
   d="scan'208"; a="52998885:sNHT17991504"
Date: Sun, 4 Mar 2007 20:24:53 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: optimize siblings status check logic in wake_idle()
Message-ID: <20070304202453.D27368@unix-os.sc.intel.com>
References: <20070302202331.B27368@unix-os.sc.intel.com> <20070305023534.GB16666@wotan.suse.de> <20070304201309.C27368@unix-os.sc.intel.com> <20070305045831.GA2972@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070305045831.GA2972@wotan.suse.de>; from npiggin@suse.de on Mon, Mar 05, 2007 at 05:58:31AM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 05:58:31AM +0100, Nick Piggin wrote:
> On Sun, Mar 04, 2007 at 08:13:09PM -0800, Suresh B wrote:
> > On a 16 node system, we have seen ~1.25% perf improvement on a database workload
> > when we completely short circuited wake_idle(). This patch is trying to comeup
> > with a best compromise to avoid the cache misses and also minimize the latenices,
> > perf impact.
> 
> Hmm, I wonder what if we only wake_idle if the wakeup comes from this
> CPU or a sibling? That's probably going to have downsides in some
> workloads as well, though.

yep. I thought about it and thought this patch is a decent solution.

thanks,
suresh
