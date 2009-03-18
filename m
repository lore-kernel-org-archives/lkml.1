Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZCRRlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZCRRlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZCRRlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:41:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:26881 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZCRRla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,385,1233561600"; 
   d="scan'208";a="121638481"
Date: Wed, 18 Mar 2009 10:41:23 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Ingo Molnar <mingo@elte.hu>
cc: Lubomir Rintel <lkundrak@v3.sk>, Joerg Roedel <joerg.roedel@amd.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: e1000e 0000:00:19.0: DMA-API: device driver tries to free DMA
 memory it has not allocated [device address=0x0000000052ff084a]	[size=90
 bytes]
In-Reply-To: <20090318164731.GB31315@elte.hu>
Message-ID: <alpine.WNT.2.00.0903181039100.5116@jbrandeb-desk1.amr.corp.intel.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu> <20090318115615.GS6159@amd.com> <20090318120458.GA1601@elte.hu> <36697.89.102.207.186.1237380871.squirrel@mail.v3.sk>
 <20090318140949.GA20852@elte.hu> <F169D4F5E1F1974DBFAFABF47F60C10A1E8795AC@orsmsx507.amr.corp.intel.com> <20090318164731.GB31315@elte.hu>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Ingo Molnar wrote:
> > >> http://lkml.org/lkml/2009/3/2/318
> > 
> > We are still looking for more testing from the general community of 
> > this patch, in particular if any tx hangs are reported.  Thanks in 
> > advance for any reports.--
> 
> Yeah - already picked it up into tip:out-of-tree and it passed about 
> a hundred bootup tests on various e1000e using systems already - 
> with no problems whatsoever. Will let you know if anything breaks - 
> e1000e has been rock solid for me in the .29 cycle.

thanks! did you pull in both e1000 and e1000e fixes?  We also have a 
similar fix in internal testing for igb.
