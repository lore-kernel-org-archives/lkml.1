Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbXEYJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbXEYJnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXEYJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:43:42 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4670 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXEYJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:43:42 -0400
Date: Fri, 25 May 2007 10:43:24 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Message-ID: <20070525094323.GB20090@flint.arm.linux.org.uk>
Mail-Followup-To: "Yu, Fenghua" <fenghua.yu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ravikiran G Thirumalai <kiran@scalex86.org>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
	linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
	heiko.carstens@de.ibm.com
References: <20070523123153.c4f8c7e6.akpm@linux-foundation.org> <79E93560F4A5FD42BB769DAAF8BEF62A01AA8E7C@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8E7C@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:13:24PM -0700, Yu, Fenghua wrote:
> Yes, in theory, sharing shared percpu data with local percpu data in one
> cache line can cause cache line contention between remote and local
> access.

What's "shared percpu data" ?  It sounds to me like a contradiction in
terms.  Isn't percpu data supposed to only be accessed by the CPU which
owns it to prevent cache line bouncing?  In which case, what's the point
of sharing that data with other CPUs?  Surely "shared percpu data" is
just the same as normal data?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
