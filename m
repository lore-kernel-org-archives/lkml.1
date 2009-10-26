Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZJZLdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZJZLdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZJZLdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:33:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:15971 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbZJZLdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,625,1249282800"; 
   d="scan'208";a="507514281"
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091026000517.723f7550@infradead.org>
References: <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256531907.7117.31.camel@marge.simson.net>
	 <20091025215225.05ac9ac9@infradead.org>
	 <1256533734.7117.45.camel@marge.simson.net>
	 <20091025223657.5ebc2857@infradead.org>
	 <1256536078.7117.67.camel@marge.simson.net>
	 <1256536660.8150.3.camel@marge.simson.net>	<20091026070112.GA14641@elte.hu>
	 <20091026000517.723f7550@infradead.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 26 Oct 2009 03:33:16 -0800
Message-Id: <1256556796.2521.38.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 00:05 -0700, Arjan van de Ven wrote:
> On Mon, 26 Oct 2009 08:01:12 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Correct. There's a few cpus where multicore means separate caches but 
> > all modern CPUs have shared caches for cores so we want to tune for 
> > that.
> 
> for those cpus where mc means separate caches we should fix the arch
> code to set up separate MC domains to be honest..
> I can look into that in a bit..

In the default performance mode, multi-core domain is populated with
only cores sharing last-level cache. In the case where the cores don't
share caches, we represent them in the smp domain.

thanks,
suresh

