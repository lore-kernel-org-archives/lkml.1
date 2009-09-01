Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZIARZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZIARZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 13:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZIARZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 13:25:12 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3083 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZIARZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 13:25:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAF/1nEqrR7MV/2dsb2JhbADEM4hBAZAZBYItgW4
X-IronPort-AV: E=Sophos;i="4.44,313,1249257600"; 
   d="scan'208";a="186929168"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>,
       Bart Van Assche <bvanassche@acm.org>,
       Alok Kataria <akataria@vmware.com>,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	<adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	<200909010933.50571.dtor@vmware.com>
	<1251823925.3864.216.camel@mulgrave.site>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Sep 2009 10:25:11 -0700
In-Reply-To: <1251823925.3864.216.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 01 Sep 2009 11:52:05 -0500")
Message-ID: <adaocpuo9vs.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2009 17:25:12.0183 (UTC) FILETIME=[29683870:01CA2B29]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Nobody said you had to have the exact same driver for every hypervisor.
 > What people are suggesting is that we look at commonalities in the
 > interfaces both from a control plane point of view (transport class) and
 > from a code sharing point of view (libscsivirt).  However, all the
 > hypervisor interfaces I've seen are basically DMA rings ...

I don't think that's anything special about hypervisors though -- pretty
much all modern device interfaces are basically DMA rings, aren't they?
I'm definitely in favor of common code to handle commonality but on the
other hand I don't see what's so special about virtual devices vs. real
HW devices.  One the one side we have VMware's closed hypervisor code
and on the other side we have vendor XYZ's closed RTL and firmware code.

 - R.
