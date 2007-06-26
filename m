Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbXFZQ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbXFZQ1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXFZQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:27:36 -0400
Received: from mga05.intel.com ([192.55.52.89]:38235 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752356AbXFZQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="261344865"
Message-ID: <46813E0F.1060806@linux.intel.com>
Date: Tue, 26 Jun 2007 09:25:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <p73645a675q.fsf@bingen.suse.de> <46812D79.8080306@linux.intel.com> <20070626153358.GA5244@one.firstfloor.org>
In-Reply-To: <20070626153358.GA5244@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Jun 26, 2007 at 08:15:05AM -0700, Arjan van de Ven wrote:
>>> Also the user interface for X server case needs more work.
>>>
>> actually with the mode setting of X moving into the kernel... X won't 
>> use /dev/mem anymore at all
> 
> We'll see if that happens. It has been talked about forever,
> but results are sparse. 

jbarnes posted the code a few weeks ago.

> 
>> (and I think it mostly already doesn't even without that)
> 
> It uses /sys/bus/pci/* which is not any better as seen from the IOMMU.
> 
> Any interface will need to be explicit because user space needs to know which
> DMA addresses to put into the hardware. It's not enough to just transparently
> translate the mappings.

that's what DRM is used for nowadays...
