Return-Path: <linux-kernel-owner+w=401wt.eu-S1763358AbXERTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763358AbXERTVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXERTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:21:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:59282 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbXERTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:21:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,553,1170662400"; 
   d="scan'208";a="88244118"
Date: Fri, 18 May 2007 12:18:13 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Message-ID: <20070518191813.GC28957@linux-os.sc.intel.com>
References: <20070518183941.GA28957@linux-os.sc.intel.com> <m1wsz6ymyv.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wsz6ymyv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 12:02:16PM -0700, Eric W. Biederman wrote:
> I will look closer but I do believe that from the ioapic to the cpu the 2.6.21
> code should be fairly robust with respect to inflight messages from the ioapic
> to the local apics and the cpus.  What I failed to consider were inflight
> messages in the other direction arriving out of order.

Yes. Inflight messages from cpu to ioapic was what I was referring to.

thanks,
suresh
