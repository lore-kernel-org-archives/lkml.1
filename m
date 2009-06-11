Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbZFKIoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbZFKIoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760635AbZFKInx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:43:53 -0400
Received: from mga06.intel.com ([134.134.136.21]:19426 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761442AbZFKInv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:43:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,201,1243839600"; 
   d="scan'208";a="420783875"
Date: Thu, 11 Jun 2009 16:27:10 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] perf_counter/x86: Correct some event and umask
	values for Intel processors
Message-ID: <20090611082710.GA29784@ywang-moblin2.bj.intel.com>
References: <20090609131553.GA12489@ywang-moblin2.bj.intel.com> <20090609141621.GA32703@elte.hu> <20090610053623.GC30923@ywang-moblin2.bj.intel.com> <20090610104242.GB27724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610104242.GB27724@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Btw, one thing I don't quite understand is why you aliased 
> > dtlb-write-ops to l1d-write-ops when setting event and umask 
> > values. Are they the same event?
> 
> No, they are indeed different events - that's a bug in the table, 
> good spotting. Mind sending a (tested) patch for it?
> 

I'm a little confused. By dtlb-write-ops, do you want to count the
number of times that DTLB is accessed due to store operations or the
number of times that DTLB entries are written to, i.e. updated?

Btw, do you know whether virtual cache is employed or not on
atom/core2/nehalem so that tlb won't be accessed when accessing l1
caches?

-Yong
