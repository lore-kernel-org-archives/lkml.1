Return-Path: <linux-kernel-owner+w=401wt.eu-S934867AbXFFTjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867AbXFFTjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbXFFTjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:39:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:46450 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbXFFTjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:39:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="253994713"
Date: Wed, 6 Jun 2007 12:35:14 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070606193514.GN17143@linux-os.sc.intel.com>
References: <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606185829.GA26062@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:58:29AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2007 at 06:37:59PM -0700, Siddha, Suresh B wrote:
> > On Tue, Jun 05, 2007 at 04:57:07PM -0700, Darrick J. Wong wrote:
> > > On Tue, Jun 05, 2007 at 02:14:51PM -0700, Siddha, Suresh B wrote:
> > >  
> > > > Can you send us your system's dmesg aswell as output of /proc/interrupts?
> > > 
> > > http://sweaglesw.net/~djwong/docs/dmesg
> > > http://sweaglesw.net/~djwong/docs/interrupts
> > 
> > Didn't find anything wrong in that information. Can you try this
> > appended debug patch and see if you see this error msg in dmesg, when you
> > hit the bug? Thanks.
> 
> I don't see that message.

Weird. Then the bug can only happen if for some reason, "mask = map"
didn't happen in fixup_irqs(). Can you send us the disassembly of the
fixup_irqs()?

thanks,
suresh
