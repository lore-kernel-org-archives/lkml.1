Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXCHBeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXCHBeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXCHBeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:34:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:41835 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXCHBeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:34:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,262,1170662400"; 
   d="scan'208"; a="192059683:sNHT18241475"
Date: Wed, 7 Mar 2007 17:07:50 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2 hang
Message-ID: <20070308010750.GB19790@linux-os.sc.intel.com>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <1173305536.868.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173305536.868.8.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 02:12:16PM -0800, Dave Hansen wrote:
> I'm seeing weird hangs running ltp on 2.6.21-rc2-mm2.  It manifests
> itself by the waitpid06 test in LTP hanging.  This is very, very
> reproducible in about 5 seconds by adding '-s wait' to the ltp command
> line.
> 
> I see 4 waitpid06 processes on my 4-way machine spinning in userspace.
> But, the weird part is that I can't ssh in once this happens, but I can
> log in to the console.  I've bisected it down to:
>         
>         sched-fix-idle-load-balancing-in-softirqd-context

[having some mailer issues. Pl ignore if this is a duplicate]

This sounds like an issue in merge we recently had and 2.6.21-rc2-mm2 already
has a fix for this.

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch  

Can you please apply both
sched-fix-idle-load-balancing-in-softirqd-context
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
and see if you still see this problem?

thanks,
suresh
