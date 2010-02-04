Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0BDPD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:03:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:40818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab0BDPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:03:57 -0500
Subject: Re: [PATCH] define percpu_counter_batch when CONFIG_SMP is not set
From: Peter Zijlstra <peterz@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <201002041828.33194.knikanth@suse.de>
References: <201002041819.22985.knikanth@suse.de>
	 <201002041828.33194.knikanth@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 16:03:37 +0100
Message-ID: <1265295817.22001.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 18:28 +0530, Nikanth Karthikesan wrote:
> On Thursday 04 February 2010 18:19:22 Nikanth Karthikesan wrote:
> > percpu_counter_batch is not defined if CONFIG_SMP is not set.
> 
> The patch "sched: cpuacct: Use bigger percpu counter batch values for stats 
> counters" in tip (43f85eab1411905afe5db510fbf9841b516e7e6a) would fail to 
> build without this if CONFIG_SMP is not set.

Which is why it got reverted (e2dfc8a0356ee7e065bd5ec8a2ca0f9b61c2daef),
Anton also posted a new version that actually does build on UP.

