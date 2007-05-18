Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbXERBET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbXERBET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXERBEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:04:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:40651 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbXERBEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:04:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="87983743"
Date: Thu, 17 May 2007 18:01:19 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Message-ID: <20070518010119.GB12088@linux-os.sc.intel.com>
References: <20070517230324.GB8089@linux-os.sc.intel.com> <m1ejlf0y96.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejlf0y96.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:30:13PM -0700, Eric W. Biederman wrote:
> So why does any of this matter?
>
> My memory says that the ioapic state for sending irqs gets reset when we
> unmask the irq.

No. Atleast not on the platform we have tested.

> If not I expect we can use the mask and edge, unmask and level
> work-around from arch/i386/ioapic.c.  That looks like it would
> be less code, less error prone and easier to implement then the
> current work around.

hmm. We have to check and see if it can help. But ioapic spec doesn't
say that the Remote IRR gets reset when the trigger mode changes. Not sure
if we can apply the logic widely.

thanks,
suresh
