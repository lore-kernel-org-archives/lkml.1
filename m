Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbZLQVBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbZLQVBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZLQVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:01:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:20511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbZLQVBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:01:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,415,1257148800"; 
   d="scan'208";a="524167328"
Subject: Re: [PATCH] x86: Reenable TSC sync check at boot, even with
 NONSTOP_TSC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091217202702.GA18015@linux-os.sc.intel.com>
References: <20091217202702.GA18015@linux-os.sc.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 17 Dec 2009 13:00:23 -0800
Message-Id: <1261083624.2535.299.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 13:27 -0700, Pallipadi, Venkatesh wrote:
> Commit 83ce4009 did the following change
> If the TSC is constant and non-stop, also set it reliable.
> 
> But, there seems to be few systems that will end up with TSC warp across
> sockets, depending on how the cpus come out of reset. Skipping TSC sync
> test on such systems may result in time inconsistency later.
> 
> So, reenable TSC sync test even on constant and non-stop TSC systems.
> Set, sched_clock_stable to 1 by default and reset it in
> mark_tsc_unstable, if TSC sync fails.
> 
> This change still gives perf benefit mentioned in 83ce4009 for systems
> where TSC is reliable.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

