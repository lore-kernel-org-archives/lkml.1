Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbXINVdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbXINVdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXINVdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:33:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:62597 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734AbXINVdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:33:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,257,1186383600"; 
   d="scan'208";a="279218551"
Date: Fri, 14 Sep 2007 14:31:12 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, akpm@osdl.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, ak@suse.com
Subject: Re: [patch] Fix BIOS-e820 end address
Message-ID: <20070914213111.GA24882@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908205044.GA16419@askeshav-devel.jf.intel.com> <46EAF652.9060405@goop.org> <20070914213159.GD6078@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914213159.GD6078@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 02:31:59PM -0700, Siddha, Suresh B wrote:
> On Fri, Sep 14, 2007 at 02:00:02PM -0700, Jeremy Fitzhardinge wrote:
> > Keshavamurthy, Anil S wrote:
> > > Subject: [patch] Fix BIOS-e820 end address
> > >
> > > --snip of boot message--
> > > BIOS-provided physical RAM map:
> > >  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
> > >  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> > >  BIOS-e820: 0000000000100000 - 000000007fe8cc00 (usable)
> > > ----end snip---
> > >
> > > As you see from above the address 0000000000100000 is both
> > > shown as reserved and usable which is confusing.
> > >   
> > 
> > I think this is consistent with many other kernel interfaces (such as
> > /proc/X/maps) where the end address is taken to be exclusive: [0xf0000,
> > 0x100000).
> 
> Andrew, Please disregard this patch. As Jermy, Jan pointed out, this
> will cause more confusions. Thanks. 
I agree, we can discard my patch.

-Anil
