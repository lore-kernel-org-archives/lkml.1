Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbXFESSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbXFESSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXFESSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:18:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:39150 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbXFESSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,386,1175497200"; 
   d="scan'208";a="253519617"
Date: Tue, 5 Jun 2007 11:13:42 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605181342.GE17143@linux-os.sc.intel.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605173647.GC12782@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:36:47AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2007 at 10:23:10AM -0700, Siddha, Suresh B wrote:
> 
> > Darrick, I see a kernel bug in this area(which is already filled with bugs,
> > and I am looking into ways to fix them). Are you making sure that
> > between step-1 and step-2, that interrupts actually started arriving at cpu1?
> > 
> > i.e., do step-1 and wait till the irq's start hitting at cpu1. At this point
> > do step-2 and let us know if you still hit this bug?
> 
> Yes, the bug only happens after CPU1 begins to receive interrupts.

I see. Your system should have 4 or 8 logical cpu's right. So you must be
using logical flat mode, right?

When this bug happens, what does /proc/irq/<irq-no>/smp_affinity show?

thanks,
suresh
