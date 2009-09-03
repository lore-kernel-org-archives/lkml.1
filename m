Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZICNjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZICNjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZICNjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:39:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:33536 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZICNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:39:02 -0400
Subject: Re: [RFC][PATCH 0/8] load-balancing and cpu_power -v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090903121045.GK7216@alberich.amd.com>
References: <20090901083431.748830771@chello.nl>
	 <20090903121045.GK7216@alberich.amd.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 15:38:56 +0200
Message-Id: <1251985136.7352.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 14:10 +0200, Andreas Herrmann wrote:
> On Tue, Sep 01, 2009 at 10:34:31AM +0200, Peter Zijlstra wrote:

> > Anyway, have at it, poke holes and report issues.
> 
> Tested it (to a certain extend).
> Found no performance degradation (on 1P, 2P, 4P systems). (One could
> think performance might slightly degrade due to more frequent
> __cpu_power updates).

Grand.

> This applies to modification of sched_mc_power_savings. And I think
> one of above scenarios is already broken in tip/master w/o your
> patches.

I suspect so, but confirmation would be good, I don't have a single
machine large enough to actually test any of that power saving muck.

> Otherwise especially wrt to integration of APERF/MPERF this seems to
> be a good approach.

On that, are there AMD systems supporting APERF/MPERF? I only know of
Intel machines doing so.

