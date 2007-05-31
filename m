Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbXEaUFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbXEaUFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXEaUFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:05:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:17434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbXEaUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,370,1175497200"; 
   d="scan'208";a="234225335"
Date: Thu, 31 May 2007 13:02:18 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       asit.k.mallick@intel.com, keith.packard@intel.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64 irq: check remote IRR bit before migrating level triggered irq (v2)
Message-ID: <20070531200218.GB17143@linux-os.sc.intel.com>
References: <20070517230324.GB8089@linux-os.sc.intel.com> <m1d50h5irm.fsf@ebiederm.dsl.xmission.com> <200705311401.02221.ak@suse.de> <m1y7j53yuw.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7j53yuw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:29:43AM -0600, Eric W. Biederman wrote:
> Andi Kleen <ak@suse.de> writes:
> 
> > On Thursday 31 May 2007 13:34:21 Eric W. Biederman wrote:
> >> 
> >> On x86_64 kernel, level triggered irq migration gets initiated in the context
> >> of that interrupt(after executing the irq handler) and following steps are
> >> followed to do the irq migration.
> >
> > What's the confidence level in the patch? Is it a .22 candidate?
> 
> Yes.
> 
> I just ran it for a little while and nothing fell over, and level
> triggered irqs continued to migrate.  So it's not horribly broken.
> 
> Outside of implementation errors the worst case that can happen with
> this code is the current behavior, with a small slow down.
> 
> So since I can not reproduce the original problem I would appreciate
> an eyeball or two more just to make certain I reimplemented this
> correctly and didn't do anything stupid.   But I don't expect anything
> to be found.  The code is pretty straight forward.

Yes. We want this to get included in .22. We did extensive testing with
our patch before.  We will also do more tests with this version, however.

thanks,
suresh
