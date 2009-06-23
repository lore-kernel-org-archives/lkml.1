Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZFWArR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZFWArR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZFWArB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:47:01 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42801 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZFWArA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:47:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19008.9397.341851.966629@cargo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 10:41:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.5 - Mmaped count
In-Reply-To: <7c86c4470906220554m1da6ebe7h50444db6ab606aa1@mail.gmail.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	<20090622115239.GF24366@elte.hu>
	<7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
	<1245674154.19816.228.camel@twins>
	<7c86c4470906220554m1da6ebe7h50444db6ab606aa1@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> I don't see where you clear that field on x86.
> Looks like it comes from hwc->idx. I suspect you need
> to do something in x86_pmu_disable() to be symmetrical
> with x86_pmu_enable().
> 
> I suspect something similar needs to be done on Power.

power_pmu_disable() already calls perf_counter_update_userpage,
so I think we're OK there.

Paul.
