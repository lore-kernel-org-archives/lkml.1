Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbXFEVSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbXFEVSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932804AbXFEVSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:18:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:24995 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbXFEVSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:18:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,386,1175497200"; 
   d="scan'208";a="235930118"
Date: Tue, 5 Jun 2007 14:14:51 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605211451.GG17143@linux-os.sc.intel.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605200954.GE12782@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 01:09:54PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2007 at 11:40:15AM -0700, Siddha, Suresh B wrote:
> 
> > Does this problem happen only under certain stress or something simple, like
> > 
> > boot the kernel
> > echo 2 > /proc/irq/114/smp_affinity
> > wait for irq to hit the cpu1.
> > echo 0 > /sys/devices/system/cpu/cpu1/online
> > 
> > will immmd trigger this?
> 
> The system is not under any stress at all.

Can you send us your system's dmesg aswell as output of /proc/interrupts?

thanks,
suresh
